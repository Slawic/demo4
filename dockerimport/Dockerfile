# Pull base image : 8
FROM amazoncorretto:8
COPY eschool.jar eschool.jar
COPY application.properties application.properties
EXPOSE 8080
CMD ["java", "-jar", "eschool.jar"]