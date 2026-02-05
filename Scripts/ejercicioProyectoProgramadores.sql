-- 1.Mostrar los subproyectos del proyecto 'Sistema de Gestión'. Un proyecto principal tiene el campo
-- idProyectoPrincipal con valor nulo. Y sólo se almacena un nivel de subproyectos.
SELECT 
    Sub.idProyecto, 
    Sub.descripcion AS Nombre_Subproyecto, 
    Sub.fechaInicio, 
    Sub.fechaFin
FROM Proyecto AS Sub
INNER JOIN Proyecto AS Principal 
    ON Sub.idProyectoPrincipal = Principal.idProyecto
WHERE Principal.descripcion = 'Sistema de Gestión';