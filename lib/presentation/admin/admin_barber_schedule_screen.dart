import 'package:barbergo_mobile/core/components/navigation_bar_admin.dart';
import 'package:barbergo_mobile/data/model/response/jadwal/get_all_jadwal_response_model.dart';
import 'package:barbergo_mobile/data/repository/jadwal_repository.dart';
import 'package:barbergo_mobile/presentation/pelanggan/jadwal/bloc/jadwal_bloc.dart';
import 'package:barbergo_mobile/service/service_http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barbergo_mobile/core/constants/colors.dart';

class AdminJadwalScreen extends StatefulWidget {
  const AdminJadwalScreen({super.key});

  @override
  State<AdminJadwalScreen> createState() => _AdminJadwalScreenState();
}

class _AdminJadwalScreenState extends State<AdminJadwalScreen> {
  final TextEditingController _hariController = TextEditingController();
  final TextEditingController _tersediaDariController = TextEditingController();
  final TextEditingController _tersediaHinggaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<JadwalBloc>().add(const LoadAllJadwalEvent());
  }

  @override
  void dispose() {
    _hariController.dispose();
    _tersediaDariController.dispose();
    _tersediaHinggaController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showJadwalFormDialog({JadwalDatum? jadwalToEdit}) {
    if (jadwalToEdit != null) {
      _hariController.text = jadwalToEdit.hari ?? '';
      _tersediaDariController.text = jadwalToEdit.tersediaDari ?? '';
      _tersediaHinggaController.text = jadwalToEdit.tersediaHingga ?? '';
    } else {
      _hariController.clear();
      _tersediaDariController.clear();
      _tersediaHinggaController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          jadwalToEdit == null ? 'Tambah Jadwal Baru' : 'Edit Jadwal',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _hariController,
                  decoration: InputDecoration(
                    labelText: 'Hari (contoh: Senin, Selasa)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Hari tidak boleh kosong' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _tersediaDariController,
                  decoration: InputDecoration(
                    labelText: 'Tersedia Dari (HH:MM)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Waktu tersedia dari tidak boleh kosong' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _tersediaHinggaController,
                  decoration: InputDecoration(
                    labelText: 'Tersedia Hingga (HH:MM)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.access_time_filled),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Waktu tersedia hingga tidak boleh kosong' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: AppColors.grey),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (jadwalToEdit == null) {
                  context.read<JadwalBloc>().add(
                        CreateMyJadwalEvent(
                          hari: _hariController.text,
                          tersediaDari: _tersediaDariController.text,
                          tersediaHingga: _tersediaHinggaController.text,
                        ),
                      );
                } else {
                  context.read<JadwalBloc>().add(
                        UpdateMyJadwalEvent(
                          id: jadwalToEdit.id!,
                          hari: _hariController.text,
                          tersediaDari: _tersediaDariController.text,
                          tersediaHingga: _tersediaHinggaController.text,
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
              jadwalToEdit == null ? 'Tambah' : 'Simpan',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('Konfirmasi Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.secondary)),
        content: Text('Apakah Anda yakin ingin menghapus jadwal ini?', style: GoogleFonts.poppins(color: AppColors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: AppColors.grey),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<JadwalBloc>().add(DeleteMyJadwalEvent(id: id));
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

  Widget _buildJadwalBody() {
    return BlocProvider(
      create: (context) => JadwalBloc(jadwalRepository: JadwalRepository(ServiceHttpClient()))..add(const LoadAllJadwalEvent()),
      child: BlocConsumer<JadwalBloc, JadwalState>(
        listener: (context, state) {
          if (state is JadwalActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<JadwalBloc>().add(const LoadAllJadwalEvent());
          } else if (state is JadwalActionFailure || state is JadwalErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error:')));
          }
        },
        builder: (context, state) {
          if (state is JadwalLoadingState || state is JadwalCreatingState || state is JadwalUpdatingState || state is JadwalDeletingState) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is JadwalLoadedState) {
            if (state.schedules.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 80, color: AppColors.grey),
                    const SizedBox(height: 10),
                    Text('Belum ada jadwal yang tersedia.', style: GoogleFonts.poppins(fontSize: 16, color: AppColors.grey)),
                    const SizedBox(height: 5),
                    Text('Tekan tombol tambah untuk membuat jadwal baru.', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.grey), textAlign: TextAlign.center),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.schedules.length,
              itemBuilder: (context, index) {
                final jadwal = state.schedules[index];
                return Card(
                  color: AppColors.primary,
                  margin: const EdgeInsets.symmetric(vertical: 15),
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
                        Row(children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                          const SizedBox(width: 6),
                          Text('Hari: ${jadwal.hari ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.access_time, color: Colors.white70, size: 18),
                          const SizedBox(width: 6),
                          Text('Waktu: ${jadwal.tersediaDari ?? 'N/A'} - ${jadwal.tersediaHingga ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                        ]),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.person, color: Colors.white54, size: 18),
                          const SizedBox(width: 6),
                          Text('Barber ID: ${jadwal.barberId ?? 'N/A'}', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54)),
                        ]),
                        const Divider(height: 16, thickness: 1, color: Colors.white30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(icon: const Icon(Icons.edit, color: Colors.white, size: 22), onPressed: () => _showJadwalFormDialog(jadwalToEdit: jadwal)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22), onPressed: () {
                              if (jadwal.id != null) {
                                _showDeleteConfirmationDialog(jadwal.id!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID Jadwal tidak tersedia.')));
                              }
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
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
                          'Kelola Jadwal Barber',
                          style: GoogleFonts.amarante(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 28 + 16),
                    ],
                  ),
                ),
                Expanded(child: _buildJadwalBody()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJadwalFormDialog(),
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
