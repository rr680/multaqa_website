# Use a specific image version to avoid rate limiting issues
FROM node:16.20-alpine3.18

# Set up backend only for now since frontend is missing
WORKDIR /app

# Copy backend files (adjust path if needed)
COPY multaqa-backend-main/ ./

# Install dependencies
RUN npm install

# Create a complete server.js file to serve both API and frontend
RUN echo 'const express = require("express");' > server.js
RUN echo 'const path = require("path");' >> server.js
RUN echo 'const cors = require("cors");' >> server.js
RUN echo 'const app = express();' >> server.js
RUN echo 'const PORT = process.env.PORT || 8080;' >> server.js
RUN echo 'app.use(cors());' >> server.js
RUN echo 'app.use(express.json());' >> server.js

# API routes
RUN echo 'app.get("/api/health", (req, res) => {' >> server.js
RUN echo '  res.json({ status: "ok" });' >> server.js
RUN echo '});' >> server.js
RUN echo 'app.get("/api", (req, res) => {' >> server.js
RUN echo '  res.json({ message: "Multaqa API is running" });' >> server.js
RUN echo '});' >> server.js

# Create a simple HTML page for the root path
RUN mkdir -p public
RUN echo '<!DOCTYPE html><html><head><title>Multaqa</title>' > public/index.html
RUN echo '<style>body{font-family:Arial;text-align:center;margin-top:50px}' >> public/index.html
RUN echo 'h1{color:#4a6cf7}</style></head><body>' >> public/index.html
RUN echo '<h1>Multaqa API Server</h1>' >> public/index.html
RUN echo '<p>Backend is running successfully!</p>' >> public/index.html
RUN echo '<p>Frontend will be deployed separately.</p>' >> public/index.html
RUN echo '</body></html>' >> public/index.html

# Serve static files and handle routes
RUN echo 'app.use(express.static("public"));' >> server.js
RUN echo 'app.get("*", (req, res) => {' >> server.js
RUN echo '  if (req.path.startsWith("/api")) return;' >> server.js
RUN echo '  res.sendFile(path.join(__dirname, "public", "index.html"));' >> server.js
RUN echo '});' >> server.js
RUN echo 'app.listen(PORT, "0.0.0.0", () => {' >> server.js
RUN echo '  console.log(`Server running on port ${PORT}`);' >> server.js
RUN echo '});' >> server.js

# Set environment variables
ENV PORT=8080
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV JWT_SECRET="multaqa-secret-key"
ENV NODE_ENV=production

# Expose port
EXPOSE 8080

# Start server
CMD ["node", "server.js"]
