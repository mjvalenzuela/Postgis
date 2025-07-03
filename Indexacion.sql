SELECT * FROM public."Barrios_Cali";
1 sec 11 ms

CREATE INDEX idx_BarriosCali_geom 
ON public."Barrios_Cali" 
USING GIST(geom);

518 ms

SELECT Sum(poblacion_total)
FROM cali_barrios barrios
JOIN cali_cuadras cuadras
ON barrios.geom && cuadras.geom
WHERE barrios.name = 'La Esperanza';

49821


SELECT Sum(poblacion_total)
FROM cali_barrios barrios
JOIN cali_cuadras cuadras
ON ST_Intersects(barrios.geom, cuadras.geom)
WHERE barrios.name = 'La Esperanza';

26718
u

ANALYZE public."Barrios_Cali";

VACUUM public."Barrios_Cali";

VACUUM ANALYZE public."Barrios_Cali";

SELECT * FROM pg_indexes WHERE schemaname = 'public' AND tablename = 'Barrios_Cali';

