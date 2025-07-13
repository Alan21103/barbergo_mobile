import 'package:barbergo_mobile/core/core.dart';
import 'package:barbergo_mobile/data/model/request/pemesanan/pemesanan_request_model.dart';
import 'package:barbergo_mobile/data/model/response/admin/get_all_admin_response_model.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';
import 'package:barbergo_mobile/presentation/pemesanan/bloc/pemesanan_bloc.dart';
import 'package:barbergo_mobile/presentation/pemesanan/widgets/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal/waktu
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

// --- PemesananFormScreen ---
class PemesananFormScreen extends StatefulWidget {
  const PemesananFormScreen({super.key});

  @override
  State<PemesananFormScreen> createState() => _PemesananFormScreenState();
}

class _PemesananFormScreenState extends State<PemesananFormScreen> {
  // GlobalKey untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // State untuk date/time picker
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _dateTimeController = TextEditingController();

  // State untuk dropdown dan input lainnya
  GetAllServiceModel? _selectedService; // Menggunakan model GetAllServiceModel
  AdminDatum? _selectedBarber; // Menggunakan model AdminDatum (dari GetAllAdminResponseModel)
  String? _selectedAddress; // Alamat yang dipilih dari MapPage
  double? _selectedLatitude; // Latitude dari MapPage
  double? _selectedLongitude; // Longitude dari MapPage
  final TextEditingController _addressController = TextEditingController();

  // Data untuk dropdown yang akan diisi dari Bloc
  List<GetAllServiceModel> _serviceList = [];
  List<AdminDatum> _barberList = [];

  // State untuk melacak apakah data dropdown sedang dimuat
  bool _isLoadingServices = false;
  bool _isLoadingBarbers = false;

  @override
  void initState() {
    super.initState();
    // Memuat data layanan dan tukang cukur secara terpisah
    context.read<PemesananBloc>().add(LoadServicesEvent());
    context.read<PemesananBloc>().add(LoadBarbersEvent());
  }

