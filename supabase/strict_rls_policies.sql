-- ============================================================
-- IRONBITE STRICT ROW LEVEL SECURITY (RLS) POLICIES
-- Jalankan skrip ini di Supabase SQL Editor untuk mengunci data
-- agar setiap user HANYA bisa mengakses & melihat datanya sendiri.
-- ============================================================

-- 1. Pastikan RLS aktif di semua tabel
alter table public.profiles enable row level security;
alter table public.foods enable row level security;
alter table public.meal_logs enable row level security;
alter table public.weight_logs enable row level security;

-- 2. Hapus kebijakan publik/longgar sebelumnya (jika ada)
drop policy if exists "Allow all access to profiles" on public.profiles;
drop policy if exists "Allow all access to foods" on public.foods;
drop policy if exists "Allow all access to meal_logs" on public.meal_logs;
drop policy if exists "Allow all access to weight_logs" on public.weight_logs;

drop policy if exists "Users can view own profile" on public.profiles;
drop policy if exists "Users can insert own profile" on public.profiles;
drop policy if exists "Users can update own profile" on public.profiles;
drop policy if exists "Users can delete own profile" on public.profiles;

drop policy if exists "Users can view global foods and own custom foods" on public.foods;
drop policy if exists "Users can insert own custom foods" on public.foods;
drop policy if exists "Users can update own custom foods" on public.foods;
drop policy if exists "Users can delete own custom foods" on public.foods;

drop policy if exists "Users can view own meal logs" on public.meal_logs;
drop policy if exists "Users can insert own meal logs" on public.meal_logs;
drop policy if exists "Users can update own meal logs" on public.meal_logs;
drop policy if exists "Users can delete own meal logs" on public.meal_logs;

drop policy if exists "Users can view own weight logs" on public.weight_logs;
drop policy if exists "Users can insert own weight logs" on public.weight_logs;
drop policy if exists "Users can update own weight logs" on public.weight_logs;
drop policy if exists "Users can delete own weight logs" on public.weight_logs;

-- ============================================================
-- 3. PROFILES
-- ID profil sama dengan auth.uid() user.
-- ============================================================
create policy "Users can view own profile" on public.profiles
  for select to authenticated using (id = (auth.uid())::text);

create policy "Users can insert own profile" on public.profiles
  for insert to authenticated with check (id = (auth.uid())::text);

create policy "Users can update own profile" on public.profiles
  for update to authenticated using (id = (auth.uid())::text) with check (id = (auth.uid())::text);

create policy "Users can delete own profile" on public.profiles
  for delete to authenticated using (id = (auth.uid())::text);

-- ============================================================
-- 4. FOODS (MASTER MAKANAN)
-- Makanan global (user_id IS NULL) bisa dibaca semua user.
-- Custom food (user_id = auth.uid()) privat hanya untuk pembuatnya.
-- ============================================================
create policy "Users can view global foods and own custom foods" on public.foods
  for select to authenticated using (user_id is null or user_id = (auth.uid())::text);

create policy "Users can insert own custom foods" on public.foods
  for insert to authenticated with check (user_id = (auth.uid())::text);

create policy "Users can update own custom foods" on public.foods
  for update to authenticated using (user_id = (auth.uid())::text) with check (user_id = (auth.uid())::text);

create policy "Users can delete own custom foods" on public.foods
  for delete to authenticated using (user_id = (auth.uid())::text);

-- ============================================================
-- 5. MEAL_LOGS
-- Catatan makan hanya dapat dibaca & dimodifikasi pemiliknya.
-- ============================================================
create policy "Users can view own meal logs" on public.meal_logs
  for select to authenticated using (user_id = (auth.uid())::text);

create policy "Users can insert own meal logs" on public.meal_logs
  for insert to authenticated with check (user_id = (auth.uid())::text);

create policy "Users can update own meal logs" on public.meal_logs
  for update to authenticated using (user_id = (auth.uid())::text) with check (user_id = (auth.uid())::text);

create policy "Users can delete own meal logs" on public.meal_logs
  for delete to authenticated using (user_id = (auth.uid())::text);

-- ============================================================
-- 6. WEIGHT_LOGS
-- Catatan berat badan hanya dapat dibaca & dimodifikasi pemiliknya.
-- ============================================================
create policy "Users can view own weight logs" on public.weight_logs
  for select to authenticated using (user_id = (auth.uid())::text);

create policy "Users can insert own weight logs" on public.weight_logs
  for insert to authenticated with check (user_id = (auth.uid())::text);

create policy "Users can update own weight logs" on public.weight_logs
  for update to authenticated using (user_id = (auth.uid())::text) with check (user_id = (auth.uid())::text);

create policy "Users can delete own weight logs" on public.weight_logs
  for delete to authenticated using (user_id = (auth.uid())::text);
