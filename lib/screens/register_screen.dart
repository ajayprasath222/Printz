import 'package:flutter/material.dart';
import 'package:printz/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String? selectedYear;
  String? selectedDepartment;

  @override
  void dispose() {
    // Dispose of the controllers when not needed
    _nameController.dispose();
    _rollNoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.1),
              _buildTitle('Register Your Account', width),
              SizedBox(height: height * 0.05),
              _buildLabel('Name'),
              _buildTextField(_nameController, 'Enter your name'),
              SizedBox(height: height * 0.02),
              _buildLabel('Roll No.'),
              _buildTextField(_rollNoController, 'Enter your roll number'),
              SizedBox(height: height * 0.02),
              _buildLabel('Choose Year and Dept'),
              _buildDropdowns(width),
              SizedBox(height: height * 0.02),
              _buildLabel('Mail'),
              _buildTextField(_emailController, 'Enter your Mail'),
              SizedBox(height: height * 0.05),
              _buildRegisterButton(),
              SizedBox(height: height * 0.05),
              _buildLoginPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, double width) {
    return Text(
      title,
      style: TextStyle(
        fontSize: width < 600 ? 26.0 : 30.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      maxLines: 1,
    );
  }

  Widget _buildDropdowns(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDropdown<String>(
          hint: selectedYear ?? 'Select Year',
          items: ['1st Year', '2nd Year', '3rd Year', '4th Year'],
          onChanged: (String? newValue) {
            setState(() {
              selectedYear = newValue;
            });
          },
        ),
        const SizedBox(width: 8),
        _buildDropdown<String>(
          hint: selectedDepartment ?? 'Department',
          items: ['ECE', 'Mech', 'CSE', 'Civil', 'IT', 'Cyber'],
          onChanged: (String? newValue) {
            setState(() {
              selectedDepartment = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged, // Updated to correct type
  }) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(hint),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: onChanged, // Fixed type issue here
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle register action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          'Register',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Text(
            ' Login',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }
}
