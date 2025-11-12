import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar_kel_5/models/warga_model.dart';
import 'package:jawara_pintar_kel_5/services/warga_service.dart';
import 'package:jawara_pintar_kel_5/utils.dart' show getPrimaryColor;
import 'package:jawara_pintar_kel_5/widget/form/section_card.dart';
import 'package:jawara_pintar_kel_5/widget/form/labeled_text_field.dart';
import 'package:jawara_pintar_kel_5/widget/form/labeled_dropdown.dart';
import 'package:jawara_pintar_kel_5/widget/form/date_picker_field.dart';
import 'package:jawara_pintar_kel_5/widget/moon_result_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditWargaPage extends StatefulWidget {
  final Warga warga;
  const EditWargaPage({super.key, required this.warga});

  @override
  State<EditWargaPage> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends State<EditWargaPage> {
  // Service
  final _wargaService = WargaService();
  
  // Controllers
  late final TextEditingController _namaCtl;
  late final TextEditingController _idCtl;
  late final TextEditingController _ttlCtl;
  late final TextEditingController _tempatLahirCtl;
  late final TextEditingController _teleponCtl;
  late final TextEditingController _emailCtl;

  // Dropdown states
  Gender? _jenisKelamin;
  String? _agama;
  GolonganDarah? _golDarah;
  String? _keluargaId;
  String? _peranKeluarga;
  String? _statusHidup;
  StatusPenduduk? _statusPenduduk;
  String? _pendidikan;
  String? _pekerjaan;

  // Data dari database
  List<Keluarga> _keluargaList = [];
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _namaCtl = TextEditingController(text: widget.warga.nama);
    _idCtl = TextEditingController(text: widget.warga.id);
    _ttlCtl = TextEditingController(text: widget.warga.tanggalLahir?.toString().split(' ')[0] ?? '');
    _tempatLahirCtl = TextEditingController(text: widget.warga.tempatLahir ?? '');
    _teleponCtl = TextEditingController(text: widget.warga.telepon ?? '');
    _emailCtl = TextEditingController(text: widget.warga.email ?? '');

    // Initialize dropdown states with existing data
    _jenisKelamin = widget.warga.gender;
    _agama = widget.warga.agama;
    _golDarah = widget.warga.golDarah;
    _keluargaId = widget.warga.keluargaId;
    _statusHidup = widget.warga.statusHidupWafat;
    _statusPenduduk = widget.warga.statusPenduduk;
    _pendidikan = widget.warga.pendidikanTerakhir;
    _pekerjaan = widget.warga.pekerjaan;

    _loadKeluargaData();
  }

  Future<void> _loadKeluargaData() async {
    setState(() => _isLoading = true);
    try {
      final keluarga = await _wargaService.getAllKeluarga();
      setState(() {
        _keluargaList = keluarga;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading keluarga: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateWarga() async {
    // Validasi form
    if (_idCtl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIK tidak boleh kosong')),
      );
      return;
    }

    if (_namaCtl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    if (_jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jenis kelamin harus dipilih')),
      );
      return;
    }

    if (_statusPenduduk == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status kependudukan harus dipilih')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Parsing tanggal lahir jika ada
      DateTime? tanggalLahir;
      if (_ttlCtl.text.isNotEmpty) {
        try {
          tanggalLahir = DateTime.parse(_ttlCtl.text);
        } catch (e) {
          // Format tanggal tidak valid, skip
        }
      }

      // Buat object Warga dengan data yang diupdate
      final wargaUpdated = Warga(
        id: _idCtl.text,
        nama: _namaCtl.text,
        tanggalLahir: tanggalLahir,
        tempatLahir: _tempatLahirCtl.text.isEmpty ? null : _tempatLahirCtl.text,
        telepon: _teleponCtl.text.isEmpty ? null : _teleponCtl.text,
        gender: _jenisKelamin,
        golDarah: _golDarah,
        pendidikanTerakhir: _pendidikan,
        pekerjaan: _pekerjaan,
        statusPenduduk: _statusPenduduk,
        statusHidupWafat: _statusHidup,
        keluargaId: _keluargaId,
        agama: _agama,
        fotoKtp: null,
        email: _emailCtl.text.isEmpty ? null : _emailCtl.text,
      );

      // Update ke database menggunakan ID lama
      await _wargaService.updateWarga(widget.warga.id, wargaUpdated);

      if (mounted) {
        // Tampilkan success modal
        await showResultModal(
          context,
          type: ResultType.success,
          title: 'Berhasil',
          description: 'Data warga berhasil diupdate.',
          actionLabel: 'Selesai',
          autoProceed: true,
        );

        // Kembali ke halaman daftar warga dengan hasil 'true'
        if (mounted) {
          context.pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        await showResultModal(
          context,
          type: ResultType.error,
          title: 'Error',
          description: 'Gagal mengupdate data: $e',
          actionLabel: 'Coba Lagi',
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _namaCtl.dispose();
    _idCtl.dispose();
    _ttlCtl.dispose();
    _tempatLahirCtl.dispose();
    _teleponCtl.dispose();
    _emailCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, color: Colors.black),
        ),
        title: const Text(
          'Edit Warga',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Data Diri
          SectionCard(
            title: 'Data Diri',
            children: [
              LabeledTextField(
                label: 'Nama Lengkap',
                controller: _namaCtl,
                hint: 'Masukkan nama lengkap',
              ),
              const SizedBox(height: 8),
              LabeledTextField(
                label: 'NIK',
                controller: _idCtl,
                keyboardType: TextInputType.number,
                hint: 'Masukkan NIK',
              ),
              const SizedBox(height: 8),
              DatePickerField(
                label: 'Tanggal Lahir',
                controller: _ttlCtl,
                placeholder: 'Pilih Tanggal',
              ),
            ],
          ),

          // Atribut Personal
          SectionCard(
            title: 'Atribut Personal',
            children: [
              LabeledDropdown<Gender>(
                label: 'Jenis Kelamin',
                value: _jenisKelamin,
                onChanged: (v) => setState(() => _jenisKelamin = v),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('-- Pilih --'),
                  ),
                  ...Gender.values.map((gender) =>
                      DropdownMenuItem(
                        value: gender,
                        child: Text(gender.value),
                      )),
                ],
              ),
              LabeledDropdown<String>(
                label: 'Agama',
                value: _agama,
                onChanged: (v) => setState(() => _agama = v),
                items: const [
                  DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                  DropdownMenuItem(value: 'Kristen', child: Text('Kristen')),
                  DropdownMenuItem(value: 'Katolik', child: Text('Katolik')),
                  DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                  DropdownMenuItem(value: 'Buddha', child: Text('Buddha')),
                  DropdownMenuItem(value: 'Konghucu', child: Text('Konghucu')),
                ],
              ),
              LabeledDropdown<GolonganDarah>(
                label: 'Golongan Darah',
                value: _golDarah,
                onChanged: (v) => setState(() => _golDarah = v),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('-- Pilih --'),
                  ),
                  ...GolonganDarah.values.map((gol) =>
                      DropdownMenuItem(
                        value: gol,
                        child: Text(gol.value),
                      )),
                ],
              ),
            ],
          ),

          // Status & Peran
          SectionCard(
            title: 'Status & Peran',
            children: [
              LabeledDropdown<String>(
                label: 'Keluarga',
                value: _keluargaId,
                onChanged: (v) => setState(() => _keluargaId = v),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(_isLoading ? 'Loading...' : '-- Pilih Keluarga --'),
                  ),
                  if (!_isLoading)
                    ..._keluargaList.map((keluarga) =>
                        DropdownMenuItem(
                          value: keluarga.id,
                          child: Text(keluarga.namaKeluarga),
                        )),
                ],
              ),
              LabeledDropdown<String>(
                label: 'Peran',
                value: _peranKeluarga,
                onChanged: (v) => setState(() => _peranKeluarga = v),
                items: const [
                  DropdownMenuItem(
                    value: 'Kepala Keluarga',
                    child: Text('Kepala Keluarga'),
                  ),
                  DropdownMenuItem(value: 'Ibu', child: Text('Ibu')),
                  DropdownMenuItem(value: 'Anak', child: Text('Anak')),
                ],
              ),
              LabeledDropdown<String>(
                label: 'Status Hidup',
                value: _statusHidup,
                onChanged: (v) => setState(() => _statusHidup = v),
                items: const [
                  DropdownMenuItem(value: 'Hidup', child: Text('Hidup')),
                  DropdownMenuItem(value: 'Wafat', child: Text('Wafat')),
                ],
              ),
              LabeledDropdown<StatusPenduduk>(
                label: 'Status Kependudukan',
                value: _statusPenduduk,
                onChanged: (v) => setState(() => _statusPenduduk = v),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('-- Pilih --'),
                  ),
                  ...StatusPenduduk.values.map((status) =>
                      DropdownMenuItem(
                        value: status,
                        child: Text(status.value),
                      )),
                ],
              ),
            ],
          ),

          // Latar Belakang
          SectionCard(
            title: 'Latar Belakang',
            children: [
              LabeledDropdown<String>(
                label: 'Pendidikan Terakhir',
                value: _pendidikan,
                onChanged: (v) => setState(() => _pendidikan = v),
                items: const [
                  DropdownMenuItem(value: 'SD', child: Text('SD')),
                  DropdownMenuItem(value: 'SMP', child: Text('SMP')),
                  DropdownMenuItem(value: 'SMA/SMK', child: Text('SMA/SMK')),
                  DropdownMenuItem(value: 'Diploma', child: Text('Diploma')),
                  DropdownMenuItem(value: 'S1', child: Text('S1')),
                  DropdownMenuItem(value: 'S2', child: Text('S2')),
                  DropdownMenuItem(value: 'S3', child: Text('S3')),
                ],
              ),
              LabeledDropdown<String>(
                label: 'Pekerjaan',
                value: _pekerjaan,
                onChanged: (v) => setState(() => _pekerjaan = v),
                items: const [
                  DropdownMenuItem(
                    value: 'Pelajar/Mahasiswa',
                    child: Text('Pelajar/Mahasiswa'),
                  ),
                  DropdownMenuItem(value: 'Karyawan', child: Text('Karyawan')),
                  DropdownMenuItem(
                    value: 'Wiraswasta',
                    child: Text('Wiraswasta'),
                  ),
                  DropdownMenuItem(
                    value: 'Ibu Rumah Tangga',
                    child: Text('Ibu Rumah Tangga'),
                  ),
                  DropdownMenuItem(
                    value: 'Tidak Bekerja',
                    child: Text('Tidak Bekerja'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: getPrimaryColor(context),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSaving ? null : () => _updateWarga(),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Simpan Perubahan'),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
