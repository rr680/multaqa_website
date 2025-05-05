# Use a specific, smaller Node version to reduce image size
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY multaqa-backend-main/multaqa-backend-main/package*.json ./

# Set NODE_OPTIONS to limit memory usage
ENV NODE_OPTIONS="--max-old-space-size=512"

# Install dependencies in smaller chunks to avoid memory issues
RUN npm install --no-optional --production && \
    npm cache clean --force

# Copy application files
COPY multaqa-backend-main/multaqa-backend-main/ ./

# Create a directory for static frontend files
RUN mkdir -p public

# Set environment variables
ENV PORT=8080
ENV NODE_ENV=production

# Expose the port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["node", "index.js"]
