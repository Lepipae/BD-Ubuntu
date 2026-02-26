# BD-Ubuntu

Configuración basada en Docker Compose para montar una base de datos MySQL básica, orientada a la práctica con ejercicios resueltos.

## Requisitos previos

- Docker
- Docker Compose

## Estructura del proyecto

- `docker-compose.yml`: Archivo principal para desplegar el contenedor de MySQL.
- `Scripts/ejercicios/`: Directorio que contiene los scripts de la base de datos y las resoluciones de los ejercicios.

## Instrucciones de uso

#### Clona este repositorio en tu máquina local y enciende el contenedor como demonio:
   ```bash
   git clone [https://github.com/Lepipae/BD-Ubuntu.git](https://github.com/Lepipae/BD-Ubuntu.git)
   cd BD-Ubuntu
   docker-compose up -d
   ```
#### Para conectarte al contenedor:
  ```bash
  docker exec -it BD mysql -u root -p
  ```
#### Para detener el contenedor:
  ```bash
  docker-compose down
  ```
