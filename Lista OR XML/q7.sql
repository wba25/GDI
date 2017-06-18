/*

Usando uma member function para avaliar o desempenho das recepcionistas foi criada um score em que para cada agenda
exame em que que a recepcionista participou em janeiro a abril ganha 1 ponto. Se a recepcionista conseguir 2 ou mais pontos
retorne “Aprovada” caso contrário “Precisa Melhorar”. Faça uma consulta utilizando a member function recupere o nome da
recepcionista também.

*/

ALTER TYPE tp_recepcionista ADD MEMBER FUNCTION avaliarDesempenho RETURN varchar2 CASCADE;
/

CREATE OR REPLACE TYPE BODY tp_recepcionista AS
	MEMBER FUNCTION avaliarDesempenho RETURN varchar2 IS
		CURSOR c_recepcionista IS SELECT COUNT(*) FROM tb_recepcionista r 
			INNER JOIN tb_agenda_exame aex ON aex.recepcionista.id = r.id
			WHERE TO_NUMBER(TO_CHAR(aex.data_hora,'mm')) BETWEEN 01 AND 04
			AND r.id = TO_NUMBER(SELF.id);
		message varchar2(200);
		points integer(4);
	BEGIN
		OPEN c_recepcionista;
		IF c_recepcionista%NOTFOUND THEN
			points := 0;
		ELSE
			FETCH c_recepcionista INTO points;
		END IF;
		IF points>=2 THEN
			message := 'Aprovada';
		ELSE
			message := 'Precisa Melhorar';
		END IF;	
		CLOSE c_recepcionista;
		RETURN message;
	END;
END;
/

-- consulta
SELECT r.nome, r.avaliarDesempenho() FROM tb_recepcionista r; 