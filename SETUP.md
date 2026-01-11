# Gauas Cloud Stack - Setup Guide

Complete setup instructions for deploying Gauas Cloud Stack locally or in production.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Setup](#detailed-setup)
4. [Git Submodules Setup](#git-submodules-setup)
5. [Environment Configuration](#environment-configuration)
6. [Running Services](#running-services)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software
- **Git**: Version 2.30 or higher
- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **Go**: Version 1.24+ (for local development)
- **Node.js**: Version 18+ (for frontend development)

### System Requirements
- **OS**: Windows 10/11, Linux, or macOS
- **RAM**: 8GB minimum, 16GB recommended
- **Disk Space**: 20GB free space
- **Network**: Stable internet connection for pulling Docker images

---

## Quick Start

### 1. Clone Repository with Submodules

```bash
# Clone the main repository with all submodules
git clone --recurse-submodules https://github.com/tnqbao/gauas-cloud-stack.git
cd gauas-cloud-stack

# Or if already cloned, initialize submodules
git submodule update --init --recursive
```

### 2. Configure Environment

```bash
# Copy environment template
cp example.env .env

# Edit configuration (optional)
nano .env
```

### 3. Start All Services

```bash
# Start infrastructure and services
docker-compose up -d

# View logs
docker-compose logs -f
```

### 4. Access Services

- **Web Console**: http://localhost:3000
- **API Gateway**: http://localhost:8083

---

## Detailed Setup

### Step 1: Clone Repository

For a fresh installation:

```bash
# Clone with all submodules
git clone --recurse-submodules https://github.com/tnqbao/gauas-cloud-stack.git
cd gauas-cloud-stack
```

If you've already cloned without submodules:

```bash
cd gauas-cloud-stack
git submodule init
git submodule update --recursive
```

### Step 2: Verify Submodules

Check that all services are properly initialized:

```bash
git submodule status
```

Expected output should show all 6 submodules:
```
backend/gau-account-service
backend/gau-authorization-service
backend/gau-cdn-service
backend/gau-cloud-service
backend/gau-upload-service
frontend/gau-cloud-console
```

---

## Git Submodules Setup

### Understanding Submodules

This project uses Git submodules to manage independent service repositories. Each service is maintained in its own repository under `github.com/tnqbao/`.

### Pull Latest Changes

To update all submodules to their latest versions:

```bash
# Update all submodules to latest master branch
git submodule update --remote --merge

# Or update a specific submodule
git submodule update --remote backend/gau-cloud-service
```

### Working with Submodules

```bash
# Enter a submodule directory
cd backend/gau-cloud-service

# Make changes and commit
git checkout master
git add .
git commit -m "Your changes"
git push origin master

# Return to main repository
cd ../..

# Commit submodule reference update
git add backend/gau-cloud-service
git commit -m "Update gau-cloud-service submodule"
git push
```

### Adding New Submodules

If you need to add a new service:

```bash
git submodule add -b master https://github.com/tnqbao/new-service.git backend/new-service
git commit -m "Add new-service submodule"
```

### Removing Submodules

To remove a submodule:

```bash
# Remove from .gitmodules and .git/config
git submodule deinit -f backend/service-name

# Remove from working tree
git rm -f backend/service-name

# Commit changes
git commit -m "Remove service-name submodule"
```

---

## Environment Configuration

### Configuration File Structure

The `example.env` file contains all configuration variables. Copy it to `.env` and modify as needed:

```bash
cp example.env .env
```

### Key Configuration Sections

#### 1. Database Configuration

```env
PGPOOL_HOST=postgres
PGPOOL_PORT=5432
PGPOOL_USER=gauas_user
PGPOOL_PASSWORD=gauas_password_2026  # Change in production!
PGPOOL_DB=gauas_db
```

#### 2. Redis Configuration

```env
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=redis_password_2026  # Change in production!
REDIS_DB=0
```

#### 3. MinIO (Object Storage)

```env
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin123  # Change in production!
MINIO_USE_SSL=false
```

#### 4. RabbitMQ (Message Queue)

```env
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=gauas_rabbitmq
RABBITMQ_PASSWORD=rabbitmq_password_2026  # Change in production!
```

#### 5. Service Ports

```env
AUTHORIZATION_SERVICE_PORT=8081
CDN_SERVICE_PORT=8082
CLOUD_SERVICE_PORT=8083
UPLOAD_SERVICE_PORT=8084
FRONTEND_PORT=3000
```

#### 6. Security Settings

```env
JWT_SECRET_KEY=your_jwt_secret_key_change_this_in_production
JWT_ALGORITHM=HS256
JWT_EXPIRE=604800  # 7 days in seconds
```

### Production Configuration

For production deployment, ensure you:

1. **Change all default passwords**
2. **Use strong JWT secret keys**
3. **Enable SSL/TLS** (`MINIO_USE_SSL=true`)
4. **Set proper CORS domains**
5. **Configure monitoring endpoints**

---

## Running Services

### Using Docker Compose

#### Start All Services

```bash
docker-compose up -d
```

#### Start Specific Services

```bash
# Infrastructure only
docker-compose up -d postgres redis minio rabbitmq

# Backend services only
docker-compose up -d gau-authorization-service gau-cdn-service gau-cloud-service gau-upload-service

# Frontend only
docker-compose up -d gau-cloud-console
```

#### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f gau-cloud-service

# Last 100 lines
docker-compose logs --tail=100 -f
```

#### Stop Services

```bash
# Stop all
docker-compose stop

# Stop specific service
docker-compose stop gau-cloud-service
```

#### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart gau-authorization-service
```

#### Rebuild Services

```bash
# Rebuild all
docker-compose build

# Rebuild and restart
docker-compose up -d --build

# Rebuild specific service
docker-compose build gau-cloud-service
docker-compose up -d gau-cloud-service
```

#### Remove Everything

```bash
# Stop and remove containers (keeps volumes)
docker-compose down

# Remove containers and volumes (clean slate)
docker-compose down -v
```

### Running Services Locally (Development)

#### Backend Services

```bash
# Navigate to service directory
cd backend/gau-cloud-service

# Install dependencies
go mod download

# Set environment variables
export $(cat ../../.env | xargs)

# Run service
go run main.go
```

#### Frontend

```bash
# Navigate to frontend
cd frontend/gau-cloud-console

# Install dependencies
npm install

# Set environment variables
export $(cat ../../.env | xargs)

# Run development server
npm run dev
```

---

## Service Access Points

### Web Interfaces

| Service | URL | Credentials |
|---------|-----|-------------|
| Web Console | http://localhost:3000 | - |
| MinIO Console | http://localhost:9001 | minioadmin / minioadmin123 |
| RabbitMQ Management | http://localhost:15672 | gauas_rabbitmq / rabbitmq_password_2026 |

### API Endpoints

| Service | URL | Description |
|---------|-----|-------------|
| Authorization | http://localhost:8081 | Auth & JWT tokens |
| CDN | http://localhost:8082 | Content delivery |
| Cloud | http://localhost:8083 | Main cloud API |
| Upload | http://localhost:8084 | File uploads |

### Database Connections

**PostgreSQL**:
```
Host: localhost
Port: 5432
Database: gauas_db
Username: gauas_user
Password: gauas_password_2026
```

**Redis**:
```
Host: localhost
Port: 6379
Password: redis_password_2026
Database: 0
```

---

## Troubleshooting

### Submodules Not Initialized

**Problem**: Empty directories in `backend/` or `frontend/`

**Solution**:
```bash
git submodule update --init --recursive
```

### Port Already in Use

**Problem**: `bind: address already in use`

**Solution**: Change port in `.env` file or stop conflicting service:
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:3000 | xargs kill -9
```

### Docker Build Failures

**Problem**: Build fails due to missing dependencies

**Solution**:
```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

### Database Connection Failed

**Problem**: Services can't connect to PostgreSQL

**Solution**:
```bash
# Check PostgreSQL is running
docker-compose ps postgres

# View PostgreSQL logs
docker-compose logs postgres

# Restart PostgreSQL
docker-compose restart postgres

# Test connection
docker-compose exec postgres psql -U gauas_user -d gauas_db
```

### Redis Connection Failed

**Problem**: Services can't connect to Redis

**Solution**:
```bash
# Check Redis is running
docker-compose ps redis

# Test connection
docker-compose exec redis redis-cli -a redis_password_2026 ping

# Expected output: PONG
```

### MinIO Connection Failed

**Problem**: Upload service can't connect to MinIO

**Solution**:
```bash
# Check MinIO is running
docker-compose ps minio

# Access MinIO console
# Go to http://localhost:9001
# Create bucket named 'gauas-bucket' if it doesn't exist
```

### RabbitMQ Connection Failed

**Problem**: Message queue not working

**Solution**:
```bash
# Check RabbitMQ status
docker-compose exec rabbitmq rabbitmq-diagnostics ping

# View RabbitMQ logs
docker-compose logs rabbitmq

# Access management console
# Go to http://localhost:15672
```

### Submodule Update Conflicts

**Problem**: Can't update submodules due to local changes

**Solution**:
```bash
# Stash local changes
cd backend/gau-cloud-service
git stash

# Pull latest changes
git pull origin master

# Apply stashed changes
git stash pop
```

### Container Health Check Failing

**Problem**: Container stays in "unhealthy" state

**Solution**:
```bash
# Check health check logs
docker inspect --format='{{json .State.Health}}' gau-cloud-service | jq

# View service logs
docker-compose logs gau-cloud-service

# Restart service
docker-compose restart gau-cloud-service
```

---

## Advanced Configuration

### Kubernetes Deployment

Each service includes Kubernetes manifests in `deploy/k8s/`:

```bash
# Deploy to Kubernetes
kubectl apply -f backend/gau-cloud-service/deploy/k8s/staging/

# Check deployment status
kubectl get pods
kubectl get services
```

### Custom Docker Network

To use a custom Docker network:

```yaml
# In docker-compose.yml
networks:
  gauas-network:
    external: true
    name: my-custom-network
```

### Volume Management

List all volumes:
```bash
docker volume ls
```

Backup a volume:
```bash
docker run --rm -v gauas-cloud-stack_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
```

Restore a volume:
```bash
docker run --rm -v gauas-cloud-stack_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres_backup.tar.gz -C /data
```

---

## Performance Tuning

### Docker Resource Limits

Add resource limits in `docker-compose.yml`:

```yaml
services:
  gau-cloud-service:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

### Database Optimization

```bash
# Increase PostgreSQL connections
# Add to docker-compose.yml under postgres environment:
POSTGRES_MAX_CONNECTIONS=200
```

### Redis Memory Management

```bash
# Set max memory in docker-compose.yml
command: redis-server --requirepass ${REDIS_PASSWORD} --maxmemory 2gb --maxmemory-policy allkeys-lru
```

---

## Security Checklist

- [ ] Changed all default passwords in `.env`
- [ ] Generated strong JWT secret key
- [ ] Configured CORS domains properly
- [ ] Enabled SSL/TLS for production
- [ ] Configured firewall rules
- [ ] Set up monitoring and alerting
- [ ] Regular backup schedule configured
- [ ] Log rotation enabled
- [ ] Security headers configured
- [ ] Rate limiting implemented

---

## Support

For issues and questions:
- **GitHub Issues**: https://github.com/tnqbao/gauas-cloud-stack/issues
- **Website**: https://gauas.online
- **Live Demo**: https://cloud.gauas.online

---

## License

Copyright © 2026 Gauas Cloud Stack. All rights reserved.

