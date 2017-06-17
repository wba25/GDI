/*

Faça uma consulta que retorna o nome dos paciente, seu bairro e o diagnóstico da sua consulta, dado que esta consulta foi
realizada no mês de Abril e o plano de saúde do paciente seja Unimed. USE DEREF.

*/

SELECT p.nome, p.endereco.bairro, c.diagnostico FROM tb_paciente p
	INNER JOIN tb_consulta c
	ON DEREF(c.paciente).cpf = p.cpf
WHERE p.plano_de_saude = 'Unimed'
AND TO_CHAR(c.data_hora,'mm') = '04';