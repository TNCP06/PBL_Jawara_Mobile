# CRUD Warga Implementation - Complete Documentation

## Overview
Full CRUD (Create, Read, Update, Delete) functionality untuk fitur Warga (Penduduk) telah diimplementasikan dengan Supabase integration dan Flutter UI.

## Architecture

### 1. Data Models (lib/models/warga_model.dart)
**Classes:**
- `Warga` - Main entity untuk data penduduk
- `Keluarga` - Entity untuk keluarga
- `AnggotaKeluarga` - Entity untuk anggota keluarga

**Enums:**
- `Gender` - Laki-laki, Perempuan
- `GolonganDarah` - A+, A-, B+, B-, AB+, AB-, O+, O-
- `StatusPenduduk` - Aktif, Nonaktif

**Key Methods:**
```dart
// Convert database JSON to Dart object
factory Warga.fromJson(Map<String, dynamic> json)

// Convert Dart object to database JSON
Map<String, dynamic> toJson()
```

### 2. Service Layer (lib/services/warga_service.dart)
**WargaService - Singleton Pattern**

**CRUD Methods:**
```dart
// CREATE
Future<Warga> createWarga(Warga warga)

// READ
Future<List<Warga>> getAllWarga()  // With explicit relationship query
Future<List<Keluarga>> getAllKeluarga()

// UPDATE
Future<Warga> updateWarga(String nik, Warga warga)

// DELETE
Future<void> deleteWarga(String nik)
```

**Important Query Details:**
- Uses explicit relationship aliasing to avoid ambiguity
- Query format: `keluarga:keluarga_id(columns)` instead of wildcard
- Prevents "multiple relationship found" errors

### 3. UI Screens

#### A. Daftar Warga (READ) - lib/screens/.../daftar_warga.dart
**Features:**
- List semua warga dengan pagination
- Search berdasarkan nama dan NIK
- Filter berdasarkan:
  - Gender (Enum dropdown)
  - Status Penduduk (Enum dropdown)
  - Keluarga (Dynamic dropdown dari DB)
  - Status Hidup/Wafat (Hardcoded dropdown)

**Actions Menu:**
- Edit - Navigate ke edit_warga dengan Warga object
- Delete - Show confirmation dialog sebelum delete

**Components:**
```dart
_WargaCard - Card untuk setiap warga item
  - Display: Nama, NIK, Keluarga
  - Chips: Status Penduduk, Gender
  - Menu: PopupMenuButton dengan Edit/Delete

_StatusChip - Visual indicator untuk Status Penduduk
_GenderChip - Visual indicator untuk Gender
_SearchFilterBar - Search dan filter controls
```

#### B. Tambah Warga (CREATE) - lib/screens/.../tambah_warga.dart
**Features:**
- Form untuk membuat warga baru
- Input fields:
  - Nama (TextEditingController, required)
  - NIK (TextEditingController, required, numeric)
  - Tanggal Lahir (DatePickerField)
  - Tempat Lahir (TextEditingController)
  - Telepon (TextEditingController)
  - Email (TextEditingController)

**Dropdown Selectors:**
- Jenis Kelamin (Gender enum, required)
- Agama (Hardcoded strings)
- Golongan Darah (GolonganDarah enum)
- Keluarga (Dynamic from database)
- Status Kependudukan (StatusPenduduk enum, required)
- Pendidikan Terakhir (Hardcoded strings)
- Pekerjaan (Hardcoded strings)

**Validation:**
```dart
if (_nikCtl.text.isEmpty) -> Show error
if (_namaCtl.text.isEmpty) -> Show error
if (_jenisKelamin == null) -> Show error
if (_statusPenduduk == null) -> Show error
```

**Process:**
1. Load keluarga list from database in initState
2. Validate form inputs
3. Parse DateTime from text field
4. Create Warga object with form data
5. Call `_wargaService.createWarga(warga)`
6. Show success modal
7. Navigate back to daftar_warga

#### C. Edit Warga (UPDATE) - lib/screens/.../edit_warga.dart
**Features:**
- Form sama seperti tambah_warga tapi untuk edit
- Pre-populated dengan existing warga data

**Initialization:**
```dart
_namaCtl = TextEditingController(text: widget.warga.nama)
_nikCtl = TextEditingController(text: widget.warga.nik)
_jenisKelamin = widget.warga.gender
_statusPenduduk = widget.warga.statusPenduduk
// ... etc untuk semua fields
```

**Process:**
1. Load keluarga list from database
2. Validate form inputs
3. Create updated Warga object
4. Call `_wargaService.updateWarga(oldNik, newWarga)`
5. Show success modal
6. Navigate back (pop twice)

#### D. Delete Warga (DELETE) - Integrated in daftar_warga.dart
**Features:**
- PopupMenuButton di setiap card
- Menu options: Edit, Delete (in red)
- Delete shows confirmation dialog

