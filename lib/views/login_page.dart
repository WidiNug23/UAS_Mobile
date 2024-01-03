import 'package:flutter/material.dart';
import 'package:spotify_mobile/navigations/tabbar.dart';
import 'package:spotify_mobile/database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    bool isRegistered = await checkUserRegistration();

                    if (isRegistered) {
                      // User is registered, handle login logic here
                      // ...

                      // Navigate to the next screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Tabbar()),
                      );
                    } else {
                      // User is not registered, show alert or handle accordingly
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('User Not Registered'),
                            content: Text('Please register before logging in.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text("Masuk"),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: Text("Kembali"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkUserRegistration() async {
    List<Map<String, dynamic>> users = await _dbHelper.getUsers();
    String enteredEmail = emailController.text;
    String enteredPassword = passwordController.text;

    for (var user in users) {
      if (user['email'] == enteredEmail && user['password'] == enteredPassword) {
        return true; // User is registered
      }
    }
    return false; // User is not registered
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
