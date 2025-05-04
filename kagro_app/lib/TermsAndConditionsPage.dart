import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        backgroundColor: Colors.blue, // Customize as needed
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'Effective Date: February 2024',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              _buildSectionTitle('1. Introduction'),
              _buildSectionContent(
                  'Welcome to Kshetrapati Industries Pvt Ltd. These Terms and Conditions govern your use of our website, e-learning platform, and software products and Services. By accessing or using our Services, you agree to comply with and be bound by these Terms. If you do not agree with these Terms, you must not use our Services.'),

              _buildSectionTitle('2. Eligibility'),
              _buildSectionContent(
                  'You must be at least 18 years old or the legal age of majority in your jurisdiction to use our Services. By using our Services, you represent and warrant that you meet the eligibility requirements.'),

              _buildSectionTitle('3. Account Registration'),
              _buildBulletPoint('Account Creation: To access certain features, you may need to create an account. Provide accurate, current, and complete information during registration.'),
              _buildBulletPoint('Account Security: You are responsible for maintaining the confidentiality of your account credentials and must notify us of any unauthorized use.'),

              _buildSectionTitle('4. Use of Services'),
              _buildBulletPoint('License: We grant you a limited, non-exclusive, non-transferable, and revocable license to use our Services.'),
              _buildBulletPoint('Prohibited Activities: You agree not to:'),
              _buildIndentedBulletPoint('Use the Services for any unlawful purpose.'),
              _buildIndentedBulletPoint('Reverse-engineer, decompile, or disassemble any part of our software.'),
              _buildIndentedBulletPoint('Distribute malware, spam, or harmful content.'),
              _buildIndentedBulletPoint('Attempt to interfere with the operation or security of the Services.'),

              _buildSectionTitle('5. Content and Intellectual Property'),
              _buildBulletPoint('Ownership: All content, including text, graphics, and software, is the property of Kshetrapati Industries Pvt Ltd.'),
              _buildBulletPoint('User Content: You retain ownership of any submitted content but grant us a non-exclusive, royalty-free license to use it.'),
              _buildBulletPoint('Copyright Infringement: Contact us if you believe any content infringes your copyright.'),

              _buildSectionTitle('6. Fees and Payments'),
              _buildBulletPoint('Pricing: Fees for courses and software are listed on our website and are non-refundable unless stated otherwise.'),
              _buildBulletPoint('Payment: Payments must be made through provided methods.'),
              _buildBulletPoint('Refund: Failed transactions will be credited back within 5-7 working days.'),
              _buildBulletPoint('Subscription Services: Subscriptions auto-renew unless canceled as per policy.'),

              _buildSectionTitle('7. Termination'),
              _buildBulletPoint('Termination by You: You may delete your account at any time.'),
              _buildBulletPoint('Termination by Us: We may suspend or terminate your account for any reason.'),
              _buildBulletPoint('Effect of Termination: Upon termination, all licenses and rights cease.'),

              _buildSectionTitle('8. Disclaimers and Limitation of Liability'),
              _buildBulletPoint('Services are provided "as is" without warranties.'),
              _buildBulletPoint('Kshetrapati Industries Pvt Ltd is not liable for indirect or consequential damages.'),
              _buildBulletPoint('Our total liability will not exceed the amount paid in the past 12 months.'),

              _buildSectionTitle('9. Indemnification'),
              _buildSectionContent(
                  'You agree to indemnify and hold Kshetrapati Industries Pvt Ltd harmless from claims, damages, or expenses resulting from your use of the Services or violation of these Terms.'),

              _buildSectionTitle('10. Changes to These Terms'),
              _buildSectionContent(
                  'We may update these Terms from time to time. If changes occur, we will notify you by email or on our website. Continued use of the Services means acceptance of the new Terms.'),

              _buildSectionTitle('11. Changes to This Privacy Policy'),
              _buildSectionContent(
                  'We may update this Privacy Policy periodically. Please review it regularly for changes.'),

              _buildSectionTitle('12. Contact Us'),
              _buildSectionContent(
                  'If you have any questions, contact us at:\nKshetrapati Industries Pvt Ltd\nC-103 Ajmera Exotica, Wagholi, Pune.\nEmail: contact@kshetrapati.info\nPhone: +91 7972657424'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 5.0),
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

  Widget _buildIndentedBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('- ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
