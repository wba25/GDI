/*

O nome do paciente,descrição e diagnóstico dos pacientes que possuem pelo menos 2 produtos e sejam do plano de saúde
Hapvida.

*/

SELECT p.nome, cons.descricao, cons.diagnostico FROM tb_paciente p
	INNER JOIN tb_consulta cons
		ON cons.paciente.cpf = p.cpf
WHERE (SELECT COUNT(*) FROM TABLE(p.produtos)) >= 2
AND p.plano_de_saude = 'Hapvida';