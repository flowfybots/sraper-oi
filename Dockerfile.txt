FROM python:3.11-alpine

WORKDIR /app

RUN apk add --no-cache tzdata busybox-suid
ENV TZ=America/Bogota

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY scrape.py /app/scrape.py

RUN echo "* * * * * python /app/scrape.py >> /var/log/scraper.log 2>&1" >> /etc/crontabs/root

CMD ["/usr/sbin/crond", "-f", "-l", "8"]
