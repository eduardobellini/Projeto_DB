# Projeto_DB

**Curso:** Sistemas para Internet-Manhã

**Disciplina:** Banco de Dados Avançado

**Professor:** Aramis

**Período:** 3°Período

**Grupo**: Sistema de delivery de refeições

**Integrantes**:Eduardo Bellini, Nadson Paulo, Marcos Winicyus, Gabriel Costa

## Objetivo Geral
Nós do grupo do sistema de delivery de refeições fizemos um banco de dados
de acordo com a porposta e desenvolvemos melhorias e automatizações para
uma consulta mais eficiente e eficaz no momento de pesquisa de alguma entidade ou atributo, 
usando o progrma PGadmin 4.

## Estrutura do banco 

Projeto do Banco
│
├── 📁 Tables/
│   ├── 001_create_tables.sql
│   ├── 002_create_indices.sql
│   ├── 003_create_triggers.sql
│   ├── 004_create_procedures.sql
│   ├── 005_create_functions.sql
│
├── 📁 scripts/
│   ├── select_media_preco_restaurante.sql
│   ├── select_total_pedidos_por_usuario.sql
│   ├── select_restaurantes_com_pratos_disponiveis.sql
│   ├── select_restaurantes_sem_pratos.sql
│   ├── select_usuarios_com_mais_de_um_pedido.sql
│   ├── select_join_pedidos_usuarios_restaurantes.sql
│   ├── select_left_join_restaurantes_pratos.sql
│   ├── select_right_join_restaurantes_pratos.sql
│   ├── select_full_join_restaurantes_pratos.sql
│   ├── select_aggregated_pedidos_restaurantes.sql
│
├── 📁 procedures/
│   ├── listar_pedidos.sql
│   ├── buscar_pedidos.sql
│   ├── atualizar_status_pedido.sql
│
├── 📁 functions/
│   ├── contar_pedidos_usuario.sql
│   ├── listar_pratos_disponiveis.sql
│   ├── obter_preco_prato.sql
│
├── 📁 triggers/
│   ├── funcao_trigger_auditar_pedidos.sql
│   ├── trigger_auditar_pedidos.sql
│   ├── funcao_trigger_deletar_itens_do_pedido.sql
│   ├── trigger_deletar_itens_apos_exclusao_pedido.sql
│   ├── funcao_trigger_bloquear_exclusao_entregador_com_pedidos_ativos.sql
│   ├── trigger_bloquear_exclusao_entregador_com_pedidos_ativos.sql

