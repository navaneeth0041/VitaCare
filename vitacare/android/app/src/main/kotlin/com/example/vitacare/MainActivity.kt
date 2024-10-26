package com.example.vitacare

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.telephony.SmsManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp/sos"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
    }

    private fun sendSMS(number: String, message: String) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(number, null, message, null, null)
            Log.d("SOS", "SMS sent to $number")
        } catch (e: Exception) {
            Log.e("SOS", "Failed to send SMS", e)
        }
    }

    private fun makeCall(number: String) {
        try {
            val intent = Intent(Intent.ACTION_CALL)
            intent.data = Uri.parse("tel:$number")
            startActivity(intent)
            Log.d("SOS", "Calling $number")
        } catch (e: Exception) {
            Log.e("SOS", "Failed to make call", e)
        }
    }
}