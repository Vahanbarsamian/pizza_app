import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const <Widget>[
        Text('Notre Pizzeria', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text(
          'Bienvenue dans notre pizzeria ! Nous servons les meilleures pizzas de la ville, préparées avec des ingrédients frais et beaucoup d\'amour.'
        ),
        Divider(height: 32),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.orange),
          title: Text('Adresse'),
          subtitle: Text('123 Rue de la Pizza, 75000 Pizzaville'),
        ),
        ListTile(
          leading: Icon(Icons.phone, color: Colors.orange),
          title: Text('Téléphone'),
          subtitle: Text('01 23 45 67 89'),
        ),
        ListTile(
          leading: Icon(Icons.email, color: Colors.orange),
          title: Text('Email'),
          subtitle: Text('contact@pizzapp.com'),
        ),
        // ✅ NOUVEAU: Ajout des horaires d'ouverture
        ListTile(
          leading: Icon(Icons.access_time, color: Colors.orange),
          title: Text('Horaires d\'ouverture'),
          subtitle: Text('Lundi - Vendredi: 11h30 - 22h00\nSamedi - Dimanche: 11h30 - 23h00'),
        ),
        SizedBox(height: 16),
        // Placeholder pour la Google Map
        Card(
          child: SizedBox(
            height: 200,
            child: Center(child: Text('Google Map à venir')),
          ),
        ),
      ],
    );
  }
}
