// lib/presentation/pembayaran/pembayaran_form_screen.dart
import 'package:barbergo_mobile/presentation/pelanggan/pembayaran/bloc/pembayaran_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Untuk memformat mata uang
import 'package:barbergo_mobile/core/constants/colors.dart'; // Import AppColors

// NEW: Import Bloc dan model terkait
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/data/model/request/pembayaran/pembayaran_request_model.dart';

class PembayaranFormScreen extends StatefulWidget {
  final int pemesananId;
  final double totalAmount;

  const PembayaranFormScreen({
    super.key,
    required this.pemesananId,
    required this.totalAmount,
  });

  @override
  State<PembayaranFormScreen> createState() => _PembayaranFormScreenState();
}

class _PembayaranFormScreenState extends State<PembayaranFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod; // Untuk menyimpan metode pembayaran yang dipilih

  // Daftar metode pembayaran yang tersedia
  // Sesuaikan dengan nilai 'via' yang diizinkan di backend (cash, transfer, qris)
  final List<String> _paymentMethods = ['cash', 'transfer', 'qris'];

  @override
  Widget build(BuildContext context) {
    // Memformat totalAmount ke format mata uang Rupiah
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formattedAmount = formatter.format(widget.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pembayaran Pesanan #${widget.pemesananId}',
          style: GoogleFonts.amarante(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<PembayaranBloc, PembayaranState>( // NEW: BlocListener
        listener: (context, state) {
          if (state is PembayaranLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Memproses pembayaran...',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.blueAccent,
              ),
            );
          } else if (state is PembayaranSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            // Kembali ke layar sebelumnya (detail pemesanan)
            // Anda mungkin ingin menavigasi ke halaman riwayat pemesanan atau home
            Navigator.pop(context); // Kembali dari PembayaranFormScreen
            Navigator.pop(context); // Kembali dari PemesananDetailScreen
          } else if (state is PembayaranError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal memproses pembayaran: ${state.error}',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total yang harus dibayar:',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formattedAmount,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                        Text(
                          'Pilih Metode Pembayaran:',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          value: _selectedPaymentMethod,
                          hint: Text(
                            'Pilih Metode',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          items: _paymentMethods.map((String method) {
                            return DropdownMenuItem<String>(
                              value: method,
                              // PERBAIKAN: Teks yang diformat langsung di child Text
                              child: Text(
                                method.substring(0, 1).toUpperCase() + method.substring(1),
                                style: GoogleFonts.poppins(),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPaymentMethod = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Metode pembayaran harus dipilih';
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _submitPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Konfirmasi Pembayaran',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      // NEW: Dispatch CreatePembayaranEvent ke PembayaranBloc
      context.read<PembayaranBloc>().add(
            CreatePembayaranEvent(
              PembayaranRequestModel(
                pemesananId: widget.pemesananId,
                amount: widget.totalAmount,
                status: 'paid', // Mengirim status 'paid' saat konfirmasi
                via: _selectedPaymentMethod!, // Menggunakan metode pembayaran yang dipilih
              ),
            ),
          );
    }
  }
}
