FROM node:20-slim

# Install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm install --production

# Copy seluruh source code
COPY . .

# PAKSA copy folder db secara eksplisit (Solusi untuk error MODULE_NOT_FOUND)
COPY db/ ./db/

# Pastikan folder database & logs ada dengan izin yang benar
RUN mkdir -p db logs public/uploads/videos public/uploads/thumbnails && \
    chmod -R 777 db logs public/uploads

# Debug: Pastikan file database.js ada (akan muncul di log build Render)
RUN ls -la db/

ENV PORT=7575
ENV NODE_ENV=production

EXPOSE 7575

# Jalankan aplikasi
CMD ["sh", "-c", "npm run generate-secret && node app.js"]
