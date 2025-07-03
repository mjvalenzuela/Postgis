from qgis.core import QgsVectorLayer, QgsDataSourceUri

def cargar_capa_sql(nombre_capa, consulta_sql):
    uri = QgsDataSourceUri()
    uri.setConnection("localhost", "5432", "malla_bogota", "postgres", "homero")
    uri.setDataSource("", f"({consulta_sql})", "geom", "", "id")

    capa = QgsVectorLayer(uri.uri(False), nombre_capa, "postgres")
    if capa.isValid():
        QgsProject.instance().addMapLayer(capa)
    else:
        print(f"La capa {nombre_capa} no es válida.")

# Ejemplo: cargar buffers de centros comerciales
sql = """
SELECT "id", "NOMBRE", 
       ST_Buffer(geom, 0.005, 'quad_segs=8') AS geom
FROM "CentrosComerciales"
"""
cargar_capa_sql("Buffer Centros Comerciales", sql)