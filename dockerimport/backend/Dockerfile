# Pull base image : 8
FROM amazoncorretto:8
RUN \
# Update
yum update -y
COPY ./backend/eschool.jar eschool.jar

COPY ./backend/application.properties application.properties
WORKDIR ./app
EXPOSE 8080
CMD ["java", "-jar", "eschool.jar", "application.properties"]
