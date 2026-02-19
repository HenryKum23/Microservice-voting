# ========================================
# Stage 1: Build
# ========================================
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0 AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

WORKDIR /source

COPY *.csproj .

RUN case ${TARGETPLATFORM} in \
        "linux/amd64")     ARCH=x64    ;; \
        "linux/arm64")     ARCH=arm64  ;; \
        "linux/arm64/v8")  ARCH=arm64  ;; \
        "linux/arm/v7")    ARCH=arm    ;; \
    esac \
    && dotnet restore -r linux-${ARCH}

COPY . .

RUN case ${TARGETPLATFORM} in \
        "linux/amd64")     ARCH=x64    ;; \
        "linux/arm64")     ARCH=arm64  ;; \
        "linux/arm64/v8")  ARCH=arm64  ;; \
        "linux/arm/v7")    ARCH=arm    ;; \
    esac \
    && dotnet publish -c Release -o /app -r linux-${ARCH} \
       --self-contained false \
       --no-restore

# ========================================
# Stage 2: Runtime (Hardened)
# ========================================
FROM mcr.microsoft.com/dotnet/runtime:7.0

# Create non-root user
RUN groupadd -r appuser && \
    useradd -r -g appuser -u 1000 -m -s /sbin/nologin appuser

WORKDIR /app

# Copy with correct ownership
COPY --from=build --chown=appuser:appuser /app .

# Create logs directory
RUN mkdir -p /app/logs && \
    chown -R appuser:appuser /app

# Switch to non-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD dotnet --info > /dev/null || exit 1

# Run application
ENTRYPOINT ["dotnet", "Worker.dll"]

# Metadata
LABEL security.non-root="true"
LABEL security.user="appuser"
LABEL security.uid="1000"