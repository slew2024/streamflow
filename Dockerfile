FROM node:20-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install --production

# Copy seluruh source code
COPY . .

# --- SOLUSI TUNTAS: Pindahkan database.js ke lokasi aman ---
RUN mv db/database.js ./database_logic.js

# Update SEMUA referensi ke database di seluruh aplikasi
RUN find . -type f -name "*.js" -exec sed -i "s|require('../db/database')|require('../database_logic.js')|g" {} \;
RUN find . -type f -name "*.js" -exec sed -i "s|require('./db/database')|require('./database_logic.js')|g" {} \;
RUN find . -type f -name "*.js" -exec sed -i "s|require('../../db/database')|require('../../database_logic.js')|g" {} \;

# Pastikan folder database & logs ada
RUN mkdir -p db logs public/uploads/videos public/uploads/thumbnails && \
    chmod -R 777 db logs public/uploads

ENV PORT=7575
ENV NODE_ENV=production
EXPOSE 7575

# Jalankan aplikasi
CMD ["sh", "-c", "npm run generate-secret && node app.js"]
