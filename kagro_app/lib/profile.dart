import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kagro_app/AboutPage.dart';
import 'package:kagro_app/ContactUsPage.dart';
import 'package:kagro_app/PrivacyPolicyPage.dart';
import 'package:kagro_app/TermsAndConditionsPage.dart';
import 'loginpage.dart';
import 'editprofile.dart';
import 'orders.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "";
  String userEmail = "";
  String userPhone = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          userEmail = userDoc['email'] ?? "";
          userName = "${userDoc['firstName'] ?? ""} ${userDoc['lastName'] ?? ""}";
          userPhone = userDoc['phone'] ?? "";
          print('User ID: ${user?.uid}');
          print('Document Exists: ${userDoc.exists}');
          print('Document Data: ${userDoc.data()}');
        });
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  Future<void> _deleteAccount() async {
    final user = _auth.currentUser;

    if (user != null) {
      bool confirmDelete = await _showConfirmationDialog();
      if (!confirmDelete) return;

      try {
        String uid = user.uid;

        // Delete user data from Firestore
        await _firestore.collection('users').doc(uid).delete();

        // Delete Firebase Authentication user
        await user.delete();

        // Sign out the user
        await _auth.signOut();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account deleted successfully")),
        );

        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting account: ${e.toString()}")),
        );
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Account"),
        content: Text("Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _buildTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50), // Prevents overlap with button
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.green,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Colors.green),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $userName!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(userEmail, style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 4),
                          Text(userPhone, style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Options List
                _buildTile('My Orders', Icons.shopping_cart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserOrdersPage()),
                  );
                }),
                _buildTile('My Profile', Icons.person, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                }),
                _buildTile('Terms & Conditions', Icons.description, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TermsPage()));
                }),
                _buildTile('Privacy Policy', Icons.privacy_tip, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPage()));
                }),
                _buildTile('About Us', Icons.info, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));
                }),
                _buildTile('Contact Us', Icons.phone, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUs()));
                }),
                _buildTile('Logout', Icons.logout, _logout),
                SizedBox(height: 100),
                // Space so last tile isn’t hidden by button
              ],
            ),
          ),

          // Delete Account Button (Always at Bottom)
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: _deleteAccount,
              icon: Icon(Icons.delete, color: Colors.white),
              label: Text(
                'Delete Account',
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteAccount() {
    print("Account Deleted!");
  }
}
