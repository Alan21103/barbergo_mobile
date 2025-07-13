import 'dart:convert'; // Untuk base64Encode
import 'dart:io'; // Untuk File
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_bloc.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_event.dart';
import 'package:barbergo_mobile/presentation/admin/bloc/portofolio_state.dart';
import 'package:barbergo_mobile/presentation/admin/camera/components/native_camera.dart';
import 'package:barbergo_mobile/presentation/admin/camera/components/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbergo_mobile/data/model/response/portofolios/get_all_portofolios_response_model.dart';
import 'package:barbergo_mobile/data/repository/portofolio_repository.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:barbergo_mobile/core/components/navigation_bar_admin.dart';
import 'package:barbergo_mobile/core/constants/colors.dart'; // Pastikan ini ada
import 'package:google_fonts/google_fonts.dart'; // Pastikan ini ada
import 'package:image_picker/image_picker.dart';

class AdminPortofolioScreen extends StatefulWidget {
  const AdminPortofolioScreen({super.key});

  @override
  State<AdminPortofolioScreen> createState() => _AdminPortofolioScreenState();
}

class _AdminPortofolioScreenState extends State<AdminPortofolioScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage; // Untuk menyimpan file gambar yang dipilih
  String? _currentImageUrl; // Untuk menyimpan URL gambar saat ini (saat edit)

  int _selectedIndex = 3; // Set index awal ke 3 untuk 'Portofolio'

  @override
  void initState() {
    super.initState();
    // Memuat portofolio milik barber yang sedang login
    // BlocProvider sekarang di level atas, jadi event dipanggil di sana
  }

  @override
  void dispose() {
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

  // Fungsi untuk memilih gambar dari galeri/kamera
  // Menerima setStateCallback untuk me-rebuild dialog
  Future<void> _pickImage(Function setStateCallback) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Untuk sudut membulat
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.primary),
                title: Text('Pilih dari Galeri', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setStateCallback(() {
                      _selectedImage = image;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primary),
                title: Text('Ambil Foto', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final File? capturedImage = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraPage()),
                  );
                  if (capturedImage != null) {
                    // --- PENTING: Simpan gambar ke penyimpanan perangkat di sini ---
                    try {
                      final File savedFile = await StorageHelper.saveImage(capturedImage, 'portfolio_');
                      setStateCallback(() {
                        _selectedImage = XFile(savedFile.path); // Gunakan path file yang sudah disimpan
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gambar berhasil disimpan ke: ${savedFile.path}')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menyimpan gambar: $e')),
                      );
                      print('Error saving image: $e'); // Log error untuk debugging
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog form portofolio (tambah/edit)
  void _showPortofolioFormDialog({PortofolioDatum? portfolioToEdit}) {
    // Reset state dialog
    _selectedImage = null;
    _currentImageUrl = null;

    // Isi controller dan gambar jika sedang mode edit
    if (portfolioToEdit != null) {
      _descriptionController.text = portfolioToEdit.description ?? '';
      _currentImageUrl = portfolioToEdit.image; // Simpan URL gambar yang ada
    } else {
      // Kosongkan controller jika mode tambah
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          portfolioToEdit == null ? 'Tambah Portofolio Baru' : 'Edit Portofolio',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary),
        ),
        content: StatefulBuilder(
          // Menggunakan StatefulBuilder di sini
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tampilan gambar yang dipilih atau gambar saat ini
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _selectedImage != null
                            ? Image.file(File(_selectedImage!.path), fit: BoxFit.cover)
                            : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                                ? Image.network(
                                    _currentImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Center(child: Icon(Icons.image_not_supported, size: 80, color: AppColors.grey)),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.photo, size: 60, color: AppColors.grey),
                                        Text('Tidak ada gambar dipilih', style: GoogleFonts.poppins(color: AppColors.grey)),
                                      ],
                                    ),
                                  )),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(setStateDialog), // Meneruskan setStateDialog
                      icon: const Icon(Icons.image, color: Colors.white),
                      label: Text(
                        _selectedImage != null || (_currentImageUrl != null && _currentImageUrl!.isNotEmpty)
                            ? 'Ganti Gambar'
                            : 'Pilih Gambar',
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      controller: _descriptionController,
                      labelText: 'Deskripsi Portofolio',
                      icon: Icons.description,
                      maxLines: 3,
                      validatorMessage: 'Deskripsi tidak boleh kosong',
                    ),
                  ],
                ),
              ),
            );
          },
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
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                String? imageBase64;
                if (_selectedImage != null) {
                  // Konversi gambar ke Base64
                  final bytes = await _selectedImage!.readAsBytes();
                  imageBase64 = base64Encode(bytes);
                } else if (portfolioToEdit != null && _currentImageUrl != null) {
                  // Jika tidak ada gambar baru dipilih saat edit, dan ada gambar lama,
                  // kita bisa mengirim null untuk 'image' di request model,
                  // dan backend akan mempertahankan gambar lama jika 'image' nullable.
                  imageBase64 = null; // Biarkan null jika tidak ada gambar baru dipilih
                }

                // Validasi bahwa setidaknya ada gambar atau gambar lama
                if (imageBase64 == null && (portfolioToEdit == null || _currentImageUrl == null || _currentImageUrl!.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mohon pilih gambar untuk portofolio.')),
                  );
                  return; // Jangan lanjutkan jika tidak ada gambar
                }

                if (portfolioToEdit == null) {
                  // Tambah Portofolio
                  context.read<PortofoliosBloc>().add(
                        CreatePortofoliosEvent(
                          image: imageBase64, // Mengirim Base64 string
                          description: _descriptionController.text,
                        ),
                      );
                } else {
                  // Edit Portofolio
                  context.read<PortofoliosBloc>().add(
                        UpdatePortofoliosEvent(
                          id: portfolioToEdit.id!,
                          image: imageBase64, // Mengirim Base64 string (null jika tidak diganti)
                          description: _descriptionController.text,
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
              portfolioToEdit == null ? 'Tambah' : 'Simpan',
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
        prefixIcon: Icon(icon, color: AppColors.grey),
        labelStyle: GoogleFonts.poppins(color: AppColors.grey),
        floatingLabelStyle: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w600),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
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
        content: Text('Apakah Anda yakin ingin menghapus portofolio ini?', style: GoogleFonts.poppins(color: AppColors.grey)),
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
              context.read<PortofoliosBloc>().add(DeletePortofoliosEvent(id: id));
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

  // Widget untuk membangun daftar portofolio
  Widget _buildPortofolioListBody() {
    return BlocConsumer<PortofoliosBloc, PortofoliosState>(
      listener: (context, state) {
        if (state is PortofoliosActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          // Reload portofolios after successful action
          context.read<PortofoliosBloc>().add(GetMyPortofoliosEvent());
        } else if (state is PortofoliosActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal melakukan aksi: ${state.error}')),
          );
        } else if (state is PortofoliosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error memuat portofolio: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        if (state is PortofoliosLoading ||
            state is PortofoliosCreating ||
            state is PortofoliosUpdating ||
            state is PortofoliosDeleting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is PortofoliosLoaded) {
          if (state.portfolios.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library, size: 80, color: AppColors.grey),
                  const SizedBox(height: 10),
                  Text('Belum ada portofolio yang tersedia.',
                      style: GoogleFonts.poppins(fontSize: 16, color: AppColors.grey)),
                  const SizedBox(height: 5),
                  Text(
                    'Tekan tombol tambah untuk membuat portofolio baru.',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7, // Aspek rasio untuk kartu agar gambar terlihat lebih besar
            ),
            itemCount: state.portfolios.length,
            itemBuilder: (context, index) {
              final portfolio = state.portfolios[index];
              return _buildPortofolioCard(portfolio);
            },
          );
        }
        return const Center(child: Text('Tekan tombol tambah untuk membuat portofolio.'));
      },
    );
  }

  // Helper untuk membangun kartu portofolio individual
  Widget _buildPortofolioCard(PortofolioDatum portfolio) {
    return Card(
      color: AppColors.white, // Latar belakang putih
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: portfolio.image != null && portfolio.image!.isNotEmpty
                  ? Image.network(
                      portfolio.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Center(child: Icon(Icons.broken_image, size: 60, color: AppColors.grey)),
                    )
                  : Center(child: Icon(Icons.image, size: 60, color: AppColors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${portfolio.id ?? 'N/A'}',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  portfolio.description ?? 'Tidak ada deskripsi',
                  style: GoogleFonts.poppins(fontSize: 10, color: AppColors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (portfolio.barberId != null) ...[
                  const SizedBox(height: 4),
                  Text('Barber ID: ${portfolio.barberId}',
                      style: GoogleFonts.poppins(fontSize: 9, color: AppColors.grey)),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                        tooltip: 'Edit Portofolio',
                        onPressed: () => _showPortofolioFormDialog(portfolioToEdit: portfolio),
                      ),
                    ),
                    Container(
                      height: 30, // Tinggi separator
                      width: 1, // Lebar separator
                      color: AppColors.light,
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        tooltip: 'Hapus Portofolio',
                        onPressed: () {
                          if (portfolio.id != null) {
                            _showDeleteConfirmationDialog(portfolio.id!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ID Portofolio tidak tersedia untuk dihapus.')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        // Pastikan PortofoliosBloc disediakan di sini di level yang cukup tinggi
        create: (context) => PortofoliosBloc(
          PortofolioRepository(
            ServiceHttpClient(),
          ),
        )..add(GetMyPortofoliosEvent()), // Muat portofolio saya saat bloc dibuat
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
                            'Kelola Portofolio',
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
                  // Main body content (portfolios list)
                  Expanded(child: _buildPortofolioListBody()),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPortofolioFormDialog(),
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