
--4326 -> WGS84
--3857 -> proyección Web Mercator

--******************************************************************* CONSULTA DE PROXIMIDAD: ST_Distance

-- CREAR TABLA DE ESTACIONES DE SERVICIO
CREATE TABLE estaciones_servicio (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    geom Geometry(Point, 4326)
);

-- INSERTAR ALGUNAS ESTACIONES DE SERVICIO
INSERT INTO estaciones_servicio (nombre, geom)
VALUES ('Estación 1', ST_SetSRID(ST_MakePoint(-75.8794, 10.8910), 4326)),
       ('Estación 2', ST_SetSRID(ST_MakePoint(-75.4630, 10.3925), 4326)),
       ('Estación 3', ST_SetSRID(ST_MakePoint(-75.5000, 10.4000), 4326)),
	   ('Estación 4', ST_SetSRID(ST_MakePoint(-74.8794, 4.8910), 4326));
	   

-- CONSULTAR LAS ESTACIONES MAS CERCANAS AL CENTRO DE CARTAGENA
SELECT	nombre, 
		ST_AsText(geom), 
		ST_Distance(
			ST_Transform(geom, 3857), 
			ST_Transform(ST_SetSRID(ST_MakePoint(-75.4794, 10.3910), 4326), 3857)) AS distancia
FROM estaciones_servicio
WHERE ST_Distance(ST_Transform(geom, 3857), ST_Transform(ST_SetSRID(ST_MakePoint(-75.4794, 10.3910), 4326), 3857)) <= 5000;  -- 5000 metros (5 km)



--******************************************************************* CONSULTA DE PROXIMIDAD: ST_Intersects

-- CREAR TABLA DE POLIGONOS DE AREAS PROTEGIDAS
CREATE TABLE areas_protegidas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    geom Geometry(Polygon, 4326)  
);

-- INSERTAR POLIGONOS
INSERT INTO areas_protegidas (nombre, geom)
VALUES 
('Área Protegida de Cartagena', ST_SetSRID(ST_GeomFromText('POLYGON((-75.9800 10.9900, -75.1090 10.3900, -75.1090 9.1910, -75.9800 9.1910,-75.9800 10.9900))'), 4326)),
('Reserva Natural de las Islas del Rosario', ST_SetSRID(ST_GeomFromText('POLYGON((-75.6900 10.3500, -75.6890 10.3500, -75.6890 10.3510, -75.6900 10.3510, -75.6900 10.3500))'), 4326));

-- CONSULTAR LAS ESTACIONES QUE SE ENCUENTRAN DENTRO DE LOS POLIGONOS DE AREAS PROTEGIDAS
SELECT e.nombre, ST_AsText(e.geom)
FROM estaciones_servicio e
JOIN areas_protegidas a 
  ON ST_Intersects(
      ST_Transform(e.geom, 3857),  
      ST_Transform(a.geom, 3857)   
  )
WHERE a.nombre = 'Área Protegida de Cartagena';


--******************************************************************* CONSULTA DE PROXIMIDAD: ST_Within


SELECT e.nombre, ST_AsText(e.geom)
FROM estaciones_servicio e
JOIN areas_protegidas a 
  ON ST_Within(
      ST_Transform(e.geom, 3857),
      ST_Transform(a.geom, 3857)
  )
WHERE a.nombre = 'Área Protegida de Cartagena';


--******************************************************************* CONSULTA DE PROXIMIDAD: ST_Union

SELECT id, nombre, geom FROM public.areas_protegidas;
	
SELECT ST_AsText(
           ST_Union(
               ST_Transform(geom, 3857)  
           )
       ) AS zona_unificada
FROM areas_protegidas;




