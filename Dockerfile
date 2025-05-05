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

# Set environment variables
ENV MONGODB_URI="mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa"
ENV PORT=8080
ENV JWT_SECRET="multaqa-secret-key"

# Expose the port the app is actually running on
EXPOSE 8080

# Start the server with increased logging
CMD ["npm", "start"]
