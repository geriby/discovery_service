# Етап 1: Збірка JAR-файлу за допомогою Maven
FROM maven:3.9.2-eclipse-temurin-17 as builder

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо pom.xml і завантажуємо залежності
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Копіюємо весь код
COPY src ./src

# Виконуємо збірку JAR-файлу
RUN mvn clean package -DskipTests

# Етап 2: Запуск Spring Boot додатку
FROM eclipse-temurin:17-jdk

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо JAR з першого етапу
COPY --from=builder /app/target/*.jar app.jar

# Виставляємо порт для сервісу
EXPOSE 8761

# Команда для запуску додатку
ENTRYPOINT ["java", "-jar", "app.jar"]
