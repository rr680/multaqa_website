FROM node:16-alpine

WORKDIR /app

# Copy backend files
COPY multaqa-backend-main/ ./

# Install dependencies
RUN npm install

# Start the server
CMD ["npm", "start"]

# Expose the port the app runs on
EXPOSE 5000
