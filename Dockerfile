# Use a single stage build to reduce complexity
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Copy frontend package.json
COPY multaqa-frontend-main/multaqa-frontend-main/package*.json ./frontend/

# Copy backend package.json
COPY multaqa-backend-main/multaqa-backend-main/package*.json ./backend/

# Install frontend dependencies
WORKDIR /app/frontend
RUN npm install --no-optional || (sleep 5 && npm install --no-optional)

# Install backend dependencies
WORKDIR /app/backend
RUN npm install --no-optional || (sleep 5 && npm install --no-optional)

# Copy frontend files and build
WORKDIR /app/frontend
COPY multaqa-frontend-main/multaqa-frontend-main/ ./
RUN npm run build

# Copy backend files
WORKDIR /app/backend
COPY multaqa-backend-main/multaqa-backend-main/ ./

# Create public directory and copy frontend build
RUN mkdir -p public
RUN cp -r /app/frontend/build/* ./public/

# Install additional packages
RUN npm install express mongoose cors dotenv jsonwebtoken bcryptjs path --save

# Add code to serve static files
RUN echo 'const path = require("path");' >> index.js
RUN echo 'app.use(express.static("public"));' >> index.js
RUN echo 'app.get("*", (req, res, next) => {' >> index.js
RUN echo '  if (req.path.startsWith("/api")) return next();' >> index.js
RUN echo '  res.sendFile(path.join(__dirname, "public", "index.html"));' >> index.js
RUN echo '});' >> index.js

# Set environment variables
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV PORT=8080
ENV JWT_SECRET="multaqa-secret-key"
ENV NODE_ENV=production

# Expose port
EXPOSE 8080

# Start server
CMD ["node", "index.js"]
