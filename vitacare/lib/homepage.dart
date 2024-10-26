import 'package:flutter/material.dart';
import 'package:vitacare/fitness_page.dart';
import 'package:vitacare/medication_tracker_screen.dart';
import 'package:vitacare/reflection_page.dart';
import 'components/category_card.dart';
import 'components/custom_styles.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const ReflectionPage(),
    MedicationTrackerScreen(),
    const FitnessPage(),  
    const Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _pages[_currentIndex],
          ]
        ),       ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomNavButton(Icons.home, 0),
            _buildBottomNavButton(Icons.dashboard, 1),
            _buildBottomNavButton(Icons.medical_information_outlined, 2),
            _buildBottomNavButton(Icons.fitness_center, 3), 
            _buildBottomNavButton(Icons.person, 4), 
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavButton(IconData icon, int index) {
    bool selected = index == _currentIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.black,
          size: 28,
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, size: 28), 
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Practices',
                        style: CustomStyles.headingTextStyle(screenWidth),
                      ),
                      Text(
                        'Exercises based on your needs',
                        style: CustomStyles.subheadingTextStyle(screenWidth),
                      ),
                    ],
                  ),
                ),
              ),
              const Icon(Icons.search, size: 28), 
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), 
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CategoryCard(
                      title: 'My Strengths & Qualities',
                      color: Colors.blue.shade100,
                      icon: Icons.arrow_forward,
                    ),
                    CategoryCard(
                      title: 'Build Confidence',
                      color: Colors.yellow.shade100,
                      icon: Icons.arrow_forward,
                    ),
                    CategoryCard(
                      title: 'Diversity & Inclusion',
                      color: Colors.teal.shade100,
                      icon: Icons.arrow_forward,
                    ),
                    CategoryCard(
                      title: 'Behavioral Activation',
                      color: Colors.purple.shade100,
                      icon: Icons.arrow_forward,
                    ),
                    CategoryCard(
                      title: 'Arabic Mental Health',
                      color: Colors.green.shade100,
                      icon: Icons.arrow_forward,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}