FROM python:3.11-slim

WORKDIR /app

# Instalar cron y zona horaria
RUN apt-get update && apt-get install -y --no-install-recommends \
    cron tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Bogota

# Dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Script
COPY scrape.py /app/scrape.py

# Cron: cada minuto (SOLO para probar)
RUN echo "* * * * * python /app/scrape.py >> /var/log/scraper.log 2>&1" > /etc/cron.d/scraper \
    && chmod 0644 /etc/cron.d/scraper \
    && crontab /etc/cron.d/scraper

# Crear log + arrancar cron + mostrar logs en Easypanel
CMD ["sh", "-c", "touch /var/log/scraper.log && cron && tail -F /var/log/scraper.log"]