  @override
  void dispose() {
    _dateTimeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)), // 1 tahun ke depan
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.secondary, // Warna header date picker
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Colors.black, // Warna teks tanggal
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary, // Warna tombol OK/CANCEL
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _selectTime(context); // Setelah pilih tanggal, langsung pilih waktu
    }
  }

  // Fungsi untuk menampilkan Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.secondary, // Warna header time picker
              onPrimary: Colors.white, // Warna teks di header
              onSurface: Colors.black, // Warna teks waktu
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary, // Warna tombol OK/CANCEL
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _updateDateTimeController(); // Update TextFormField setelah pilih waktu
    }
  }

  // Fungsi untuk memperbarui teks di TextFormField Jadwal
  void _updateDateTimeController() {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime fullDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      _dateTimeController.text = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(fullDateTime);
    } else {
      _dateTimeController.text = '';
    }
  }

  // Fungsi untuk menangani pemilihan alamat dari MapPage
  Future<void> _pickAddress() async {
    // Navigasi ke MapPage. MapPage diharapkan mengembalikan Map<String, dynamic>
    // yang berisi 'address', 'latitude', dan 'longitude'.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedAddress = result['address'] as String?;
        _selectedLatitude = result['latitude'] as double?;
        _selectedLongitude = result['longitude'] as double?;
        _addressController.text = _selectedAddress ?? ''; // Update controller
      });
    }
  }

  // Fungsi untuk menangani submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Pastikan tanggal dan waktu sudah dipilih
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih tanggal dan waktu pemesanan.')),
        );
        return;
      }
      // Pastikan alamat sudah dipilih
      if (_selectedAddress == null || _selectedAddress!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon pilih alamat pemesanan.')),
        );
        return;
      }

      final DateTime fullScheduledTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final requestModel = PemesananRequestModel(
        adminId: _selectedBarber!.id, // Menggunakan ID dari objek AdminDatum yang dipilih
        serviceId: _selectedService!.id, // Menggunakan ID dari objek GetAllServiceModel
        scheduledTime: fullScheduledTime, // Langsung gunakan objek DateTime
        alamat: _selectedAddress!,
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
      );

      // Panggil event CreatePemesananEvent
      context.read<PemesananBloc>().add(CreatePemesananEvent(requestModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dihapus untuk membuat background full screen
      // appBar: AppBar(
      //   title: Text(
      //     'Buat Pemesanan',
      //     style: GoogleFonts.poppins(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: Colors.teal,
      //   foregroundColor: Colors.white,
      //   centerTitle: true,
      // ),
      body: BlocListener<PemesananBloc, PemesananState>(
        listener: (context, state) {
          // Listener untuk operasi CRUD pemesanan
          if (state is PemesananLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Memproses pemesanan...',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.blueAccent,
              ),
            );
          } else if (state is PemesananSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Kembali ke layar sebelumnya
          } else if (state is PemesananAddErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal membuat pemesanan: ${state.error}',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          // Listener untuk data layanan (Service)
          else if (state is ServicesLoadingState) {
            setState(() {
              _isLoadingServices = true;
            });
          } else if (state is ServicesLoadedState) {
            setState(() {
              _isLoadingServices = false;
              _serviceList = state.services;
            });
          } else if (state is ServicesErrorState) {
            setState(() {
              _isLoadingServices = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal memuat layanan: ${state.error}',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          // Listener untuk data tukang cukur (Barber / Admin)
          else if (state is BarbersLoadingState) {
            setState(() {
              _isLoadingBarbers = true;
            });
          } else if (state is BarbersLoadedState) {
            setState(() {
              _isLoadingBarbers = false;
              _barberList = state.barbers;
            });
          } else if (state is BarbersErrorState) {
            setState(() {
              _isLoadingBarbers = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Gagal memuat tukang cukur: ${state.error}',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Full-screen background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/barbershop.jpg', // Path ke gambar wallpaper Anda
                fit: BoxFit.cover,
                // Optional: Add a color filter to make text more readable
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.4), // Adjust opacity as desired
              ),
            ),
            // Konten form di atas background (menggunakan Column dan Expanded)
            Column(
              children: [
                // Bagian atas yang kosong (untuk mendorong form ke bawah)
                // Sesuaikan flex ini untuk mengontrol seberapa banyak gambar yang terlihat di atas form
                const Expanded(flex: 1, child: SizedBox.shrink()), 

                // Form Section
                Expanded(
                  flex: 3, // Memberikan lebih banyak ruang untuk form, sesuaikan sesuai kebutuhan
                  child: SingleChildScrollView(
                    // Padding hanya di bagian atas untuk efek "terangkat"
                    padding: const EdgeInsets.only(top: 68.0),
                    child: Container(
                      // Tidak perlu Center di sini karena Container akan mengisi lebar Expanded
                      width: double.infinity, // Memastikan Container mengisi lebar penuh
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9), // Slightly transparent white for better blend
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0), // Hanya sudut atas yang melengkung
                          topRight: Radius.circular(30.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row( // Menggunakan Row untuk menempatkan ikon dan teks dalam satu baris
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, color: AppColors.primary), // Ikon kembali
                                  onPressed: () {
                                    Navigator.pop(context); // Fungsi untuk kembali ke layar sebelumnya
                                  },
                                ),
                                const SizedBox(width: 8), // Spasi antara ikon dan teks
                                Text(
                                  'Form Pemesanan',
                                  style: GoogleFonts.amarante( // Font diubah menjadi Amarante
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary, // Warna diubah ke AppColors.primary
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _buildSectionTitle('Tanggal & Waktu:'),
                            _buildDateTimePicker(),
                            const SizedBox(height: 20),

                            _buildSectionTitle('Pilih Layanan:'),
                            _buildServiceDropdown(),
                            const SizedBox(height: 20),

                            _buildSectionTitle('Pilih Tukang Cukur:'),
                            _buildBarberDropdown(),
                            const SizedBox(height: 20),

                            _buildSectionTitle('Alamat Pemesanan:'),
                            _buildAddressPicker(),
                            const SizedBox(height: 30),

                            Center(
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5, // Add shadow to button
                                ),
                                child: Text(
                                  'Buat Pemesanan',
                                  style: GoogleFonts.amarante(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method untuk judul bagian
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.amarante(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper method untuk Date/Time Picker
  Widget _buildDateTimePicker() {
    return TextFormField(
      controller: _dateTimeController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Ketuk untuk memilih tanggal & waktu',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none, // Remove default border
        ),
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: const Icon(Icons.calendar_today, color: AppColors.secondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal & waktu harus dipilih';
        }
        return null;
      },
      style: GoogleFonts.poppins(),
    );
  }

  // Helper method untuk Service Dropdown
  Widget _buildServiceDropdown() {
    return _isLoadingServices
        ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
        : _serviceList.isEmpty
            ? Text(
                'Tidak ada layanan tersedia.',
                style: GoogleFonts.poppins(color: Colors.grey),
              )
            : DropdownButtonFormField<GetAllServiceModel>(
                value: _selectedService,
                hint: Text(
                  'Pilih Layanan',
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
                items: _serviceList.map((GetAllServiceModel service) {
                  return DropdownMenuItem<GetAllServiceModel>(
                    value: service,
                    child: Text(
                      service.name ?? 'N/A',
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
                onChanged: (GetAllServiceModel? newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Layanan harus dipilih';
                  }
                  return null;
                },
                style: GoogleFonts.poppins(color: Colors.black),
              );
  }

  // Helper method untuk Barber Dropdown
  Widget _buildBarberDropdown() {
    return _isLoadingBarbers
        ? const Center(child: CircularProgressIndicator(color: AppColors.secondary))
        : _barberList.isEmpty
            ? Text(
                'Tidak ada tukang cukur tersedia.',
                style: GoogleFonts.poppins(color: Colors.grey),
              )
            : DropdownButtonFormField<AdminDatum>(
                value: _selectedBarber,
                hint: Text(
                  'Pilih Tukang Cukur',
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
                items: _barberList.map((AdminDatum barber) {
                  return DropdownMenuItem<AdminDatum>(
                    value: barber,
                    child: Text(
                      barber.name ?? 'N/A',
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
                onChanged: (AdminDatum? newValue) {
                  setState(() {
                    _selectedBarber = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Tukang cukur harus dipilih';
                  }
                  return null;
                },
                style: GoogleFonts.poppins(color: Colors.black),
              );
  }

  // Helper method untuk Address Picker
  Widget _buildAddressPicker() {
    return TextFormField(
      controller: _addressController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Ketuk untuk memilih alamat',
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: IconButton(
          icon: const Icon(Icons.map, color: AppColors.secondary),
          onPressed: _pickAddress,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onTap: _pickAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Alamat harus dipilih';
        }
        return null;
      },
      style: GoogleFonts.poppins(),
    );
  }
}
