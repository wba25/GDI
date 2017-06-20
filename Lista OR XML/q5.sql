/*Crie um procedure para o tipo laboratório que imprime o id, o nome e o(s) telefone(s) do laboratório se
neste ocorreu um agendamento no mês passado como parâmetro, caso contrário levante uma exceção.*/

CREATE OR REPLACE PROCEDURE p_agendamento(data_hora_in TIMESTAMP) IS
id1 NUMBER(3);
nome1 VARCHAR2(200);
telefone1 VARCHAR2(20);
vEXCEPTION EXCEPTION;		

BEGIN
IF(month(data_hora_in) = month(current_timestamp - 1)) THEN
SELECT l.id INTO id1, 
	   l.nome INTO nome1,
	   l.laboratorio_telefone INTO telefone1
FROM tp_laboratorio l, tp_agenda_exame a
WHERE
	   a.laboratorio = l.id AND
	   a.data_hora = data_hora_in;
dbms_output.put_line(id1);
dbms_output.put_line(nome1);
dbms_output.put_line(telefone1);	   
ELSE
EXCEPTION
		WHEN vEXCEPTION THEN
			RAISE_APPLICATION_ERROR('-20999','ATENÇÃO! Mês inválido. Informe uma data do mês passado.', FALSE);
END IF;
END p_agendamento;
/
