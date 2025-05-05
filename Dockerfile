FROM node:16-alpine

# Set working directory for the whole container
WORKDIR /app

# Copy the backend files to the container
COPY multaqa-backend-main/ ./

# Install dependencies 
RUN npm install

# Expose the port the app runs on
EXPOSE 5000

# Start the server
CMD ["npm", "start"]
