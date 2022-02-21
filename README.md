# osm-geoserver-postgis
Docker-compose que ensambla los componentes necesarios para implementar una instancia Geoserver que publica las capas de OpenStreetMap (OSM) de forma local en un único host/máquina (Postgis es requerido para almacenar las capas de OSM).

Se siguen las instrucciones de este proyecto como base [OSM-Styles](https://github.com/geosolutions-it/osm-styles).

## Pasos

Con los scripts que se incluyen en la carpeta hemos simplificado los pasos a seguir para desplegar una solución que incluye un Geoserver publicando las capas de OSM (almacenadas en un Postgis), a través de servicio WMS. 

Esta simplificación está condicionada a que el despliegue se realice especificamente en un mismo host (en el cual se ejecutará el docker-compose que inicializa el sistema). En caso de tener que hacer un despligue en mas de un host, hay que contemplar algunos aspectos técnicos (los mismos que llevar de docker-compose a swarm o a kubernetes).

La idea es mantener el caso de uso simple (debajo esta el diagrama de contenedores y volumenes a crear).

Los pasos son:

1. Instalar [git](https://github.com/git-guides/install-git), [docker](https://docs.docker.com/engine/install/ubuntu/) y [docker-compose](https://docs.docker.com/compose/install/) en la máquina host.

   Ejemplo comandos basado en distribución Ubuntu:

   a. **sudo apt update**

   b. **sudo apt install git**

   c. **sudo apt-get install docker-ce docker-ce-cli containerd.io**

   d. **sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose**

   e. **sudo chmod +x /usr/local/bin/docker-compose**

2. Descargar el repositorio git de este proyecto.

   a. **git clone https://github.com/geotekne/docker-compose-samples.git**

3. Descargar los archivos OSM por país/región del portal de [GeoFabrik](https://download.geofabrik.de/) (archivos extensión PBF) que se deseen importar en la instancia Postgis (estos archivos mantienen la información vectorial de alta resolución/detalle), y **colocarlos en la carpeta ./osm-geoserver-postgis/pbfs** que se encuentra en el repositorio git.

   a. Ejemplo:  **wget https://download.geofabrik.de/south-america-latest.osm.pbf**

4. Ejecutar el comando **./startup.sh**  (nota: este comando inicializa las instancias de contenedores docker, descarga el archivo de low-resolution de datos de OSM - gentileza de [Geosolutions](https://www.geosolutionsgroup.com/) -, importa los archivos PBF del paso 3 en la base de datos PostGIS y una vez importados los mueve a la carpeta ./osm-geoserver-postgis/pbfs/imported).

   a.  **./osm-geoserver-postgis/startup.sh**

Observaciones : 

- Cada vez que se inicializa el docker-compose, se valida si en la carpeta de PBFs hay archivos a importar, y se reinicia la información de las capas de OSM. Solo en el caso de tener la carpeta vacia, es decir sin archivos PBF, es que no se resetea la información existente. 
- En el caso de querer sumar nuevos PBFs contemplando mantener la información ya importada, se sugiere copiar aquellos archivos que ya se hubieran importado (carpeta /pbfs/imported) a la carpeta ./pbfs para que se acumulen las nuevas capas de datos junto con las previas. Luego, se deberá proceder a detener el docker-compose (./osm-geoserver-postgis/shutdown.sh) y reiniciar con ./startup.sh .
- Los pasos mencionados en parrafo anterior, forzarán a una reinicialización de la instancia OSM (dejandola inactiva). Si bien no es la situación ideal, es la forma más simple de explicar los pasos a ejecutar. Opcionalmente, el usuario puede chequear los scripts (./startup.sh y ./imposm/import-pg.sh) los cuales brindan mas detalle acerca de como hacer la misma labor sin afectar a la disponibilidad del sistema.



## Detalle Técnico

- Una instancia de cada servicio
- Imagenes utilizadas
  - geoserver: geotekne/geoserver:lime-2.16.2
    - Incluye los plugins CSS y Pregeneralized features para lograr renderizar las capas de OSM como corresponde.
    - TO-DO: la imagen se basa en kartoza/geoserver incluyendo los plugins mencionados habilitados, pero eso lleva a una imagen docker de 1.9 GB (demasiado). Hay que mejorar esto.
  - postgis: kartoza/postgis:12.1
    - Utilizado para almacenar las capas de OSM.
- Volumen de datos de Geoserver mapeado a carpeta en host
- Volumen de datos de Postgis mapeado a volumen pgdata en docker
- Puertos mapeados en host:
  - geoserver: 8080
  - postgis: 5432

## Diagrama

![](./diagram.png)