
import 'package:vitacare/views/HealthCHecks/heightandweightscreen.dart';

enum QuestionType { heightWeight, slider, mcq }

class Question {
  final String questionText;
  final QuestionType type;
  final List<String>? options; // For MCQ
  final String? description; 
  final String? imageurl;// For descriptions like in height & weight
  dynamic answer;

  Question( {
    required this.questionText,
    required this.type,
    this.options,
    this.description,
    this.imageurl
  });
}


List<Question> questions = [
  Question(
    questionText: 'Enter your height and weight',
    type: QuestionType.heightWeight,
    description: '',
    imageurl:"https://www.pnbmetlife.com/content/dam/pnb-metlife/images/articles/health/How_BMI_is_Calculated_Are_You_Measuring_Your_Height_and_Weight_the_Right_Way.jpg"
  ),
  Question(
    questionText: 'What would you rate your stress levels over the last month?',
    type: QuestionType.slider,
    imageurl: "https://www.assistinghands-il-wi.com/wp-content/uploads/2022/06/What-are-the-Effects-of-Stress-on-Seniors.png",
  ),
  Question(
    questionText: 'How would you rate your eating habits?',
    type: QuestionType.slider,
    imageurl: "https://www.athulyaliving.com/blogs/wp-content/uploads/2018/02/Nutritious-Eating-Among-Senior-Citizens.jpg",
  ),
  Question(
    questionText: 'How often do you feel overwhelmed by your financial situation?',
    type: QuestionType.mcq,
    options: ['Often', 'Sometimes', 'Rarely', 'Never'],
    imageurl: "https://betterhealthwhileaging.net/wp-content/uploads/2015/05/bigstock-elderly-caucasian-woman-counti-74594728.jpg",
  ),
  Question(
    questionText: 'How would you rate the quality of your sleep over the past month?',
    type: QuestionType.slider,
    imageurl: "https://veritascare.co.uk/wp-content/uploads/2023/01/obraz-wyrÃ³zniajacy-1200x-628-px-1-2.png",
  ),
  Question(
    questionText: 'How satisfied are you with your social relationships?',
    type: QuestionType.mcq,
    options: ['Very satisfied', 'Satisfied', 'Neutral', 'Dissatisfied'],
    imageurl: "https://domf5oio6qrcr.cloudfront.net/medialibrary/5616/n0619j16207259157696.jpg",
  ),
  Question(
    questionText: 'How confident do you feel about your current weight?',
    type: QuestionType.slider,
    imageurl: "https://media.cnn.com/api/v1/images/stellar/prod/230410141359-weight-loss-older-adults-wellness-042023.jpg?c=original",
  ),
  Question(
    questionText: 'How often have you felt anxious over the last month?',
    type: QuestionType.mcq,
    options: ['Often', 'Sometimes', 'Rarely', 'Never'],
    imageurl: "https://www.blueridgeassistedliving.com/wp-content/uploads/2022/02/panic-attack-in-the-elderly-causes-and-treatments.jpg",
  ),
  Question(
    questionText: 'Do you smoke?',
    type: QuestionType.mcq,
    options: ['Yes', 'No'],
    imageurl: "https://img.freepik.com/premium-photo/elderly-man-smoking-cigarette-with-smoke-drifting-air-world-no-tobacco-day_616001-29755.jpg",
  ),
  Question(
    questionText: 'How often do you drink alcohol?',
    type: QuestionType.mcq,
    options: ['Never', 'Rarely', 'Occasionally', 'Often'],
    imageurl: "https://www.recoverylighthouse.com/wp-content/uploads/2016/05/alcohol-elderly.jpg",
  ),
  Question(
    questionText: 'How often do you exercise each week?',
    type: QuestionType.mcq,
    options: ['Never', '1-2 times', '3-4 times', '5 or more times'],
    imageurl: "https://www.seniorlifestyle.com/wp-content/uploads/2020/02/senior-exercise.jpg",
  ),
  // Add more questions here if needed
];