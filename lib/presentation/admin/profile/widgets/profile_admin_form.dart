
import 'package:barbergo_mobile/data/model/request/admin/admin_profile_request_model.dart';
import 'package:barbergo_mobile/presentation/Admin/Admin_home_screen.dart';
import 'package:barbergo_mobile/presentation/admin/profile/bloc/profile_admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAdminInputForm extends StatefulWidget {
  const ProfileAdminInputForm({super.key});

  @override
  State<ProfileAdminInputForm> createState() => _ProfileAdminInputFormState();
}

class _ProfileAdminInputFormState extends State<ProfileAdminInputForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileAdminBloc, ProfileAdminState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nama"),
                  validator: (value) =>
                      value!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Alamat"),
                  validator: (value) =>
                      value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "No HP"),
                  validator: (value) =>
                      value!.isEmpty ? "Nomor HP tidak boleh kosong" : null,
                ),
                const SizedBox(height: 20),
                BlocConsumer<ProfileAdminBloc, ProfileAdminState>(
                  listener: (context, state) {
                    if (state is ProfileAdminAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profil berhasil disimpan"),
                        ),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminHomeScreen(),
                        ),
                        (route) => false,
                      );
                    } else if (state is ProfileAdminError ||
                        state is ProfileAdminAddError) {
                      final errorMessage = state is ProfileAdminError
                          ? state.message
                          : (state as ProfileAdminAddError).message;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(errorMessage)));
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ProfileAdminLoading;

                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final request = AdminProfileRequestModel(
                                  name: nameController.text,
                                  alamat: addressController.text,
                                );
                                context.read<ProfileAdminBloc>().add(
                                  AddProfileAdminEvent(requestModel: request),
                                );
                              }
                            },
                      child: isLoading
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : Text("Simpan Profil"),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
