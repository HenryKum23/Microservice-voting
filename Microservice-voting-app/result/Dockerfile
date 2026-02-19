# ========================================
# Stage 1: Builder
# ========================================
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production \
    && npm cache clean --force

# ========================================
# Stage 2: Runtime
# ========================================
FROM node:18-alpine

# Install tini (process manager)
RUN apk add --no-cache tini

# ========================================
# HARDENING: Create non-root user
# ========================================
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser -s /sbin/nologin appuser

WORKDIR /app

# Copy node_modules from builder
COPY --from=builder /app/node_modules ./node_modules

# Copy application code
COPY --chown=appuser:appuser . .

# ========================================
# HARDENING: Switch to non-root user
# ========================================
USER appuser

# Health check (for Node.js)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD node healthcheck.js || exit 1

# Expose port
EXPOSE 80

# Run application with tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "server.js"]

# Metadata
LABEL security.non-root="true"
LABEL security.user="appuser"
LABEL security.uid="1001"