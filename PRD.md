# Product Requirement Document (PRD)

## 1. Project Overview & Objective

- **Nama Proyek:** IronBite (Working Title)
- **Platform:** Mobile Application (Android & iOS via Flutter)
- **Tujuan Utama:** Membantu pengguna mencapai target komposisi tubuh (_lean bulking_, _cutting_, atau _maintenance_) melalui pencatatan nutrisi harian yang presisi, pemantauan progres latihan beban, dan analitik tren berat badan.
- **Tech Stack Utama:**
- **Frontend:** Flutter (Dart)
- **State Management:** Riverpod / Bloc
- **Cloud Backend & Database:** Supabase (PostgreSQL, Supabase Auth, Supabase Storage, Realtime)
- **Local Database (Offline-First):** Drift (SQLite)

---

## 2. Target Persona & User Stories

- **Target Pengguna:** Individu yang aktif berolahraga di gym (pemula hingga lanjutan) yang ingin mengontrol asupan kalori dan makronutrisi harian secara konsisten tanpa antarmuka yang rumit.
- **User Stories:**
- Sebagai lifter, saya ingin menghitung target kalori harian (TDEE + surplus/defisit) agar memiliki panduan konsumsi energi yang terukur.
- Sebagai lifter, saya ingin mencatat makanan harian dengan cepat dan melihat sisa kuota kalori serta protein secara _real-time_.
- Sebagai lifter, saya ingin aplikasi tetap berfungsi mencatat makanan dan log latihan saat berada di area gym yang minim sinyal internet (_offline-first_).
- Sebagai lifter, saya ingin memantau riwayat timbangan berat badan dan foto progres fisik yang tersimpan secara privat dan aman di cloud.

---

## 3. Fitur & Ruang Lingkup (Scope)

### Fase 1: MVP (Minimum Viable Product)

- **Kalkulator & Profil Target Energi:**
- Input data fisik: Berat badan (kg), tinggi badan (cm), tanggal lahir, jenis kelamin, dan faktor aktivitas harian.
- Perhitungan BMR dan TDEE menggunakan rumus _Mifflin-St Jeor_.
- Pemilihan target kalori:
- _Cutting:_ Defisit 300–500 kkal/hari.
- _Maintenance:_ 0 kkal penyesuaian.
- _Lean Bulking:_ Surplus 300–500 kkal/hari.

- Pembagian target makronutrisi: Protein (1.6–2.2 g/kg BB), Lemak (20–25% total kalori), dan sisa dialokasikan ke Karbohidrat.

- **Daily Calorie & Macro Dashboard:**
- Cincin progres visual atau _bar indicator_ untuk total kalori masuk vs batas target harian.
- Sisa kuota kalori (_remaining calories_).
- Pemenuhan target gramasi makronutrisi: Protein, Karbohidrat, Lemak.

- **Meal & Food Logging:**
- Pengelompokan 4 waktu makan: Sarapan (_Breakfast_), Makan Siang (_Lunch_), Makan Malam (_Dinner_), dan Camilan (_Snacks_).
- Pencarian master makanan dan perhitungan porsi/gramasi dinamis.
- Pembuatan makanan kustom (_Custom Foods_) oleh pengguna.

- **Weight Tracker:**
- Pencatatan berat badan berkala (harian atau mingguan).
- Grafik visual tren fluktuasi berat badan dari waktu ke waktu.

- **Supabase Authentication:**
- Registrasi dan login berbasis Email/Password atau Google OAuth.
- Manajemen sesi pengguna menggunakan token JWT bawaan Supabase Auth.

### Fase 2: Enhanced & Offline-First (Post-MVP)

- **Offline-First Data Synchronization:**
- Operasi pencatatan lokal disimpan ke Drift (SQLite).
- Sinkronisasi data latar belakang (_background sync_) ke Supabase PostgreSQL saat koneksi internet kembali aktif.

- **Workout & Cardio Logging:**
- Pencatatan latihan beban per gerakan: Set, Repetisi, dan Beban (kg).
- Pencatatan kardio: Jenis aktivitas dan durasi.

- **Progress Photo Tracker:**
- Pengambilan dan penyimpanan foto progres fisik berkala (_front, side, back_).
- Penyimpanan file terenkripsi pada Supabase Storage bucket privat.

- **Barcode Scanner:**
- Pemindaian barcode produk kemasan menggunakan kamera perangkat untuk membaca informasi gizi secara otomatis.

---

## 4. Technical Architecture

```
+-------------------------------------------------------------+
|                     Flutter Mobile App                      |
|                                                             |
|  [Presentation Layer]    Flutter UI Widgets                 |
|  [State Management]      Riverpod / Bloc                    |
|  [Repository Layer]      Offline-First Repository Policy    |
|  [Local Persistence]     Drift (SQLite)                     |
+------------------------------+------------------------------+
                               |
                               | (Sync Engine / REST / PostgREST)
                               v
+-------------------------------------------------------------+
|                     Supabase Platform                       |
|                                                             |
|  * Supabase Auth         : JWT Token Session Management     |
|  * PostgreSQL Database   : Relational Engine with RLS       |
|  * Supabase Storage      : Private Bucket (Progress Photos) |
|  * Row Level Security    : User Data Isolation (auth.uid()) |
+-------------------------------------------------------------+

```

