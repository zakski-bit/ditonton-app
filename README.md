# Ditonton - Movie & TV Series Catalogue App

[![CI](https://github.com/zakski-bit/ditonton-app/actions/workflows/ci.yml/badge.svg)](https://github.com/zakski-bit/ditonton-app/actions/workflows/ci.yml)

**Ditonton** adalah aplikasi katalog film dan serial TV yang mengadopsi standar rekayasa perangkat lunak tingkat *enterprise*: **Clean Architecture**, **Multi-Package Modularization**, **BLoC Pattern State Management**, **SSL Pinning**, **Firebase Analytics & Crashlytics**, serta **Continuous Integration (CI/CD)**.

Proyek ini dibangun sebagai submission akhir pada kelas **Menjadi Flutter Developer Expert** di Dicoding Academy dengan target capaian **Bintang 5**.

---

## 🌟 Fitur Utama & Kriteria Penilaian

### 1. Multi-Package Modularization
Aplikasi dipecah menjadi beberapa paket modular yang mandiri (*decoupled*) dengan dependensi terarah (DAG):
* **`core`**: Menyediakan komponen inti bersama seperti Database Helper (SQLite), SSL Pinning HTTP Client, konfigurasi tema gelap (Dark Theme), palet warna (`kRichBlack`, `kOxfordBlue`, `kMikadoYellow`), tipografi Poppins, entities inti (`Movie`, `TvSeries`, `Genre`, `Season`, dsb), network exception & failures, serta navigation observer.
* **`about`**: Menampilkan profil pengembang dan informasi aplikasi.
* **`movie`**: Modul fitur Movie lengkap (Data, Domain, Presentation) dengan BLoC untuk *Now Playing*, *Popular*, *Top Rated*, *Detail*, *Recommendations*, dan *Watchlist*.
* **`tv`**: Modul fitur TV Series lengkap (Data, Domain, Presentation) dengan BLoC untuk *On The Air*, *Popular*, *Top Rated*, *Detail (termasuk Seasons & Episodes)*, *Recommendations*, dan *Watchlist*.
* **`search`**: Modul fitur pencarian terpadu untuk Movie dan TV Series yang dilengkapi *debounce event transformer* (RxDart 500ms) untuk mencegah *request spam*.
* **`watchlist`**: Modul tampilan terpadu daftar pantauan pengguna (Movies & TV Series) berbasis `TabBar` dan sinkronisasi realtime melalui `RouteAware`.

### 2. Migrasi Menyeluruh ke BLoC (State Management)
Seluruh pengelolaan state aplikasi dimigrasi 100% dari `Provider` menjadi `flutter_bloc`:
| Fitur | BLoC | Tanggung Jawab |
|---|---|---|
| Movie | `NowPlayingMoviesBloc` | Mengelola daftar film yang sedang tayang |
| Movie | `PopularMoviesBloc` | Mengelola daftar film terpopuler |
| Movie | `TopRatedMoviesBloc` | Mengelola daftar film berperingkat tertinggi |
| Movie | `MovieDetailBloc` | Mengelola detail film dan status watchlist |
| Movie | `MovieRecommendationsBloc` | Mengelola rekomendasi film terkait |
| Movie | `WatchlistMovieBloc` | Mengelola operasi CRUD watchlist film |
| TV Series | `OnTheAirTvSeriesBloc` | Mengelola daftar serial TV yang sedang tayang |
| TV Series | `PopularTvSeriesBloc` | Mengelola daftar serial TV terpopuler |
| TV Series | `TopRatedTvSeriesBloc` | Mengelola serial TV berperingkat tertinggi |
| TV Series | `TvSeriesDetailBloc` | Mengelola detail TV (termasuk Seasons & Episodes) |
| TV Series | `TvSeriesRecommendationsBloc` | Mengelola rekomendasi serial TV terkait |
| TV Series | `WatchlistTvSeriesBloc` | Mengelola operasi CRUD watchlist serial TV |
| Search | `MovieSearchBloc` | Pencarian film dengan debounce 500ms |
| Search | `TvSearchBloc` | Pencarian serial TV dengan debounce 500ms |

### 3. Keamanan Tingkat Lanjut: SSL Pinning
Untuk melindungi komunikasi data dari ancaman *Man-In-The-Middle (MITM)*, aplikasi menerapkan **SSL Pinning**:
* Sertifikat SSL resmi dari `api.themoviedb.org` disematkan di `assets/certificates/certificates.pem`.
* Dikonfigurasi menggunakan `SecurityContext(withTrustedRoots: false)` dan `IOClient(httpClient)`.
* Sertifikat yang disematkan adalah sertifikat leaf yang berlaku sampai **4 Mei 2027**. Perbarui bundle sebelum tanggal itu dan setiap kali sertifikat TMDB berganti.
* Test yang ada saat ini hanya memeriksa pembuatan client; belum ada test yang membuktikan koneksi dengan sertifikat valid atau menolak sertifikat yang berbeda.

### 4. Firebase Analytics & Crashlytics
* **Firebase Analytics**: Mengirim perubahan rute melalui `FirebaseAnalyticsObserver` setelah Firebase berhasil diinisialisasi.
* **Firebase Crashlytics**: Menangkap error Flutter dan error tak tertangani pada isolate utama setelah Firebase berhasil diinisialisasi.
* Jika konfigurasi Firebase tidak tersedia, inisialisasi dilewati dan aplikasi tetap berjalan; Analytics dan Crashlytics tidak aktif pada kondisi itu.

### 5. Continuous Integration (CI/CD)
* **GitHub Actions** (`.github/workflows/ci.yml`): Berjalan otomatis pada setiap *push* dan *pull request* ke branch `main`/`master`, menjalankan `flutter pub get`, `flutter analyze` (0 warning/error), serta eksekusi seluruh *test suite* dengan *coverage*.
* **Codemagic CI** (`codemagic.yaml`): Konfigurasi untuk menjalankan analisis dan test pada runner macOS. Status build baru tersedia setelah workflow ditautkan ke aplikasi Codemagic.

---

## 📐 Arsitektur Proyek

```
ditonton (root)
├── android/
├── assets/
│   └── certificates/
│       └── certificates.pem          <-- TMDB SSL Certificate
├── integration_test/
│   └── app_test.dart                 <-- E2E Integration Test
├── lib/
│   ├── injection.dart                <-- Dependency Injection (GetIt)
│   └── main.dart                     <-- App Entry Point & Routing
├── packages/
│   ├── core/                         <-- Shared entities, DB, SSL, styles
│   ├── about/                        <-- About feature module
│   ├── movie/                        <-- Movie Clean Architecture module
│   ├── tv/                           <-- TV Series Clean Architecture module
│   ├── search/                       <-- Search feature module (Debounce RxDart)
│   └── watchlist/                    <-- Watchlist Tabbed feature module
├── .github/workflows/
│   └── ci.yml                        <-- GitHub Actions CI
├── codemagic.yaml                    <-- Codemagic CI Configuration
├── test.sh                           <-- Bash Coverage & Test Runner
└── run_all_tests.ps1                 <-- PowerShell Test Runner (Windows)
```

---

## 🧪 Pengujian & Test Coverage

Suite test mencakup:
* **Unit Test**: Domain use cases, repository implementations, data sources, model, dan BLoCs.
* **Widget Test**: Halaman dan komponen UI yang memiliki test di direktori `test/` setiap paket.
* **Integration Test**: Skenario navigasi TV Series dan watchlist tersedia di `integration_test/app_test.dart`; script CI saat ini belum menjalankannya dan skenario itu belum memverifikasi item yang tersimpan.

### Menjalankan Pengujian

#### Pada Windows (PowerShell):
```powershell
.\run_all_tests.ps1
```

#### Pada Linux / macOS (Bash):
```bash
chmod +x test.sh
./test.sh
```

#### Menjalankan Per Paket:
```bash
# Contoh pengujian pada paket movie
cd packages/movie
flutter test --coverage
flutter analyze
```

---

## 📋 Panduan Submission ke Dicoding

1. **Push ke GitHub Repository Public**:
   Pastikan kode terunggah ke repositori GitHub yang disetel ke **Public**.
2. **Screenshot Bukti CI Build & Firebase**:
   Ambil screenshot:
   - Dashboard CI (GitHub Actions / Codemagic) yang berstatus **Passed / Green**.
   - Dashboard Firebase Analytics & Crashlytics setelah konfigurasi Firebase dipasang dan event diterima.
3. **Pembersihan Berkas**:
   Jalankan `flutter clean` di root dan seluruh paket sebelum membuat arsip ZIP agar ukuran berkas ringan dan bebas dari artefak build.
