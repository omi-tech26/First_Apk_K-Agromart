import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kagro_app/register.dart';
import 'package:video_player/video_player.dart';
import 'Home.dart';
import 'forgot-password.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _passwordVisible = false;  // To track the visibility of the password

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/agri_video.mp4")
      ..initialize().then((_) {
        if (mounted) {
          print("Video initialized successfully.");
          setState(() {});
          _controller.setLooping(true);
          _controller.play();
        }
      }).catchError((e) {
        print('Error loading video: $e');
        _controller.dispose();  // Release resources if error occurs
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background video player
          Positioned.fill(
            child: _controller.value.isInitialized
                ? SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(_controller),
            )
                : Center(
              child: CircularProgressIndicator(), // Show loading indicator if video isn't initialized
            ),
          ),
          // Semi-transparent overlay for darkening background
          Container(color: Colors.black.withOpacity(0.5)),
          // Login content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/kagro logo.jpeg', // Ensure the logo is in assets
                      height: 100,
                    ),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Log in to continue your journey with us.',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: !_passwordVisible,  // Set the password visibility based on _passwordVisible
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;  // Toggle the visibility
                          });
                        },
                        child: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.orange.shade800,
                        ),
                        child: const Text(
                          'LOG IN',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          ),
                          child: const Text(
                            ' Sign Up',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,  // To add a suffix icon (e.g., eye icon)
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black), // Ensures input text is black
      onTap: () {
        if (controller.text.isEmpty) {
          controller.clear(); // Clears any existing text when tapped
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.orange),
        hintText: label, // Placeholder text that disappears when user types
        hintStyle: const TextStyle(color: Colors.grey), // Placeholder in grey
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,  // Add the suffix icon here
      ),
    );
  }

  void _loginUser() async {
    String email = _emailController.text.trim();  // Trim the email input
    String password = _passwordController.text.trim();  // Trim the password input

    // Validate email format
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      _showErrorDialog("Invalid email format.");
      return;
    }

    // Validate password
    final passwordRegex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
    if (password.isEmpty || !passwordRegex.hasMatch(password)) {
      _showErrorDialog("Password must be at least 8 characters long, including one uppercase, one lowercase letter, a special character, and a number.");
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Skip the email verification check and log the user in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showErrorDialog("Something went wrong, please try again.");
      }
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        _showErrorDialog("No user found for that email.");
      } else if (e is FirebaseAuthException && e.code == 'wrong-password') {
        _showErrorDialog("Incorrect password.");
      } else {
        _showErrorDialog("Login failed: ${e.toString()}");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
