#!/bin/bash

# Configuración de variables
YOUTUBE_KEY="${YOUTUBE_KEY:-your-youtube-code}"
VIDEO_FILE="215407_small.mp4"
AUDIO_FILE="light-thunder.mp3"
SERVER_PORT="${PORT:-8080}"

# Instalar dependencias
apt-get update && apt-get install -y ffmpeg nginx

# Configurar nginx
mkdir -p /var/www/html
echo "Stream is running." > /var/www/html/index.html

cat > /etc/nginx/sites-available/default << EOF
server {
    listen $SERVER_PORT default_server;
    listen [::]:$SERVER_PORT default_server;
    root /var/www/html;
}
EOF

# Iniciar nginx en segundo plano
nginx -g 'daemon off;' &

# Iniciar la transmisión a YouTube en primer plano
ffmpeg -re -stream_loop -1 -i "$VIDEO_FILE" \
    -stream_loop -1 -i "$AUDIO_FILE" \
    -map 0:v:0 -map 1:a:0 \
    -c:v copy \
    -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY"
