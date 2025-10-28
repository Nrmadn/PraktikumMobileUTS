# 🕌 Target Ibadah Harian

Aplikasi Gamifikasi Target Ibadah Harian dengan Flutter

---

## 📱 Tema dan Tujuan Aplikasi

### Tema
**Target Ibadah Harian** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu umat Muslim dalam mengelola dan melacak target ibadah harian mereka dengan pendekatan gamifikasi.

### Tujuan
1. Membantu pengguna membuat dan mengelola target ibadah harian (sholat, Qur'an, dzikir, sedekah)
2. Meningkatkan konsistensi beribadah melalui sistem gamifikasi (poin, level, achievement, streak)
3. Menyediakan jadwal sholat akurat dengan integrasi Aladhan API
4. Memberikan motivasi melalui tracking progress visual dan statistik
5. Memudahkan monitoring capaian ibadah dengan dashboard interaktif

---

## 📋 Daftar Halaman dan Fungsinya

| No | Nama Halaman | Route | Fungsi |
|----|--------------|-------|--------|
| 1 | Splash Screen | `/splash` | Menampilkan loading screen dengan animasi logo aplikasi |
| 2 | Login | `/login` | Autentikasi user dengan email dan password |
| 3 | Register | `/register` | Pendaftaran akun baru dengan validasi nama, email, dan password |
| 4 | Home | `/home` | Menampilkan dashboard utama: jadwal sholat, progress harian, kategori ibadah, dan daftar target |
| 5 | Progress | `/progress` | Menampilkan statistik lengkap: level & poin user, grafik progress 7 hari, statistik per kategori, dan achievements |
| 6 | Manage Targets | `/prayer_time` | Interface untuk mengelola target: melihat semua target, filter berdasarkan kategori, search, edit, dan delete |
| 7 | Add Target | `/add_target` | Form untuk menambahkan target ibadah baru dengan input nama, kategori, tanggal target, dan catatan |
| 8 | Edit Target | `/edit_target` | Form untuk mengedit detail target ibadah yang sudah ada |
| 9 | Prayer Times | `/sholat` | Menampilkan jadwal sholat 5 waktu lengkap dengan highlight sholat berikutnya dan countdown |
| 10 | Qur'an Tracker | `/quran` | Menampilkan daftar surah Al-Qur'an dengan progress tracking bacaan per surah |
| 11 | Dzikir Counter | `/dzikir` | Tasbih digital dengan pilihan dzikir (Subhanallah, Alhamdulillah, Allahu Akbar) dan counter |
| 12 | Sedekah Tracker | `/sedekah` | Menampilkan history sedekah dan total sedekah bulanan |
| 13 | Profile | `/profile` | Menampilkan informasi user, statistik capaian, edit profil, ganti password, dan logout |
| 14 | Settings | `/setting` | Pengaturan aplikasi: dark mode, notifikasi waktu sholat, pilihan bahasa, dan informasi aplikasi |

---

## 🚀 Langkah-langkah Menjalankan Aplikasi

### 1. Buka Aplikasi
Tap icon **Target Ibadah Harian** di home screen smartphone Anda. Aplikasi akan menampilkan splash screen dengan animasi selama ±3 detik.

### 2. Login atau Daftar Akun

**Jika Belum Punya Akun:**
- Tap **"Daftar Sekarang"** di halaman login
- Isi form registrasi: Nama Lengkap, Email, Password, Konfirmasi Password
- Centang checkbox **"Syarat & Ketentuan"**
- Tap tombol **"Buat Akun"**
- Setelah berhasil, gunakan email dan password yang baru dibuat untuk login

**Jika Sudah Punya Akun:**
- Masukkan Email dan Password Anda
- Tap tombol **"Masuk"**

**Akun Demo untuk Testing:**
- Email: `Nirma@mail.com`
- Password: `nirma123`

### 3. Navigasi Dashboard (Home)
Setelah login, Anda akan masuk ke halaman Home:
- **Jadwal Sholat**: Lihat 5 waktu sholat hari ini di card bagian atas dengan countdown ke sholat berikutnya
- **Progress Harian**: Cek berapa target yang sudah Anda selesaikan hari ini
- **Kategori**: Tap salah satu kategori (Sholat, Qur'an, Dzikir, Sedekah) untuk mengakses fitur spesifik
- **Daftar Target**: Scroll ke bawah untuk melihat target hari ini

### 4. Kelola Target Ibadah

**Melihat Semua Target:**
- Tap menu **"Schedule"** (ikon kalender) di bottom navigation
- Atau tap **"Kelola Target"** di Home screen
- Gunakan search bar untuk mencari target
- Tap filter kategori untuk menyaring target berdasarkan kategori

**Menambah Target Baru:**
- Tap tombol **+** (floating button) di pojok kanan bawah halaman Manage Targets
- Isi nama target (contoh: "Sholat Subuh Tepat Waktu")
- Pilih kategori dari dropdown
- Tap kalender untuk memilih tanggal target
- Tambahkan catatan jika diperlukan (optional)
- Tap tombol **"Simpan"**

**Mengedit Target:**
- Di halaman Manage Targets, tap ikon **⋮** (tiga titik) pada target yang ingin diedit
- Pilih **"Edit"**
- Ubah data yang diperlukan
- Tap tombol **"Update"**

**Menghapus Target:**
- Tap ikon **⋮** (tiga titik) pada target
- Pilih **"Hapus"**
- Konfirmasi penghapusan

### 5. Tracking Progress & Gamifikasi
- Tap menu **"Calendar"** di bottom navigation
- Lihat **level & poin** Anda saat ini
- Cek **streak counter** yang menunjukkan berapa hari berturut-turut Anda konsisten
- Analisis **grafik progress** 7 hari terakhir dalam bentuk bar chart
- Lihat **statistik per kategori** untuk mengetahui progress setiap jenis ibadah
- Scroll ke bawah untuk melihat **achievements** yang sudah di-unlock

### 6. Fitur Tambahan

**Jadwal Sholat Lengkap:**
- Dari Home, tap kategori **"Sholat"**
- Lihat jadwal 5 waktu sholat dengan detail
- Sholat berikutnya ditandai dengan border dan countdown

**Tracking Bacaan Qur'an:**
- Tap kategori **"Qur'an"**
- Browse daftar 114 surah
- Lihat progress bacaan per surah dengan progress bar

**Dzikir Counter (Tasbih Digital):**
- Tap kategori **"Dzikir"**
- Pilih jenis dzikir dari dropdown (Subhanallah, Alhamdulillah, dll)
- Tap tombol **"+"** untuk menambah hitungan
- Tap tombol **"-"** untuk mengurangi
- Tap tombol **"↻"** untuk reset counter ke 0

**Tracking Sedekah:**
- Tap kategori **"Sedekah"**
- Lihat total sedekah bulan ini
- Scroll untuk melihat history sedekah dengan detail tanggal dan jumlah

### 7. Profile & Pengaturan

**Melihat Profile:**
- Tap menu **"Profile"** di bottom navigation
- Lihat informasi: nama, email, level, poin, dan capaian hari ini
- Tap **"Edit Profil"** untuk mengubah data pribadi
- Tap **"Ubah Password"** untuk mengganti password

**Pengaturan Aplikasi:**
- Tap menu **"Settings"** di bottom navigation
- Toggle **Mode Gelap** untuk mengubah tema
- Toggle **Notifikasi Sholat** untuk mengaktifkan/nonaktifkan reminder
- Toggle **Notifikasi Motivasi** untuk pesan motivasi harian
- Pilih **Bahasa** dari dropdown (Indonesia/English/العربية)

### 8. Logout
- Buka halaman **Profile**
- Scroll ke bawah
- Tap tombol **"Keluar"**
- Konfirmasi logout pada dialog yang muncul
- Anda akan kembali ke halaman Login


---

**Dikembangkan oleh**: Nirma Nur Diana - 230605110147 
**Mata Kuliah**: Mobile Programming
