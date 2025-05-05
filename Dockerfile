FROM node:16-alpine

# Set working directory for the whole container
WORKDIR /app

# Copy package.json and package-lock.json first for better caching
COPY multaqa-backend-main/package*.json ./

# Install dependencies with proper error output
RUN npm install --no-optional && npm cache clean --force

# Copy the rest of the backend files
COPY multaqa-backend-main/ ./

# Install Express explicitly in case it's missing from package.json
RUN npm install express mongoose cors dotenv jsonwebtoken bcryptjs --save

# Create health check route file
RUN echo 'const express = require("express"); \
const router = express.Router(); \
router.get("/health", (req, res) => { \
  res.status(200).json({ status: "ok", message: "API is healthy" }); \
}); \
module.exports = router;' > health.js

# Add health check route to index.js
RUN echo 'const healthRoutes = require("./health"); \
app.use("/api", healthRoutes);' >> index.js

# Set environment variables
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV PORT=8080
ENV JWT_SECRET="multaqa-secret-key"

# Expose the port the app is actually running on
EXPOSE 8080

# Start the server with increased logging
CMD ["npm", "start"]
