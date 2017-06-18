/*

Utilizando bloco anônimo remova somente o primeiro telefone cujo pertence ao laboratório com id '10’’ e em seguida atualize o
telefone '’8121244270’' para '8187128686'.
Para testar faça uma consulta no telefone da tabela de laboratório com o laboratório com id '10’' .

*/

DECLARE
	array_aux tb_laboratorio.laboratorio_telefone%TYPE;
	array_out tp_fones := tp_fones();
	counter integer := 0;
BEGIN
	SELECT laboratorio_telefone INTO array_aux FROM tb_laboratorio
	WHERE id = 10;
	FOR i IN 1 .. array_aux.COUNT LOOP 
		IF i!=1 THEN
			counter := counter + 1;
			array_out.EXTEND;
			IF array_aux(i).numero = 8121244270 THEN
				array_out(counter) := tp_fone(8187128686);
			ELSE
				array_out(counter) := array_aux(i);	
			END IF;
			dbms_output.put_line(array_out(counter).numero);
		END IF;
   	END LOOP;
   	UPDATE tb_laboratorio
   	SET laboratorio_telefone = array_out
   	WHERE id = 10;
END;
/

SELECT laboratorio_telefone FROM tb_laboratorio
WHERE id = 10;
