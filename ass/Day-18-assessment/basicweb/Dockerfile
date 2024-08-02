# Use the official Nginx image from Docker Hub
FROM nginx:latest

# Install net-tools (includes netstat) or iproute2 (includes ss)
RUN apt-get update && apt-get install -y net-tools iproute2

# Copy the static website files to the Nginx web root
COPY ./index.html /usr/share/nginx/html/
COPY ./styles.css /usr/share/nginx/html/
COPY ./scene.jpeg /usr/share/nginx/html/
COPY ./script.js /usr/share/nginx/html/

# Expose port 8081
EXPOSE 8081

