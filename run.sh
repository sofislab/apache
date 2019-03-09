#!/bin/bash

    if [ -z "$TIMEZONE" ]; then
echo "···································································································"
echo "VARIABLE TIMEZONE NO SETEADA - INICIANDO CON VALORES POR DEFECTO"
echo "POSIBLES VALORES: America/Montevideo | America/El_Salvador"
echo "···································································································"
else
echo "···································································································"
echo "TIMEZONE SETEADO ENCONTRADO: " $TIMEZONE
echo "···································································································"
echo "SETENADO TIMEZONE"
cat /usr/share/zoneinfo/$TIMEZONE >> /etc/localtime && echo $TIMEZONE > /etc/timezone
if [ $? -eq 0 ]; then
echo "···································································································"
echo "TIMEZONE SETEADO CORRECTAMENTE"
echo "···································································································"
else

echo "···································································································"
echo "ERROR AL SETEAR EL TIMEZONE - SALIENDO"
echo "···································································································"
exit 1
fi
fi
echo "INICIANDO EL SERVICIO APACHE...."
exec "$@"
