import 'package:barbergo_mobile/presentation/auth/login/widgets/login_background.dart';
import 'package:barbergo_mobile/presentation/auth/login/widgets/login_form.dart'; // Assuming this is LoginFormSection
import 'package:barbergo_mobile/presentation/auth/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          LoginBackground(),

          // Content Column
          Column(
            children: [
              // Header inside an Expanded
              // This will make the header take up available space,
              // but you might need to adjust its internal layout (e.g., MainAxisAlignment)
              // if you want it to push its content to the top/bottom or center.
              Expanded(
                flex: 1, // You can adjust flex to control ratio with LoginFormSection
                child: LoginHeader(),
              ),
              // Form Section (already expanded)
              Expanded(
                flex: 2, // Assign a higher flex to the form for more space, adjust as needed
                child: LoginFormSection(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}