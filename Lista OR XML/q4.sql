/*

Crie uma function para o tipo paciente que retorna a idade do paciente. Considere que não existem anos bissextos. Use essa
function para fazer uma consulta que retorna os 3 pacientes mais jovens, juntamente com suas idades. Use a função MAP.

*/

ALTER TYPE tp_paciente ADD MAP MEMBER FUNCTION getIdade RETURN INTEGER CASCADE;
/

CREATE OR REPLACE TYPE BODY tp_paciente AS
	MAP MEMBER FUNCTION getIdade RETURN INTEGER IS
	year number(4);
	BEGIN	
		year := TO_NUMBER(TO_CHAR(sysdate,'yyyy'))-TO_NUMBER(TO_CHAR(data_nascimento,'yyyy'));
		IF TO_NUMBER(TO_CHAR(sysdate,'mm')) < TO_NUMBER(TO_CHAR(data_nascimento,'mm')) THEN
			RETURN year-1;
		ELSE 
			IF TO_NUMBER(TO_CHAR(sysdate,'mm')) = TO_NUMBER(TO_CHAR(data_nascimento,'mm')) THEN
				IF TO_NUMBER(TO_CHAR(sysdate,'dd')) >= TO_NUMBER(TO_CHAR(data_nascimento,'dd')) THEN
					RETURN year; 
				ELSE RETURN year-1;
				END IF;
			ELSE 
				RETURN year;
			END IF; 
		END IF;
	END;

END;
/

-- consulta
SELECT name, age FROM 
	(SELECT p.nome as name, p.getIdade() as age
	FROM tb_paciente p ORDER BY p.getIdade())
WHERE ROWNUM <= 3;