import 'package:jawara_pintar_kel_5/models/warga_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WargaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch semua warga dengan data keluarga
  Future<List<Warga>> getAllWarga() async {
    try {
      final response = await _supabase
          .from('warga')
          .select('''
            id, nama, tanggal_lahir, tempat_lahir, telepon, gender, 
            gol_darah, pendidikan_terakhir, pekerjaan, status_penduduk, keluarga_id, agama, foto_ktp, email,
            keluarga:keluarga_id(id, nama_keluarga, kepala_keluarga_id, alamat_rumah, status_kepemilikan, status_keluarga)
          ''')
          .order('nama');

      return List<Warga>.from(
          response.map((json) => Warga.fromJson(json)));
    } catch (e) {
      throw Exception('Error fetching warga: $e');
    }
  }

  /// Fetch warga berdasarkan NIK
  Future<Warga?> getWargaByNik(String nik) async {
    try {
      final response = await _supabase
          .from('warga')
          .select('''
            id, nama, tanggal_lahir, tempat_lahir, telepon, gender, 
            gol_darah, pendidikan_terakhir, pekerjaan, status_penduduk, keluarga_id, agama, foto_ktp, email,
            keluarga:keluarga_id(id, nama_keluarga, kepala_keluarga_id, alamat_rumah, status_kepemilikan, status_keluarga)
          ''')
          .eq('nik', nik)
          .single();

      return Warga.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching warga: $e');
    }
  }

  /// Fetch warga berdasarkan keluarga_id
  Future<List<Warga>> getWargaByKeluargaId(String keluargaId) async {
    try {
      final response = await _supabase
          .from('warga')
          .select('''
            id, nama, tanggal_lahir, tempat_lahir, telepon, gender, 
            gol_darah, pendidikan_terakhir, pekerjaan, status_penduduk, keluarga_id, agama, foto_ktp, email,
            keluarga:keluarga_id(id, nama_keluarga, kepala_keluarga_id, alamat_rumah, status_kepemilikan, status_keluarga)
          ''')
          .eq('keluarga_id', keluargaId)
          .order('nama');

      return List<Warga>.from(
          response.map((json) => Warga.fromJson(json)));
    } catch (e) {
      throw Exception('Error fetching warga by keluarga: $e');
    }
  }

  /// Fetch warga dengan filter
  Future<List<Warga>> getWargaFiltered({
    String? gender,
    String? statusPenduduk,
    String? keluargaId,
    String? searchQuery,
  }) async {
    try {
      var query = _supabase
          .from('warga')
          .select('''
            id, nama, tanggal_lahir, tempat_lahir, telepon, gender, 
            gol_darah, pendidikan_terakhir, pekerjaan, status_penduduk, keluarga_id, agama, foto_ktp, email,
            keluarga:keluarga_id(id, nama_keluarga, kepala_keluarga_id, alamat_rumah, status_kepemilikan, status_keluarga)
          ''');

      if (gender != null && gender.isNotEmpty) {
        query = query.eq('gender', gender);
      }

      if (statusPenduduk != null && statusPenduduk.isNotEmpty) {
        query = query.eq('status_penduduk', statusPenduduk);
      }

      if (keluargaId != null && keluargaId.isNotEmpty) {
        query = query.eq('keluarga_id', keluargaId);
      }

      final response = await query.order('nama');

      List<Warga> wargaList =
          List<Warga>.from(response.map((json) => Warga.fromJson(json)));

      // Filter berdasarkan search query (nama atau ID)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        wargaList = wargaList
            .where((w) =>
                w.nama.toLowerCase().contains(lowerQuery) ||
                (w.id.contains(searchQuery)))
            .toList();
      }

      return wargaList;
    } catch (e) {
      throw Exception('Error filtering warga: $e');
    }
  }

  /// Create warga baru
  Future<Warga> createWarga(Warga warga) async {
    try {
      final response = await _supabase
          .from('warga')
          .insert(warga.toJson())
          .select('''
            id, nama, tanggal_lahir, tempat_lahir, telepon, gender, 
            gol_darah, pendidikan_terakhir, pekerjaan, status_penduduk, keluarga_id, agama, foto_ktp, email,
            keluarga:keluarga_id(id, nama_keluarga, kepala_keluarga_id, alamat_rumah, status_kepemilikan, status_keluarga)
          ''')
          .single();

      return Warga.fromJson(response);
    } catch (e) {
      throw Exception('Error creating warga: $e');
    }
  }

  /// Update warga
  Future<Warga> updateWarga(String id, Warga warga) async {
    try {
      final response = await _supabase
          .from('warga')
          .update(warga.toJson())
          .eq('id', id) // DIGANTI dari nik ke id
          .select('''
            id, nama, tanggal_lahir, tempat_lahir, telepon, gender, 
            gol_darah, pendidikan_terakhir, pekerjaan, status_penduduk, keluarga_id, agama, foto_ktp, email,
            keluarga:keluarga_id(id, nama_keluarga, kepala_keluarga_id, alamat_rumah, status_kepemilikan, status_keluarga)
          ''')
          .single();

      return Warga.fromJson(response);
    } catch (e) {
      throw Exception('Error updating warga: $e');
    }
  }

  /// Delete warga
  Future<void> deleteWarga(String id) async {
    try {
      await _supabase.from('warga').delete().eq('id', id); // DIGANTI dari nik ke id
    } catch (e) {
      throw Exception('Error deleting warga: $e');
    }
  }

  /// Fetch semua keluarga
  Future<List<Keluarga>> getAllKeluarga() async {
    try {
      final response = await _supabase
          .from('keluarga')
          .select()
          .order('nama_keluarga');

      return List<Keluarga>.from(
          response.map((json) => Keluarga.fromJson(json)));
    } catch (e) {
      throw Exception('Error fetching keluarga: $e');
    }
  }
}
