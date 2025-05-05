FROM node:16-alpine

# Install nginx
RUN apk add --update nginx

# Set working directory
WORKDIR /app

# Install Node dependencies
RUN npm init -y && npm install express cors

# Create a simple HTML frontend
RUN mkdir -p /usr/share/nginx/html
RUN echo '<!DOCTYPE html>' > /usr/share/nginx/html/index.html
RUN echo '<html lang="en">' >> /usr/share/nginx/html/index.html
RUN echo '<head>' >> /usr/share/nginx/html/index.html
RUN echo '  <meta charset="UTF-8">' >> /usr/share/nginx/html/index.html
RUN echo '  <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> /usr/share/nginx/html/index.html
RUN echo '  <title>Multaqa</title>' >> /usr/share/nginx/html/index.html
RUN echo '  <style>' >> /usr/share/nginx/html/index.html
RUN echo '    body { font-family: Arial, sans-serif; margin: 0; padding: 0; }' >> /usr/share/nginx/html/index.html
RUN echo '    header { background-color: #4a6cf7; color: white; padding: 20px; text-align: center; }' >> /usr/share/nginx/html/index.html
RUN echo '    main { margin: 20px; }' >> /usr/share/nginx/html/index.html
RUN echo '    .card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin: 15px 0; }' >> /usr/share/nginx/html/index.html
RUN echo '    button { background-color: #4a6cf7; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; }' >> /usr/share/nginx/html/index.html
RUN echo '  </style>' >> /usr/share/nginx/html/index.html
RUN echo '</head>' >> /usr/share/nginx/html/index.html
RUN echo '<body>' >> /usr/share/nginx/html/index.html
RUN echo '  <header>' >> /usr/share/nginx/html/index.html
RUN echo '    <h1>Multaqa Platform</h1>' >> /usr/share/nginx/html/index.html
RUN echo '  </header>' >> /usr/share/nginx/html/index.html
RUN echo '  <main>' >> /usr/share/nginx/html/index.html
RUN echo '    <div class="card">' >> /usr/share/nginx/html/index.html
RUN echo '      <h2>Welcome to Multaqa</h2>' >> /usr/share/nginx/html/index.html
RUN echo '      <p>This is a simple placeholder for the Multaqa event management platform.</p>' >> /usr/share/nginx/html/index.html
RUN echo '      <p><button id="checkApi">Check API Status</button></p>' >> /usr/share/nginx/html/index.html
RUN echo '      <p id="apiStatus"></p>' >> /usr/share/nginx/html/index.html
RUN echo '    </div>' >> /usr/share/nginx/html/index.html
RUN echo '  </main>' >> /usr/share/nginx/html/index.html
RUN echo '  <script>' >> /usr/share/nginx/html/index.html
RUN echo '    document.getElementById("checkApi").addEventListener("click", async () => {' >> /usr/share/nginx/html/index.html
RUN echo '      const statusElement = document.getElementById("apiStatus");' >> /usr/share/nginx/html/index.html
RUN echo '      statusElement.textContent = "Checking API...";' >> /usr/share/nginx/html/index.html
RUN echo '      try {' >> /usr/share/nginx/html/index.html
RUN echo '        const response = await fetch("/api");' >> /usr/share/nginx/html/index.html
RUN echo '        const data = await response.json();' >> /usr/share/nginx/html/index.html
RUN echo '        statusElement.textContent = `API Response: ${data.message}`;' >> /usr/share/nginx/html/index.html
RUN echo '      } catch (error) {' >> /usr/share/nginx/html/index.html
RUN echo '        statusElement.textContent = `Error: ${error.message}`;' >> /usr/share/nginx/html/index.html
RUN echo '      }' >> /usr/share/nginx/html/index.html
RUN echo '    });' >> /usr/share/nginx/html/index.html
RUN echo '  </script>' >> /usr/share/nginx/html/index.html
RUN echo '</body>' >> /usr/share/nginx/html/index.html
RUN echo '</html>' >> /usr/share/nginx/html/index.html

# Copy nginx config
COPY nginx.conf /etc/nginx/http.d/default.conf

# Create API server
RUN echo 'const express = require("express");' > api.js
RUN echo 'const cors = require("cors");' >> api.js
RUN echo 'const app = express();' >> api.js
RUN echo 'const port = 3000;' >> api.js
RUN echo 'app.use(cors());' >> api.js
RUN echo 'app.use(express.json());' >> api.js
RUN echo 'app.get("/", (req, res) => {' >> api.js
RUN echo '  res.json({ message: "Multaqa API is running" });' >> api.js
RUN echo '});' >> api.js
RUN echo 'app.listen(port, "127.0.0.1", () => {' >> api.js
RUN echo '  console.log(`API server running at http://localhost:${port}`);' >> api.js
RUN echo '});' >> api.js

# Create a start script
RUN echo '#!/bin/sh' > start.sh
RUN echo 'node api.js &' >> start.sh
RUN echo 'nginx -g "daemon off;"' >> start.sh
RUN chmod +x start.sh

# Expose port 8080
EXPOSE 8080

# Start both servers
CMD ["./start.sh"]
