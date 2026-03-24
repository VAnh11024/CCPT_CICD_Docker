# Giai đoạn 1: Build (Sử dụng JDK 25 để khớp với project của bạn)
FROM maven:3.9.11-eclipse-temurin-25 AS builder
WORKDIR /app

# Bước này giúp Docker cache lại các thư viện, lần sau build sẽ cực nhanh
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy toàn bộ code và tiến hành đóng gói file .jar
COPY . .
RUN mvn package -DskipTests

# Giai đoạn 2: Run (Sử dụng JRE 25 siêu nhẹ để chạy ứng dụng)
FROM eclipse-temurin:25-jre-jammy
WORKDIR /app

# Copy file jar từ giai đoạn builder sang
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]