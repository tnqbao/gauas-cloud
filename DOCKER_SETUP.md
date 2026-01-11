# Gauas Cloud Stack - Docker Compose Setup

Hệ thống microservices hoàn chỉnh cho Gauas Cloud Platform với Docker Compose.

## 📋 Yêu cầu hệ thống

- Docker Desktop for Windows (hoặc Docker Engine + Docker Compose)
- Minimum 8GB RAM
- 20GB ổ cứng trống
- Windows 10/11 hoặc Linux

## 🏗️ Kiến trúc hệ thống

### Infrastructure Services
- **PostgreSQL 15**: Cơ sở dữ liệu quan hệ
- **Redis 7**: Cache và session storage
- **MinIO**: Object storage (S3-compatible)
- **RabbitMQ 3**: Message queue

### Backend Services
- **gau-authorization-service** (Port 8081): Xác thực và phân quyền
- **gau-cdn-service** (Port 8082): Content Delivery Network
- **gau-cloud-service** (Port 8083): Core cloud management
- **gau-upload-service** (Port 8084): File upload và xử lý

### Frontend
- **gau-cloud-console** (Port 3000): Next.js web console

## 🚀 Hướng dẫn khởi động

### 1. Chuẩn bị môi trường

```powershell
# Clone repository (nếu chưa có)
git clone <repository-url>
cd gauas-cloud-stack

# Copy file cấu hình mẫu
Copy-Item example.env .env

# Chỉnh sửa .env theo nhu cầu (tùy chọn)
notepad .env
```

### 2. Khởi động toàn bộ stack

```powershell
# Khởi động tất cả services
docker-compose --env-file example.env up -d

# Hoặc nếu đã copy sang .env
docker-compose up -d
```

### 3. Khởi động từng phần

#### Chỉ khởi động infrastructure:
```powershell
docker-compose up -d postgres redis minio rabbitmq
```

#### Khởi động backend services:
```powershell
docker-compose up -d gau-authorization-service gau-cdn-service gau-cloud-service gau-upload-service
```

#### Khởi động frontend:
```powershell
docker-compose up -d gau-cloud-console
```

## 📊 Kiểm tra trạng thái

### Xem logs
```powershell
# Xem logs tất cả services
docker-compose logs -f

# Xem logs một service cụ thể
docker-compose logs -f gau-authorization-service
docker-compose logs -f gau-cloud-console

# Xem 100 dòng logs cuối
docker-compose logs --tail=100 -f
```

### Kiểm tra health status
```powershell
# Xem trạng thái containers
docker-compose ps

# Xem chi tiết một container
docker inspect gauas-postgres
```

## 🔗 Truy cập các services

### Frontend
- **Web Console**: http://localhost:3000

### Backend Services
- **Authorization Service**: http://localhost:8081
- **CDN Service**: http://localhost:8082
- **Cloud Service**: http://localhost:8083
- **Upload Service**: http://localhost:8084

### Infrastructure Management UIs
- **MinIO Console**: http://localhost:9001
  - Username: minioadmin
  - Password: minioadmin123
  
- **RabbitMQ Management**: http://localhost:15672
  - Username: gauas_rabbitmq
  - Password: rabbitmq_password_2026

### Database
- **PostgreSQL**: localhost:5432
  - Database: gauas_db
  - Username: gauas_user
  - Password: gauas_password_2026

- **Redis**: localhost:6379
  - Password: redis_password_2026

## 🛠️ Quản lý services

### Dừng services
```powershell
# Dừng tất cả
docker-compose stop

# Dừng một service
docker-compose stop gau-cloud-service
```

### Khởi động lại services
```powershell
# Khởi động lại tất cả
docker-compose restart

# Khởi động lại một service
docker-compose restart gau-authorization-service
```

### Xóa containers (giữ lại data)
```powershell
docker-compose down
```

### Xóa hoàn toàn (bao gồm volumes)
```powershell
docker-compose down -v
```

## 🔧 Rebuild services

