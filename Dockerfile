# Этап 1: Сборка приложения с помощью Maven
FROM maven:3.8.7-eclipse-temurin-8 AS build

# Устанавливаем рабочую директорию для сборки
WORKDIR /app

# Копируем файл pom.xml и скачиваем зависимости
COPY pom.xml .

RUN mvn dependency:go-offline

# Копируем исходный код приложения
COPY src ./src

# Выполняем сборку Maven, получаем файл .war
RUN mvn clean package

# Этап 2: Создание образа с Tomcat и нашим приложением
FROM tomcat:8.5-jre8

# Определяем аргумент для контекста веб-приложения

ARG WEBCONTEXT=simplewebappdev

# Копируем собранный файл .war из предыдущего этапа в директорию webapps Tomcat
COPY --from=build /app/target/simplewebapp.war /usr/local/tomcat/webapps/simplewebapp.war

# Открываем порт 8080
EXPOSE 8080

# Запускаем Tomcat в форграундном режиме
CMD ["catalina.sh", "run"]