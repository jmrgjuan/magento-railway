# magento-railway

Magento 2.4.x prepared to be deployed on Railway (with Docker + IaC-friendly config).

## 🧱 ¿Qué hay en este repo?

- `Dockerfile` + `docker-compose.yml` para levantar un entorno local completo (PHP-FPM + nginx + MySQL + Redis + Elasticsearch).
- `scripts/init-magento.sh` para inicializar el proyecto Magento usando Composer (requiere claves de Magento Marketplace).
- `railway.toml` para describir el despliegue en Railway.
- `.env.example` con variables recomendadas para el entorno.

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

3) Levanta los contenedores (usa los scripts de utilidad):

```bash
./scripts/start.sh
```

> Tip: puedes verificar el estado de los contenedores con `./scripts/status.sh` y detenerlos con `./scripts/stop.sh`.

4) Inicializa el proyecto Magento (esto descargará Magento vía Composer):

```bash
source .env
./scripts/composer-create-project-magento.sh
```

5) Ejecuta la instalación de Magento (puede tardar algunos minutos):

```bash
source .env
./scripts/magento-setup-install.sh
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
