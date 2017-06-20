set serveroutput on;

DECLARE
    ctx dbms_xmlgen.ctxhandle;
    answer clob;
BEGIN
    -- criar um novo contexto para a consulta SQL
    ctx := dbms_xmlgen.newContext('SELECT l.id as codigo, l.nome as laboratorio_nome, l.laboratorio_endereco, l.laboratorio_telefone FROM tb_laboratorio l');
    -- personalizar as tags raiz e de entidade
    DBMS_XMLGEN.setRowsetTag(ctx, 'CLINICA');
    DBMS_XMLGEN.setRowTag(ctx,'LABORATORIO');
    -- gerar um valor CLOB como resultado
    answer := dbms_xmlgen.getXML(ctx);
    -- dar saída do resultado
    dbms_output.put_line(answer);
    
    -- fechar o contexto
    dbms_xmlgen.closeContext(ctx);
END;
/