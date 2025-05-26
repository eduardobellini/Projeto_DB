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
    descricao TEXT,
    endereco TEXT NOT NULL,
    telefone VARCHAR(20),
    cnpj VARCHAR(18) UNIQUE 
);

CREATE TABLE pratos (
    id SERIAL PRIMARY KEY,
    restaurante_id INTEGER REFERENCES restaurantes(id), 
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10, 2) NOT NULL, 
    disponivel BOOLEAN DEFAULT TRUE
);

CREATE TABLE entregadores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    veiculo VARCHAR(50),
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