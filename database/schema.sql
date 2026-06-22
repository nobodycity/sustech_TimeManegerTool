-- ÐÞÕý°æ - È¥µô default auth.uid()

create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table public.profiles enable row level security;
create policy "Users can view own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger as 
begin
  insert into public.profiles (id, username) values (new.id, new.raw_user_meta_data->>'username');
  return new;
end;
 language plpgsql security definer;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();

create table if not exists public.courses (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  day_key smallint not null check (day_key between 0 and 6),
  period smallint not null,
  name text not null,
  location text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table public.courses enable row level security;
create policy "Users can CRUD own courses" on public.courses for all using (auth.uid() = user_id);

create table if not exists public.tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  name text not null,
  start_date date,
  deadline_date date,
  duration_minutes int,
  location text,
  notes text,
  status text default 'pending' check (status in ('pending','completed','archived')),
  is_longline boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
alter table public.tasks enable row level security;
create policy "Users can CRUD own tasks" on public.tasks for all using (auth.uid() = user_id);

create table if not exists public.fixed_events (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  name text not null,
  event_date date not null,
  start_time time not null,
  end_time time not null,
  location text,
  notes text,
  created_at timestamptz default now()
);
alter table public.fixed_events enable row level security;
create policy "Users can CRUD own fixed_events" on public.fixed_events for all using (auth.uid() = user_id);
