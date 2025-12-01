import 'package:flutter/material.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('Promotions et Annonces', style: TextStyle(fontSize: 22, color: Colors.grey)),
          Text('Bientôt disponible !', style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