**Process:**
1. User taps delete option
2. Show confirmation dialog dengan nama/NIK warga
3. On confirm: Call `_wargaService.deleteWarga(nik)`
4. Remove from _allWarga list
5. Show success message
6. UI updates automatically

### 4. Routing (lib/router.dart)
**Routes:**
```dart
'wargaList' -> DaftarWargaPage()
'wargaAdd' -> TambahWargaPage()
'wargaEdit' -> EditWargaPage(warga: Warga object)
```

**Type Safety:**
- Uses warga_model.Warga alias to avoid import conflicts
- Passes complete Warga object through navigation

## Database Schema (Supabase)

**Table: warga**
```sql
- nik (TEXT, PRIMARY KEY)
- nama (TEXT)
- tanggal_lahir (DATE)
- tempat_lahir (TEXT)
- gender (TEXT) - Maps to Gender enum
- golongan_darah (TEXT) - Maps to GolonganDarah enum
- pendidikan_terakhir (TEXT)
- pekerjaan (TEXT)
- status_penduduk (TEXT) - Maps to StatusPenduduk enum
- status_hidup_wafat (TEXT)
- keluarga_id (UUID, FOREIGN KEY)
- agama_id (TEXT)
- telepon (TEXT)
- email (TEXT)
- foto_ktp (TEXT)
```

**Relationship:**
- warga.keluarga_id -> keluarga.id

## Implementation Details

### Enum Conversion
**Database to Dart:**
```dart
Gender? _genderFromString(String? value) {
  switch (value) {
    case 'Laki-laki': return Gender.lakilaki;
    case 'Perempuan': return Gender.perempuan;
    default: return null;
  }
}
```

**Dart to Database:**
```dart
gender?.value // Returns 'Laki-laki' or 'Perempuan'
```

### Error Handling
- Try-catch blocks untuk semua database operations
- User-friendly error messages di SnackBar
- Validation errors untuk form inputs

### State Management
- StatefulWidget dengan setState
- Controllers disposed properly in dispose()
- _isLoading dan _isSaving flags untuk UX feedback

## Testing Checklist

### CREATE
- [ ] Fill all required fields (NIK, Nama, Gender, StatusPenduduk)
- [ ] Submit form
- [ ] Verify success modal appears
- [ ] Check data appears in daftar_warga
- [ ] Verify in Supabase database

### READ
- [ ] Load daftar_warga
- [ ] Verify all warga displayed
- [ ] Test search by name/NIK
- [ ] Test each filter
- [ ] Test filter combinations

### UPDATE
- [ ] Navigate to edit_warga from menu
- [ ] Verify all fields pre-populated
- [ ] Modify some fields
- [ ] Save changes
- [ ] Verify changes reflected in list
- [ ] Verify in Supabase database

### DELETE
- [ ] Click delete option in menu
- [ ] Verify confirmation dialog
- [ ] Click cancel - confirm no delete
- [ ] Click delete again
- [ ] Confirm delete
- [ ] Verify item removed from list
- [ ] Verify in Supabase database

## Known Limitations
- foto_ktp upload not yet implemented
- anggota_keluarga relationship not fully integrated
- No pagination for large datasets (consider adding)

## Future Enhancements
1. Add foto_ktp upload functionality
2. Implement anggota_keluarga CRUD
3. Add pagination for daftar_warga
4. Add export to CSV/PDF
5. Add bulk import functionality
6. Add history/audit trail
7. Add offline support with local database

## Debugging Tips

### Relationship Error: "could not embed because more than one relationship was found"
**Solution:** Use explicit relationship format in query
```dart
// ❌ Wrong
.select('*, keluarga(*)')

// ✅ Correct
.select('*, keluarga:keluarga_id(*)')
```

### Type Mismatch: String vs Enum
**Solution:** Use proper enum types in form and ensure conversion
```dart
// ✅ Correct pattern
Gender? _jenisKelamin; // Type-safe state variable
LabeledDropdown<Gender>(
  value: _jenisKelamin,
  items: Gender.values.map(...).toList(),
)
```

### Modal/Navigation Issues
**Solution:** Use `if (mounted)` checks before setState/navigation
```dart
if (mounted) {
  context.pop();
}
```

## Files Summary
- `lib/models/warga_model.dart` - Data models with ENUMs
- `lib/services/warga_service.dart` - CRUD service
- `lib/screens/admin/penduduk/warga/daftar_warga.dart` - List & Delete
- `lib/screens/admin/penduduk/warga/tambah_warga.dart` - Create
- `lib/screens/admin/penduduk/warga/edit_warga.dart` - Update
- `lib/router.dart` - Navigation routes

---
**Last Updated:** November 12, 2025
**Status:** ✅ CRUD Fully Implemented
