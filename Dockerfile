FROM ubuntu:22.04

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el script de transmisión y el archivo de video al directorio de trabajo
COPY stream.sh .
COPY rickroll.mp4 .

# Otorga permisos de ejecución al script
RUN chmod +x ./stream.sh

# Ejecuta el script de transmisión cuando el contenedor se inicie
CMD ["./stream.sh"]