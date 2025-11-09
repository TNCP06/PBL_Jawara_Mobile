import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_pintar_kel_5/screens/admin/dashboard/dashboard.dart';
import 'package:jawara_pintar_kel_5/screens/admin/keuangan/keuangan_menu_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/keuangan/laporan_keuangan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/keuangan/pengeluaran_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/laporan/cetak_laporan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/laporan/semua_pemasukan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/laporan/semua_pengeluaran_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/layout.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/detail_pemasukan_lain_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/kategori_iuran_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/pemasukan_lain_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/pemasukan_lain_tambah_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/pemasukan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/tagih_iuran_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/tagihan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/penduduk_menu_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/warga/daftar_warga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/rumah/daftar_rumah.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/rumah/tambah_rumah.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/rumah/detail_rumah.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/rumah/edit_rumah.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/warga/detail_warga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/warga/tambah_warga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/warga/edit_warga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/penerimaan/daftar_penerimaan_warga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/penerimaan/detail_penerimaan_warga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/keluarga/daftar_keluarga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/keluarga/detail_keluarga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/keluarga/daftar_mutasi_keluarga.dart';
import 'package:jawara_pintar_kel_5/screens/admin/penduduk/keluarga/tambah_mutasi_keluarga.dart';
// import 'package:jawara_pintar_kel_5/screens/admin/keuangan/keuangan_menu_screen.dart';
// import 'package:jawara_pintar_kel_5/screens/admin/pemasukan/pemasukan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/lainnya_menu_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/edit_profile_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/manajemen_pengguna_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/pengguna/tambah_pengguna.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/pengguna/detail_pengguna.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/pengguna/edit_pengguna.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/manajemen_channel_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/channel_transfer/tambah_channel.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/channel_transfer/detail_channel.dart';
import 'package:jawara_pintar_kel_5/screens/admin/lainnya/channel_transfer/edit_channel.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pengeluaran/daftar_pengeluaran_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/pengeluaran/tambah_pengeluaran_screen.dart';
import 'package:jawara_pintar_kel_5/screens/auth/login.dart';
import 'package:jawara_pintar_kel_5/screens/auth/register.dart';

import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/kegiatan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/kegiatan/daftar_kegiatan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/kegiatan/tambah_kegiatan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/kegiatan/edit_kegiatan_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/kegiatan/detail_kegiatan_screen.dart';

import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/broadcast/daftar_broadcast.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/broadcast/tambah_broadcast.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/broadcast/detail_broadcast_screen.dart';
import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/broadcast/edit_broadcast_screen.dart';

import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/pesanwarga/pesanwarga_tab.dart';
// import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/pesanwarga/edit_pesan_warga_screen.dart';
// import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/pesanwarga/detail_pesan_warga_screen.dart';

