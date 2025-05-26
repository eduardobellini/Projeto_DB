CALL listar_pedidos();

CALL buscar_pedidos(1);

SELECT contar_pedidos_usuario(1);

SELECT * FROM listar_pratos_disponiveis();

SELECT obter_preco_prato(1);

INSERT INTO pedidos (usuario_id, restaurante_id, entregador_id, status, endereco_entrega) 
VALUES (1, 1, 1, 'pendente', 'Rua Teste, 123');

SELECT * FROM registro_pedidos;

DELETE FROM pedidos WHERE id = 1;

DELETE FROM entregadores WHERE id = 1;

SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename IN ('usuarios', 'pratos', 'pedidos', 'itens_pedido');