---

## 5. Skema Database Supabase (PostgreSQL DDL)

Eksekusi skrip SQL berikut langsung pada Supabase SQL Editor:

```sql
-- 1. SETUP EXTENSIONS
create extension if not exists "uuid-ossp";

-- 2. TABEL PROFILES
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  gender text check (gender in ('male', 'female')) not null,
  birth_date date not null,
  height_cm numeric(5, 2) not null,
  current_weight_kg numeric(5, 2) not null,
  activity_level numeric(3, 2) not null, -- 1.2 (sedentary) s.d 1.9 (extremely active)
  goal text check (goal in ('cut', 'maintain', 'bulk')) not null default 'maintain',
  calorie_target integer not null,
  protein_target_g numeric(5, 1) not null,
  carbs_target_g numeric(5, 1) not null,
  fat_target_g numeric(5, 1) not null,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  updated_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.profiles enable row level security;

create policy "Users can view own profile" on public.profiles
  for select using (auth.uid() = id);

create policy "Users can update own profile" on public.profiles
  for update using (auth.uid() = id);

create policy "Users can insert own profile" on public.profiles
  for insert with check (auth.uid() = id);

-- 3. TABEL FOODS (MASTER MAKANAN)
create table public.foods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null, -- NULL menandakan makanan global
  name text not null,
  barcode text unique,
  serving_size_g numeric(6, 2) not null default 100.0,
  calories_per_serving numeric(6, 2) not null,
  protein_g numeric(5, 2) not null default 0,
  carbs_g numeric(5, 2) not null default 0,
  fat_g numeric(5, 2) not null default 0,
  is_verified boolean not null default false,
  created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.foods enable row level security;

create policy "Users can view global foods and their own custom foods" on public.foods
  for select using (user_id is null or auth.uid() = user_id);

create policy "Users can insert their own custom foods" on public.foods
  for insert with check (auth.uid() = user_id);

create policy "Users can update their own custom foods" on public.foods
  for update using (auth.uid() = user_id);

create policy "Users can delete their own custom foods" on public.foods
  for delete using (auth.uid() = user_id);

-- 4. TABEL MEAL_LOGS
create table public.meal_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  food_id uuid not null references public.foods(id) on delete restrict,
  meal_type text check (meal_type in ('breakfast', 'lunch', 'dinner', 'snack')) not null,
  serving_quantity numeric(5, 2) not null default 1.0, -- Pengali porsi (misal 1.5 porsi)
  total_calories numeric(6, 2) not null,
  total_protein_g numeric(5, 2) not null,
  total_carbs_g numeric(5, 2) not null,
  total_fat_g numeric(5, 2) not null,
  logged_date date not null default current_date,
  created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.meal_logs enable row level security;

create policy "Users can view own meal logs" on public.meal_logs
  for select using (auth.uid() = user_id);

create policy "Users can insert own meal logs" on public.meal_logs
  for insert with check (auth.uid() = user_id);

create policy "Users can update own meal logs" on public.meal_logs
  for update using (auth.uid() = user_id);

create policy "Users can delete own meal logs" on public.meal_logs
  for delete using (auth.uid() = user_id);

create index idx_meal_logs_user_date on public.meal_logs(user_id, logged_date);

-- 5. TABEL WEIGHT_LOGS
create table public.weight_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  weight_kg numeric(5, 2) not null,
  logged_date date not null default current_date,
  notes text,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  constraint unique_user_weight_date unique (user_id, logged_date)
);

alter table public.weight_logs enable row level security;

create policy "Users can manage own weight logs" on public.weight_logs
  for all using (auth.uid() = user_id);

create index idx_weight_logs_user_date on public.weight_logs(user_id, logged_date);

```

---

## 6. Non-Functional Requirements

- **Keamanan Data & Privasi:**
- Seluruh akses data pada PostgreSQL wajib melalui validasi _Row Level Security_ (RLS). Pengguna dilarang mengakses baris data milik pengguna lain.
- Berkas pada Supabase Storage (foto progres) diletakkan di dalam private bucket bertaut ID pengguna.

- **Performa & Offline Capability:**
- Pencatatan log di Flutter tidak boleh memblokir thread UI (_non-blocking_). Data disimpan ke SQLite lokal (Drift) sebelum proses sinkronisasi remote ke Supabase dijalankan.
- Indeks basis data PostgreSQL dipasang pada kombinasi kolom `(user_id, logged_date)` guna memastikan agregasi harian tetap cepat seiring pertambahan baris data.

- **Efisiensi Penyimpanan Gambar:**
- Seluruh citra foto progres wajib dikompresi di sisi aplikasi Flutter (maksimal 1–2 MB, format JPEG/WebP) sebelum diunggah ke storage backend.
