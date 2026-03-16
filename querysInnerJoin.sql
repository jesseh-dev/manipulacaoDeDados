/* TAREFA 1 

Criar um aluguel de equipamento para o mês de novembro (qualquer data e hora), qualquer equipamento, qualquer 
funcionário e qualquer cliente, mas cujo pagamento não tenha sido feito (ficou em aberto).*/

INSERT INTO aluguel (idCliente, idFuncionario, dataHoraRetirada, dataHoraDevolucao, valorAPagar, valorPago, pago, formaPagamento, qtVezes)
VALUES 
(8,2,'2026-11-25 15:00','2026-11-25 17:00','3,00','3,00',0,NULL,NULL)

INSERT INTO aluguelequipamento (idEquipamento, idAluguel, valorItem, valorUnitario, qtd)
VALUES
(5,7,'3.00','1.50',1)

UPDATE  equipamento
SET qtd = 29
WHERE idEquipamento=5 

UPDATE  aluguel
SET valorPago = 0
WHERE idAluguel=7 

/* TAREFA 2

Listar nome de todos os funcionários, cpf e os aluguéis feitos por ele (apenas a data e que equipamento alugou). */

SELECT funcionario.nomeFuncionario AS 'Funcionário', 
funcionario.cpfFuncionario AS 'CPF', 
aluguel.dataHoraRetirada AS 'Hora Retirada', 
aluguel.dataHoraDevolucao AS 'Hora Devolucao', 
equipamento.nomeEquipamento AS 'Equipamento'

FROM funcionario
INNER JOIN aluguel
ON funcionario.idFuncionario = aluguel.idFuncionario
INNER JOIN aluguelequipamento 
ON aluguel.idAluguel = aluguelequipamento.idAluguel
INNER JOIN equipamento
ON equipamento.idEquipamento = aluguelequipamento.idEquipamento

/* TAREFA 3

Listar nome do cliente, cpf, datas que ele esteve na praia, quem atendeu este
cliente, tudo isto, ordenado por data, da mais nova para a mais antiga, apenas no mês de DEZ24.*/

SELECT cliente.nomeCliente AS 'Cliente', 
cliente.cpfCliente AS 'CPF',
aluguel.dataHoraRetirada AS 'Hora Retirada', 
aluguel.dataHoraDevolucao AS 'Hora Devolucao',
funcionario.nomeFuncionario AS 'Funcionário'
FROM aluguel
INNER JOIN cliente
ON aluguel.idCliente = cliente.idCliente 
INNER JOIN funcionario
ON aluguel.idFuncionario = funcionario.idFuncionario
WHERE aluguel.dataHoraRetirada BETWEEN	'2024-12-01 00:00:00' AND '2024-12-31 23:59:59'
ORDER BY aluguel.dataHoraRetirada DESC;

/* TAREFA 4

Lista do nome dos equipamentos que foram mais alugados em ordem decrescente, do equipamento mais alugado para o menos alugado.
 Equipamentos não alugados devem sair no relatório. */

SELECT equipamento.nomeEquipamento AS 'Equipamento',
 	COUNT(aluguelequipamento.idEquipamento) AS 'TotalAlugado'
FROM equipamento
	left JOIN aluguelequipamento
ON aluguelequipamento.idEquipamento=equipamento.idEquipamento 
GROUP BY equipamento.nomeEquipamento
ORDER BY TotalAlugado DESC;

/* TAREFA 5

Listar a arrecadação bruta da barraca de praia entre Natal e Ano Novo.*/

SELECT SUM(valorPago) AS 'Valor Bruto'
FROM aluguel
WHERE dataHoraRetirada BETWEEN '2024-12-25 00:00:00' AND '2025-01-01 23:59:59'

/* TAREFA 6

Reajustar preço por hora de todos os equipamentos em 10%.*/

UPDATE equipamento
SET valorHora = valorHora * 1.10

SELECT * FROM equipamento

/* TAREFA 7

Listar a quantidade de clientes que pagaram utilizando determinada forma de pagamento, em ordem crescente,
 do método mais usado para o menos usado. Também é necessário que pagamentos não realizados sejam apontados. */
 
  
/* A função IFNULL() é utilizada para verificar se o campo formaPagamento está NULL.*/

SELECT * FROM aluguel
select IFNULL(formaPagamento,'Não realizado') AS formaPagamento,
COUNT(idCliente) AS qtdClientes
FROM aluguel 
GROUP BY formaPagamento
ORDER BY qtdClientes DESC


/* TAREFA 8

Listar quanto a barraca faturou por dia, em cada um dos dias do mês de dezembro apenas. */

SELECT DATE(dataHoraRetirada) AS Dia,
SUM(valorPago) AS Faturamento
FROM aluguel
Where dataHoraRetirada BETWEEN '2024-12-01 00:00:00' AND '2024-12-31 23:59:59'
GROUP BY dia
ORDER BY dia
 
/* TAREFA 9

Excluir o aluguel e todas as referências a ele criadas no item 1. 
Se tentar excluir direto da tabela aluguel teremos um problema? Por que isto ocorre?
Como resolver (escrever o código usado)?*/

/* No exercício 1 foi feito um update nas tabelas aluguel e aluguelequipamento. 
Para excluir os registros, é preciso primeiro apagar os dados da tabela aluguelequipamento e depois da tabela aluguel,
para não quebrar a integridade do banco de dados. Caso contrário, o sistema não permite fazer a exclusão. */

SELECT * FROM aluguelequipamento
SELECT * FROM aluguel
 
DELETE FROM aluguelequipamento
WHERE idAluguelEquipamento = 4
 
DELETE FROM aluguel
WHERE idAluguel = 7

/* TAREFA 10

Listar todos os equipamentos que tiveram a quantidade de aluguéis inferiores a 5 unidades, durante o mês de DEZ24. */

SELECT 
    equipamento.nomeEquipamento,
    COUNT(aluguelequipamento.idAluguel) AS qtdAlugueis
FROM equipamento
LEFT JOIN aluguelequipamento 
    ON aluguelequipamento.idEquipamento = equipamento.idEquipamento
LEFT JOIN aluguel 
    ON aluguel.idAluguel = aluguelequipamento.idAluguel
WHERE aluguel.dataHoraRetirada BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY equipamento.nomeEquipamento
HAVING COUNT(aluguelequipamento.idAluguel) < 5
ORDER BY qtdAlugueis