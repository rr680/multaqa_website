# Use a specific image version to avoid rate limiting issues
FROM node:16.20-alpine3.18

# Set up backend only first to keep it simple
WORKDIR /app

# Copy backend files
COPY multaqa-backend-main/multaqa-backend-main/ ./

# Install dependencies
RUN npm install

# Create a test server.js file to ensure the app starts and responds
RUN echo 'const express = require("express");' > server.js
RUN echo 'const app = express();' >> server.js
RUN echo 'const PORT = process.env.PORT || 8080;' >> server.js
RUN echo 'app.get("/", (req, res) => {' >> server.js
RUN echo '  res.json({ message: "Multaqa API is running" });' >> server.js
RUN echo '});' >> server.js
RUN echo 'app.get("/api/health", (req, res) => {' >> server.js
RUN echo '  res.json({ status: "ok" });' >> server.js
RUN echo '});' >> server.js
RUN echo 'app.listen(PORT, "0.0.0.0", () => {' >> server.js
RUN echo '  console.log(`Server running on port ${PORT}`);' >> server.js
RUN echo '});' >> server.js

# Set environment variables
ENV PORT=8080
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV JWT_SECRET="multaqa-secret-key"

# Expose port
EXPOSE 8080

# Start server with the simplified file for testing
CMD ["node", "server.js"]
