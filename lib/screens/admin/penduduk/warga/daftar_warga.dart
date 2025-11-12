import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar_kel_5/models/warga_model.dart';
import 'package:jawara_pintar_kel_5/services/warga_service.dart';
import 'package:jawara_pintar_kel_5/utils.dart' show getPrimaryColor;
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final WargaService _wargaService = WargaService();
  
  String _query = '';
  Gender? _filterGender;
  StatusPenduduk? _filterStatus;
  String? _filterFamily;
  String? _filterLife;
  
  List<Warga> _allWarga = [];
  List<Keluarga> _allKeluarga = [];

  void _openFilter() {
    Gender? tempGender = _filterGender;
    StatusPenduduk? tempStatus = _filterStatus;
    String? tempFamily = _filterFamily;
    String? tempLife = _filterLife;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (c) {
        final bottom = MediaQuery.of(c).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 12),
                      const Text(
                        'Filter Penerimaan Warga',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Jenis Kelamin',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Gender>(
                        initialValue: tempGender,
                        isExpanded: true,
                        decoration: _dropdownDecoration(),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('-- Semua --'),
                          ),
                          ...Gender.values.map((gender) =>
                              DropdownMenuItem(
                                value: gender,
                                child: Text(gender.value),
                              )),
                        ],
                        onChanged: (v) => setModalState(() => tempGender = v),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Status Kependudukan',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<StatusPenduduk>(
                        initialValue: tempStatus,
                        isExpanded: true,
                        decoration: _dropdownDecoration(),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('-- Semua --'),
                          ),
                          ...StatusPenduduk.values.map((status) =>
                              DropdownMenuItem(
                                value: status,
                                child: Text(status.value),
                              )),
                        ],
                        onChanged: (v) => setModalState(() => tempStatus = v),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Keluarga',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: tempFamily,
                        isExpanded: true,
                        decoration: _dropdownDecoration(),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('-- Semua Keluarga --'),
                          ),
                          ..._allKeluarga.map((keluarga) =>
                              DropdownMenuItem(
                                value: keluarga.namaKeluarga,
                                child: Text(keluarga.namaKeluarga),
                              )),
                        ],
                        onChanged: (v) => setModalState(() => tempFamily = v),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Status Hidup/Wafat',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: tempLife,
                        isExpanded: true,
                        decoration: _dropdownDecoration(),
                        items: const [
                          DropdownMenuItem(
                            value: 'Hidup',
                            child: Text('Hidup'),
                          ),
                          DropdownMenuItem(
                            value: 'Wafat',
                            child: Text('Wafat'),
                          ),
                        ],
                        onChanged: (v) => setModalState(() => tempLife = v),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: Color.fromRGBO(78, 70, 180, 0.12),
                                ),
                                backgroundColor: const Color(0xFFF4F3FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                setModalState(() {
                                  tempGender = null;
                                  tempStatus = null;
                                  tempFamily = null;
                                  tempLife = null;
                                });
                              },
                              child: const Text(
                                'Reset Filter',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4E46B4),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _filterGender = tempGender;
                                  _filterStatus = tempStatus;
                                  _filterFamily = tempFamily;
                                  _filterLife = tempLife;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Terapkan',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4E46B4), width: 1.2),
      ),
    );
  }

  List<Warga> get _filtered {
    return _allWarga.where((warga) {
      // Filter berdasarkan search query
      final matchesQuery = _query.isEmpty ||
          warga.nama.toLowerCase().contains(_query.toLowerCase()) ||
          warga.id.contains(_query);

      // Filter berdasarkan gender
      final matchesGender =
          _filterGender == null || warga.gender == _filterGender;

      // Filter berdasarkan status penduduk
      final matchesStatus =
          _filterStatus == null || warga.statusPenduduk == _filterStatus;

      // Filter berdasarkan keluarga
      final matchesFamily = _filterFamily == null ||
          warga.keluarga?.namaKeluarga == _filterFamily;

      // Filter berdasarkan status hidup/wafat
      final matchesLife =
          _filterLife == null || warga.statusHidupWafat == _filterLife;

      return matchesQuery &&
          matchesGender &&
          matchesStatus &&
          matchesFamily &&
          matchesLife;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadWargaData();
  }

  Future<void> _loadWargaData() async {
    // -- TAMBAHKAN PRINT UNTUK DEBUGGING --
    debugPrint("Mencoba memuat data warga. Status login: ${Supabase.instance.client.auth.currentUser?.email ?? 'Tidak Login'}");
    // ------------------------------------
    try {
      final warga = await _wargaService.getAllWarga();
      final keluarga = await _wargaService.getAllKeluarga();
      
      setState(() {
        _allWarga = warga;
        _allKeluarga = keluarga;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _navigateToEdit(Warga warga) async {
    final result = await context.pushNamed('wargaEdit', extra: warga);
    // Jika halaman edit mengembalikan nilai 'true', muat ulang data
    if (result == true && mounted) {
      _loadWargaData();
    }
  }

  Future<void> _navigateToAdd() async {
    final result = await context.pushNamed('wargaAdd');
    // Jika halaman tambah mengembalikan nilai 'true', muat ulang data
    if (result == true && mounted) {
      _loadWargaData();
    }
  }

  void _showDeleteConfirmation(BuildContext context, Warga warga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Warga'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${warga.nama} (${warga.id})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteWarga(warga.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWarga(String nik) async {
    try {
      await _wargaService.deleteWarga(nik);
      
      if (mounted) {
        setState(() {
          _allWarga.removeWhere((w) => w.id == nik);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data warga berhasil dihapus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting warga: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
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
          'Daftar Warga',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and filter
            _SearchFilterBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (v) => setState(() => _query = v),
              onFilterTap: _openFilter,
            ),

            // list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 80, top: 8),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    return _WargaCard(
                      warga: item,
                      primary: getPrimaryColor(context),
                      onTap: () => _navigateToEdit(item),
                      onDelete: () => _showDeleteConfirmation(context, item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getPrimaryColor(context),
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const _SearchFilterBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.03),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onTap: () => focusNode.requestFocus(),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  hintText: 'Cari Nama atau NIK',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onFilterTap,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.tune, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WargaCard extends StatelessWidget {
  final Warga warga;
  final Color primary;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _WargaCard({
    required this.warga,
    required this.primary,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        warga.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'NIK : ${warga.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final c = Colors.black;
                          return Text(
                            'Keluarga : ${warga.keluarga?.namaKeluarga ?? '-'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: c.withValues(alpha: 0.8)),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (warga.statusPenduduk != null)
                            _StatusChip(status: warga.statusPenduduk!),
                          if (warga.gender != null)
                            _GenderChip(gender: warga.gender!),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(78, 70, 180, 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.more_vert, color: primary),
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

class _StatusChip extends StatelessWidget {
  final StatusPenduduk status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text = Colors.white;
    switch (status) {
      case StatusPenduduk.aktif:
        bg = const Color(0xFF4E46B4); // Primary color
        break;
      case StatusPenduduk.nonaktif:
        bg = Colors.grey.shade300;
        text = Colors.black87;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map, size: 14, color: text),
          const SizedBox(width: 6),
          Text(
            status.value,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final Gender gender;
  const _GenderChip({required this.gender});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text = Colors.white;
    switch (gender) {
      case Gender.lakilaki:
        bg = const Color(0xFF4E46B4); // Primary color
        break;
      case Gender.perempuan:
        bg = Colors.pink.shade400;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gender == Gender.lakilaki ? Icons.male : Icons.female,
            size: 14,
            color: text,
          ),
          const SizedBox(width: 6),
          Text(
            gender.value,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

