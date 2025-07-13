// lib/presentation/auth/widgets/login_background.dart
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full-screen background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/barbershop.jpg', // Path ke gambar wallpaper Anda
            fit: BoxFit.cover,
          ),
        ),
        // Translucent overlay for text contrast (optional)
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.4), // Adjust opacity as desired
          ),
        ),
      ],
    );
  }
}