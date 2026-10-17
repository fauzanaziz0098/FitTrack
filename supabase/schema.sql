-- 1. SETUP EXTENSIONS
create extension if not exists "uuid-ossp";

-- 2. DROP OLD POLICIES FIRST
drop policy if exists "Users can view own profile" on public.profiles;
drop policy if exists "Users can update own profile" on public.profiles;
drop policy if exists "Users can insert own profile" on public.profiles;
drop policy if exists "Allow all access to profiles" on public.profiles;

drop policy if exists "Users can view global foods and their own custom foods" on public.foods;
drop policy if exists "Users can insert their own custom foods" on public.foods;
drop policy if exists "Users can update their own custom foods" on public.foods;
drop policy if exists "Users can delete their own custom foods" on public.foods;
drop policy if exists "Allow all access to foods" on public.foods;

drop policy if exists "Users can view own meal logs" on public.meal_logs;
drop policy if exists "Users can insert own meal logs" on public.meal_logs;
drop policy if exists "Users can update own meal logs" on public.meal_logs;
drop policy if exists "Users can delete own meal logs" on public.meal_logs;
drop policy if exists "Allow all access to meal_logs" on public.meal_logs;

drop policy if exists "Users can manage own weight logs" on public.weight_logs;
drop policy if exists "Allow all access to weight_logs" on public.weight_logs;

-- 3. DROP RESTRICTIVE FOREIGN KEYS TO AUTH.USERS
alter table if exists public.profiles drop constraint if exists profiles_id_fkey;
alter table if exists public.meal_logs drop constraint if exists meal_logs_user_id_fkey;
alter table if exists public.weight_logs drop constraint if exists weight_logs_user_id_fkey;
alter table if exists public.foods drop constraint if exists foods_user_id_fkey;

-- 4. ALTER COLUMN TYPES TO TEXT
alter table public.profiles alter column id type text using id::text;
alter table public.foods alter column user_id type text using user_id::text;
alter table public.meal_logs alter column user_id type text using user_id::text;
alter table public.weight_logs alter column user_id type text using user_id::text;

-- 5. ENABLE ROW LEVEL SECURITY AND PERMIT ACCESS USING API KEY
alter table public.profiles enable row level security;
alter table public.foods enable row level security;
alter table public.meal_logs enable row level security;
alter table public.weight_logs enable row level security;

create policy "Allow all access to profiles" on public.profiles
  for all to public using (true) with check (true);

create policy "Allow all access to foods" on public.foods
  for all to public using (true) with check (true);

create policy "Allow all access to meal_logs" on public.meal_logs
  for all to public using (true) with check (true);

create policy "Allow all access to weight_logs" on public.weight_logs
  for all to public using (true) with check (true);

-- 6. INDICES
create index if not exists idx_meal_logs_user_date on public.meal_logs(user_id, logged_date);
create index if not exists idx_weight_logs_user_date on public.weight_logs(user_id, logged_date);
