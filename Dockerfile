FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata cron \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Bogota

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY scrape.py /app/scrape.py

# cron cada minuto (prueba)
RUN echo "* * * * * python /app/scrape.py >> /var/log/scraper.log 2>&1" > /etc/cron.d/scraper \
    && chmod 0644 /etc/cron.d/scraper \
    && crontab /etc/cron.d/scraper

# ✅ arranca cron y además “sigue” el log para que Easypanel lo muestre
CMD ["sh", "-c", "cron && tail -f /var/log/scraper.log"]
