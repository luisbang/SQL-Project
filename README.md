![image](https://user-images.githubusercontent.com/79090589/114392695-816cd300-9b6f-11eb-8b13-16c9465707fb.png)

# SQL Project - Improving the bank service solution

## 1. Problem

  The bank wants to improve their services. For instance, the bank managers have only vague idea,
  who is a good client (whom to offer some additional services) and who is a bad client
  (whom to watch carefully to minimize the bank loses).

  `A Turquia iniciou uma série de reformas nos anos 1980 com o objetivo de reorientar a economia de um sistema estatista e isolado para um modelo mais voltado para o setor privado. As reformas provocaram um crescimento econômico acelerado, embora com episódios de forte recessão e crises financeiras em 1994, 1999 e 2001.`
`A incapacidade de implementar reformas adicionais, combinada com déficits públicos elevados e crescentes e corrupção generalizada, resultou em inflação alta, volatilidade econômica e um setor bancário fraco.`
## 2. Solution
  
  **2.1 Good client**
  
  a) One of the ways the bank can earn money is through interest and loans.
     Filtering all customers who did not make a loan, and among them, was selected
     who has a credit card GOLD, to ensure that the person has the credit in the bank and is also able to repay the loan.
     After that, like the image below, all customers (72 customers) who never made a loan and, have a GOLD credit card were filtered
     
  ![image](https://user-images.githubusercontent.com/79090589/114393950-05738a80-9b71-11eb-919e-e3c610304dc9.png)
  
  *Suggested action*
  
  For these customers, I would offer a low-interest loan. Having a credit card gold  not only means that the customer does not need a loan, but it may be that the customer does not know this service yet.
    
  b) For a bank the more money in the bank is better. For that, the balance of incoming and outgoing customers' accounts (1,618 customers) was analyzed
  
  ![image](https://user-images.githubusercontent.com/79090589/114399778-aebd7f00-9b77-11eb-9ede-ff70684ee9f2.png)

  *Suggested action*
  
  First, it would need to obtain information on why they are withdrawing the cash (or if they are transferring to another bank).
  And i would offer better interest for the customer to keep the cash in the account
  

  **2.2 Bad client**
  
  a) An analysis was made of all clients who made a loan and passed the contract and still have not been able to repay the loan and are in debt (45 clients). analyzing the table, percentage of loan paid varied from 1.76 ~ 8%, most were unable to pay even 5%. 
  
  ![image](https://user-images.githubusercontent.com/79090589/114401023-eb3daa80-9b78-11eb-8c21-5db1bc89dbf7.png)
  
  
  *Suggested action*
  
  first necessary action is to contact each customer (45 customers), having a friendly notice before placing
the customer in a dirty name. If the customer is not able to pay, it would even be possible to have a negotiation decreasing the interest that has been accumulated to encourage the repayment of the loan to be able to receive all loans from customers
