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

10. Al ejecutar la coneccion ssh del paso nueve le decimos que si ( 'yes' ) y listo, estamos dentro de openwrt.
11. Una vez dentro, cambiemos la contrasenia default de la raspberry con el siguiente comando: passwd, y luego creamos nuestra nueva contrasenia.
12. luego nos vamos a la siguiente ruta: cd /etc/config
13. Los documentos importantes de configuracion son los siguientes: 'firewall', 'wireless' y 'network' asi que hacemos un backup de los tres ejecutando los siguientes comandos(por si la cagamos en la configuracion siempre es buena idea hacer un bk de los documentos originales que empezaremos a modificar):
    - cd firewall firewall.bk
    - cd wireless wireless.bk
    - cd wireless network.bk
14. Ahora hay que cambiar la ip de la raspberry porque 192.168.1.1 es el mas comun en los router y pues eso lo hace mas facil de hackear al parecer, abrimos el archivo 'network' ejecutando:
    - vi network
15. Vamos a modificar las lineas:
    ```bash
    config interface 'lan'
        option device 'br-lan'
        option proto 'static'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
        option ip6assign '60'
    ```
    #por lo siguiente:
```bash
    config interface 'lan'
        option device 'br-lan'
        option proto 'static'
        option ipaddr '10.10.***.***'
        option netmask '255.255.255.0'
        option ip6assign '60'
        option force_link '1'
   ```
NOTA: en la opcion: option ipaddr '10.10.***.***' sustituye los *** por cualquier numero, pero si es importante que inicie con 10.10... porque si no no te deja configurar cosas como smart tv porque dice que estas en una red publica, creo que los 198... los 10.10... son ip para redes privadas.

17. Luego agregamos las siguientes lineas al final del archivo network:
    ```bash
    config interface 'wwan'
        option proto 'dhcp'
        option peerdns '0'
        option dns '1.1.1.1 8.8.8.8'
    ```

    y listo!
19. Ahora abrimos el archivo firewall con:  vi firewall
20. Modificamos las siguientes lineas de la siguiente manera:
   ```bash
   config zone
        option name             wan
        list   network          'wan'
        list   network          'wan6'
        option input            REJECT
        option output           ACCEPT
        option forward          REJECT
        option masq             1
        option mtu_fix          1
   ```

   LAS MODIFICAMOS POR:
```bash
    config zone
        option name             wan
        list   network          'wan'
        list   network          'wan6'
        option input            ACCEPT
        option output           ACCEPT
        option forward          REJECT
        option masq             1
        option mtu_fix          1
   ```
   ESTO PARA QUE NO NOS BLOQUE LAS ENTRADAS DE RED, ES DECIR QUE NOS DEJE CONECTARNOS AL MODEM FUENTE.

22. luego ejecutamos el comando ' reboot ' y esperamos un poco en lo que se reinicia la raspberry pi.
23. Una vez reiniciada, para poder conectarnos de nuevo hay que ir a panel de control y lo que habiamos modificado de la ipv4, hay que ponerla como automatica otra vez, como estaba al inicio.
24. ahora conectarnos de nuevo, haremos una coneccion ssh pero a la nueva ip que configuramos:
   - ssh root@10.10.***.***
25. Insertamos la contrasenia root que configuramos en unos pasos anteriores y listo, estamos de nuevo dentro en la raspberry pi.
26. Una vez que estemos loggeados de nuevo, nos vamos a modificar el archivo:
```bash
vi /etc/config/wireless
```
27. Modificamos el contenido de ese archivo para que quede de la siguiente manera:
```bash
config wifi-device 'radio0'
        option type 'mac80211'
        option path 'platform/soc/fe300000.mmcnr/mmc_host/mmc1/mmc1:0001/mmc1:0001:1'
        option channel '7'
        option band '11g'
        option htmode 'HT20'
        option disabled '0'
        option short_gi_40 '0'

config wifi-iface 'default_radio0'
        option device 'radio0'
        option network 'lan'
        option mode 'ap'
        option ssid 'OpenWrt'
        option encryption 'none'
```
Guardamos el archivo ( con los comandos ESC seguido de :wq y ENTER)
28. Ahora una vez actualizado el archivo ejecutamos desde la linea de comandos los siguientes comandos para actualizar la configuracion wireless:
```bash
uci commit wireless
wifi
```
29.  Hasta este punto si se hizo todo bien ya debe aparecer una red sin contrasenia ni nada llamada 'OpenWrt', basicamente habilitamos la red rad0, pero esa la vamos a usar para conectarse a la fuente de internet wifi,  la antena externa que compramos es
    la que haremos que emita nuestro portal cautivo. Ahora vamos a conectarnos a la fuente wifi y para esto lo mas facil es irse a la interface grafica, estando conectados a la red que emite la raspberry por wifi o por ethernet, metemos en el explorador la ip que le configuramos a la raspberry, en este caso 10.10.***.***, nos aparecera una ventana para logg in, metemos solo la contrasena que le configuramos a la raspberry pi y listo:
