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

# Set environment variable for MongoDB
ENV MONGODB_URI="mongodb+srv://your_username:your_password@your_actual_cluster.mongodb.net/multaqa?retryWrites=true&w=majority"

# Expose the port the app is actually running on (8080 not 3000)
EXPOSE 8080

# Start the server with increased logging
CMD ["npm", "start"]
