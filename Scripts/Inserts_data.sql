--INSERTS

--Usuários
INSERT INTO usuarios (nome, email, senha_hash, endereco, telefone) VALUES
('Carlos Silva', 'carlos.silva@email.com', 'hashsenha1', 'Rua A, 123', '11999999999'),
('Maria Oliveira', 'maria.oliveira@email.com', 'hashsenha2', 'Rua B, 456', '11888888888'),
('João Souza', 'joao.souza@email.com', 'hashsenha3', 'Rua C, 789', '11777777777');

--restaurantes
INSERT INTO restaurantes (nome, descricao, endereco, telefone, cnpj) VALUES
('Pizzaria Bella', 'Pizzas artesanais e tradicionais', 'Avenida Central, 100', '1122223333', '12.345.678/0001-00'),
('Hamburgueria Top', 'Hambúrgueres gourmet e milkshakes', 'Rua das Flores, 50', '1133334444', '23.456.789/0001-11'),
('Sushi House', 'Sushis frescos e temakis', 'Avenida do Sol, 200', '1144445555', '34.567.890/0001-22');

--pratos
INSERT INTO pratos (restaurante_id, nome, descricao, preco, disponivel) VALUES
(1, 'Pizza Margherita', 'Queijo, tomate e manjericão', 30.00, TRUE),
(1, 'Pizza Calabresa', 'Calabresa, queijo e cebola', 35.00, TRUE),
(2, 'Hambúrguer Clássico', 'Carne, queijo, alface, tomate', 25.00, TRUE),
(2, 'Milkshake Chocolate', 'Leite, sorvete, calda de chocolate', 15.00, FALSE),
(3, 'Sushi Salmão', 'Salmão fresco e arroz', 20.00, TRUE),
(3, 'Temaki Atum', 'Cone de alga com atum e arroz', 18.00, TRUE);


--entregadores
INSERT INTO entregadores (nome, telefone, veiculo, disponivel) VALUES
('Pedro Almeida', '11911112222', 'Moto', TRUE),
('Ana Costa', '11922223333', 'Carro', TRUE),
('Lucas Pereira', '11933334444', 'Bicicleta', FALSE);

--pedidos
INSERT INTO pedidos (usuario_id, restaurante_id, entregador_id, status, endereco_entrega) VALUES
(1, 1, 1, 'pendente', 'Rua A, 123'),
(2, 2, 2, 'em andamento', 'Rua B, 456'),
(1, 3, 3, 'finalizado', 'Rua A, 123'),
(3, 1, 1, 'pendente', 'Rua C, 789'),
(2, 3, 2, 'em andamento', 'Rua B, 456');

--itens_pedido
INSERT INTO itens_pedido (pedido_id, prato_id, quantidade, preco_unitario) VALUES
(1, 1, 2, 30.00),
(1, 2, 1, 35.00),
(2, 3, 1, 25.00),
(3, 5, 3, 20.00),
(4, 1, 1, 30.00),
(4, 2, 2, 35.00),
(5, 6, 1, 18.00);
