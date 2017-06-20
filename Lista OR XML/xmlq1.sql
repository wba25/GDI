/*

Adicione um campo ao tipo medicamento com o tipo XMLTYPE que guarda se um recepcionista já foi o recepcionista do mês pelo
menos uma vez ou não (Sim/Nao). Mude o povoamento utilizando a função createXML de forma que somente os recepcionistas
que já realizaram algum agendamento de exame tenham sido recepcionista do mês e todos os restantes nunca tenham sido. Em
seguida, faça uma consulta utilizando a função extract() que retorna o nome dos recepcionistas (ordenados) que já foram

*/

--Adiciona coluna
ALTER TYPE tp_recepcionista ADD ATTRIBUTE was_receptionist_the_month SYS.XMLTYPE CASCADE;

--Set todas as recepcionista com 'não'
DECLARE
    CURSOR c_recep IS SELECT id FROM tb_recepcionista;
    id_temp tb_recepcionista.id%TYPE;
BEGIN
    OPEN c_recep;
    LOOP
        EXIT WHEN c_recep%notfound;
        FETCH c_recep INTO id_temp;
        UPDATE tb_recepcionista
        SET was_receptionist_the_month = SYS.xmltype.createxml('<RECEPCIONISTA_DO_MES>Nao</RECEPCIONISTA_DO_MES>')
        WHERE id = id_temp;
    END LOOP;
    CLOSE c_recep;
END;
/

--Certifica as recepcionista que são funcionarias do mês com sim
DECLARE
    CURSOR c_recep IS SELECT DISTINCT r.id FROM tb_recepcionista r
                      INNER JOIN tb_agenda_exame aex
                      ON aex.recepcionista.id = r.id;
    id_temp tb_recepcionista.id%TYPE;
BEGIN
    OPEN c_recep;
    LOOP
        EXIT WHEN c_recep%notfound;
        FETCH c_recep INTO id_temp;
        UPDATE tb_recepcionista
        SET was_receptionist_the_month = SYS.xmltype.createxml('<RECEPCIONISTA_DO_MES>Sim</RECEPCIONISTA_DO_MES>')
        WHERE id = id_temp;
    END LOOP;
    CLOSE c_recep;
END;
/

--Consulta para verificar
SELECT r.nome, r.was_receptionist_the_month.extract('/RECEPCIONISTA_DO_MES/text()').getStringVal() as FunDoMes FROM tb_recepcionista r;
--WHERE r.was_receptionist_the_month.extract('/RECEPCIONISTA_DO_MES/text()').getStringVal() = 'Sim'      
