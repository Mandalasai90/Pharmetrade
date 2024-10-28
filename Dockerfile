# Stage 1: Build the application
FROM node:18 as build

# Set the working directory
WORKDIR /app

# Set proxy if required
ARG HTTP_PROXY
ARG HTTPS_PROXY
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Configure npm proxy if necessary
RUN npm config set proxy ${HTTP_PROXY} && \
    npm config set https-proxy ${HTTPS_PROXY}

# Install dependencies
RUN npm install

# Copy all project files to the working directory
COPY . .

# Build the application for production
RUN npm run build

# Stage 2: Serve the production build
FROM node:18 as production

# Set the working directory
WORKDIR /app

# Install a lightweight HTTP server to serve the static files
RUN npm install -g serve

# Copy only the built files from the build stage
COPY --from=build /app/dist ./dist

# Expose the port
EXPOSE 5173

# Command to serve the files
CMD ["serve", "-s", "dist", "-l", "5173"]
