SELECT * FROM account;
SELECT * FROM client;
SELECT * FROM creditcard;
SELECT * FROM demograph;
SELECT * FROM disposition;
SELECT * FROM transactions;

---------------------------------------------
--Good cliente
--1
SELECT disposition.disp_id, creditcard.type, disposition.client_id, disposition.account_id,
       loan.date, loan.amount, loan.payments,loan.status
FROM creditcard
INNER JOIN disposition ON creditcard.disp_id=disposition.disp_id
LEFT JOIN loan ON disposition.account_id=loan.account_id
WHERE creditcard.type='gold' and loan.amount is NULL;


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

SELECT *
FROM
	(SELECT credit.account_id, credit.type,credit.operation, credit.sum_amount, withdrawal.operation, withdrawal.sum_amount,
			(credit.sum_amount-withdrawal.sum_amount) AS balance
	FROM credit
	INNER JOIN withdrawal ON credit.account_id=withdrawal.account_id
	ORDER BY balance) AS credit_balance
WHERE balance<0;


----------------------------------------------------------------
--Bad client
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