```powershell
# Rebuild tất cả
docker-compose build

# Rebuild một service cụ thể
docker-compose build gau-cloud-service

# Rebuild và khởi động lại
docker-compose up -d --build

# Rebuild một service và khởi động lại
docker-compose up -d --build gau-authorization-service
```

## 📝 Cấu hình môi trường

Tất cả biến môi trường được quản lý trong file `example.env`. Các biến quan trọng:

### Security (NÊN THAY ĐỔI TRONG PRODUCTION!)
```env
JWT_SECRET_KEY=your_jwt_secret_key_change_this_in_production
PGPOOL_PASSWORD=gauas_password_2026
REDIS_PASSWORD=redis_password_2026
MINIO_SECRET_KEY=minioadmin123
RABBITMQ_PASSWORD=rabbitmq_password_2026
```

### Service URLs (cho internal communication)
```env
AUTHORIZATION_SERVICE_URL=http://gau-authorization-service:8080
UPLOAD_SERVICE_URL=http://gau-upload-service:8080
```

### Frontend URLs (cho browser)
```env
NEXT_PUBLIC_API_URL=http://localhost:8083
NEXT_PUBLIC_AUTHORIZATION_URL=http://localhost:8081
```

## 🐛 Troubleshooting

### Container không khởi động được
```powershell
# Xem logs chi tiết
docker-compose logs <service-name>

# Kiểm tra health status
docker-compose ps
```

### Port đã được sử dụng
Chỉnh sửa port trong file `.env`:
```env
FRONTEND_PORT=3001
AUTHORIZATION_SERVICE_PORT=8091
```

### Database connection failed
```powershell
# Kiểm tra PostgreSQL đã sẵn sàng chưa
docker-compose exec postgres pg_isready -U gauas_user

# Kết nối vào PostgreSQL
docker-compose exec postgres psql -U gauas_user -d gauas_db
```

### Redis connection failed
```powershell
# Test Redis connection
docker-compose exec redis redis-cli -a redis_password_2026 ping
```

### MinIO connection failed
```powershell
# Kiểm tra MinIO logs
docker-compose logs minio

# Truy cập MinIO console để tạo bucket nếu cần
# http://localhost:9001
```

### RabbitMQ connection failed
```powershell
# Kiểm tra RabbitMQ status
docker-compose exec rabbitmq rabbitmq-diagnostics ping

# Xem queues
docker-compose exec rabbitmq rabbitmqctl list_queues
```

### Service không kết nối được với nhau
Kiểm tra network:
```powershell
# Xem networks
docker network ls

# Inspect network
docker network inspect gauas-cloud-stack_gauas-network
```

## 🔄 Database Migration

```powershell
# Migration sẽ tự động chạy khi container khởi động
# Nếu cần chạy lại migration:

# Authorization Service
docker-compose exec gau-authorization-service ./entrypoint.sh

# Cloud Service  
docker-compose exec gau-cloud-service ./entrypoint.sh
```

## 📦 Backup và Restore

### Backup PostgreSQL
```powershell
docker-compose exec postgres pg_dump -U gauas_user gauas_db > backup_$(Get-Date -Format "yyyyMMdd_HHmmss").sql
```

### Restore PostgreSQL
```powershell
Get-Content backup_20260111_120000.sql | docker-compose exec -T postgres psql -U gauas_user -d gauas_db
```

### Backup MinIO Data
```powershell
docker-compose exec minio mc mirror /data ./minio_backup
```

## 🎯 Production Deployment

Trước khi deploy lên production:

1. **Thay đổi tất cả mật khẩu mặc định** trong `.env`
2. **Enable SSL/TLS** cho các services
3. **Cấu hình firewall** và network policies
4. **Setup monitoring** với Grafana
5. **Cấu hình backup tự động**
6. **Review resource limits** trong docker-compose.yml
7. **Enable logging** và log rotation

## 📚 Thêm thông tin

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)
- [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- [RabbitMQ Documentation](https://www.rabbitmq.com/documentation.html)

## 📄 License

Copyright © 2026 Gauas Cloud Stack

