import 'package:flutter/material.dart';

class AdminSectionTitle extends StatelessWidget {
  final String title;
  const AdminSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade700)),
    );
  }
}
