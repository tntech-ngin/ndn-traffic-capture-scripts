FROM python:3.10-alpine
WORKDIR /app
RUN apk add --no-cache bash git openssh jq
COPY --from=ghcr.io/usnistgov/ndntdump:latest /ndntdump /usr/local/bin/
COPY scheduler.py .
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["sleep", "infinity"]
# ENTRYPOINT ["python3.10", "scheduler.py"]