import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.blue, // Customize color as needed
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Effective Date: February 2024',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('1. Introduction'),
              _buildParagraph(
                'Kshetrapati Industries Pvt Ltd is committed to protecting your privacy. '
                    'This Privacy Policy explains how we collect, use, disclose, and safeguard your '
                    'information when you visit our website, use our e-learning platform, or purchase our software products.',
              ),
              _buildSectionTitle('2. Information We Collect'),
              _buildBulletPoint('Personal Information: Name, email address, phone number, billing address, payment details.'),
              _buildBulletPoint('Account Information: Username, password, and profile information.'),
              _buildBulletPoint('Usage Data: Information about interactions with our platform.'),
              _buildBulletPoint('Device Information: IP address, browser type, operating system, and device identifiers.'),
              _buildBulletPoint('Cookies & Tracking: We use cookies to enhance user experience.'),

              _buildSectionTitle('3. How We Use Your Information'),
              _buildBulletPoint('Provide and manage accounts.'),
              _buildBulletPoint('Process transactions and send confirmations.'),
              _buildBulletPoint('Personalize user experience and improve services.'),
              _buildBulletPoint('Ensure compliance with legal obligations.'),

              _buildSectionTitle('4. How We Share Your Information'),
              _buildBulletPoint('Service Providers: Third-party vendors who assist in providing services.'),
              _buildBulletPoint('Business Transfers: In case of mergers or acquisitions.'),
              _buildBulletPoint('Legal Requirements: If required by law or legal processes.'),

              _buildSectionTitle('5. Your Choices and Rights'),
              _buildBulletPoint('Access and correct personal data.'),
              _buildBulletPoint('Opt-out of promotional emails.'),
              _buildBulletPoint('Manage cookie preferences.'),

              _buildSectionTitle('6. Data Security'),
              _buildParagraph(
                  'We implement reasonable security measures to protect your personal information. '
                      'However, no transmission over the internet is 100% secure.'
              ),

              _buildSectionTitle('7. Data Retention'),
              _buildParagraph(
                  'We retain your data as long as necessary for providing services, complying with legal obligations, '
                      'resolving disputes, and enforcing agreements.'
              ),

              _buildSectionTitle('8. Children’s Privacy'),
              _buildParagraph(
                  'Our services are not directed to individuals under 13. If we discover data from a child under 13, '
                      'we will delete it immediately.'
              ),

              _buildSectionTitle('9. Changes to This Privacy Policy'),
              _buildParagraph(
                  'We may update this policy periodically. Any changes will be posted on our website.'
              ),

              _buildSectionTitle('10. Contact Us'),
              _buildParagraph(
                  'Kshetrapati Industries Pvt Ltd\n'
                      'C-103 Ajmera Exotica, Wagholi, Pune.\n'
                      'Email: contact@kshetrapati.info\n'
                      'Phone: +91 7972657424'
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
