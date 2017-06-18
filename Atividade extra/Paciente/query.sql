-- Testa a função sys_xmlgen
-- SELECT SYS_XMLGEN(*) as XML FROM tb_paciente;

set serveroutput on;

DECLARE
    ctx dbms_xmlgen.ctxhandle;
    answer clob;
BEGIN
    -- criar um novo contexto para a consulta SQL
    ctx := dbms_xmlgen.newContext('SELECT p.cpf, p.nome as nome_completo, p.sexo, p.data_nascimento, p.plano_de_saude, p.fones as telefones, p.endereco, DEREF(value(produt)) as produto FROM tb_paciente p, TABLE(p.produtos) produt');
    -- personalizar as tags raiz e de entidade
    DBMS_XMLGEN.setRowsetTag(ctx, 'CLINICA');
    DBMS_XMLGEN.setRowTag(ctx,'PACIENTE');
    -- gerar um valor CLOB como resultado
    answer := dbms_xmlgen.getXML(ctx);
    -- dar saída do resultado
    dbms_output.put_line(answer);
    
    -- fechar o contexto
    dbms_xmlgen.closeContext(ctx);
END;
/
