# ========================================
# Stage 1: Builder
# ========================================
FROM python:3.7-alpine AS builder

WORKDIR /app

# Install build dependencies (USE apk, NOT apt-get!)
RUN apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev

# Install Python packages
COPY requirements.txt .
RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

# ========================================
# Stage 2: Runtime
# ========================================
FROM python:3.7-alpine

# Install only runtime libraries (USE apk, NOT apt-get!)
RUN apk add --no-cache \
    libpq

# ========================================
# HARDENING: Create non-root user
# ========================================
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser -s /sbin/nologin appuser

WORKDIR /app

# Copy from builder
COPY --from=builder /install /usr/local

# Create directories with correct ownership
RUN mkdir -p /app/logs /app/tmp && \
    chown -R appuser:appuser /app

# Copy application
COPY --chown=appuser:appuser . .

# ========================================
# HARDENING: Switch to non-root user
# ========================================
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health').read()" || exit 1

# Expose port
EXPOSE 8000

# Run application
ENTRYPOINT ["gunicorn"]
CMD ["--bind", "0.0.0.0:8000", "--workers", "4", "app:app"]

# Metadata
LABEL security.non-root="true"
LABEL security.user="appuser"
LABEL security.uid="1000"