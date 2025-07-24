create database BigBasket;
use BigBasket;
select * from customers;
select * from churn;
select * from subscriptions;
select * from transactions;

-- 1. total number of customers?
select distinct count(*) as Total_Number from customers;

-- 2. show the first name, last name and status of all customer
select FirstName,LastName,Status from customers;

-- 3. Retrive the data of customers from North America
select * from customers where Region = 'North America';

-- 4. Find out those customers whose status = Active
select count(*) from customers where Status = "Active";

-- 5. How many customers are there who joined 'jan-01-2001'
select count(*) from customers where JoinDate>'01-01-2001';


-- 6. List down the active customers from europe
select * from customers where Status = 'Active' and Region = 'Europe';

-- update date format:
SET SQL_SAFE_UPDATES=0;

UPDATE customers
SET JoinDate = STR_TO_DATE(JoinDate,'%d-%m-%Y')
WHERE JoinDate LIKE '%-%-%';

UPDATE transactions
SET TransactionDate = STR_TO_DATE(TransactionDate,'%d-%m-%Y')
WHERE TransactionDate LIKE '%-%-%';

-- 7. Find out how many customers had joined in year 2001.
select count(*) from customers where Year(JoinDate) = 2021 ;

-- 8. Count number of customers who are having email id containing 'example'.
select count(*) as example_count_email from customers where email LIKE '%example%';

-- 9. Retreive number of customer who are having annual subscription plan.
select count( distinct CustomerID) from subscriptions where PlanType = 'Annual'; 

-- 10. Retrive all transactions where the amount is greater than $100. 
select * from transactions where Amount > 100;

-- 11. calculate average amount of all transaction
select avg(amount) from transactions;


-- 12. Retrive all transaction along with first name,last name, transaction id , transaction amount
select c.FirstName,c.LastName,t.TransactionID,t.Amount 
from  customers c
join transactions t 
on c.CustomerID = t.CustomerID;

-- 13. Find out the 5 most recent transactions
select * from transactions
 order by TransactionDate desc 
limit 5;

-- 14. Retrive all reasons to churn
select distinct Reason from churn;

-- 15. List the churn reason and customer left by all the reasons
select count(*),Reason from churn 
group by Reason;

-- 16. retrive customerID, full name, email , plan type
select c.customerID, concat(c.firstName," ", c.LastName ) as FullName , c.email , s.PlanType from
customers c join
subscriptions s
 on c.customerID = s.customerID;
 
 -- 17. Retrive the active customers who have annual subscription
 select c.customerID, concat(c.FirstName," ",c.LastName) as FullName,c.Status, s.PlanType
 from customers c
 join subscriptions s on c.CustomerID = s.CustomerID
 where Status = "Active" and PlanType = "Annual";
 
 -- 18. List down the churn reasons & how many north american churn for same reason?
 select count(ch.Reason), c.region from churn ch join
 customers c on c.customerID = ch.customerID
 where c.Region="North America"
 group by ch.Reason;
 
 -- 19. How many customer churned but made a transactions?
 select count(*) as countoffall from churn ch
 join transactions t 
 on ch.CustomerID = t.CustomerID
 where t.TransactionID is NOT NULL;
 
 
 
-- 20. Retrive all customer who did not have any transaction with us 
select count(*) from customers c left join 
transactions t on c.CustomerID = t.CustomerID
where transactionid is null;



-- 21. Findout the customer who have more than 1 subscriptions.
with neha as (
select c.CustomerID, count(PlanType) from customers c
join  subscriptions s on 
c.CustomerID = s.CustomerId 
group by CustomerID
having count(PlanType)>1)
select count(*) from neha;


-- 22. How many transactions made in last 6 month.
SELECT COUNT(*) AS transactions_last_6_months
FROM transactions
WHERE DATEDIFF(CURDATE(), TransactionDate) <= 180;


-- 23. How many customers are there who do not have any subscription.
select count(customerID) from customers where customerid not in(select customerid from subscriptions);


 


  
 
 
 
 
 
