/*

Utilize DBMS_XMLGEN para criar um bloco XML cuja Rowset é Pacientes e a Rowtag é Paciente, e este bloco contém as
informações dos pacientes que já se consultaram com os médicos de telefones ‘11983544792’ e '11961959561' . Liste o cpf, nome
e plano de saúde destes pacientes.  

*/

set serveroutput on;

DECLARE
    ctx dbms_xmlgen.ctxhandle;
    result clob;
BEGIN
    ctx := dbms_xmlgen.newContext('SELECT DISTINCT p.cpf, p.nome, p.plano_de_saude FROM tb_paciente p
                                    INNER JOIN tb_consulta con
                                    ON con.paciente.cpf = p.cpf
                                    INNER JOIN tb_medico m
                                    ON con.medico.crm = m.crm
                                WHERE ''11983544792'' = ANY (SELECT T.numero FROM TABLE(SELECT med.fones FROM tb_medico med WHERE med.crm = m.crm)T)
                                OR ''11961959561'' = ANY (SELECT T.numero FROM TABLE(SELECT med.fones FROM tb_medico med WHERE med.crm = m.crm)T)');
    dbms_xmlgen.setRowsetTag(ctx, 'PACIENTES');
    dbms_xmlgen.setRowTag(ctx, 'PACIENTE');
    result := dbms_xmlgen.getXML(ctx);
    dbms_output.put_line(result);
END;
/
