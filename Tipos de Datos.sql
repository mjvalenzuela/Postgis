
--******************************************************************* GEOMETRYCOLLECTION

-- CREAR TABLA 
CREATE TABLE ColeccionGeometrias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    geom Geometry(GeometryCollection, 4326)  -- Usamos SRID 4326 (WGS 84)
);

-- INSERTAR UNA GEOMETRYCOLLECTION (un punto, una línea y un polígono)
INSERT INTO ColeccionGeometrias (nombre, geom)
VALUES ('Ejemplo de GeometryCollection',
        ST_GeomFromText('GEOMETRYCOLLECTION(
		                 POINT(-74.0721 4.7110), 
                         LINESTRING(-74.0721 4.7110, -75.5644 6.2172), 
                         POLYGON((-75.565 6.217, -75.566 6.218, -75.565 6.219, -75.564 6.218, -75.565 6.217))
						 )', 4326));

-- CONSULTAR TODOS LOS DATOS
SELECT id, nombre, geom FROM public.colecciongeometrias;

-- CONSULTAR SEPARANDO POR GEOMETRIA
SELECT nombre,
       ST_AsText(ST_GeometryN(geom, 1)) AS punto,  -- Obtener el primer elemento (punto)
       ST_AsText(ST_GeometryN(geom, 2)) AS linea,  -- Obtener el segundo elemento (línea)
       ST_AsText(ST_GeometryN(geom, 3)) AS poligono -- Obtener el tercer elemento (polígono)
FROM public.colecciongeometrias;

--******************************************************************* MULTIPOLYGON

-- CREAR TABLA 
CREATE TABLE multipolígonos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    geom Geometry(MultiPolygon, 4326)
);

-- INSERTAR UN MULTIPOLYGON (conjunto de varios polígonos representando áreas urbanas)
INSERT INTO multipolígonos (nombre, geom)
VALUES ('Áreas urbanas de Colombia',
        ST_GeomFromText('MULTIPOLYGON(
						(( -75.565 6.217, -75.566 6.218, -75.565 6.219, -75.564 6.218, -75.565 6.217)),
                        ((-75.073 6.711, -75.074 6.712, -75.073 6.713, -75.072 6.712, -75.073 6.711))
						)', 4326));

-- CONSULTAR
SELECT id, nombre, geom FROM public."multipolígonos";	


--******************************************************************* MULTIPOINT

-- CREAR TABLA 
CREATE TABLE multipuntos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    geom Geometry(MultiPoint, 4326)
);

-- INSERTAR UN MULTIPOINT (conjunto de varios puntos de estaciones de servicio)
INSERT INTO multipuntos (nombre, geom)
VALUES ('Estaciones de servicio en Colombia',
        ST_GeomFromText('MULTIPOINT(
		(-74.0721 4.7110), (-74.0644 4.8172), (-74.0369 4.6372)
		)', 4326));

-- CONSULTAR
SELECT id, nombre, geom FROM public.multipuntos;


--******************************************************************* MULTILINESTRING

-- CREAR TABLA 
CREATE TABLE multilíneas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    geom Geometry(MultiLineString, 4326)
);

-- INSERTAR UN MULTILINESTRING (conjunto de varias rutas)
INSERT INTO multilíneas (nombre, geom)
VALUES ('Rutas de carreteras en Colombia',
      ST_GeomFromText('MULTILINESTRING(
	  					(-74.0721 4.7110, -75.5644 6.2172), 
                        (-74.0721 4.7110, -77.0369 1.6372)
						)', 4326));

-- CONSULTAR
SELECT id, nombre, geom FROM public."multilíneas";







