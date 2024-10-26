package com.example.vitacare

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.BatteryManager
import android.os.Bundle
import android.telephony.SmsManager
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yourapp/sos"
    private val EMERGENCY_NUMBER = "+918089198810"  
    private val LOW_BATTERY_THRESHOLD =  5

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register MethodChannel for Flutter interaction
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSMS" -> {
                    val number = call.argument<String>("number")
                    val message = call.argument<String>("message")
                    if (number != null && message != null) {
                        sendSMS(number, message)
                        result.success("SMS sent to $number")
                    } else {
                        result.error("UNAVAILABLE", "SMS parameters missing", null)
                    }
                }
                "makeCall" -> {
                    val number = call.argument<String>("number")
                    if (number != null) {
                        makeCall(number)
                        result.success("Calling $number")
                    } else {
                        result.error("UNAVAILABLE", "Call parameters missing", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Register the battery level BroadcastReceiver
        registerReceiver(batteryLevelReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }

    // BroadcastReceiver for battery level
    private val batteryLevelReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            val batteryPct = level * 100 / scale.toFloat()

            Log.d("BatteryMonitor", "Battery level: $batteryPct%")
            if (batteryPct <= LOW_BATTERY_THRESHOLD) {
                triggerLowBatterySOS()
            }
        }
    }

    // Method to send an SMS
    private fun sendSMS(number: String, message: String) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
            try {
                val smsManager = SmsManager.getDefault()
                smsManager.sendTextMessage(number, null, message, null, null)
                Log.d("SOS", "SMS sent to $number")
            } catch (e: Exception) {
                Log.e("SOS", "Failed to send SMS", e)
            }
        } else {
            Log.e("SOS", "SMS permission not granted")
        }
    }

    // Method to make a call
    private fun makeCall(number: String) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
            try {
                val intent = Intent(Intent.ACTION_CALL)
                intent.data = Uri.parse("tel:$number")
                startActivity(intent)
                Log.d("SOS", "Calling $number")
            } catch (e: Exception) {
                Log.e("SOS", "Failed to make call", e)
            }
        } else {
            Log.e("SOS", "Call permission not granted")
        }
    }

    // Trigger SOS for low battery
    private fun triggerLowBatterySOS() {
        val message = "Battery critically low! Please check on me."

        Log.d("BatteryMonitor", "Triggering low battery SOS")

        sendSMS(EMERGENCY_NUMBER, message)
        makeCall(EMERGENCY_NUMBER)
    }

    override fun onDestroy() {
        super.onDestroy()
        // Unregister the battery level receiver
        unregisterReceiver(batteryLevelReceiver)
    }
}
