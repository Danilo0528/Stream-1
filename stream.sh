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
# Usamos -preset ultrafast y un bitrate más bajo para reducir la carga en la CPU y asegurar una transmisión estable.
ffmpeg -re -stream_loop -1 -i "$VIDEO_FILE" \
    -c:v libx264 -preset ultrafast -tune zerolatency -b:v 1000k -maxrate 1000k -bufsize 2000k -g 48 \
    -c:a aac -b:a 96k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY"