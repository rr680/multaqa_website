FROM node:16-alpine AS frontend-build

# Set working directory for frontend
WORKDIR /frontend-build
# Copy frontend files
COPY multaqa-frontend-main/multaqa-frontend-main/ ./
# Install and build frontend
RUN npm install
RUN npm run build

FROM node:16-alpine

# Set working directory for backend
WORKDIR /app
# Copy backend package files and install dependencies
COPY multaqa-backend-main/multaqa-backend-main/package*.json ./
RUN npm install --no-optional

# Copy backend files
COPY multaqa-backend-main/multaqa-backend-main/ ./

# Copy built frontend from previous stage
COPY --from=frontend-build /frontend-build/build ./public

# Install additional required packages
RUN npm install express mongoose cors dotenv jsonwebtoken bcryptjs path --save

# Configure server to serve frontend and API
RUN echo 'const path = require("path");' >> index.js
RUN echo 'app.use(express.static("public"));' >> index.js
RUN echo 'app.get("*", (req, res) => {' >> index.js
RUN echo '  if (req.path.startsWith("/api")) return next();' >> index.js
RUN echo '  res.sendFile(path.join(__dirname, "public", "index.html"));' >> index.js
RUN echo '});' >> index.js

# Set environment variables
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV PORT=8080
ENV JWT_SECRET="multaqa-secret-key"
ENV NODE_ENV=production

# Expose the port
EXPOSE 8080

# Start the server
CMD ["node", "index.js"]
