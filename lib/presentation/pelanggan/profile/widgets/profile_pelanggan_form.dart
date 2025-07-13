
import 'package:barbergo_mobile/data/model/request/pelanggan/pelanggan_profile_request_model.dart';
import 'package:barbergo_mobile/presentation/pelanggan/home/pelanggan_home_screen.dart';
import 'package:barbergo_mobile/presentation/pelanggan/profile/bloc/profile_pelanggan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfilePelangganInputForm extends StatefulWidget {
  const ProfilePelangganInputForm({super.key});

  @override
  State<ProfilePelangganInputForm> createState() => ProfilePelangganInputFormState();
}

class ProfilePelangganInputFormState extends State<ProfilePelangganInputForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePelangganBloc, ProfilePelangganState>(
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
                  validator:
                      (value) =>
                          value!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Alamat"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "No HP"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Nomor HP tidak boleh kosong" : null,
                ),
                const SizedBox(height: 20),
                BlocConsumer<ProfilePelangganBloc, ProfilePelangganState>(
                  listener: (context, state) {
                    if (state is ProfilePelangganAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profil berhasil disimpan"),
                        ),
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PelangganHomeScreen(), // <- sesuaikan jika perlu
                        ),
                        (route) => false,
                      );
                    } else if (state is ProfilePelangganError ||
                        state is ProfilePelangganAddError) {
                      final errorMessage =
                          state is ProfilePelangganError
                              ? state.message
                              : (state as ProfilePelangganAddError).message;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(errorMessage)));
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is ProfilePelangganLoading;

                    return ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  final request = PelangganProfileRequestModel(
                                    name: nameController.text,
                                    address: addressController.text,
                                    phone: phoneController.text,
                                    photo: "",
                                  );
                                  context.read<ProfilePelangganBloc>().add(
                                    AddProfilePelangganEvent(requestModel: request),
                                  );
                                }
                              },
                      child:
                          isLoading
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