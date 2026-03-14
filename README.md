# magento-railway

Magento 2.4.x prepared to be deployed on Railway (with Docker + IaC-friendly config).

## 🧱 ¿Qué hay en este repo?

- `Dockerfile` + `docker-compose.yml` para levantar un entorno local completo (PHP-FPM + nginx + MySQL + Redis + Elasticsearch).
- `railway.toml` para describir el despliegue en Railway.
- `.env.example` con variables recomendadas para el entorno.

## 🛠️ Scripts disponibles

### Unix / macOS (Bash)
- `./scripts/unix/start.sh` — arranca el stack Docker (PHP/nginx/DB/Redis/ES).
- `./scripts/unix/stop.sh` — detiene y limpia los contenedores.
- `./scripts/unix/status.sh` — muestra el estado de los servicios Docker.
- `./scripts/unix/docker-compose-helper.sh` — selecciona `docker compose` o `docker-compose` según esté disponible.
- `./scripts/unix/load-env-variables.sh` — carga `.env` desde la raíz y exige que exista.
- `./scripts/unix/composer-create-project-magento.sh` — descarga/instala Magento vía Composer.
- `./scripts/unix/magento-setup-install.sh` — ejecuta `bin/magento setup:install` dentro del contenedor.

### Windows (PowerShell)
- `./scripts/win/start.ps1` — arranca el stack Docker.
- `./scripts/win/stop.ps1` — detiene y limpia los contenedores.
- `./scripts/win/status.ps1` — muestra el estado de los servicios Docker.
- `./scripts/win/docker-compose-helper.ps1` — selecciona `docker compose` o `docker-compose` según esté disponible.
- `./scripts/win/load-env-variables.ps1` — carga `.env` desde la raíz y exige que exista.
- `./scripts/win/composer-create-project-magento.ps1` — descarga/instala Magento vía Composer.
- `./scripts/win/magento-setup-install.ps1` — ejecuta `bin/magento setup:install` dentro del contenedor.

---

## 🚀 Primeros pasos (local)

1) Clona este repo y muévete a la carpeta:

```bash
cd magento-railway
```

2) Copia el archivo de ejemplo y configura tus credenciales:

```bash
cp .env.example .env
# luego edita .env y pon tu MAGENTO_PUBLIC_KEY / MAGENTO_PRIVATE_KEY
```

3) Levanta los contenedores (usa el script wrapper, que elige la versión adecuada según tu entorno):

```bash
./scripts/start
```

> Tip: puedes verificar el estado de los contenedores con `./scripts/unix/status.sh` (Unix) o `./scripts/win/status.ps1` (Windows), y detenerlos con `./scripts/unix/stop.sh` o `./scripts/win/stop.ps1`.

4) Inicializa el proyecto Magento (esto descargará Magento vía Composer):

```bash
./scripts/unix/composer-create-project-magento.sh
```

5) Ejecuta la instalación de Magento (puede tardar algunos minutos):

```bash
./scripts/unix/magento-setup-install.sh
```

6) Abre tu navegador en http://localhost:8080

---

## 🧩 Despliegue en Railway

1) Crea un nuevo proyecto en Railway.
2) Conecta tu repo (este mismo) y agrega las variables de entorno desde `railway.toml`.
3) Agrega servicios gestionados (MySQL, Redis, Elasticsearch) en Railway y apunta las variables:
   - `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
   - `ELASTICSEARCH_HOST`, `ELASTICSEARCH_PORT`
   - `REDIS_HOST`, `REDIS_PORT`

> Nota: Railway no instala Magento automáticamente, por lo que puedes usar un `run` / script post-deploy para ejecutar `bin/magento setup:install`.
