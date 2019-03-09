# APACHE 2.4.38 CENTOS 7

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)


# Funcionalidades:

  - Permite definir la zona horaria al iniciar el servicio
  - Non-root container

### Iniciar


Ejecutar para iniciar el servicio

```sh
$ docker run -d -e TIMEZONE=America/Montevideo  -V apache_data:/opt/apache/htdocs mvilche/apache:2.4.38-centos7
```
Eliga el tag según el sistema operativo desead

### Variables


| Variable | Detalle |
| ------ | ------ |
| TIMEZONE | Define la zona horaria a utilizar (America/Montevideo, America/El_salvador) |

License
----

Martin vilche
