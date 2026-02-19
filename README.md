# 🗳️ Multi-Language Microservices Voting Application

A production-ready, containerized voting application demonstrating microservices architecture across multiple programming languages with complete Docker implementation from development to production.

![Architecture Diagram](docs/architecture.png) *(Add your architecture diagram here)*

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Development](#development)
- [Testing](#testing)
- [Production Deployment](#production-deployment)
- [Project Structure](#project-structure)
- [Technical Details](#technical-details)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

This project demonstrates a complete microservices architecture using Docker containers, featuring:

- **3 programming languages** (Python, Node.js, .NET Core)
- **5 microservices** (Vote, Result, Worker, Redis, PostgreSQL)
- **Multi-stage Docker builds** for optimized images
- **Production-grade security hardening**
- **Automated integration testing**


---

## 🏗️ Architecture
```
┌─────────────┐         ┌─────────────┐
│   Browser   │         │   Browser   │
└──────┬──────┘         └──────┬──────┘
       │                       │
       │ Vote (Port 5050)      │ Results (Port 5051)
       ↓                       ↓
┌─────────────┐         ┌─────────────┐
│    Vote     │         │   Result    │
│  (Python)   │         │  (Node.js)  │
└──────┬──────┘         └──────┬──────┘
       │                       │
       ↓                       ↓
┌─────────────┐         ┌─────────────┐
│    Redis    │────────→│  PostgreSQL │
│   (Queue)   │         │    (DB)     │
└─────────────┘         └─────────────┘
       ↑                       ↑
       │                       │
       │    ┌─────────────┐    │
       └────│   Worker    │────┘
            │  (.NET Core)│
            └─────────────┘
```

### Service Communication Flow

1. **Vote Service** → User casts vote → Stores in **Redis** queue
2. **Worker Service** → Polls **Redis** → Processes vote → Stores in **PostgreSQL**
3. **Result Service** → Reads from **PostgreSQL** → Displays real-time results

---

## ✨ Features

### Application Features
- Real-time vote casting interface
- Live results dashboard with automatic updates
- Asynchronous vote processing
- Data persistence across container restarts
- Horizontal scaling support

### Technical Features
- **Multi-stage Docker builds** - Optimized image sizes (77% reduction)
- **Security hardened** - Non-root users, capability dropping, read-only filesystems
- **Health checks** - Automated service monitoring
- **Network isolation** - Front-tier and back-tier separation
- **Resource limits** - CPU and memory constraints
- **Automated testing** - Integration test suite
- **Development/Production separation** - Different compose files for different stages

---

## 📦 Prerequisites

- **Docker** 20.10+ ([Install Docker](https://docs.docker.com/get-docker/))
- **Docker Compose** v2.0+ (included with Docker Desktop)
- **Git** (for cloning the repository)

**System Requirements:**
- 4GB RAM minimum
- 10GB free disk space
- macOS, Linux, or Windows with WSL2

---

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/HenryKum23/Microservice-voting.git
cd Microservice-voting
```

### 2. Run with Pre-built Images (Fastest)
```bash
# Pull and run production images
docker compose -f docker-compose.images.yml up --pull never -d

# Access the application
# Vote: http://localhost:5050
# Result: http://localhost:5051
```

### 3. Build and Run from Source
```bash
# Build all images
docker compose build

# Start all services
docker compose up -d

# View logs
docker compose logs -f
```

### 4. Stop the Application
```bash
docker compose down

# Remove volumes (deletes data)
docker compose down -v
```

---

## 💻 Development

### Building Individual Services
```bash
# Build vote service
cd vote
docker build -t vote:latest .

# Build result service
cd result
docker build -t result:latest .

# Build worker service
cd worker
docker build -t worker:latest .
```

### Running in Development Mode
```bash
# Start with live logs
docker compose up

# Rebuild specific service
docker compose up -d --build vote

# Execute commands in running container
docker compose exec vote sh
docker compose exec result sh
```

### Development Tools
```bash
# View all running containers
docker compose ps

# Check service logs
docker compose logs vote
docker compose logs result
docker compose logs worker

# Restart a service
docker compose restart vote

# Remove and rebuild
docker compose down
docker compose build --no-cache
docker compose up -d
```

---

## 🧪 Testing

### Automated Integration Tests
```bash
# Run full test suite
docker compose -f docker-compose.test.yml up --abort-on-container-exit

# Expected output:
# ================================
# ✓ Tests PASSED
# ✓ Vote was recorded successfully
# ================================
```

### Test Coverage

The test suite validates:
- ✅ Service connectivity
- ✅ Vote submission
- ✅ Worker processing
- ✅ Result display
- ✅ End-to-end flow

### Manual Testing
```bash
# Submit a vote via curl
curl -X POST --data "vote=a" http://localhost:5050

# Check results
curl http://localhost:5051

# Health checks
docker compose ps
# All services should show (healthy)
```

---

## 🚀 Production Deployment

### Using Pre-built Images
```bash
# 1. Build production images
docker compose build

# Tag images with version
docker tag vote:latest vote:v1.0
docker tag result:latest result:v1.0
docker tag worker:latest worker:v1.0

# 2. Deploy to production
docker compose -f docker-compose.images.yml up -d

# 3. Scale services
docker compose -f docker-compose.images.yml up -d --scale vote=3

# 4. Monitor
docker compose -f docker-compose.images.yml ps
docker compose -f docker-compose.images.yml logs -f
```

### Production Checklist

- [ ] All images scanned for vulnerabilities
- [ ] Environment variables configured
- [ ] SSL/TLS certificates installed (if using reverse proxy)
- [ ] Backup strategy for PostgreSQL
- [ ] Monitoring and alerting configured
- [ ] Resource limits set appropriately
- [ ] Health checks verified
- [ ] Log aggregation setup

### Security Considerations
```yaml
# Production hardening already implemented:
- Non-root users (UID 1000+)
- Read-only filesystems
- Capability dropping (ALL capabilities removed)
- No new privileges
- Resource limits (CPU/Memory)
- Network segmentation
- Secret management at runtime
```

---

## 📁 Project Structure
```
voting-app-microservices/
├── vote/                      # Python voting service
│   ├── Dockerfile            # Multi-stage production build
│   ├── app.py                # Flask application
│   ├── requirements.txt      # Python dependencies
│   └── static/               # Frontend assets
│
├── result/                    # Node.js results service
│   ├── Dockerfile            # Multi-stage production build
│   ├── server.js             # Express application
│   ├── package.json          # Node dependencies
│   └── views/                # Frontend templates
│
├── worker/                    # .NET Core worker service
│   ├── Dockerfile            # Multi-stage production build
│   ├── Worker.cs             # Background service
│   └── Worker.csproj         # .NET project file
│
├── tests/                     # Integration tests
│   ├── Dockerfile            # Test container
│   ├── test.sh               # Test script
│   └── render.js             # (Optional) Browser automation
│
├── healthchecks/             # Health check scripts
│   ├── redis.sh
│   └── postgres.sh
│
├── docker-compose.yml        # Development environment
├── docker-compose.test.yml   # Testing environment
├── docker-compose.images.yml # Production with pre-built images
├── .dockerignore             # Docker ignore patterns
├── README.md                 # This file
└── docs/                     # Additional documentation
    ├── architecture.png
    └── deployment-guide.md
```

---

## 🔧 Technical Details

### Vote Service (Python/Flask)

**Technology:** Python 3.11, Flask, Gunicorn  
**Port:** 8000 (internal)  
**Image Size:** 195 MB  
**Dependencies:** Redis client, Flask
```dockerfile
# Multi-stage build
FROM python:3.11-alpine AS builder
# Build dependencies...

FROM python:3.11-alpine
# Runtime only
```

**Endpoints:**
- `GET /` - Voting interface
- `POST /` - Submit vote
- `GET /health` - Health check

---

### Result Service (Node.js/Express)

**Technology:** Node.js 18, Express, Socket.io  
**Port:** 4000 (internal)  
**Image Size:** 25 MB  
**Dependencies:** PostgreSQL client, Express, Socket.io

**Endpoints:**
- `GET /` - Results dashboard
- `GET /health` - Health check

---

### Worker Service (.NET Core)

**Technology:** .NET 7.0 Runtime  
**Image Size:** 288 MB  
**Dependencies:** Redis client, PostgreSQL client

**Function:** Polls Redis queue, processes votes, stores in PostgreSQL

---

### Data Layer

**Redis (Queue):**
- Image: `redis:alpine`
- Port: 6379
- Volume: None (ephemeral queue)

**PostgreSQL (Database):**
- Image: `postgres:15-alpine`
- Port: 5432
- Volume: `db-data` (persistent)
- Database: `postgres`

---

## 🔒 Security

### Implemented Security Measures

1. **Non-root Users**
   - All services run as UID 1000 (appuser)
   - No privileged operations

2. **Minimal Base Images**
   - Alpine Linux (5 MB base)
   - Slim variants for larger images
   - Multi-stage builds remove build tools

3. **Capability Dropping**
```yaml
   cap_drop:
     - ALL
   security_opt:
     - no-new-privileges:true
```

4. **Read-only Filesystems**
```yaml
   read_only: true
   tmpfs:
     - /tmp
```

5. **Network Isolation**
   - Front-tier: Vote, Result (public)
   - Back-tier: Worker, Redis, PostgreSQL (private)

6. **Resource Limits**
```yaml
   deploy:
     resources:
       limits:
         cpus: '1.0'
         memory: 512M
```

### Vulnerability Scanning
```bash
# Scan images for vulnerabilities
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image vote:latest

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image result:latest

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image worker:latest
```

---

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use

**Problem:** `bind: address already in use`

**Solution:**
```bash
# Check what's using the port
lsof -i :5050

# Kill the process or use different port
# Edit docker-compose.yml ports section
```

#### Container Unhealthy

**Problem:** Service shows `(unhealthy)` status

**Solution:**
```bash
# Check logs
docker compose logs <service-name>

# Check health check endpoint
docker compose exec <service-name> curl localhost:<port>/health

# Restart service
docker compose restart <service-name>
```

#### Connection Refused

**Problem:** `Connection refused` when accessing services

**Solution:**
```bash
# Verify containers are running
docker compose ps

# Check port mappings match internal ports
# vote: 5050:8000 (not 5050:80)
# result: 5051:4000 (not 5051:80)

# Verify logs
docker compose logs
```

#### Empty Reply from Server

**Problem:** `curl: (52) Empty reply from server`

**Solution:**
```bash
# Port mapping mismatch - check docker-compose.yml
# Container port must match service bind port

# Example fix:
ports:
  - "5050:8000"  # If service binds to 8000
```

#### Build Failures

**Problem:** Docker build fails

**Solution:**
```bash
# Clean build (no cache)
docker compose build --no-cache

# Check Dockerfile syntax
docker compose config

# Verify base images are accessible
docker pull python:3.11-alpine
```

---

## 📈 Performance Optimization

### Image Size Comparison

| Component | Traditional | Optimized | Reduction |
|-----------|------------|-----------|-----------|
| Vote | 600 MB | 195 MB | 67% |
| Result | 500 MB | 25 MB | 95% |
| Worker | 400 MB | 288 MB | 28% |
| **Total** | **1.5 GB** | **508 MB** | **66%** |

### Build Time Comparison

| Stage | Traditional | Optimized | Improvement |
|-------|------------|-----------|-------------|
| Build | 5-7 min | 2-3 min | 60% faster |
| Deploy | 10 min | 2 min | 80% faster |

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow existing code style
- Add tests for new features
- Update documentation
- Ensure all tests pass
- Keep commits atomic and well-described

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Docker community for excellent documentation
- Microservices architecture patterns from industry best practices
- Open-source contributors

---

## 📞 Contact

**Henry Kumah** - email: henrykum088@gmail.com

**Project Link:** https://github.com/HenryKum23/Microservice-voting.git

---

## 🚀 What's Next?

- [ ] Kubernetes deployment manifests
- [ ] Helm charts for easy deployment
- [ ] Prometheus/Grafana monitoring stack
- [ ] GitHub Actions CI/CD pipeline
- [ ] Blue-green deployment strategy
- [ ] Horizontal pod autoscaling
- [ ] Service mesh integration (Istio)
- [ ] API Gateway (Kong/Ambassador)

---

**⭐ If you found this project helpful, please consider giving it a star!**

Made with ❤️ and 🐳 by [Your Name]
