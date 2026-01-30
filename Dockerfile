FROM node:20-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm install --production

# Copy the rest of the application
COPY . .

# Ensure necessary directories exist
RUN mkdir -p db logs public/uploads/videos public/uploads/thumbnails

# Set environment variables
ENV PORT=7575
ENV NODE_ENV=production

# Expose the port
EXPOSE 7575

# Start command: generate secret then start app
CMD ["sh", "-c", "npm run generate-secret && npm start"]
