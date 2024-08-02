# Use the official Apache HTTP Server image from Docker Hub
FROM httpd:latest

# Copy the static website files to the Apache web root
COPY ./index.html /usr/local/apache2/htdocs/
COPY ./styles.css /usr/local/apache2/htdocs/
COPY ./scene.jpeg /usr/local/apache2/htdocs/
COPY ./script.js /usr/local/apache2/htdocs/

# Expose port 80
EXPOSE 80