import 'package:jawara_pintar_kel_5/screens/admin/kegiatanMenu/logaktivitas/logaktivitas_tab.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: "/login",
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AdminLayout(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/dashboard',
              name: 'admin_dashboard',
              builder: (context, state) => AdminDashboard(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/penduduk',
              name: 'pendudukMenu',
              builder: (context, state) => const PendudukMenuScreen(),
              routes: [
                GoRoute(
                  path: 'daftar-warga',
                  name: 'wargaList',
                  builder: (context, state) => const DaftarWargaPage(),
                ),
                GoRoute(
                  path: 'daftar-rumah',
                  name: 'rumahList',
                  builder: (context, state) => const DaftarRumahPage(),
                ),
                GoRoute(
                  path: 'tambah-rumah',
                  name: 'rumahAdd',
                  builder: (context, state) => const TambahRumahPage(),
                ),
                GoRoute(
                  path: 'detail-rumah',
                  name: 'rumahDetail',
                  builder: (context, state) {
                    final rumah = state.extra as Rumah;
                    return DetailRumahPage(rumah: rumah);
                  },
                ),
                GoRoute(
                  path: 'edit-rumah',
                  name: 'rumahEdit',
                  builder: (context, state) {
                    final rumah = state.extra as Rumah;
                    return EditRumahPage(rumah: rumah);
                  },
                ),
                GoRoute(
                  path: 'detail-warga',
                  name: 'wargaDetail',
                  builder: (context, state) {
                    final data = state.extra as Map<String, String>? ?? {};
                    return DetailWargaPage(warga: data);
                  },
                ),
                GoRoute(
                  path: 'tambah-warga',
                  name: 'wargaAdd',
                  builder: (context, state) => const TambahWargaPage(),
                ),
                GoRoute(
                  path: 'edit-warga',
                  name: 'wargaEdit',
                  builder: (context, state) {
                    final data = state.extra as Map<String, String>? ?? {};
                    return EditWargaPage(warga: data);
                  },
                ),
                GoRoute(
                  path: 'daftar-penerimaan',
                  name: 'penerimaanList',
                  builder: (context, state) =>
                      const DaftarPenerimaanWargaPage(),
                ),
                GoRoute(
                  path: 'detail-penerimaan',
                  name: 'penerimaanDetail',
                  builder: (context, state) {
                    final penerimaan = state.extra as PenerimaanWarga;
                    return DetailPenerimaanWargaPage(penerimaan: penerimaan);
                  },
                ),
                GoRoute(
                  path: 'daftar-keluarga',
                  name: 'keluargaList',
                  builder: (context, state) => const DaftarKeluargaPage(),
                ),
                GoRoute(
                  path: 'detail-keluarga',
                  name: 'keluargaDetail',
                  builder: (context, state) {
                    final keluarga = state.extra as Keluarga;
                    return DetailKeluargaPage(keluarga: keluarga);
                  },
                ),
                GoRoute(
                  path: 'daftar-mutasi-keluarga',
                  name: 'mutasiKeluargaList',
                  builder: (context, state) => const DaftarMutasiKeluargaPage(),
                ),
                GoRoute(
                  path: 'tambah-mutasi-keluarga',
                  name: 'mutasiKeluargaAdd',
                  builder: (context, state) => const TambahMutasiKeluargaPage(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/keuangan',
              builder: (context, state) => const KeuanganMenuScreen(),
            ),
            GoRoute(
              path: '/admin/pemasukan',
              builder: (context, state) => const PemasukanScreen(),
            ),
            GoRoute(
              path: '/admin/pengeluaran',
              builder: (context, state) => const PengeluaranScreen(),
            ),
            GoRoute(
              path: '/admin/laporan-keuangan',
              builder: (context, state) => const LaporanKeuanganScreen(),
            ),
            // Pemasukan routes - halaman terpisah tanpa tab
            GoRoute(
              path: '/admin/pemasukan/kategori-iuran',
              builder: (context, state) => const KategoriIuranScreen(),
            ),
            GoRoute(
              path: '/admin/pemasukan/tagih-iuran',
              builder: (context, state) => const TagihIuranScreen(),
            ),
            GoRoute(
              path: '/admin/pemasukan/tagihan',
              builder: (context, state) => const TagihanScreen(),
            ),
            GoRoute(
              path: '/admin/pemasukan/pemasukan-lain',
              builder: (context, state) => const PemasukanLainScreen(),
            ),
            GoRoute(
              path: '/admin/pemasukan/pemasukan-lain-detail',
              builder: (context, state) {
                final data = state.extra as PemasukanLainModel;
                return DetailPemasukanLainScreen(data: data);
              },
            ),
            GoRoute(
              path: '/admin/pemasukan/pemasukan-lain-tambah',
              builder: (context, state) => const PemasukanLainTambahScreen(),
            ),
            // Pengeluaran routes
            GoRoute(
              path: '/admin/pengeluaran/daftar',
              builder: (context, state) => const DaftarPengeluaranScreen(),
            ),
            GoRoute(
              path: '/admin/pengeluaran/tambah',
              builder: (context, state) => const TambahPengeluaranScreen(),
            ),
            // Laporan routes
            GoRoute(
              path: '/admin/laporan/semua-pemasukan',
              builder: (context, state) => const SemuaPemasukanScreen(),
            ),
            GoRoute(
              path: '/admin/laporan/semua-pengeluaran',
              builder: (context, state) => const SemuaPengeluaranScreen(),
            ),
            GoRoute(
              path: '/admin/laporan/cetak-laporan',
              builder: (context, state) => const CetakLaporanScreen(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/kegiatan',
              name: 'kegiatanMenu',
              builder: (context, state) => const KegiatanScreen(),
              routes: [
                GoRoute(
                  path: 'daftar',
                  builder: (context, state) => const DaftarKegiatanScreen(),
                ),
                GoRoute(
                  path: 'tambah',
                  builder: (context, state) => const TambahKegiatanScreen(),
                ),
                GoRoute(
                  path: 'detail',
                  builder: (context, state) {
                    final kegiatanData =
                        state.extra as Map<String, String>? ?? {};
                    return DetailKegiatanScreen(kegiatan: kegiatanData);
                  },
                ),
                GoRoute(
                  path: 'edit',
                  builder: (context, state) {
                    final kegiatanData =
                        state.extra as Map<String, String>? ?? {};
                    return EditKegiatanScreen(kegiatan: kegiatanData);
                  },
                ),
                GoRoute(
                  path: 'broadcast/daftar',
                  name: 'broadcastDaftar',
                  builder: (context, state) => const DaftarBroadcastScreen(),
                ),
                GoRoute(
                  path: 'broadcast/tambah',
                  name: 'broadcastTambah',
                  builder: (context, state) => const TambahBroadcastScreen(),
                ),
                GoRoute(
                  path: 'broadcast/detail/:judul',
                  name: 'broadcastDetail',
                  builder: (context, state) {
                    final _ = state.pathParameters['judul']!;
                    final broadcastData = state.extra as KegiatanBroadcast?;
                    if (broadcastData == null) {
                      return const DaftarBroadcastScreen();
                    }
                    return DetailBroadcastScreen(broadcastData: broadcastData);
                  },
                ),
                GoRoute(
                  path: 'broadcast/edit/:judul',
                  name: 'broadcastEdit',
                  builder: (context, state) {
                    final _ = state.pathParameters['judul']!;
                    final broadcastData = state.extra as Map<String, dynamic>?;
                    if (broadcastData == null ||
                        broadcastData['data'] == null) {
                      return const DaftarBroadcastScreen();
                    }
                    return EditBroadcastScreen(
                      initialBroadcastData:
                          broadcastData['data'] as KegiatanBroadcast,
                    );
                  },
                ),
                GoRoute(
                  path: 'pesanwarga',
                  name: 'pesanWarga',
                  builder: (context, state) => const PesanWargaScreen(),
                ),
                GoRoute(
                  path: 'logaktivitas',
                  name: 'logAktivitas',
                  builder: (context, state) => const LogAktivitasScreen(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/lainnya',
              builder: (context, state) => const LainnyaScreen(),
            ),
            GoRoute(
              path: '/admin/lainnya/edit-profile',
              name: 'editProfile',
              builder: (context, state) => const EditProfileScreen(),
            ),
            GoRoute(
              path: '/admin/lainnya/manajemen-pengguna',
              builder: (context, state) => const ManajemenPenggunaScreen(),
            ),
            GoRoute(
              path: '/admin/lainnya/manajemen-pengguna/tambah',
              builder: (context, state) => const TambahPenggunaScreen(),
            ),
            GoRoute(
              path: '/admin/lainnya/manajemen-pengguna/detail',
              name: 'penggunaDetail',
              builder: (context, state) {
                final userdata = state.extra as Map<String, String>? ?? {};
                return DetailPenggunaScreen(userData: userdata);
              },
            ),
            GoRoute(
              path: '/admin/lainnya/manajemen-pengguna/edit',
              name: 'penggunaEdit',
              builder: (context, state) {
                final userdata = state.extra as Map<String, String>? ?? {};
                return EditPenggunaScreen(userData: userdata);
              },
            ),
            GoRoute(
              path: '/admin/lainnya/manajemen-channel',
              builder: (context, state) => const ChannelTransferScreen(),
            ),
            GoRoute(
              path: '/admin/lainnya/manajemen-channel/tambah',
              builder: (context, state) => const TambahChannelPage(),
            ),
            GoRoute(
              path: '/admin/lainnya/channel-transfer/detail',
              builder: (context, state) {
                final channelData = state.extra as Map<String, String>;
                return DetailChannelPage(channelData: channelData);
              },
            ),
            GoRoute(
              path: '/admin/lainnya/channel-transfer/edit',
              builder: (context, state) {
                final channelData = state.extra as Map<String, String>;
                return EditChannelPage(channelData: channelData);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
