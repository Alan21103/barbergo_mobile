import 'package:barbergo_mobile/presentation/admin/service/bloc/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/data/model/response/services/get_all_service_model.dart';
import 'package:barbergo_mobile/data/repository/service_repository.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:barbergo_mobile/core/components/navigation_bar_admin.dart'; // Import CustomAdminBottomNavBar
import 'package:barbergo_mobile/core/constants/colors.dart'; // Pastikan ini diimpor
import 'package:google_fonts/google_fonts.dart'; // Pastikan ini diimpor

class AdminServiceScreen extends StatefulWidget {
  const AdminServiceScreen({super.key});

  @override
  State<AdminServiceScreen> createState() => _AdminServiceScreenState();
}

class _AdminServiceScreenState extends State<AdminServiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _selectedIndex = 2; // Set index awal ke 2 untuk 'Layanan'

  @override
  void initState() {
    super.initState();
    // Memuat semua layanan saat layar diinisialisasi
    // Asumsi admin ingin melihat semua layanan
    // BlocProvider sekarang di level atas, jadi event dipanggil di sana
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Callback untuk menangani tap pada item Bottom Navigation Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigasi sebenarnya akan ditangani di dalam CustomAdminBottomNavBar
    // sehingga tidak perlu ada Navigator.pushReplacement di sini lagi.
  }

  // Fungsi untuk menampilkan dialog form layanan (tambah/edit)
  void _showServiceFormDialog({GetAllServiceModel? serviceToEdit}) {
    // Isi controller jika sedang mode edit
    if (serviceToEdit != null) {
      _nameController.text = serviceToEdit.name ?? '';
      _priceController.text = serviceToEdit.price?.toString() ?? ''; // Convert int/double to String
      _descriptionController.text = serviceToEdit.description ?? '';
    } else {
      // Kosongkan controller jika mode tambah
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          serviceToEdit == null ? 'Tambah Layanan Baru' : 'Edit Layanan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextFormField(
                  controller: _nameController,
                  labelText: 'Nama Layanan',
                  icon: Icons.cut,
                  validatorMessage: 'Nama layanan tidak boleh kosong',
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _priceController,
                  labelText: 'Harga',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validatorMessage: 'Harga harus berupa angka dan tidak boleh kosong',
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _descriptionController,
                  labelText: 'Deskripsi',
                  icon: Icons.description,
                  maxLines: 3,
                  validatorMessage: 'Deskripsi tidak boleh kosong',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.grey),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (serviceToEdit == null) {
                  // Tambah Layanan
                  context.read<ServiceBloc>().add(
                        CreateServiceEvent(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          price: _priceController.text, // Mengirim sebagai String
                        ),
                      );
                } else {
                  // Edit Layanan
                  context.read<ServiceBloc>().add(
                        UpdateServiceEvent(
                          id: serviceToEdit.id!,
                          name: _nameController.text,
                          description: _descriptionController.text,
                          price: _priceController.text, // Mengirim sebagai String
                        ),
                      );
                }
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              serviceToEdit == null ? 'Tambah' : 'Simpan',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk TextFormField yang konsisten
  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (keyboardType == TextInputType.number && double.tryParse(value) == null) {
          return 'Harus berupa angka';
        }
        return null;
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Konfirmasi Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary)),
        content: Text('Apakah Anda yakin ingin menghapus layanan ini?', style: GoogleFonts.poppins(color: AppColors.grey)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.grey),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ServiceBloc>().add(DeleteServiceEvent(id: id));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun daftar layanan
  Widget _buildServiceListBody() {
    return BlocConsumer<ServiceBloc, ServiceState>(
      listener: (context, state) {
        if (state is ServiceActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          // Reload services after successful action
          context.read<ServiceBloc>().add(GetServicesEvent());
        } else if (state is ServiceActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal melakukan aksi: ${state.error}')),
          );
        } else if (state is ServiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error memuat layanan: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is ServiceLoading || state is ServiceCreating || state is ServiceUpdating || state is ServiceDeleting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is ServiceLoaded) {
          if (state.services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.room_service, size: 80, color: AppColors.grey),
                  const SizedBox(height: 10),
                  Text('Belum ada layanan yang tersedia.', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.grey)),
                  const SizedBox(height: 5),
                  Text(
                    'Tekan tombol tambah untuk membuat layanan baru.',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.services.length,
            itemBuilder: (context, index) {
              final service = state.services[index];
              return _buildServiceCard(service);
            },
          );
        }
        // Ini akan menangani ServiceInitial dan state lainnya yang tidak tertangkap di atas
        return const Center(child: Text('Tekan tombol tambah untuk membuat layanan.'));
      },
    );
  }

  // Helper untuk membangun kartu layanan individual
  Widget _buildServiceCard(GetAllServiceModel service) {
    return Card(
      color: AppColors.primary, // Warna latar belakang kartu
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.secondary.withOpacity(0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cut, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  service.name ?? 'N/A',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.white70, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Harga: Rp${service.price ?? 'N/A'}',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.description_outlined, color: Colors.white70, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Deskripsi: ${service.description ?? 'N/A'}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (service.barberId != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white54, size: 18),
                  const SizedBox(width: 6),
                  Text('Barber ID: ${service.barberId}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
                ],
              ),
            ],
            const Divider(height: 16, thickness: 1, color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 22),
                  onPressed: () => _showServiceFormDialog(serviceToEdit: service),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
                  onPressed: () {
                    if (service.id != null) {
                      _showDeleteConfirmationDialog(service.id!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ID Layanan tidak tersedia untuk dihapus.')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        // Pastikan ServiceBloc disediakan di sini di level yang cukup tinggi
        create: (context) => ServiceBloc(
          ServiceRepository(
            ServiceHttpClient(),
          ),
        )..add(GetServicesEvent()), // Muat semua layanan saat bloc dibuat
        child: Stack(
          children: [
            // Top wave background
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Screen content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Text(
                            'Kelola Layanan Barber',
                            style: GoogleFonts.amarante(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 28 + 16), // Untuk menyeimbangkan tombol kembali
                      ],
                    ),
                  ),
                  // Main body content (services list)
                  Expanded(child: _buildServiceListBody()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showServiceFormDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: CustomAdminBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Tambahkan Clipper di bawah file ini:
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}