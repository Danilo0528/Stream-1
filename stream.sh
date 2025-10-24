#!/bin/bash

# Configuración de variables
YOUTUBE_KEY="${YOUTUBE_KEY:-your-youtube-code}"
VIDEO_FILE="215407_small.mp4"
AUDIO_FILE="light-thunder.mp3"

# Instalar dependencias necesarias
apt-get update && apt-get install -y ffmpeg

# Iniciar la transmisión a YouTube
ffmpeg -re -stream_loop -1 -i "$VIDEO_FILE" \
    -stream_loop -1 -i "$AUDIO_FILE" \
    -map 0:v:0 -map 1:a:0 \
    -c:v copy \
    -c:a aac -b:a 128k -ar 44100 \
    -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_KEY"