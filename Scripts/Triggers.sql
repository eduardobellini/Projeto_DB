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