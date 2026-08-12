-- LUNARA: seguridad para la tabla Productos y el bucket Productos
-- Tu tabla y bucket ya existen. Este script NO los crea de nuevo.

-- Segunda foto por producto (columna opcional, puede quedar vacía)
ALTER TABLE public."Productos" ADD COLUMN IF NOT EXISTS foto_url_2 text;

ALTER TABLE public."Productos" ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can view products" ON public."Productos";
DROP POLICY IF EXISTS "Authenticated can insert products" ON public."Productos";
DROP POLICY IF EXISTS "Authenticated can update products" ON public."Productos";
DROP POLICY IF EXISTS "Authenticated can delete products" ON public."Productos";

CREATE POLICY "Public can view products"
ON public."Productos" FOR SELECT TO anon, authenticated USING (true);

CREATE POLICY "Authenticated can insert products"
ON public."Productos" FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated can update products"
ON public."Productos" FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated can delete products"
ON public."Productos" FOR DELETE TO authenticated USING (true);

-- Storage: bucket público llamado exactamente Productos
DROP POLICY IF EXISTS "Public can view product images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can upload product images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can update product images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated can delete product images" ON storage.objects;

CREATE POLICY "Public can view product images"
ON storage.objects FOR SELECT TO public
USING (bucket_id = 'Productos');

CREATE POLICY "Authenticated can upload product images"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'Productos');

CREATE POLICY "Authenticated can update product images"
ON storage.objects FOR UPDATE TO authenticated
USING (bucket_id = 'Productos') WITH CHECK (bucket_id = 'Productos');

CREATE POLICY "Authenticated can delete product images"
ON storage.objects FOR DELETE TO authenticated
USING (bucket_id = 'Productos');
