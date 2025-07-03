----------------------------------------------1. ST_Buffer(geom, distancia)
--Crea un polígono alrededor de cada centro comercial con un radio de 500 metros.
--'quad_segs=8' define el número de segmentos utilizados para aproximar los bordes del buffer.

SELECT "NOMBRE", 
       ST_Buffer(geom,
	   0.005, 'quad_segs=8') 
FROM "CentrosComerciales"

 --0.005 ≈ 555 metros

----------------------------------------------2. ST_Difference(geomA, geomB)
--Calcula la parte de la malla vial que no está dentro de los barrios. 
--Esto puede ser útil para obtener las partes de las calles que no están en áreas residenciales.

SELECT ST_AsText(ST_Difference("malla_vial_pgsql".geom, "barrios".geom)) AS diferencia_geom
FROM "malla_vial_pgsql", "barrios"
WHERE ST_Intersects("malla_vial_pgsql".geom, "barrios".geom);

SELECT ST_Difference("malla_vial_pgsql".geom, "barrios".geom) AS diferencia_geom
FROM "malla_vial_pgsql", "barrios"
WHERE ST_Intersects("malla_vial_pgsql".geom, "barrios".geom);


----------------------------------------------3. ST_SimplifyPreserveTopology(geom, tolerancia)
--Reduce los vértices de la geometría de cada barrio para simplificarla, usando una tolerancia de 50 metros. Preserva la topología de la geometría
--Esto puede ayudar a acelerar la visualización en mapas o análisis. 

SELECT "BARRIO", 
       ST_SimplifyPreserveTopology(ST_MakeValid(geom), 50) AS geometria_simplificada
FROM barrios
WHERE ST_IsValid(geom);



----------------------------------------------4. ST_MakeValid(geom) y ST_IsValid(geom)
--ST_IsValid(geom): Verifica si la geometría es válida.
--ST_MakeValid(geom): Repara geometrías inválidas, como aquellos polígonos autointersectados o incorrectos.

--Dañar algunas geometrias
UPDATE barrios
SET geom = ST_GeomFromText('POLYGON((0 0, 1 1, 1 0, 0 1, 0 0))')
WHERE "BARRIO" = 'MIRANDELA'; 

SELECT "BARRIO", 
       CASE 
           WHEN ST_IsValid(geom) THEN 'Válida'
           ELSE 'Inválida, reparando'
       END AS estado,
       ST_AsText(ST_MakeValid(geom)) AS geom_reparada
FROM "barrios"
WHERE ST_IsValid(geom) = FALSE;


----------------------------------------------5. Funciones de Clustering Espacial
----------------------------------------------ST_ClusterDBSCAN (Agrupamiento por densidad)
--ST_ClusterDBSCAN(geom, 1000, 2): Agrupa los centros comerciales en clústeres de acuerdo con la densidad. 
--El primer parámetro (1000) es el radio de la búsqueda (1000 metros), 
--y el segundo parámetro (2) es el número mínimo de puntos necesarios para formar un clúster.

SELECT "NOMBRE", ST_ClusterDBSCAN(ST_Transform(geom, 3395), 1000, 2) OVER () AS cluster_id
FROM "CentrosComerciales";


----------------------------------------------6. ST_ClusterKMeans (Agrupamiento por K-means)
--Agrupa los CAI de Bogotá en 5 clústeres según su ubicación espacial.
SELECT "NOMBRE", ST_ClusterKMeans(geom, 5) OVER () AS cluster_id
FROM "cai";


----------------------------------------------7. ST_X(geom) / ST_Y(geom)
--Extraen las coordenadas X (longitud) y Y (latitud) de cada geometría de los aeropuertos.
SELECT "NOMBRE", 
       ST_X(geom) AS lon, 
       ST_Y(geom) AS lat
FROM "aeropuertos";


----------------------------------------------8. ST_Contains
--Determina si una geometría A contiene completamente a una geometría B.
--Si el centro_comercial está dentro de un barrio, el valor de contiene será TRUE.

SELECT b."BARRIO", c."NOMBRE" AS centro_comercial,
       ST_Contains(b.geom, c.geom) AS contiene
FROM "barrios" b
JOIN "CentrosComerciales" c
  ON ST_Contains(b.geom, c.geom);
  
----------------------------------------------9. ST_Area
--Calcula el área de una geometría, generalmente utilizada para polígonos.
--Calcular el área de un barrio.

SELECT "BARRIO", ST_Area(geom) AS area_barrio
FROM "barrios";

SELECT DISTINCT ST_SRID(geom) AS srid
FROM "barrios";

SELECT "BARRIO", 
       ST_Area(ST_Transform(geom, 3857)) AS area_barrio_m2
FROM "barrios";


----------------------------------------------10. ST_Centroid
--Calcula el centro de masa de una geometría, generalmente un punto representativo dentro de una geometría compleja (como un polígono).
--Calcular el centro de cada barrio.

SELECT "BARRIO", ST_AsText(ST_Centroid(geom)) AS centro_barrio
FROM "barrios";


----------------------------------------------11. ST_GeometryType
--Devuelve el tipo de la geometría (como Point, Polygon, LineString, etc.).
--Verificar el tipo de geometría de los barrios.

SELECT "NOMBRE", ST_GeometryType(geom) AS tipo_geom
FROM "cai";





SELECT * FROM "barrios"