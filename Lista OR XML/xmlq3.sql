/*

Utilizando SYS_XMLGEN gere os nomes das recepcionistas que agendaram  os exames que o médico do consultório 13 prescreveu.

*/

SELECT SYS_XMLGEN(r.nome) as XML FROM tb_recepcionista r
    INNER JOIN tb_agenda_exame aex
    ON aex.recepcionista.id = r.id
    INNER JOIN tb_exame ex
    ON aex.exame.id = ex.id
    INNER JOIN tb_prescreve pre
    ON pre.produto.id = ex.id
    INNER JOIN tb_medico m
    ON m.crm = pre.medico.crm
WHERE m.consultorio.numero = 13;
