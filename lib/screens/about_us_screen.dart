import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/app_database.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  LatLng? _mapCenter;
  bool _isLoadingMap = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = Provider.of<AppDatabase>(context, listen: false);
    db.watchCompanyInfo().first.then((info) {
      if (info != null && info.latitude != null && info.longitude != null) {
        if (mounted) {
          setState(() {
            _mapCenter = LatLng(info.latitude!, info.longitude!);
            _isLoadingMap = false;
          });
        }
      } else {
         if (mounted) {
          setState(() {
            _isLoadingMap = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À Propos'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<CompanyInfoData?>(
        stream: Provider.of<AppDatabase>(context).watchCompanyInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final info = snapshot.data;
          if (info == null) {
            return const Center(child: Text('Informations sur l\'établissement non disponibles.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.blue.shade100, child: Icon(Icons.storefront, color: Colors.blue.shade800, size: 40))),
              const SizedBox(height: 16),
              Center(child: Text(info.name ?? 'Notre Pizzeria', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              Center(child: Text(info.presentation ?? 'Bienvenue !', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium)),
              const Divider(height: 32),
              _buildSocialRow(info),
              const Divider(height: 32),
              ListTile(leading: const Icon(Icons.location_on, color: Colors.orange), title: const Text('Adresse'), subtitle: Text(info.address ?? 'Non renseignée')),
              ListTile(leading: const Icon(Icons.phone, color: Colors.orange), title: const Text('Téléphone'), subtitle: Text(info.phone ?? 'Non renseigné')),
              ListTile(leading: const Icon(Icons.email, color: Colors.orange), title: const Text('Email'), subtitle: Text(info.email ?? 'Non renseigné')),
              const ListTile(leading: Icon(Icons.access_time, color: Colors.orange), title: Text('Horaires d\'ouverture'), subtitle: Text('Lundi - Vendredi: 11h30 - 22h00\nSamedi - Dimanche: 11h30 - 23h00')),
              const SizedBox(height: 16),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  height: 300,
                  child: _isLoadingMap
                      ? const Center(child: CircularProgressIndicator())
                      : _mapCenter == null
                          ? const Center(child: Text('Coordonnées GPS non configurées.'))
                          : FlutterMap(
                              options: MapOptions(center: _mapCenter!, zoom: 16.0),
                              children: [
                                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                                MarkerLayer(markers: [Marker(width: 80.0, height: 80.0, point: _mapCenter!, child: const Icon(Icons.location_pin, color: Colors.red, size: 40))]),
                              ],
                            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSocialRow(CompanyInfoData info) {
    final Map<String, FaIcon> socialLinks = {
      if (info.facebookUrl != null && info.facebookUrl!.isNotEmpty) info.facebookUrl!: const FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF1877F2)),
      if (info.instagramUrl != null && info.instagramUrl!.isNotEmpty) info.instagramUrl!: const FaIcon(FontAwesomeIcons.instagram, color: Color(0xFFC13584)),
      if (info.xUrl != null && info.xUrl!.isNotEmpty) info.xUrl!: const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.black),
      if (info.whatsappPhone != null && info.whatsappPhone!.isNotEmpty) 'https://wa.me/${info.whatsappPhone}': const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366)),
      if (info.googleUrl != null && info.googleUrl!.isNotEmpty) info.googleUrl!: const FaIcon(FontAwesomeIcons.google, color: Color(0xFF4285F4)),
      if (info.pagesJaunesUrl != null && info.pagesJaunesUrl!.isNotEmpty) info.pagesJaunesUrl!: const FaIcon(FontAwesomeIcons.bookOpen, color: Color(0xFFFFD700)),
    };

    if (socialLinks.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: socialLinks.entries.map((entry) {
        return IconButton(
          icon: entry.value,
          iconSize: 32,
          onPressed: () async {
            final url = Uri.parse(entry.key);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          },
        );
      }).toList(),
    );
  }
}
