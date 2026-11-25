-- Run in Supabase SQL Editor after the existing setup.sql
create table if not exists public.resort_room_info (
  room_number integer primary key check (room_number between 1 and 3),
  price text not null default 'สอบถามราคา',
  description text not null default 'ห้องเช่ารายเดือน สอบถามรายละเอียดเพิ่มเติม',
  details text not null default 'ห้องเช่ารายเดือน\nสอบถามรายละเอียดและสิ่งอำนวยความสะดวก\nสอบถามเงื่อนไขการเช่าเพิ่มเติม',
  updated_at timestamptz not null default now()
);

alter table public.resort_room_info enable row level security;
drop policy if exists "Public can read resort room info" on public.resort_room_info;
create policy "Public can read resort room info" on public.resort_room_info for select using (true);
drop policy if exists "Admins can insert resort room info" on public.resort_room_info;
create policy "Admins can insert resort room info" on public.resort_room_info for insert to authenticated with check (public.is_resort_admin());
drop policy if exists "Admins can update resort room info" on public.resort_room_info;
create policy "Admins can update resort room info" on public.resort_room_info for update to authenticated using (public.is_resort_admin()) with check (public.is_resort_admin());

insert into public.resort_room_info(room_number) values (1),(2),(3) on conflict (room_number) do nothing;
