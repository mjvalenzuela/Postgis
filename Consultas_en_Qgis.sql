--ST_Buffer (zona de influencia)
SELECT "NOMBRE", 
ST_Buffer(geom, 0.005, 'quad_segs=8') AS geom
FROM "CentrosComerciales"

--ST_Difference (elementos fuera de un área)
SELECT mv."id" AS id, mv."NOMBRE", 
ST_Difference(mv.geom, b.geom) AS geom
FROM "malla_vial_pgsql" mv, "barrios" b
WHERE ST_Intersects(mv.geom, b.geom);

--ST_SimplifyPreserveTopology (geometrías simplificadas)
SELECT "id", "BARRIO", 
ST_SimplifyPreserveTopology(ST_MakeValid(geom), 50) AS geom
FROM "barrios"
WHERE ST_IsValid(geom);

--ST_MakeValid (geometrías reparadas)
SELECT "id", "BARRIO", 
ST_MakeValid(geom) AS geom
FROM "barrios"
WHERE NOT ST_IsValid(geom);

--ST_ClusterDBSCAN (agrupamiento espacial por densidad)
SELECT "id", "NOMBRE", 
ST_Transform(geom, 4326) AS geom, 
ST_ClusterDBSCAN(ST_Transform(geom, 3395), 1000, 2) OVER () AS cluster_id
FROM "CentrosComerciales";

--ST_ClusterKMeans (agrupamiento por número de clústeres)
SELECT "id", "NOMBRE", 
geom, 
ST_ClusterKMeans(geom, 5) OVER () AS cluster_id
FROM "cai";

--ST_Centroid (punto central de una geometría)
SELECT "id", "BARRIO", 
ST_Centroid(geom) AS geom
FROM "barrios";
