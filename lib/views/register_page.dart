import 'package:flutter/material.dart';
import 'package:spotify_mobile/navigations/tabbar.dart';
import 'package:spotify_mobile/database_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController dayController;
  late TextEditingController monthController;
  late TextEditingController yearController;
  late String selectedGender = 'Pria'; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    dayController = TextEditingController();
    monthController = TextEditingController();
    yearController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  bool validateStep() {
    switch (_currentStep) {
      case 0:
        return emailController.text.isNotEmpty;
      case 1:
        return passwordController.text.isNotEmpty;
      case 2:
        return dayController.text.isNotEmpty &&
            monthController.text.isNotEmpty &&
            yearController.text.isNotEmpty;
      case 3:
        return selectedGender.isNotEmpty;
      default:
        return false;
    }
  }

  void showEmptyFieldsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Form Kosong'),
          content: Text('Harap isi semua formulir sebelum melanjutkan.'),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dayController.text = picked.day.toString();
        monthController.text = picked.month.toString();
        yearController.text = picked.year.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Akun"),
        centerTitle: true,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            if (validateStep()) {
              setState(() {
                _currentStep++;
              });
            } else {
              showEmptyFieldsAlert(); // Show alert for empty fields
            }
          } else {
            // Handle registration logic here
            handleRegistration();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: [
          buildStep("Email", emailController),
          buildStep("Password", passwordController),
          buildDateStep("Tanggal Lahir", () => _selectDate(context)),
          buildGenderStep("Gender"),
        ],
      ),
    );
  }

  Step buildStep(String title, TextEditingController controller) {
    return Step(
      title: Text(title),
      content: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
        ],
      ),
    );
  }

  Step buildDateStep(String title, VoidCallback onTap) {
    return Step(
      title: Text(title),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: dayController,
                  decoration: InputDecoration(labelText: 'Day'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: monthController,
                  decoration: InputDecoration(labelText: 'Month'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: yearController,
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Step buildGenderStep(String title) {
    return Step(
      title: Text(title),
      content: Column(
        children: [
          DropdownButton<String>(
            value: selectedGender,
            hint: Text('Select Gender'),
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
              });
            },
            items: ['Pria', 'Wanita', 'Tidak ingin memberi tahu']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void handleRegistration() async {
    if (validateStep()) {
      Map<String, dynamic> userData = {
        'email': emailController.text,
        'password': passwordController.text,
        'birth_date': '${dayController.text}/${monthController.text}/${yearController.text}',
        'gender': selectedGender,
      };

      int userId = await DatabaseHelper().insertUser(userData);


      if (userId != -1) {
        // Registration successful, you can navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Tabbar(),
          ),
        );
      } else {
        // Handle registration failure (e.g., show an error message)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text('An error occurred during registration.'),
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
    } else {
      showEmptyFieldsAlert(); // Show alert for empty fields
    }
  }
}
