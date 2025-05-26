--tables
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,              
    nome VARCHAR(100) NOT NULL,         
    email VARCHAR(100) UNIQUE NOT NULL, 
    senha_hash VARCHAR(255) NOT NULL,   
    endereco TEXT NOT NULL,             
    telefone VARCHAR(20)                
);

CREATE TABLE restaurantes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco TEXT NOT NULL,
    telefone VARCHAR(20),
    cnpj VARCHAR(18) UNIQUE 
);

CREATE TABLE pratos (
    id SERIAL PRIMARY KEY,
    restaurante_id INTEGER REFERENCES restaurantes(id), 
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10, 2) NOT NULL, 
    disponivel BOOLEAN DEFAULT TRUE
);

CREATE TABLE entregadores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    disponivel BOOLEAN DEFAULT TRUE 
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),      
    restaurante_id INTEGER REFERENCES restaurantes(id), 
    entregador_id INTEGER REFERENCES entregadores(id),  
    status VARCHAR(50) DEFAULT 'pendente',              
    endereco_entrega TEXT NOT NULL                     
);

CREATE TABLE itens_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INTEGER REFERENCES pedidos(id),
    prato_id INTEGER REFERENCES pratos(id),
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10, 2) NOT NULL
);

CREATE TABLE registro_pedidos (
    id SERIAL PRIMARY KEY,
    pedido_id INTEGER,
    operacao VARCHAR(10),
    data_hora TIMESTAMP DEFAULT now()
);

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

--funções
CREATE OR REPLACE FUNCTION contar_pedidos_usuario(usuario_id_param INTEGER)
RETURNS INTEGER
LANGUAGE sql
AS $$
    SELECT COUNT(*) FROM pedidos WHERE usuario_id = usuario_id_param;
$$;
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION listar_pratos_disponiveis()
RETURNS TABLE(id INTEGER, nome VARCHAR, preco NUMERIC)
LANGUAGE sql
AS $$
    SELECT id, nome, preco FROM pratos WHERE disponivel = TRUE;
$$;
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION obter_preco_prato(prato_id_param INTEGER)
RETURNS NUMERIC
LANGUAGE sql
AS $$
    SELECT preco FROM pratos WHERE id = prato_id_param;
$$;
----------------------------------------------------------------------

--Triggers
CREATE OR REPLACE FUNCTION funcao_trigger_auditar_pedidos()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO registro_pedidos (pedido_id, operacao, data_hora)
    VALUES (NEW.id, TG_OP, now());
    RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_auditar_pedidos
AFTER INSERT OR UPDATE OR DELETE ON pedidos
FOR EACH ROW EXECUTE FUNCTION funcao_trigger_auditar_pedidos();
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION funcao_trigger_deletar_itens_do_pedido()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM itens_pedido WHERE pedido_id = OLD.id;
    RETURN OLD;
END;
$$;

CREATE TRIGGER trigger_deletar_itens_apos_exclusao_pedido
AFTER DELETE ON pedidos
FOR EACH ROW EXECUTE FUNCTION funcao_trigger_deletar_itens_do_pedido();
----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION funcao_trigger_bloquear_exclusao_entregador_com_pedidos_ativos()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pedidos 
        WHERE entregador_id = OLD.id AND status <> 'finalizado'
    ) THEN
        RAISE EXCEPTION 'Não é permitido excluir entregador com pedidos ativos.';
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER trigger_bloquear_exclusao_entregador_com_pedidos_ativos
BEFORE DELETE ON entregadores
FOR EACH ROW EXECUTE FUNCTION funcao_trigger_bloquear_exclusao_entregador_com_pedidos_ativos();
----------------------------------------------------------------------

--indices
CREATE INDEX idx_usuarios_email ON usuarios(email);

CREATE INDEX idx_pratos_restaurante_id ON pratos(restaurante_id);

CREATE INDEX idx_pedidos_restaurante_status ON pedidos(restaurante_id, status);

CREATE INDEX idx_pedidos_usuario_id ON pedidos(usuario_id);

CREATE INDEX idx_itens_pedido_pedido_id ON itens_pedido(pedido_id);







