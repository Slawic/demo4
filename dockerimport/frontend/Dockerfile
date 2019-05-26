# Pull base image : latest
FROM nginx:latest
COPY ./frontend/eschool/ /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80

