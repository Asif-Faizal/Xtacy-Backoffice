-- Run this in Supabase Dashboard → SQL Editor (free tier, no payment required)
--
-- Creates a public bucket for product images and allows the app (anon key) to
-- upload/read/delete. Firebase Auth is used for app login; Supabase is only
-- used for storage.

-- 1. Create public bucket (or enable "Public bucket" in Storage → New bucket → products)
insert into storage.buckets (id, name, public)
values ('products', 'products', true)
on conflict (id) do update set public = true;

-- 2. Storage policies for the products bucket
create policy "products_public_read"
on storage.objects for select
using (bucket_id = 'products');

create policy "products_anon_insert"
on storage.objects for insert
with check (bucket_id = 'products');

create policy "products_anon_update"
on storage.objects for update
using (bucket_id = 'products');

create policy "products_anon_delete"
on storage.objects for delete
using (bucket_id = 'products');
