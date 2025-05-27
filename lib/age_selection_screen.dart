import 'package:flutter/material.dart';
import 'books_screen.dart';

class AgeSelectionScreen extends StatelessWidget {
  const AgeSelectionScreen({super.key});

  void openBooks(BuildContext context, String ageRange, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BooksScreen(ageRange: ageRange, type: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Choose your child's age and format:",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/word.png', height: 50, width: 50),
                      SizedBox(height: 4),
                      Text("Word", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/pdf.png', height: 50, width: 50),
                      SizedBox(height: 4),
                      Text("PDF", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    AgeCard(
                      label: '0-4 Word',
                      imagePath: 'assets/0-4.png',
                      onTap: () => openBooks(context, '0-4', 'word'),
                    ),
                    AgeCard(
                      label: '0-4 PDF',
                      imagePath: 'assets/0-4.png',
                      onTap: () => openBooks(context, '0-4', 'pdf'),
                    ),
                    AgeCard(
                      label: '4-8 Word',
                      imagePath: 'assets/4-8.png',
                      onTap: () => openBooks(context, '4-8', 'word'),
                    ),
                    AgeCard(
                      label: '4-8 PDF',
                      imagePath: 'assets/4-8.png',
                      onTap: () => openBooks(context, '4-8', 'pdf'),
                    ),
                    AgeCard(
                      label: '8-12 Word',
                      imagePath: 'assets/8-12.png',
                      onTap: () => openBooks(context, '8-12', 'word'),
                    ),
                    AgeCard(
                      label: '8-12 PDF',
                      imagePath: 'assets/8-12.png',
                      onTap: () => openBooks(context, '8-12', 'pdf'),
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
}

class AgeCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const AgeCard({super.key, 
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 98, width: 98, fit: BoxFit.cover),
              SizedBox(height: 12),
              Text(label, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
