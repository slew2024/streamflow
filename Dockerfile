FROM node:20-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . .

# Buat folder database & logs
RUN mkdir -p db logs public/uploads/videos public/uploads/thumbnails

ENV PORT=7575
ENV NODE_ENV=production

EXPOSE 7575

# Generate secret otomatis saat container jalan
CMD ["sh", "-c", "npm run generate-secret && npm start"]
