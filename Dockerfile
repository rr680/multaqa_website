# Use a specific image version
FROM node:16.20-alpine3.18

# Set working directory
WORKDIR /app

# Install dependencies
RUN npm init -y && npm install express cors

# Create a simple HTML frontend
RUN mkdir -p public
RUN echo '<!DOCTYPE html>' > public/index.html
RUN echo '<html lang="en">' >> public/index.html
RUN echo '<head>' >> public/index.html
RUN echo '  <meta charset="UTF-8">' >> public/index.html
RUN echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> public/index.html
RUN echo '  <title>Multaqa</title>' >> public/index.html
RUN echo '  <style>' >> public/index.html
RUN echo '    body { font-family: Arial, sans-serif; margin: 0; padding: 0; }' >> public/index.html
RUN echo '    header { background-color: #4a6cf7; color: white; padding: 20px; text-align: center; }' >> public/index.html
RUN echo '    main { margin: 20px; }' >> public/index.html
RUN echo '    .card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin: 15px 0; }' >> public/index.html
RUN echo '  </style>' >> public/index.html
RUN echo '</head>' >> public/index.html
RUN echo '<body>' >> public/index.html
RUN echo '  <header>' >> public/index.html
RUN echo '    <h1>Multaqa Platform</h1>' >> public/index.html
RUN echo '  </header>' >> public/index.html
RUN echo '  <main>' >> public/index.html
RUN echo '    <div class="card">' >> public/index.html
RUN echo '      <h2>Welcome to Multaqa</h2>' >> public/index.html
RUN echo '      <p>This is a simple placeholder for the Multaqa event management platform.</p>' >> public/index.html
RUN echo '      <p>Backend API is active and running.</p>' >> public/index.html
RUN echo '    </div>' >> public/index.html
RUN echo '  </main>' >> public/index.html
RUN echo '</body>' >> public/index.html
RUN echo '</html>' >> public/index.html

# Create server file that serves static content and API endpoints
RUN echo 'const express = require("express");' > index.js
RUN echo 'const cors = require("cors");' >> index.js
RUN echo 'const path = require("path");' >> index.js
RUN echo 'const app = express();' >> index.js
RUN echo 'const port = process.env.PORT || 8080;' >> index.js
RUN echo '' >> index.js
RUN echo 'app.use(cors());' >> index.js
RUN echo 'app.use(express.json());' >> index.js
RUN echo 'app.use(express.static("public"));' >> index.js
RUN echo '' >> index.js
RUN echo 'app.get("/api/health", (req, res) => {' >> index.js
RUN echo '  res.json({ status: "ok" });' >> index.js
RUN echo '});' >> index.js
RUN echo '' >> index.js
RUN echo 'app.get("/api", (req, res) => {' >> index.js
RUN echo '  res.json({ message: "Multaqa API is running" });' >> index.js
RUN echo '});' >> index.js
RUN echo '' >> index.js
RUN echo 'app.get("*", (req, res) => {' >> index.js
RUN echo '  res.sendFile(path.join(__dirname, "public", "index.html"));' >> index.js
RUN echo '});' >> index.js
RUN echo '' >> index.js
RUN echo 'app.listen(port, "0.0.0.0", () => {' >> index.js
RUN echo '  console.log(`Server listening on port ${port}`);' >> index.js
RUN echo '});' >> index.js

# Expose port
EXPOSE 8080

# Set environment variables
ENV PORT=8080

# Start the server
CMD ["node", "index.js"]
