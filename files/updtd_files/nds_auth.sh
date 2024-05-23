#!/bin/sh

METHOD="$1"
MAC="$2"

# Ruta al archivo donde se guardarán los datos
DATA_FILE="/etc/user_data.txt"
MAX_SIZE=5242880  # 5 MB en bytes

# Función para comprobar y borrar el archivo si excede el tamaño máximo
check_file_size() {
  if [ -f "$DATA_FILE" ]; then
    FILE_SIZE=$(stat -c%s "$DATA_FILE")
    if [ "$FILE_SIZE" -ge "$MAX_SIZE" ]; then
      rm "$DATA_FILE"
    fi
  fi
}


case "$METHOD" in
  auth_client)
    USERNAME="$3"
    PASSWORD="$4"
   
    if true; then
      # Permite al cliente acceder a Internet durante una hora (3600 segundos)
      # Los siguientes valores son límites de carga y descarga en bytes. 0 para ningún límite.
      echo 3600 0 0
            check_file_size

      # Crear el JSON y guardarlo en el archivo
      JSON_DATA=$(cat <<EOF
{
  "nombre": "$USERNAME"
  "whatsapp": "$PASSWORD"
}
EOF
)
      echo "$JSON_DATA" >> "$DATA_FILE"

      echo 3600 0 0
      exit 0
    else
      # Niega al cliente el acceso a Internet.
      exit 1
    fi
    ;;
  client_auth|client_deauth|idle_deauth|timeout_deauth|ndsctl_auth|ndsctl_deauth|shutdown_deauth)
    INGOING_BYTES="$3"
    OUTGOING_BYTES="$4"
    SESSION_START="$5"
    SESSION_END="$6"
    # client_auth: Cliente autenticado a través de este script.
    # client_deauth: Cliente desautenticado por el cliente a través de la página de inicio de sesión.
    # idle_deauth: Cliente desautenticado debido a la inactividad.
    # timeout_deauth: Cliente desautenticado porque la sesión expiró.
    # ndsctl_auth: Cliente autenticado por la herramienta ndsctl.
    # ndsctl_deauth: Cliente desautenticado por la herramienta ndsctl.
    # shutdown_deauth: Cliente desautenticado por Nodogsplash que termina.
    ;;
esac

echo "Nombre: $USERNAME" >> /etc/form_output.txt
echo "WhatsApp: $PASSWORD" >> /etc/form_output.txt

