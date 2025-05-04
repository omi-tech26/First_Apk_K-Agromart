import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset('assets/images/logo_Kshetrapati.png', height: 100),
            const SizedBox(height: 20),

            // Contact Information
            _buildContactInfo('Name:', 'Kshetrapati Industries'),
            _buildContactInfo('Address:', 'C103 Ajmera exotica wagholi wagholi 412207'),
            _buildClickableInfo(Icons.email, 'Email Id:', 'sales@kshetrapati.com', 'mailto:contact@kshetrapati.info'),
            _buildClickableInfo(Icons.phone, 'Contact:', '7972657424', 'tel:7972657424'),
            _buildClickableInfo(Icons.public, 'Website:', 'www.kshetrapati.info', 'https://www.kshetrapati.info'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableInfo(IconData icon, String label, String value, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => launchUrl(Uri.parse(url)),
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
