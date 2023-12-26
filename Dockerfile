# Use the official Golang Alpine image as the base image for building the application
FROM golang:alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy only the dependency files to leverage Docker caching for faster builds
COPY go.mod .
COPY go.sum .

# Download and install Go module dependencies
RUN go mod download

# Copy the entire application source code to the container
COPY . .

# Build the Go application and create an executable named "main"
RUN go build -o main ./cmd/main.go

# Start a new stage with a minimal Alpine image to reduce the final image size
FROM alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built executable from the builder stage to the final image
COPY --from=builder /app/main /app/main

# Specify the command to run when the container starts
CMD ["/app/main"]
