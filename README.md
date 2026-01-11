# Gauas Cloud Stack

An open-source cloud platform built with microservices architecture, providing infrastructure management, object storage, and compute resources.

## Overview

Gauas Cloud Stack is a self-hosted cloud platform that enables organizations to deploy and manage their own cloud infrastructure. Built with modern technologies and microservices patterns, it offers scalable and reliable cloud services similar to major cloud providers.

**Live Demo**: [cloud.gauas.online](https://cloud.gauas.online)  
**Website**: [gauas.online](https://gauas.online)  
**Author**: [github.com/tnqbao](https://github.com/tnqbao)

## Core Features

- **Object Storage**: S3-compatible storage service powered by MinIO
- **Authentication & Authorization**: JWT-based auth system with role management
- **Content Delivery**: CDN service with caching and image optimization
- **File Management**: Chunked upload with resumable capabilities
- **Infrastructure Management**: Resource provisioning and monitoring
- **Microservices Architecture**: Independently scalable services
- **Container-Ready**: Full Docker and Kubernetes support

## Architecture

### Backend Services (Go)
- **gau-authorization-service**: Authentication, JWT token management, user sessions
- **gau-cdn-service**: Content delivery, image processing, caching layer
- **gau-cloud-service**: Core cloud operations, resource management, IAM
- **gau-upload-service**: File upload handling, chunked transfer, format conversion

### Frontend (Next.js)
- **gau-cloud-console**: Web-based management console with React 19

### Infrastructure
- **PostgreSQL**: Primary database for persistent data
- **Redis**: Cache and session store
- **MinIO**: S3-compatible object storage
- **RabbitMQ**: Message queue for async processing
- **Grafana**: Monitoring and observability (OpenTelemetry)

## Technology Stack

**Backend**
- Go 1.24+
- Gin Web Framework
- GORM (PostgreSQL)
- go-redis
- AWS SDK v2 (S3)
- RabbitMQ AMQP
- OpenTelemetry

**Frontend**
- Next.js 16
- React 19
- TypeScript
- TailwindCSS
- React OAuth

**DevOps**
- Docker & Docker Compose
- Kubernetes (K8s manifests included)
- GitHub Actions (CI/CD ready)

## Quick Start

### Prerequisites
- Docker & Docker Compose
- 8GB RAM minimum
- 20GB disk space

### Installation

```bash
# Clone repository
git clone https://github.com/tnqbao/gauas-cloud-stack.git
cd gauas-cloud-stack

# Configure environment
cp example.env .env

# Start all services
docker-compose up -d
```

### Access

- **Web Console**: http://localhost:3000
- **MinIO Console**: http://localhost:9001
- **RabbitMQ Management**: http://localhost:15672

For detailed setup instructions, see [SETUP.md](./SETUP.md)

## Project Structure

```
gauas-cloud-stack/
├── backend/
│   ├── gau-authorization-service/   # Auth & JWT service
│   ├── gau-cdn-service/             # CDN & caching
│   ├── gau-cloud-service/           # Core cloud service
│   └── gau-upload-service/          # Upload handler
├── frontend/
│   └── gau-cloud-console/           # Web console
├── docker-compose.yml               # Local development stack
├── example.env                      # Environment template
└── SETUP.md                         # Setup guide
```

## Service Ports

| Service | Port | Description |
|---------|------|-------------|
| Frontend | 3000 | Web console |
| Authorization | 8081 | Auth API |
| CDN | 8082 | CDN API |
| Cloud | 8083 | Cloud API |
| Upload | 8084 | Upload API |
| PostgreSQL | 5432 | Database |
| Redis | 6379 | Cache |
| MinIO | 9000 | Object storage |
| MinIO Console | 9001 | MinIO UI |
| RabbitMQ | 5672 | AMQP |
| RabbitMQ UI | 15672 | Management UI |

## Development

### Backend Development
```bash
cd backend/gau-cloud-service
go mod download
go run main.go
```

### Frontend Development
```bash
cd frontend/gau-cloud-console
npm install
npm run dev
```

### Running Tests
```bash
# Backend tests
cd backend/gau-cloud-service
go test ./...

# Frontend tests
cd frontend/gau-cloud-console
npm test
```

## Deployment

### Docker Compose (Development)
```bash
docker-compose up -d
```

### Kubernetes (Production)
```bash
# Each service has K8s manifests in deploy/k8s/
kubectl apply -f backend/gau-cloud-service/deploy/k8s/staging/
```

## Configuration

All services share environment variables from `example.env`:

- **Database**: PostgreSQL connection settings
- **Cache**: Redis configuration
- **Storage**: MinIO credentials and endpoints
- **Queue**: RabbitMQ connection strings
- **Security**: JWT secrets, API keys
- **Monitoring**: Grafana/OTLP endpoints

See [SETUP.md](./SETUP.md) for detailed configuration options.

## Monitoring

Built-in OpenTelemetry integration with:
- Distributed tracing
- Metrics collection
- Structured logging
- Grafana dashboards

## API Documentation

Each service exposes REST APIs:

- Authorization: `/api/v1/auth/*`
- CDN: `/api/v1/cdn/*`
- Cloud: `/api/v1/cloud/*`
- Upload: `/api/v1/upload/*`

API documentation available at each service's README.

## Contributing

Contributions are welcome. Please:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## Security

- Change all default passwords in production
- Use HTTPS/TLS for all services
- Enable firewall rules
- Regular security updates
- Audit logs enabled

## License

Copyright © 2026 Gauas Cloud Stack. All rights reserved.

## Links

- **Live Platform**: [cloud.gauas.online](https://cloud.gauas.online)
- **Website**: [gauas.online](https://gauas.online)
- **GitHub**: [github.com/tnqbao](https://github.com/tnqbao)
- **Issues**: [GitHub Issues](https://github.com/tnqbao/gauas-cloud-stack/issues)

## Support

For questions and support:
- Open an issue on GitHub
- Visit [gauas.online](https://gauas.online)
- Check documentation in [SETUP.md](./SETUP.md)

