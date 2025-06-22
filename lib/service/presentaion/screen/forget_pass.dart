
import 'package:authenticationapp/service/presentaion/screen/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/auth_view_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Column(
            children: [
              const SizedBox(height: 70.0),
              const Align(
                alignment: Alignment.topCenter,
                child: Text("Password Recovery", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10.0),
              const Text("Enter your mail", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
              Expanded(child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Please Enter Email';
                            return null;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                            prefixIcon: Icon(Icons.person, color: Colors.white70, size: 30.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      GestureDetector(
                        onTap: viewModel.isLoading ? null : () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.sendPasswordResetEmail(_emailController.text);
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text("Send Email", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                          const SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                            child: const Text("Create", style: TextStyle(color: Color.fromARGB(225, 184, 166, 6), fontSize: 20.0, fontWeight: FontWeight.w500)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
