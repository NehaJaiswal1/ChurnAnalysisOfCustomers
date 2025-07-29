
use BigBasket;
select * from customers;
select * from churn;
select * from subscriptions;
select * from transactions;

-- 1. Identify the churn reasons and rank them by the count.
select c.region, ch.reason, dense_rank() over (partition by c.region order by count(*) desc) as count_reason from customers c 
join churn ch on
c.CustomerID = ch.CustomerID group by c.region, ch.reason order by c.region, count_reason ;

-- 2. For each month in 2024 , show the number of churn & total transaction value.
select date_format(t.transactiondate, '%Y-%m') as Month, count(distinct ch.customerid) as Churn_Count , 
sum(t.amount) as Total_Transactions
from transactions t left join churn ch on t.CustomerID = ch.CustomerID and date_format(t.transactiondate, '%Y-%m')
group by Month order by Month;

-- 3. Identify the customers who made purchase after their subscription ended.
select FirstName , LastName from customers where CustomerID in
(select distinct t.CustomerID from transactions t join subscriptions s on t.CustomerID = s.CustomerID 
where t.TransactionDate >s.EndDate AND t.TransactionType = 'Purchase');

-- 4. List down the customer name and dates if their subscription ended before they churned.
select c.FirstName , c.LastName , s.EndDate, ch.ChurnDate from customers c
join subscriptions s on c.CustomerID = s.CustomerID
join churn ch on ch.CustomerID = s.CustomerID;

-- 5. Calculate the churn rate (%) per plan type.
SELECT 
    s.PlanType,
    COUNT(s.CustomerID) AS total_customers,
    COUNT(c.ChurnDate) AS churned_customers,
    ROUND(COUNT(c.ChurnDate) * 100.0 / COUNT(s.CustomerID), 2) AS churn_rate_percent
FROM 
    Subscriptions s
LEFT JOIN 
    Churn c ON s.CustomerID = c.CustomerID
GROUP BY 
    s.PlanType;


-- 6. Find top 5 customers with the highest monthly spend (based on their purchases)
select CustomerID, round(sum(Amount) / count(distinct date_format(transactiondate, '%Y-%m')),2) 
as AverageMonthlySpend
From transactions where TransactionType = 'Purchase'
group by CustomerID order by AverageMonthlySpend DESC limit 5;

-- 7. For each month in 2024, show the total revenue from purchase 
SELECT 
    DATE_FORMAT(TransactionDate, '%Y-%m') AS PurchaseMonth,
    SUM(Amount) AS TotalRevenue
FROM 
    Transactions
WHERE 
    YEAR(PurchaseDate) = 2024
GROUP BY 
    DATE_FORMAT(PurchaseDate, '%Y-%m')
ORDER BY 
    PurchaseMonth;


















