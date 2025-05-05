# Use a specific image version to avoid rate limiting issues
FROM node:16.20-alpine3.18 AS frontend-build

# Set working directory for frontend
WORKDIR /frontend-build
# Copy frontend files
COPY multaqa-frontend-main/multaqa-frontend-main/ ./
# Install and build frontend
RUN npm install
RUN npm run build

FROM node:16.20-alpine3.18

# Set up backend
WORKDIR /app
# Copy backend files
COPY multaqa-backend-main/multaqa-backend-main/ ./
# Install dependencies
RUN npm install

# Copy built frontend from previous stage
COPY --from=frontend-build /frontend-build/build ./public

# Create a complete server.js file to serve both API and frontend
RUN echo 'const express = require("express");' > server.js
RUN echo 'const path = require("path");' >> server.js
RUN echo 'const cors = require("cors");' >> server.js
RUN echo 'const app = express();' >> server.js
RUN echo 'const PORT = process.env.PORT || 8080;' >> server.js
RUN echo 'app.use(cors());' >> server.js
RUN echo 'app.use(express.json());' >> server.js
RUN echo 'app.use(express.static("public"));' >> server.js
RUN echo 'app.get("/api/health", (req, res) => {' >> server.js
RUN echo '  res.json({ status: "ok" });' >> server.js
RUN echo '});' >> server.js
RUN echo 'app.get("/api", (req, res) => {' >> server.js
RUN echo '  res.json({ message: "Multaqa API is running" });' >> server.js
RUN echo '});' >> server.js
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

# Start server with our server file
CMD ["node", "server.js"]
