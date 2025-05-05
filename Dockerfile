# Build stage for React frontend
FROM node:16-alpine AS build-frontend

# Set working directory for frontend
WORKDIR /frontend

# Copy frontend files using the confirmed path
COPY multaqa-frontend-main/ ./

# Install dependencies and build frontend
RUN npm install && \
    npm run build

# Main stage
FROM node:16-alpine

# Install nginx for serving frontend
RUN apk add --update nginx

# Set working directory
WORKDIR /app

# Install Node dependencies for backend
RUN npm init -y && npm install express cors mongoose

# Copy the built frontend from build stage
COPY --from=build-frontend /frontend/build /usr/share/nginx/html

# Copy backend files
COPY multaqa-backend-main/ ./

# Copy nginx config
COPY nginx.conf /etc/nginx/http.d/default.conf

# Create API server that connects to MongoDB
RUN echo 'const express = require("express");' > api.js
RUN echo 'const cors = require("cors");' >> api.js
RUN echo 'const mongoose = require("mongoose");' >> api.js
RUN echo 'const app = express();' >> api.js
RUN echo 'const port = 3000;' >> api.js
RUN echo 'app.use(cors());' >> api.js
RUN echo 'app.use(express.json());' >> api.js
RUN echo '' >> api.js
RUN echo 'mongoose.connect(process.env.MONGODB_URI)' >> api.js
RUN echo '  .then(() => console.log("Connected to MongoDB"))' >> api.js
RUN echo '  .catch(err => console.error("MongoDB connection error:", err));' >> api.js
RUN echo '' >> api.js
RUN echo 'app.get("/", (req, res) => {' >> api.js
RUN echo '  res.json({ message: "Multaqa API is running" });' >> api.js
RUN echo '});' >> api.js
RUN echo '' >> api.js
RUN echo 'app.listen(port, "127.0.0.1", () => {' >> api.js
RUN echo '  console.log(`API server running at http://localhost:${port}`);' >> api.js
RUN echo '});' >> api.js

# Create start script
RUN echo '#!/bin/sh' > start.sh
RUN echo 'node api.js &' >> start.sh
RUN echo 'nginx -g "daemon off;"' >> start.sh
RUN chmod +x start.sh

# Set environment variables
ENV PORT=8080
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV JWT_SECRET="multaqa-secret-key"

# Expose port
EXPOSE 8080

# Start both servers
CMD ["./start.sh"]
