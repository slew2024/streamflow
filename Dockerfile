FROM node:20-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install --production

# Copy seluruh source code
COPY . .

# --- PERBAIKAN KRUSIAL UNTUK RENDER ---
# Pindahkan logika database ke luar folder 'db' agar tidak tertutup saat Mounting Disk
RUN mv db/database.js ./database_logic.js

# Update referensi di kode agar mengarah ke lokasi baru
RUN sed -i "s|require('../db/database')|require('../database_logic.js')|g" models/User.js
RUN sed -i "s|require('./db/database')|require('./database_logic.js')|g" app.js

# Pastikan folder database & logs ada
RUN mkdir -p db logs public/uploads/videos public/uploads/thumbnails && \
    chmod -R 777 db logs public/uploads

ENV PORT=7575
ENV NODE_ENV=production
EXPOSE 7575

# Jalankan aplikasi
CMD ["sh", "-c", "npm run generate-secret && node app.js"]
