# Use a specific image version to avoid rate limiting issues
FROM node:16.20-alpine3.18

# Set up backend only first to keep it simple
WORKDIR /app

# Copy backend files
COPY multaqa-backend-main/multaqa-backend-main/ ./

# Install dependencies
RUN npm install

# Create basic health check endpoint
RUN echo 'const express = require("express");' > health.js
RUN echo 'const router = express.Router();' >> health.js
RUN echo 'router.get("/health", (req, res) => { res.json({ status: "ok" }); });' >> health.js
RUN echo 'router.get("/", (req, res) => { res.json({ message: "Multaqa API is running" }); });' >> health.js
RUN echo 'module.exports = router;' >> health.js

# Add health routes to index.js
RUN echo 'const healthRoutes = require("./health");' >> index.js
RUN echo 'app.use("/", healthRoutes);' >> index.js
RUN echo 'app.use("/api", healthRoutes);' >> index.js

# Set environment variables
ENV PORT=8080
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV JWT_SECRET="multaqa-secret-key"

# Expose port
EXPOSE 8080

# Start server
CMD ["npm", "start"]
