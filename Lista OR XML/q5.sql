/*Crie um procedure para o tipo laboratório que imprime o id, o nome e o(s) telefone(s) do laboratório se
neste ocorreu um agendamento no mês passado como parâmetro, caso contrário levante uma exceção.*/

CREATE OR REPLACE PROCEDURE p_agendamento(data_horai IN TIMESTAMP) IS
id1 NUMBER(3);
nome1 VARCHAR2(200);
telefone1 VARCHAR2(20);
vEXCEPTION EXCEPTION;		

CURSOR cr_telefone IS SELECT * FROM tb_fone;
v_telefone cr_telefone%rowtype;

BEGIN
	OPEN cr_telefone;
	LOOP
	FETCH cr_telefone INTO v_telefone
	EXIT WHEN cr_telefone

BEGIN
	IF EXTRACT(MONTH FROM data_horai) = (EXTRACT(MONTH FROM CURRENT_TIMESTAMP) - 1) THEN
		SELECT l.id INTO id1, 
			   l.nome INTO nome1,
			   f.numero INTO telefone1
		FROM tb_laboratorio l, tb_agenda_exame a, tp_fone f
		WHERE
			   a.laboratorio = l.id AND
			   a.data_hora = data_horai;
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
