#!/bin/bash

# Configuración de variables
YOUTUBE_KEY="${YOUTUBE_KEY:-your-youtube-key}"
VIDEO_FILE="${VIDEO_FILE:-rickroll.mp4}"
SERVER_PORT="${PORT:-8080}"

# Instalar dependencias
apt-get update && apt-get install -y ffmpeg nginx

# Configurar nginx para el chequeo de salud de Koyeb
mkdir -p /var/www/html
echo "Stream is running." > /var/www/html/index.html

cat > /etc/nginx/sites-available/default << EOF
server {
    listen $SERVER_PORT default_server;
    root /var/www/html;
}
EOF

# Iniciar nginx en segundo plano para mantener el servicio web activo
nginx -g 'daemon off;' &

# Iniciar la transmisión a YouTube en primer plano, leyendo el archivo directamente
ffmpeg -re -stream_loop -1 -i "$VIDEO_FILE" \
    -c:v libx264 -preset veryfast -crf 23 -maxrate 2500k -bufsize 5000k -g 50 \
    -c:a aac -b:a 128k -ar 44100 -strict experimental \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY"