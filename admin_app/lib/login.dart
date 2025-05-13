import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final String BASE_URL = "https://sihgeoattendance-production.up.railway.app/";
  final email = TextEditingController();
  final pass = TextEditingController();
  // Function to show alert dialog
  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> checkCredentialsAndRoute(BuildContext context) async {
    final String apiUrl =
        BASE_URL + 'users/login'; // Replace with actual login endpoint
    final Map<String, dynamic> requestBody = {
      "email": email.text, // Text from email controller
      "password": pass.text, // Text from password controller
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Success
        final responseData = jsonDecode(response.body);
        print("Login Successful: ${responseData['message']}");
        Navigator.pushNamed(context, 'map');
        // Example: Navigate to dashboard or home screen
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      } else if (response.statusCode == 401) {
        // Unauthorized: Invalid credentials
        showAlertDialog(context, "Login Failed", "Invalid email or password.");
      } else {
        // Other server errors
        showAlertDialog(
            context, "Error", "Something went wrong: ${response.body}");
      }
    } catch (error) {
      // Network error or exception
      showAlertDialog(context, "Network Error",
          "Failed to connect to server. Please try again.");
      print("Error during login: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF96E9C6),
              Color(0xFF56C596),
              Color(0xFF1DA079),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  'Hello Again!',
                  style: TextStyle(
                    fontFamily: 'YatraOne',
                    fontSize: 48,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 5.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Welcome back, you\'ve been missed',
                  style: TextStyle(
                    fontFamily: 'YatraOne',
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Employee@gmail.com',
                    hintStyle: const TextStyle(
                      fontFamily: 'YatraOne',
                      fontSize: 15.0,
                      color: Colors.black45,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        email.clear();
                      },
                      icon: const Icon(Icons.clear, color: Colors.black45),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: TextField(
                  controller: pass,
                  obscureText: true, // Hides password input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontFamily: 'YatraOne',
                      fontSize: 15.0,
                      color: Colors.black45,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        pass.clear();
                      },
                      icon: const Icon(Icons.clear, color: Colors.black45),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: const Color(0xFF56C596),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black38,
                    ),
                    onPressed: () {
                      checkCredentialsAndRoute(context);
                      // Ensure 'map' route is defined in your MaterialApp routes
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'QuickSandBold'),
                    ),
                  ),
                  const SizedBox(width: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: const Color(0xFF56C596),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black38,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'QuickSandBold'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
