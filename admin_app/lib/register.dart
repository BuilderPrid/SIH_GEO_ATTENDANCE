import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});
  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final String BASE_URL = "http://localhost:3000/";
  final email = TextEditingController();
  final pass = TextEditingController();
  final name = TextEditingController();
  Future<void> registerUser() async {
    final String apiUrl =
        BASE_URL + 'users/signup'; // Replace with actual API URL
    final Map<String, dynamic> requestBody = {
      "uuid": Uuid().v4(),
      "email": email.text, // Get text from the controller
      "name": name.text,
      "password": pass.text,
      "currentLocation": "Office A",
      "workMode": "WFO",
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
        print("Registration Successful: ${responseData['message']}");
      } else {
        // Error
        print("Failed: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
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
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'YatraOne',
                    fontSize: 40,
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
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Employee Name',
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
                        name.clear();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black45,
                      ),
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
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black45,
                      ),
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
                  obscureText: true,
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
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color(0xFF56C596),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 10,
                  shadowColor: Colors.black38,
                ),
                onPressed: () {
                  registerUser();
                  Navigator.pushNamed(context, 'login');
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'QuickSandBold'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
