SELECT * FROM account;
SELECT * FROM client;
SELECT * FROM creditcard;
SELECT * FROM demograph;
SELECT * FROM disposition;
SELECT * FROM transactions;
----------------------------------------------------------------

CREATE TEMPORARY TABLE loan_table AS
						(SELECT *,
						(amount-payments) AS resto,
						CAST(payments AS FLOAT)/CAST(amount AS FLOAT)*100 AS resto_per
						FROM loan
						WHERE status='D'
						ORDER BY resto_per, resto DESC, date DESC);

SELECT loan_table.account_id, client_id, disposition.disp_id, creditcard.type
		,date ,amount, duration, payments, status, resto, resto_per
FROM loan_table
INNER JOIN disposition ON loan_table.account_id=disposition.account_id
LEFT JOIN creditcard ON disposition.disp_id=creditcard.disp_id;

--Foi feito um filtro dos clientes que fizerem o emprestimo e esta em stuacao 'D' que passou o vencimento do contrato
--e ainda nao conseguiu pagar o emprestimo. analisando a tabela a porcentagem de saldo empresitmo variava de 1.76~8%
--maioria nao conseguiu pagar nem 5%. 
--acao necessaria:
--primeira acao necessaria e entrar em contato com cada cliente(45 clientes), tendo um aviso amigavel antes de colocar
--o cliente em nome sujo.
-- se o cliente nao estiver condicao para pagar, ate seria possivel ter uma negociacao diminuindo os juros que foi acumulado
-- para incentivar a quitar o emprestimo.

---------------------------------------------
--1
SELECT disposition.disp_id, creditcard.type, disposition.client_id, disposition.account_id,
       loan.date, loan.amount, loan.payments,loan.status
FROM creditcard
INNER JOIN disposition ON creditcard.disp_id=disposition.disp_id
LEFT JOIN loan ON disposition.account_id=loan.account_id
WHERE creditcard.type='gold' and loan.amount is NULL;

--analisando as pessoas que nunca pegou um emprestimo entre os clientes com cartao de credito gold
--ofereceria um emprestimo com juro baixo.
--uma pessoa que tem cartao gold, pode significar que nao precisa de empresimo, mas tambem pode ser pelo fato
--de nao conhecer sobre o emprestimo.
---------------------------------------------
--2
CREATE TEMPORARY TABLE withdrawal AS 
								(WITH acc_withdrawal AS (SELECT account_id, operation, ROUND(SUM(amount)) AS sum_amount
														FROM transactions
														WHERE operation='Withdrawal in cash'
														GROUP BY account_id, operation
														ORDER BY sum_amount DESC)

								SELECT acc_withdrawal.account_id, operation, sum_amount, creditcard.type
								FROM acc_withdrawal
								INNER JOIN disposition ON acc_withdrawal.account_id=disposition.account_id
								LEFT JOIN creditcard ON disposition.disp_id=creditcard.disp_id
								WHERE disposition.type='OWNER');

CREATE TEMPORARY TABLE credit AS 
								(WITH acc_withdrawal AS (SELECT account_id, operation, ROUND(SUM(amount)) AS sum_amount
														FROM transactions
														WHERE operation='Credit in cash'
														GROUP BY account_id, operation
														ORDER BY sum_amount DESC)

								SELECT acc_withdrawal.account_id, operation, sum_amount, creditcard.type
								FROM acc_withdrawal
								INNER JOIN disposition ON acc_withdrawal.account_id=disposition.account_id
								LEFT JOIN creditcard ON disposition.disp_id=creditcard.disp_id
								WHERE disposition.type='OWNER');

SELECT credit.account_id, credit.type,credit.operation, credit.sum_amount, withdrawal.operation, withdrawal.sum_amount,
		(credit.sum_amount-withdrawal.sum_amount) AS balance
FROM credit
INNER JOIN withdrawal ON credit.account_id=withdrawal.account_id
ORDER BY balance;
-------------------------
--Analisando transacao de entrada e saida de cash na conta.
--Obteria porque essas retiradas para cada cliente, e ofereceria uma poupanca melhor para que
--o cliente deixe seu dinheiro na conta
--para o banco quanto mais dinheiro no bano eh melhor.

