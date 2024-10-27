import 'package:flutter/material.dart';
import 'package:vitacare/questions/questions.dart';
import 'package:vitacare/views/HealthCHecks/resultscreen.dart';
import 'package:vitacare/widgets/questionimage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';



class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;
    List<Map<String, dynamic>> responses = [];
void _nextQuestion() {

   responses.add({
      'question': questions[currentQuestionIndex].questionText,
      'answer': questions[currentQuestionIndex].answer,
    });


  setState(() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
    } else {
      // Navigate to ResultsScreen and pass the questions list with answers
      _sendToGeminiAndNavigate();
    }
  });
}
Future<void> _sendToGeminiAndNavigate() async {
  try {
    // Step 1: Initialize GenerativeModel with the API key
    print("Initializing GenerativeModel...");
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: "AIzaSyCntOUJ55NKZ-_yx-DGAS9Z2MD6Dfgrac8",
    );

    // Step 2: Define the prompt with detailed structure for report
    print("Setting up prompt for health check analysis...");
final prompt = """
Please evaluate the following health check responses and provide a structured report using the template below. Ensure that the output is formatted clearly, with consistent use of line breaks and bullet points for each section to facilitate easy parsing.

---

**General Health Check:**
- **Results:** [Give rating out of 100]
- **Overall Description:** [Detailed description of overall result]

---

**Result Breakdown:**

1. **Mental Wellbeing:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

2. **Physical Health:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

3. **Practical Skills:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

4. **Emotional Health:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

5. **Sleep:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

6. **Nutrition:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

7. **Social Health:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

8. **Financial Health:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

9. **Environmental Health:**
   - **Result:** [Result]
   - **Description:** [Detailed explanation]

10. **Time Management:**
    - **Result:** [Result]
    - **Description:** [Detailed explanation]

11. **Lifestyle Choices:**
    - **Result:** [Result]
    - **Description:** [Detailed explanation]

---

**General Health Ranking and Want to Improve:**
- **Result:** [Result]
- **Description:** [Detailed explanation]

---

**General Overview:**
- **Description:** [General overview]

---

**Our Recommendations:**
- [Any specific recommendations based on the results]
- Redo check if needed

---

**Responses:**
$responses

---

**Note:** Please ensure that each section is separated by a clear line break and that there are no additional or missing lines, which can complicate parsing. Each section should strictly adhere to the provided format.
""";


print("Prompt setup completed.");

// Step 3: Prepare the content list for the model
final content = [Content.text(prompt)];
print("Sending prompt to Gemini...");

// Step 4: Send the prompt to the model and await the response
final response = await model.generateContent(content);
print("Response received from Gemini.");

// Step 5: Process the response text
String formattedResponse = response.text!
    .replaceAll("Google", "Tech-Codianzz")
    .replaceAll("Gemini", "Vita");
print("Formatted response prepared.");
print("Formatted Response: $formattedResponse");



Map<String, dynamic> parsedResult = parseResponse(formattedResponse);

print("Parsed General Health:");
print(parsedResult['GeneralHealth']);

print("Parsed Breakdown Categories:");
if (parsedResult.containsKey('Breakdown')) {
  parsedResult['Breakdown']?.forEach((category) {
    print("Category: ${category['Category']}");
    print("Description: ${category['Description']}");
  });
} else {
  print("No breakdown data found.");
}




print("Navigating to ResultsScreen with the formatted response...");
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Resultscreen(result: parsedResult),
  ),
);
  } catch (error) {
    // Catching and printing any errors encountered during the process
    print("Error sending data to Gemini: $error");
    // Optionally, display an error message to the user if needed
  }
}

