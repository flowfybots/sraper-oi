FROM python:3.11-slim

WORKDIR /app

# zona horaria + cron
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata cron \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=America/Bogota

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY scrape.py /app/scrape.py

# (POR AHORA) cada minuto para probar
RUN echo "* * * * * python /app/scrape.py >> /var/log/scraper.log 2>&1" > /etc/cron.d/scraper \
    && chmod 0644 /etc/cron.d/scraper \
    && crontab /etc/cron.d/scraper

CMD ["cron", "-f"]
