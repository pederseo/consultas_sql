-- 1) Selecciona las columnas DisplayName, Location y Reputation de los usuarios con mayor
-- reputación. Ordena los resultados por la columna Reputation de forma descendente y
-- presenta los resultados en una tabla mostrando solo las columnas DisplayName,
-- Location y Reputation.

SELECT TOP 200
	DisplayName, Location, Reputation
FROM 
	Users
ORDER BY Reputation DESC;

-- _____________________________________________________________________________
-- 2) Selecciona la columna Title de la tabla Posts junto con el DisplayName de los usuarios
-- que lo publicaron para aquellos posts que tienen un propietario.
-- Para lograr esto une las tablas Posts y Users utilizando OwnerUserId para obtener el
-- nombre del usuario que publicó cada post. Presenta los resultados en una tabla
-- mostrando las columnas Title y DisplayName

SELECT TOP 200
    Posts.Title, 
    Users.DisplayName
FROM 
    Posts
INNER JOIN 
    Users
ON 
    Posts.OwnerUserId = Users.Id
WHERE 
    Posts.OwnerUserId IS NOT NULL;

-- ______________________________________________________________________________
-- 3) Calcula el promedio de Score de los Posts por cada usuario y muestra el DisplayName
-- del usuario junto con el promedio de Score.
-- Para esto agrupa los posts por OwnerUserId, calcula el promedio de Score para cada
-- usuario y muestra el resultado junto con el nombre del usuario. Presenta los resultados
-- en una tabla mostrando las columnas DisplayName y el promedio de Score

SELECT TOP 200
    Users.DisplayName,
    AVG(Posts.Score) AS Puntaje_promedio -- saca el promedio
FROM 
    Posts
INNER JOIN 
    Users ON Posts.OwnerUserId = Users.Id
GROUP BY 
    Users.DisplayName
ORDER BY 
    Puntaje_promedio DESC;  -- Ordena por el promedio de Score de mayor a menor

-- _________________________________________________________________________________
-- 4) Encuentra el DisplayName de los usuarios que han realizado más de 100 comentarios
-- en total. Para esto utiliza una subconsulta para calcular el total de comentarios por
-- usuario y luego filtra aquellos usuarios que hayan realizado más de 100 comentarios en
-- total. Presenta los resultados en una tabla mostrando el DisplayName de los usuarios

SELECT TOP 200
    Users.DisplayName
FROM 
    Users
WHERE 
    Users.Id IN (
        SELECT 
            Comments.UserId
        FROM 
            Comments
        GROUP BY 
            Comments.UserId
        HAVING 
            COUNT(Comments.Id) > 100
    );

-- _________________________________________________________________________________
-- 5) Actualiza la columna Location de la tabla Users cambiando todas las ubicaciones vacías
-- por "Desconocido". Utiliza una consulta de actualización para cambiar las ubicaciones
-- vacías. Muestra un mensaje indicando que la actualización se realizó correctamente.


UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

-- Mostrar mensaje de actualización realizada
PRINT 'La actualización se realizó correctamente.';

-- Verificar las actualizaciones
SELECT TOP 200
    Location 
FROM 
    Users

-- ________________________________________________________________________________
-- 6) Elimina todos los comentarios realizados por usuarios con menos de 100 de reputación.
-- Utiliza una consulta de eliminación para eliminar todos los comentarios realizados y
-- muestra un mensaje indicando cuántos comentarios fueron eliminados

DELETE FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);
PRINT 'LAS FILAS FUERON ELIMINADAS'

-- ________________________________________________________________________________
-- 7) Para cada usuario, muestra el número total de publicaciones (Posts), comentarios
-- (Comments) y medallas (Badges) que han realizado. Utiliza uniones (JOIN) para combinar
-- la información de las tablas Posts, Comments y Badges por usuario. Presenta los
-- resultados en una tabla mostrando el DisplayName del usuario junto con el total de
-- publicaciones, comentarios y medallas

SELECT TOP 200
    U.DisplayName, 
    COALESCE(P.NumeroPublicaciones, 0) AS TotalPosts,
    COALESCE(C.NumeroComentarios, 0) AS TotalComments,
    COALESCE(B.NumeroMedallas, 0) AS TotalBadges
FROM 
    Users U
LEFT JOIN (
    SELECT 
        OwnerUserId, 
        COUNT(*) AS NumeroPublicaciones
    FROM 
        Posts
    GROUP BY 
        OwnerUserId
) P ON U.Id = P.OwnerUserId
LEFT JOIN (
    SELECT 
        UserId, 
        COUNT(*) AS NumeroComentarios
    FROM 
        Comments
    GROUP BY 
        UserId
) C ON U.Id = C.UserId
LEFT JOIN (
    SELECT 
        UserId, 
        COUNT(*) AS NumeroMedallas
    FROM 
        Badges
    GROUP BY 
        UserId
) B ON U.Id = B.UserId;

-- _________________________________________________________________________________
-- 8) Muestra las 10 publicaciones más populares basadas en la puntuación (Score) de la
-- tabla Posts. Ordena las publicaciones por puntuación de forma descendente y
-- selecciona solo las 10 primeras. Presenta los resultados en una tabla mostrando el Title
-- de la publicación y su puntuación

SELECT TOP 10 
    Title, 
    Score
FROM 
    Posts
ORDER BY Score DESC;

-- __________________________________________________________________________________
-- 9) Muestra los 5 comentarios más recientes de la tabla Comments. Ordena los comentarios
-- por fecha de creación de forma descendente y selecciona solo los 5 primeros. Presenta
-- los resultados en una tabla mostrando el Text del comentario y la fecha de creación

SELECT TOP 5
    Text,
    CreationDate
FROM
    Comments
ORDER BY
    CreationDate DESC;