Map<String, dynamic> parseResponse(String responseText) {
  Map<String, dynamic> resultData = {};

  // Match General Health Check section
  final generalHealthRegExp = RegExp(
    r'\*\*General Health Check:\*\*.*?- \*\*Results:\*\* (.*?)\n- \*\*Overall Description:\*\* (.*?)\n',
    dotAll: true,
  );

  // Regex pattern for breakdown sections
  final breakdownRegExp = RegExp(
    r'(\d+)\.\s*\*\*(.*?)\*\*:\s*- \*\*Result:\*\* (.*?)\s*- \*\*Description:\*\* (.*?)(?=\n\d+\.|\n---|$)',
    dotAll: true,
  );

  // Match General Health Check
  var generalMatch = generalHealthRegExp.firstMatch(responseText);
  if (generalMatch != null) {
    resultData['GeneralHealth'] = {
      'Rating': generalMatch.group(1),
      'Description': generalMatch.group(2),
    };
  } else {
    print("General Health data could not be parsed.");
  }

  // Match each breakdown category
  var breakdowns = [];
  for (var match in breakdownRegExp.allMatches(responseText)) {
    breakdowns.add({
      'Number': match.group(1)?.trim(),
      'Category': match.group(2)?.trim(),
      'Result': match.group(3)?.trim(),
      'Description': match.group(4)?.trim(),
    });
  }

  if (breakdowns.isNotEmpty) {
    resultData['Breakdown'] = breakdowns;
  } else {
    print("No breakdown categories were parsed.");
  }

  return resultData;
}






  void _previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth * 0.09),
              Text(
                'Health Check',
                style: TextStyle(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,

              ),
              SizedBox(height: screenWidth * 0.06),
              Text(
                currentQuestion.questionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (currentQuestion.description != null) ...[
                const SizedBox(height: 10),
                Text(
                  currentQuestion.description!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 20),
              _buildQuestionWidget(currentQuestion),
              const Spacer(),
    Padding(
  padding: const EdgeInsets.only(bottom: 40),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0), // Add padding between buttons
          child: ElevatedButton(
            onPressed: _previousQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Set button color
              padding: const EdgeInsets.symmetric(vertical: 16.0), // Increase vertical padding
              textStyle: const TextStyle(
                fontSize: 18, // Increase text size
                color: Colors.white, // Set text color to white
              ),
            ),
            child: const Text('Previous',style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
      Text(
        '${currentQuestionIndex + 1}/${questions.length}',
        style: const TextStyle(
          fontSize: 20, // Increase text size for better readability
          fontWeight: FontWeight.bold, // Make text bold
          color: Colors.black, // Set text color
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Add padding between buttons
          child: ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Set button color
              padding: const EdgeInsets.symmetric(vertical: 16.0), // Increase vertical padding
              textStyle: const TextStyle(
                fontSize: 18, // Increase text size
                color: Colors.white, // Set text color to white
              ),
            ),
            child: const Text('Next',style: TextStyle(color: Colors.white),),
          ),
        ),

      ),
    ],
  ),
),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(Question question) {
    switch (question.type) {
      case QuestionType.heightWeight:
        return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      'These measurements will be used to calculate your Body Mass Index (BMI). '
      'While BMI can provide insights into general health, it does not represent a full health assessment. '
      'Please consult a healthcare professional for a complete evaluation.',
      style: TextStyle(fontSize: 14, color: Colors.grey),
      textAlign: TextAlign.left,
    ),
    const SizedBox(height: 20),
    TextField(
      decoration: const InputDecoration(
        labelText: 'Height (cm)',
         labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Blue border color
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        question.answer = {'height': value};
      },
    ),
    const SizedBox(height: 20),
    TextField(
      decoration: const InputDecoration(
        labelText: 'Weight (kg)',
                 labelStyle: TextStyle(color: Colors.blue),

        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // Blue border color
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        question.answer = {
          ...question.answer ?? {},
          'weight': value,
        };
      },
    ),
  ],
);

        case QuestionType.slider:
      final imageUrl =question.imageurl;
      final questionText = question.questionText;

      return Column(
        children: [
          QuetionImage(imageUrl: imageUrl, questionText: questionText),
          SizedBox(height: 50,),
           Slider(
            thumbColor: Colors.blue,
            activeColor: Colors.blue,
            inactiveColor: const Color.fromARGB(255, 171, 206, 212),
                  value: (question.answer ?? 0.0) as double,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: (question.answer ?? 0.0).toString(),
                  onChanged: (value) {
                    setState(() {
                      question.answer = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('No stress'),
                    Text('Extremely stressed'),
                  ],
                ),
        ],
      );
case QuestionType.mcq:
  final imageUrl = question.imageurl;
  final questionText = question.questionText;

  return Column(
    children: [
      QuetionImage(imageUrl: imageUrl, questionText: questionText),
      
      // Map through options to display each as a RadioListTile
      ...question.options!.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: question.answer,
          onChanged: (value) {
            setState(() {
              question.answer = value;
            });
          },
        );
      }).toList(),
    ],
  );

      default:
        return Container();
    }
  }
}

