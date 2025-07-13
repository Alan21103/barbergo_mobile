// lib/presentation/auth/widgets/login_form_section.dart
import 'package:barbergo_mobile/core/components/buttons.dart';
import 'package:barbergo_mobile/core/components/custom_text_field.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';
import 'package:barbergo_mobile/core/extensions/build_context_ext.dart';
import 'package:barbergo_mobile/data/model/request/auth/login_request_model.dart';
import 'package:barbergo_mobile/presentation/admin/profile/admin_profile_screen.dart';
import 'package:barbergo_mobile/presentation/auth/bloc/login/login_bloc.dart';
import 'package:barbergo_mobile/presentation/auth/regisster_screen.dart';
import 'package:barbergo_mobile/presentation/pelanggan/profile/pelanggan_profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({super.key});

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> _key;
  bool isShowPassword = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _key = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 25.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Moved from LoginHeader to be inside the white area
                Image.asset(
                  'assets/images/barbergo.png',
                  width: 120,
                ),
                const SizedBox(height: 5),
                Text(
                  "Welcome To Barber App",
                  style: GoogleFonts.amarante(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  "Isi form login dibawah",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.028,
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 15), // Spacing before the first text field

                // EMAIL FIELD
                CustomTextField(
                  validator: 'Email tidak boleh kosong',
                  controller: emailController,
                  label: 'Email',
                  inputDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: AppColors.primary, width: 2.0),
                    ),
                    labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                    hintText: 'Masukkan Email Anda',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 10.0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.email,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // PASSWORD FIELD
                CustomTextField(
                  validator: 'Password tidak boleh kosong',
                  controller: passwordController,
                  label: 'Password',
                  obscureText: !isShowPassword,
                  inputDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: AppColors.primary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: AppColors.primary, width: 2.0),
                    ),
                    labelStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                    hintText: 'Masukkan Password Anda',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 10.0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.lock,
                        color: AppColors.primary,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      icon: Icon(
                        isShowPassword ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginFailure) {
                      if (kDebugMode) {
                        print(
                          '[DEBUG] Login Gagal: ${state.error}',
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    } else if (state is LoginSuccess) {
                      if (kDebugMode) {
                        print('[DEBUG] Login Berhasil');
                      }
                      final role =
                          state.responseModel.user?.role?.toLowerCase();
                      if (kDebugMode) {
                        print('[DEBUG] Role: $role');
                      }
                      if (kDebugMode) {
                        print(
                          '[DEBUG] Token: ${state.responseModel.user?.token}',
                        );
                      }
                      if (role == 'admin') {
                        context.pushAndRemoveUntil(
                          const AdminProfileScreen(),
                          (route) => false,
                        );
                      } else if (role == 'pelanggan') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.responseModel.message!,
                            ),
                          ),
                        );
                        context.pushAndRemoveUntil(
                          const PelangganProfileScreen(),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Role tidak dikenali'),
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return Button.filled(
                      onPressed: state is LoginLoading
                          ? null
                          : () {
                              if (_key.currentState!.validate()) {
                                final request = LoginRequestModel(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                if (kDebugMode) {
                                  print(
                                    '[DEBUG] Mengirim Permintaan Login',
                                  );
                                  print(
                                    '[DEBUG] Email: ${emailController.text}',
                                  );
                                  print(
                                    '[DEBUG] Password: ${passwordController.text}',
                                  );
                                }
                                context.read<LoginBloc>().add(
                                      LoginRequested(
                                        requestModel: request,
                                      ),
                                    );
                              }
                            },
                      label: state is LoginLoading ? 'Memuat...' : 'Masuk',
                    );
                  },
                ),
                const SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    text: 'Belum memiliki akun? Silahkan ',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize:
                          MediaQuery.of(context).size.width * 0.032,
                    ),
                    children: [
                      TextSpan(
                        text: 'Daftar disini!',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push(
                              const RegisterScreen(),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}