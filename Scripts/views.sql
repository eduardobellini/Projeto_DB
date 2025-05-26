--selects
SELECT restaurantes.nome, precos.media_preco
FROM (
    SELECT restaurante_id, AVG(preco)::numeric(10,2) AS media_preco
    FROM pratos
    GROUP BY restaurante_id
) AS precos
JOIN restaurantes ON restaurantes.id = precos.restaurante_id;
----------------------------------------------------------------------

SELECT usuarios.nome,
       (SELECT COUNT(*) FROM pedidos
	   WHERE pedidos.usuario_id = usuarios.id) AS total_pedidos
FROM usuarios;
----------------------------------------------------------------------
SELECT restaurantes.nome
FROM restaurantes
WHERE EXISTS (
    SELECT 1
    FROM pratos
    WHERE pratos.restaurante_id = restaurantes.id
      AND pratos.disponivel = TRUE
);
----------------------------------------------------------------------
SELECT restaurantes.nome
FROM restaurantes
WHERE NOT EXISTS (
    SELECT 1
    FROM pratos
    WHERE pratos.restaurante_id = restaurantes.id
);
----------------------------------------------------------------------
SELECT usuarios.nome, usuarios.email
FROM usuarios
WHERE usuarios.id IN (
    SELECT pedidos.usuario_id
    FROM pedidos
    GROUP BY pedidos.usuario_id
    HAVING COUNT(*) > 1
);
----------------------------------------------------------------------
SELECT pedidos.id, usuarios.nome AS cliente, restaurantes.nome AS restaurante
FROM pedidos
INNER JOIN usuarios ON pedidos.usuario_id = usuarios.id
INNER JOIN restaurantes ON pedidos.restaurante_id = restaurantes.id;
----------------------------------------------------------------------
SELECT restaurantes.nome AS restaurante, pratos.nome AS prato
FROM restaurantes
LEFT JOIN pratos ON pratos.restaurante_id = restaurantes.id;
----------------------------------------------------------------------
SELECT pratos.nome AS prato, restaurantes.nome AS restaurante
FROM pratos
RIGHT JOIN restaurantes ON pratos.restaurante_id = restaurantes.id;
----------------------------------------------------------------------
SELECT restaurantes.nome AS restaurante, pratos.nome AS prato
FROM restaurantes
FULL JOIN pratos ON pratos.restaurante_id = restaurantes.id;
----------------------------------------------------------------------
SELECT restaurantes.nome, pedidos_aggregados.total_pedidos
FROM restaurantes
JOIN (
    SELECT pedidos.restaurante_id, COUNT(*) AS total_pedidos
    FROM pedidos
    GROUP BY pedidos.restaurante_id
) AS pedidos_aggregados
ON restaurantes.id = pedidos_aggregados.restaurante_id;