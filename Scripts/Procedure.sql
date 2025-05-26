--Procedure
CREATE OR REPLACE PROCEDURE listar_pedidos()
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT pedidos.id AS pedido_id, usuarios.nome AS nome_usuario, restaurantes.nome AS nome_restaurante, pedidos.status
    FROM pedidos
    JOIN usuarios ON pedidos.usuario_id = usuarios.id
    JOIN restaurantes ON pedidos.restaurante_id = restaurantes.id;
END;
$$;

CALL listar_pedidos();
----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE buscar_pedidos(usuario_id_param INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT id, usuario_id, status
    FROM pedidos
    WHERE usuario_id = usuario_id_param;
END;
$$;

----------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE atualizar_status_pedido(pedido_id_param INTEGER, novo_status_param VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE pedidos
    SET status = novo_status_param
    WHERE id = pedido_id_param;
END;
$$;
----------------------------------------------------------------------