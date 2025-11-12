# ===== Build stage (nothing to build for plain Flask, but keeps it extensible)
FROM python:3.11-slim AS build

WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

# ===== Runtime stage
FROM python:3.11-slim

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY --from=build /install /usr/local
COPY app.py /app/app.py

EXPOSE 5000
# Production-ready WSGI server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]

