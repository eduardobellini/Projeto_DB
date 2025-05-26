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