![Inicio de sesion](./img/1.png)
30. Despues de esos pasos ya estamos dentro del menu, es un menu como el de cualquier modem, y nos vamos a la siguiente ruta en los menus: Network/Wireless/
    ![Configuracion de Wireless](./img/2.png)
    en la ruta veremos lo siguiente, y damos clic en 'scan' para conectar 'rad0'
    ![Scanear las redes disponibles](./img/3.png)

31. Seguimos los siguientes pasos para configurar la red 'client', no creo que sea necesario detallar mas en cada paso:
        ![1](./img/4.png)
        ![2](./img/5.png)
        ![3](./img/6.png)
        ![4](./img/7.png)
        ![5](./img/8.png)
        ![6](./img/9.png)

32. Si seguimos bien los pasos anteriores ya configuramos el cliente, BASICAMENTE ESTOS PASOS QUE HICIMOS CON LA INTERFACE GRAFICA SON LOS PASOS QUE TENEMOS QUE HACER PARA CADA VEZ QUE QUERAMOS CONECTAR EL ROUTER A UNA NUEVA RED, ES DECIR TENEMOS QUE CONECTAR AL NUEVO CLIENTE, BUSCAMOS LA RED, ACTIVAMOS LA CHECK BOX PARA QUE REEMPLACE LA CONFIGURACION DEL CLIENTE ANTERIOR Y PONEMOS LA CONTRASENA Y FINALMENTE GUARDAMOS Y LISTO. Incluso podemos hacer una prueba de conexion por ejemplo ejecutando el comando 'ping google.com'         ![6](./img/10.png)
33. Los siguientes pasos ahora es configurar la re trasnmision de la red por la antena que compramos, yo ya probe con dos diferentes antenas que compre por amazon pero antes de comprar una antena hay que buscar en internet por antenas wifi compatibles con raspberry pi, si no habra problemas de drivers y no va a jalar, eso ya investiguen cual antena venden en mexico y es compatible, normalmente las baratas chinas jalan bien jaja, probe con tp-link y no jalo.
34. Antes de conectar la antena hay que actualizar los paquetes de la raspberry pi, ejecutando el siguiente comando(si no descarga los paquetes actualizados reinicia el raspberry con 'reboot' y despues lo vuelves a intentar):
```bash
opkg update
```
35. Y ahora instalamos los drivers de antenas wifi comunes:
    ```bash
    opkg install kmod-rt2800-lib kmod-rt2800-usb kmod-rt2x00-lib kmod-rt2x00-usb kmod-usb-core kmod-usb-uhci kmod-usb-ohci kmod-usb2 usbutils openvpn-openssl luci-app-openvpn nano
    ```
36. Ahora si podemos conectar la antena usb pero antes ejecuta el siguiente comando para ver la lista de los dispositivos que tienes conectados via usb, y para ver cual aparece nuevo una vez conectada la antena, eso te dara una idea de que driver necesitas en caso de que no te hayan funcionado los drivers en el paso anterior. El comando es 'lsusb'. Por ejemplo en mi caso ese comando anterior no me funciono, pero yo se que el driver que necesito es un realtek por lo siguiente:
    ![6](./img/realtek.png)
38. Para comenzar a buscar entre los drivers ejecutamos el comando
```bash
 opkg list | grep Realtek
```
39. Y con este comando instalariamos todos los paquetes que salgan filtrados con la palabra Realtek(por flojera de no investigar cual especificamente sirve):
```bash
opkg list | grep Realtek | awk '{print $1}' | xargs opkg install
```
y tambien intenta con 
```bash
opkg list | grep RealTek | awk '{print $1}' | xargs opkg install
```
40. 
