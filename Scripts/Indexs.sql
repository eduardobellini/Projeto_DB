--indices
CREATE INDEX idx_usuarios_email ON usuarios(email);

CREATE INDEX idx_pratos_restaurante_id ON pratos(restaurante_id);

CREATE INDEX idx_pedidos_restaurante_status ON pedidos(restaurante_id, status);

CREATE INDEX idx_pedidos_usuario_id ON pedidos(usuario_id);

CREATE INDEX idx_itens_pedido_pedido_id ON itens_pedido(pedido_id);