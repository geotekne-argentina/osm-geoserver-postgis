# osm-geoserver-postgis

**Obten tu conjunto de datos de OSM preferido (ejemplo, un pais) corriendo de forma local en una instancia Geoserver con solo 2 comandos.**

<a href="https://www.youtube.com/watch?v=XpFxNAVAy3k" rel="video">![sample](./img/osm-geoserver-postgis-optimized.gif)</a>

En la imagen anterior puede ver la aplicación de demostración en acción (en http://localhost servimos una pequeña aplicación que permite ver el contenido de su implementación)

El proyecto involucra un archivo docker-compose.yml que ensambla los componentes necesarios para implementar una instancia de Geoserver que publica las capas de OpenStreetMap (OSM) localmente en un solo host/máquina (se requiere Postgis para almacenar las capas de OSM).

Las instrucciones para este proyecto se basan en este repositorio [OSM-Styles](https://github.com/geosolutions-it/osm-styles), pero haciendo un plan de ejecución más simple.

Los pasos y scripts están destinados a ejecutarse en el contexto de entornos Linux, Mac y Windows.

Tenga en cuenta que, en la demo, puede navegar por la versión Remota de OSM o la instancia local de OSM siendo que en esta ultima solo en la región de Surinam verá detalles en alta resolución (puede ampliarla a la cobertura global deseada, solo tendrá que ingestar el conjunto de datos global de archivos OSM segun explicaciones a continuación).

## Pasos

Con los scripts que se incluyen en la carpeta, hemos simplificado los pasos para implementar una solución que incluye una instancia de Geoserver que publica las capas de OSM (almacenadas en un Postgis), utilizando el servicio WMS.

Esta simplificación funcionará bien cuando la implementación se realice en el mismo host (en el que se ejecutará la composición del docker que inicializa el sistema). Si tiene que implementar en más de un host, debe considerar algunos aspectos técnicos (básicamente, lo mismo que pasar de docker compose a swarm o kubernetes, por lo que deberá adaptarlo).

La idea es mantener el caso de uso simple (a continuación se muestra el diagrama de contenedores y volúmenes para crear).

**Precondiciones:**

Nota: puede chequearse estado de precondiciones ejecutando el siguiente script **check-preconditions.sh**

1. Instale [git](https://github.com/git-guides/install-git), [docker](https://docs.docker.com/engine/install/ubuntu/) y [docker compose (V2)](https://docs.docker.com/compose/install/) en la máquina host.

2. Descarga el repositorio de este proyecto.

    ```
    git clone https://github.com/geotekne-argentina/osm-geoserver-postgis
    ```

3. Opcional: edite el archivo **config.sh** y seleccione qué archivo PBF descargar (de GeoFabrik, https://download.geofabrik.de/); de lo contrario, la demostración predeterminada descargará el archivo PBF de Surinam.

**2 Pasos**

1. Ejecute el script setup-datasets.sh

    ```
    ./osm-geoserver-postgis/setup-datasets.sh
    ```

2. Una vez que finalice la configuración y descarga de los conjuntos de datos, ejecute el script startup.sh

    ```
    ./osm-geoserver-postgis/startup.sh
    ```

**IMPORTANTE:**
  - Asegúrese de que los puertos asignados (80 y 8080) en su host estén disponibles para su uso.
  - Recuerde ejecutar el script ./setup-datasets.sh para descargar el archivo de BAJA resolución.

Observaciones :

- Restablecimiento de datos OSM: Cada vez que se inicializa el docker compose, se valida si hay archivos para importar en la carpeta PBFs, y así se restablece la información de las capas OSM. Solo en el caso de tener la carpeta vacía, es decir sin archivos PBF, es que no se reseteará la información existente en el volumen pgdata. Por lo tanto, sugerimos ejecutar el script ./setup-datasets.sh al menos una vez y luego agregar sus archivos PBF en la carpeta ./pbfs. Tambien, después de la primera ejecución del script ./start.sh (que activará el proceso de importación) sugerimos eliminar los archivos PBF de la carpeta ./pbfs; de lo contrario, el proceso de importación se ejecutará cada vez que inicie la composición de contenedores docker)

(*) La versión inicial de ese archivo sale de este repositorio https://github.com/geosolutions-it/osm-styles (en el README se encuentra el link para su descarga desde Dropbox), pero tiene errores/imperfecciones en ciertas zonas - producto del tratamiento para bajar la resolucion - que han sido corregidos.


## Detalle Técnico

- Una instancia de cada servicio
- Imagenes utilizadas
  - geoserver: geotekne/geoserver:lime-alpine-2.16.2
    - El docker compose define el uso de los plugins CSS y Pregeneralized features para lograr renderizar las capas de OSM como corresponde.
  - postgis: kartoza/postgis:12.1
    - Utilizado para almacenar las capas de OSM.
  - wmsclient: nginx:1.21.3-alpine
    - Que muestra en un ejemplo sencillo, en una aplicación web html+css+js, el acceso a datos de OSM en directo o bien del OSM en instancia local que hemos creado. Accesible a través del navegador en http://localhost:80  
  - imposm-worker: geotekne/imposm-worker:1.0.0
    + Contenedor que permite ingerir los archivos PBFs ubicados en la carpeta ./pbfs en la base de datos de Postgis
- Volumen de datos de Geoserver mapeado a carpeta en host
- Volumen de datos de Postgis mapeado a volumen pgdata en docker
- Volumen de datos de Wmsclient mapeado a carpeta que contiene la aplicación web de ejemplo.
- Puertos mapeados en host:
  - geoserver: 8080
  - postgis: 5432
  - wmsclient: 80

## Diagrama

![](./diagram.png)
