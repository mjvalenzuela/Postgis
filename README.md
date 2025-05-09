# Postgis

# 📘 Curso de PostgreSQL y PostGIS – Ejercicios y Consultas

Este repositorio contiene ejemplos prácticos, consultas y estructuras de datos que he ido aprendiendo a lo largo del curso de PostgreSQL y PostGIS. El objetivo es tener un recurso de consulta organizado y reutilizable para proyectos futuros en bases de datos espaciales.

---

## 📂 Estructura del repositorio

- `tipos_datos.sql` → Sentencias con diferentes tipos de datos en PostgreSQL.
- `consultas_espaciales.sql` → Consultas utilizando funciones espaciales de PostGIS (ST_Intersects, ST_Distance, etc.).
- `joins_y_subconsultas.sql` → Ejemplos de JOINs, subconsultas, filtros y condiciones.
- `consultas_agregadas.sql` → Agrupaciones, funciones COUNT, SUM, AVG, etc.
- `creacion_tablas.sql` → Tablas con y sin geometría, claves primarias y foráneas.
- `carga_datos.sql` → Ejemplos para insertar registros manualmente o desde archivos externos.
- (Puedes ir agregando más archivos según avance el curso)

---

## 🛠 Requisitos

Para probar los ejemplos necesitas:

- PostgreSQL 15+
- Extensión PostGIS instalada y habilitada
- Un entorno como pgAdmin, DBeaver o terminal (`psql`)

---

## 🧪 Ejemplo de consulta espacial

```sql
SELECT nombre
FROM parques
WHERE ST_Intersects(
    ST_Transform(parques.geom, 3857),
    ST_Buffer(ST_Transform(ST_SetSRID(ST_MakePoint(-75.5, 10.4), 4326), 3857), 1000)
);
