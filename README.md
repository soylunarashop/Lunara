# LUNARA — Panel de administración

Esta versión elimina la dependencia de Google Sheets y prepara Lunara para usar:
- tienda pública (`index.html`)
- panel privado (`admin.html`)
- Supabase Auth para el administrador
- Supabase Database para productos
- Supabase Storage para fotos

## Campos del producto

Solo existen:
1. Nombre
2. Precio
3. Categoría
4. Foto principal
5. Foto secundaria (opcional)

No se incluye stock ni descripción.

## 1. Crear el backend gratuito

Crea un proyecto en Supabase con el plan gratuito.

Después:
1. Abre `SQL Editor`.
2. Abre `supabase_setup.sql`.
3. Ejecuta todo el script.
4. Ve a `Authentication > Users` y crea manualmente el usuario que será administrador.
   - Usa el correo y contraseña que quieras para el acceso.
   - No necesitas habilitar registro público.

## 2. Conectar Lunara

En Supabase:
`Project Settings > API`

Copia:
- Project URL
- Publishable/anon key

Abre `config.js` y reemplaza:

SUPABASE_URL: "PEGA_AQUI_TU_SUPABASE_URL"
SUPABASE_ANON_KEY: "PEGA_AQUI_TU_SUPABASE_ANON_KEY"

IMPORTANTE:
- Usa únicamente la clave pública/anon.
- Nunca pongas la `service_role` key en estos archivos.

### Si vas a subir el proyecto a GitHub

`config.js` está incluido en `.gitignore`, así que **no se subirá** a tu repositorio aunque hagas `git add .`. Esto es solo para evitar confusiones si el repo es público; la clave anon en sí es segura de exponer (está diseñada para usarse en el navegador).

Para que cualquiera pueda clonar el proyecto y configurarlo:
1. Usa `config.example.js` como plantilla (ya está en el repo, sin credenciales reales).
2. Cópialo y renómbralo a `config.js`.
3. Pega ahí tus credenciales reales de Supabase.

Si ya subiste `config.js` a GitHub antes de tener el `.gitignore`, recuerda quitarlo del historial (`git rm --cached config.js`) además de agregarlo al `.gitignore`.

## 3. Probar

Para probar localmente usa VS Code + Live Server (o cualquier servidor HTTP local).

Abre:
- `index.html` → tienda
- `admin.html` → administración

En `admin.html` inicia sesión con el usuario que creaste en Supabase.

Luego:
1. Pulsa `+ Nuevo producto`.
2. Escribe nombre.
3. Escribe precio en pesos colombianos, por ejemplo `89900`.
4. Escribe categoría.
5. Selecciona una foto desde el computador o celular.
6. Guarda.

El producto aparecerá en la tienda pública.

## 4. Seguridad

El panel no tiene registro público. Solo entra quien tenga una cuenta creada en Supabase Auth.

La tienda puede leer productos, pero las operaciones de crear, editar y eliminar requieren autenticación.

## 5. Hosting gratuito

El frontend puede publicarse en un hosting estático gratuito. Supabase aloja la base de datos, autenticación y las imágenes dentro de sus límites del plan gratuito.

El proyecto está preparado para no necesitar un servidor Node/Java/PHP propio.

## Nota sobre fotos

Las fotos se suben directamente desde el panel al bucket `Productos`. No tienes que copiar URLs ni utilizar Google Drive.

- **Compresión automática**: antes de subir, el panel redimensiona la imagen (máximo 1600px en su lado más largo) y ajusta la calidad para que pese menos. Esto hace que la tienda cargue más rápido para tus clientas y que el plan gratuito de Storage rinda más. Si por algún motivo la compresión no mejora el peso del archivo, se sube el original tal cual. Los GIF no se recomprimen (para no dañar la animación).
- **Limpieza de Storage**: cuando eliminas un producto, o cuando reemplazas/quitas cualquiera de sus fotos al editarlo, el panel borra automáticamente las imágenes anteriores que ya no utiliza el producto. Si una subida o el guardado falla después de subir una foto nueva, el panel también intenta eliminar esa foto nueva para evitar archivos huérfanos.

## Vista previa al compartir el link (WhatsApp / Instagram / Facebook)

`index.html` ya incluye metaetiquetas Open Graph y Twitter Card, así que cuando alguien comparta el link de la tienda se verá una tarjeta con título, descripción e imagen.

**Antes de publicar, revisa y ajusta en el `<head>` de `index.html`:**
- `og:image` y `twitter:image` apuntan a `https://lunarashop.co/icono.png` como marcador de posición. Cámbialo por la URL real de tu dominio (o por una imagen cuadrada de al menos 512×512px pensada para compartir, no necesariamente el ícono).
- `og:url` también usa `https://lunarashop.co/` como marcador — reemplázalo por el dominio real donde publiques la tienda.

## Estructura

index.html  -> tienda pública
admin.html       -> panel
admin.css        -> estilos del panel
style.css        -> estilos de Lunara
config.js        -> credenciales públicas de Supabase
supabase_setup.sql -> tablas, políticas y almacenamiento
icono.png        -> favicon
