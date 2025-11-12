import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar_kel_5/models/warga_model.dart';
import 'package:jawara_pintar_kel_5/services/warga_service.dart';
import 'package:jawara_pintar_kel_5/widget/moon_result_modal.dart';
import 'package:moon_design/moon_design.dart';
import 'package:intl/intl.dart';

class DetailWargaPage extends StatelessWidget {
  final Warga warga;
  const DetailWargaPage({super.key, required this.warga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, color: Colors.black),
        ),
        title: Text(
          'Detail Warga',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _MoreMenu(
            warga: warga,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF7F7FB),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Header info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      warga.gender == Gender.lakilaki ? Icons.male : Icons.female,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warga.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'NIK :  ${warga.id}',
                          style: const TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _SectionCard(
              title: 'Data Diri',
              children: [
                _IconTextRow(
                  icon: Icons.event,
                  title: 'Tempat, Tanggal Lahir:',
                  value:
                      '${warga.tempatLahir ?? '-'}, ${warga.tanggalLahir != null ? DateFormat('d MMMM yyyy').format(warga.tanggalLahir!) : '-'}',
                ),
                _IconTextRow(
                  icon: Icons.people,
                  title: 'Jenis Kelamin:',
                  value: warga.gender?.value ?? '-',
                ),
                _IconTextRow(
                  icon: Icons.self_improvement,
                  title: 'Agama:',
                  value: warga.agama ?? '-',
                ),
                _IconTextRow(
                  icon: Icons.bloodtype,
                  title: 'Golongan Darah:',
                  value: warga.golDarah?.value ?? '-',
                ),
              ],
            ),

            const SizedBox(height: 16),

            _SectionCard(
              title: 'Keluarga & Kependudukan',
              children: [
                _IconTextRow(
                  icon: Icons.groups_2,
                  title: 'Keluarga:',
                  value: warga.keluarga?.namaKeluarga ?? '-',
                ),
                const _IconTextRow(
                  icon: Icons.badge,
                  title: 'Peran Dalam Keluarga:',
                  value: 'Anak', // Note: This data is not in the model
                ),
                _IconTextRow(
                  icon: Icons.verified,
                  title: 'Status Kependudukan:',
                  value: warga.statusPenduduk?.value ?? '-',
                ),
              ],
            ),

            const SizedBox(height: 16),

            _SectionCard(
              title: 'Informasi Tambahan',
              children: [
                _IconTextRow(
                  icon: Icons.school,
                  title: 'Pendidikan Terakhir:',
                  value: warga.pendidikanTerakhir ?? '-',
                ),
                _IconTextRow(
                  icon: Icons.work_outline,
                  title: 'Pekerjaan:',
                  value: warga.pekerjaan ?? '-',
                ),
                _IconTextRow(
                  icon: Icons.phone,
                  title: 'Nomor Telephone:',
                  value: warga.telepon ?? '-',
                ),
                _IconTextRow(
                  icon: Icons.email,
                  title: 'Email:',
                  value: warga.email ?? '-',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= More Menu & Dialog =========================

class _MoreMenu extends StatelessWidget {
  final Warga warga;

  const _MoreMenu({
    required this.warga,
  });

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Opsi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4E46B4).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF4E46B4),
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Edit Data',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Ubah data warga'),
                  onTap: () {
                    Navigator.pop(context);
                    context.pushNamed('wargaEdit', extra: warga);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Hapus Data',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: const Text('Hapus data warga secara permanen'),
                  onTap: () async {
                    Navigator.pop(context);
                    final confirmed = await _showDeleteConfirmationDialog(
                      context: context,
                      title: 'Hapus Data Warga?',
                      message:
                          'Apakah Anda yakin ingin menghapus data "${warga.nama}"? Data yang sudah dihapus tidak dapat dikembalikan.',
                    );
                    if (confirmed == true) {
                      try {
                        await WargaService().deleteWarga(warga.id);
                        if (context.mounted) {
                           await showResultModal(
                            context,
                            type: ResultType.success,
                            title: 'Berhasil',
                            description: 'Data "${warga.nama}" telah dihapus.',
                            actionLabel: 'Selesai',
                            autoProceed: true,
                          );
                          // Kembali ke halaman daftar warga
                          context.pop(true); // Kirim 'true' untuk refresh
                        }
                      } catch (e) {
                         if (context.mounted) {
                           showResultModal(
                            context,
                            type: ResultType.error,
                            title: 'Gagal',
                            description: 'Gagal menghapus data: $e',
                            actionLabel: 'Tutup',
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Lainnya',
      icon: const Icon(Icons.more_vert, color: Colors.black),
      onPressed: () => _showOptionsBottomSheet(context),
    );
  }
}

Future<bool?> _showDeleteConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  bool? result;
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'DeleteConfirm',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (ctx, anim, secAnim) {
      final colors = ctx.moonColors ?? MoonTokens.light.colors;
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.86,
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: MoonSquircleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ).squircleBorderRadius(ctx),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                Text(title, style: MoonTokens.light.typography.heading.text18),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: MoonTokens.light.typography.body.text14.copyWith(
                    color: colors.trunks,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: MoonOutlinedButton(
                        onTap: () {
                          result = false;
                          Navigator.of(ctx).maybePop();
                        },
                        label: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MoonFilledButton(
                        backgroundColor: Colors.red,
                        onTap: () {
                          result = true;
                          Navigator.of(ctx).maybePop();
                        },
                        label: const Text('Ya, Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim, secAnim, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      ).animate(curved);
      final fade = Tween<double>(begin: 0.8, end: 1).animate(curved);
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: fade, child: child),
      );
    },
  );
  return result;
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...children.map(
              (w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTextRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _IconTextRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(78, 70, 180, 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF4E46B4)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
