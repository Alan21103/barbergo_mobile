// lib/presentation/auth/widgets/login_header.dart
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text(''), // Title is empty as per original
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        // Remove the Image.asset, Welcome text, and Isi form text from here
        const SizedBox(
            height: 77), // Adjust this height as needed to position the white box
      ],
    );
  }
}