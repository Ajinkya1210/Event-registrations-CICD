# Stage 1: Build dependencies
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Stage 2: Final Runtime Environment
FROM node:18-alpine
WORKDIR /app

# Only copy the necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Environment variables (Default placeholders)
# These will be overridden by your Jenkins 'docker run' command
ENV DB_HOST=localhost
ENV DB_USER=postgres
ENV DB_PASSWORD=password
ENV DB_NAME=registration_db

# The port your Node.js app listens on
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]