// ENUMS untuk Warga Model

enum GolonganDarah {
  aPositif('A+'),
  aNegatif('A-'),
  bPositif('B+'),
  bNegatif('B-'),
  abPositif('AB+'),
  abNegatif('AB-'),
  oPositif('O+'),
  oNegatif('O-');

  final String value;
  const GolonganDarah(this.value);

  static GolonganDarah? fromString(String? value) {
    if (value == null) return null;
    try {
      return GolonganDarah.values.firstWhere((e) => e.value == value);
    } catch (e) {
      return null;
    }
  }
}

enum Gender {
  lakilaki('Pria'),
  perempuan('Wanita');

  final String value;
  const Gender(this.value);

  static Gender? fromString(String? value) {
    if (value == null) return null;
    try {
      return Gender.values.firstWhere((e) => e.value == value);
    } catch (e) {
      return null;
    }
  }
}

enum StatusPenduduk {
  aktif('Aktif'),
  nonaktif('Nonaktif');

  final String value;
  const StatusPenduduk(this.value);

  static StatusPenduduk? fromString(String? value) {
    if (value == null) return null;
    try {
      return StatusPenduduk.values.firstWhere((e) => e.value == value);
    } catch (e) {
      return null;
    }
  }
}

class Warga {
  final String id;
  final String nama;
  final DateTime? tanggalLahir;
  final String? tempatLahir;
  final String? telepon;
  final Gender? gender;
  final GolonganDarah? golDarah;
  final String? pendidikanTerakhir;
  final String? pekerjaan;
  final StatusPenduduk? statusPenduduk;
  final String? statusHidupWafat; // 'Hidup' atau 'Wafat'
  final String? keluargaId;
  final String? agama;
  final String? fotoKtp;
  final String? email;
  final Keluarga? keluarga;
  final List<AnggotaKeluarga>? anggotaKeluarga;

  Warga({
    required this.id,
    required this.nama,
    this.tanggalLahir,
    this.tempatLahir,
    this.telepon,
    this.gender,
    this.golDarah,
    this.pendidikanTerakhir,
    this.pekerjaan,
    this.statusPenduduk,
    this.statusHidupWafat,
    this.keluargaId,
    this.agama,
    this.fotoKtp,
    this.email,
    this.keluarga,
    this.anggotaKeluarga,
  });

  factory Warga.fromJson(Map<String, dynamic> json) {
    return Warga(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.parse(json['tanggal_lahir'])
          : null,
      tempatLahir: json['tempat_lahir'],
      telepon: json['telepon'],
      gender: Gender.fromString(json['gender']),
      golDarah: GolonganDarah.fromString(json['gol_darah']),
      pendidikanTerakhir: json['pendidikan_terakhir'],
      pekerjaan: json['pekerjaan'],
      statusPenduduk: StatusPenduduk.fromString(json['status_penduduk']),
      statusHidupWafat: json['status_hidup_wafat'],
      keluargaId: json['keluarga_id'],
      agama: json['agama'],
      fotoKtp: json['foto_ktp'],
      email: json['email'],
      keluarga: json['keluarga'] != null
          ? Keluarga.fromJson(json['keluarga'])
          : null,
      anggotaKeluarga: json['anggota_keluarga'] != null
          ? List<AnggotaKeluarga>.from(
              json['anggota_keluarga'].map((x) => AnggotaKeluarga.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'tempat_lahir': tempatLahir,
      'telepon': telepon,
      'gender': gender?.value,
      'gol_darah': golDarah?.value,
      'pendidikan_terakhir': pendidikanTerakhir,
      'pekerjaan': pekerjaan,
      'status_penduduk': statusPenduduk?.value,
      'status_hidup_wafat': statusHidupWafat,
      'keluarga_id': keluargaId,
      'agama': agama,
      'foto_ktp': fotoKtp,
      'email': email,
    };
  }
}

class Keluarga {
  final String id;
  final String namaKeluarga;
  final String? kepaluKepalaId;
  final String? alamatRumah;
  final String? statusKepemilikan;
  final String? statusKeluarga;

  Keluarga({
    required this.id,
    required this.namaKeluarga,
    this.kepaluKepalaId,
    this.alamatRumah,
    this.statusKepemilikan,
    this.statusKeluarga,
  });

  factory Keluarga.fromJson(Map<String, dynamic> json) {
    return Keluarga(
      id: json['id'] ?? '',
      namaKeluarga: json['nama_keluarga'] ?? '',
      kepaluKepalaId: json['kepala_keluarga_id'],
      alamatRumah: json['alamat_rumah'],
      statusKepemilikan: json['status_kepemilikan'],
      statusKeluarga: json['status_keluarga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_keluarga': namaKeluarga,
      'kepala_keluarga_id': kepaluKepalaId,
      'alamat_rumah': alamatRumah,
      'status_kepemilikan': statusKepemilikan,
      'status_keluarga': statusKeluarga,
    };
  }
}

class AnggotaKeluarga {
  final String id;
  final String keluargaId;
  final String wargaNik;
  final String? peran;
  final Warga? warga;

  AnggotaKeluarga({
    required this.id,
    required this.keluargaId,
    required this.wargaNik,
    this.peran,
    this.warga,
  });

  factory AnggotaKeluarga.fromJson(Map<String, dynamic> json) {
    return AnggotaKeluarga(
      id: json['id'] ?? '',
      keluargaId: json['keluarga_id'] ?? '',
      wargaNik: json['warga_id'] ?? '',
      peran: json['peran'],
      warga:
          json['warga'] != null ? Warga.fromJson(json['warga']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keluarga_id': keluargaId,
      'warga_id': wargaNik,
      'peran': peran,
    };
  }
}
