# Use an official OpenJDK runtime as a parent image
FROM openjdk:11

# Set the working directory in the container
WORKDIR /app

# Copy the Java source file into the container
COPY Simple.java .

# Compile the Java source code
RUN javac Simple.java

# Run the Java application
CMD ["java", "HelloWorld"]
