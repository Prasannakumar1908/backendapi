# Build Stage
FROM openjdk:17-jdk-slim AS build

# Install Maven
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://archive.apache.org/dist/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz && \
    tar -xzf apache-maven-3.8.8-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.8/bin/mvn /usr/bin/mvn && \
    rm apache-maven-3.8.8-bin.tar.gz

WORKDIR /app
COPY myapp/pom.xml .
COPY myapp/src ./src


RUN mvn clean package -DskipTests


FROM openjdk:17-jdk-slim
WORKDIR /app


COPY --from=build /app/target/myapp.jar /app/myapp.jar

EXPOSE 8080
CMD ["java", "-jar", "/app/myapp.jar"]
