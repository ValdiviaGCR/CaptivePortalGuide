# CaptivePortalGuide: GUIA PARA ESPECIFICAMENTE HACERLO FUNCIONAR EN RASPBERRY PI 4B

Basicamente segui los pasos del tutorial de youtube:\
https://www.youtube.com/watch?v=jlHWnKVpygw&t=597s
En caso de que el tutorial ya no este en linea lo descargue y lo tengo en mi drive publico:
https://drive.google.com/drive/folders/1Pv3NOzGnVHLNCD1gwwUuR6ygyMyayGDn?usp=sharing

Ese tutorial lo segui porque inicialmente me interesaba un router VPN seguro pero me fue de mas ayuda entender lo que este vato
estaba haciendo para entender bien como configurar openWRT.

## Paso 1:
Instale el software Raspberry Pi Imager de su sition oficial:
https://www.raspberrypi.com/software/

## Paso 2:
Descargue el software de OpenWRT para raspberry pi de su sitio oficial:
https://firmware-selector.openwrt.org/?version=23.05.3&target=bcm27xx%2Fbcm2708&id=rpi
especificamente escogi la imagen FACTORY (SQUASHFS), hay unas descripciones y creo que esa era la mejor.
Una vez que este terminada la instalacion solo sacar la memoria SD y listo.

## Paso 3:
1. Insertar la memoria SD en la raspberry pi
2. Conectar la raspberry pi al puerto ethernet de tu pc
3. Conectar la raspberry pi a alimantacion (cargador USB C)
4. IMPORTANTE: Hasta este punto no conectar la antena wifi externa para no confundirla con la externa, no pasa nada, se puede configurar cualquiera como 'Emisor' y como 'Receptor' pero siguiendo estos pasos ya funciona asi que para que jugarle al chingon.

## Paso 4(En windows):
1. Ir a panel de control
2. Network and internet
3. Network and sharing center
4. Click en 'Ethernet' para abrir la configuracion de la coneccion de ethernet
5. Propiedades, y luego en 'Internet protocol ipV4' o algo asi
6. Luego vamos a modificar a que sea una ip manual 'use the following ip address' y ponemos la siguiente configuracion:
   - IP: 192.168.1.10
   - Subne: 255.255.255.0
   - Gateway: 192.168.1.1
7. Click en ok y en ok para guardar y salir.
8. Abrir el command prompt
9. Ahora ya nos podemos conectar a la raspberry pi por SSH:
  - SSH root@192.168.1.1

### NOTA IMPORTANTE: No me estaba dejando  configurar esta nueva raspberry pi porque ya habia configurado una conexion ssh a la anterior que configure y use esa ip
### la solucion es borrar la configuracion de conexion ssh en el siguiente documento: C:\Users\<your user name>\.ssh , ahi dentro hay un archivo y si ya tienes una coneccion
### ssh con la ip 192.168.1.1 borra esa linea nada mas y listo.

10. Al ejecutar la coneccion ssh del paso nueve le decimos que si ( 'y' ) y listo, estamos dentro de openwrt.
11. Una vez dentro, cambiemos la contrasenia default de la raspberry con el siguiente comando: passwd, y luego creamos nuestra nueva contrasenia.
12. luego nos vamos a la siguiente ruta: cd /etc/config
13. Los documentos importantes de configuracion son los siguientes: 'firewall', 'wireless' y 'network' asi que hacemos un backup de los tres ejecutando los siguientes comandos(por si la cagamos en la configuracion siempre es buena idea hacer un bk de los documentos originales que empezaremos a modificar):
    - cd firewall firewall.bk
    - cd wireless wireless.bk
    - cd wireless network.bk
14. Ahora hay que cambiar la ip de la raspberry porque 192.168.1.1 es el mas comun en los router y pues eso lo hace mas facil de hackear al parecer, abrimos el archivo 'network' ejecutando:
    - vi network
15.

