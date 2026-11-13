use ecomm;
--➢ Calculate the total order amount hike from last year for customers who are single
and prefer mobile phones for ordering.
SELECT 
    SUM(OrderAmountHikeFromlastYear) AS Total_Hike
FROM customer_churn
WHERE MaritalStatus = 'Single'
  AND PreferredLoginDevice = 'Mobile Phone'; 
  
  --Find the average number of devices registered among customers who used UPI as
their preferred payment mode.

SELECT 
    AVG(NumberOfDeviceRegistered) AS Avg_Devices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI'; 

-- Determine the city tier with the highest number of customers.
SELECT 
    CityTier,
    COUNT(*) AS Total_Customers
FROM customer_churn
GROUP BY CityTier
ORDER BY Total_Customers DESC
LIMIT 1; 
--Identify the gender that utilized the highest number of coupons.

SELECT 
    Gender,
    SUM(CouponUsed) AS Total_Coupons
FROM customer_churn
GROUP BY Gender
ORDER BY Total_Coupons DESC
LIMIT 1; 

-- List the number of customers and the maximum hours spent on the app in each
preferred order category. 
use ecomm;
describe customer_churn; 
SELECT 
    PreferedOrderCat,
    COUNT(*) AS Number_of_Customers,
    MAX(HourSpendOnApp) AS Max_Hours
FROM customer_churn
GROUP BY PreferedOrderCat; 

--Calculate the total order count for customers who prefer using credit cards and
have the maximum satisfaction score. 
SELECT 
    SUM(OrderCount) AS Total_Order_Count
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn); 
  
 SELECT 
    AVG(SatisfactionScore) AS Avg_Satisfaction
FROM customer_churn
WHERE ComplaintReceived = 'Yes'; 

-- List the preferred order category among customers who used more than 5
coupons.
 SELECT PreferredOrderCat, COUNT(*) AS Number_of_Customers
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat; 

-- List the top 3 preferred order categories with the highest average cashback
amount. 
SELECT PreferredOrderCat, AVG(CashbackAmount) AS Avg_Cashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY Avg_Cashback DESC
LIMIT 3; 

--Find the preferred payment modes of customers whose average tenure is 10
months and have placed more than 500 orders. 

SELECT PreferredPaymentMode, ROUND(AVG(Tenure),2) AS Avg_Tenure, SUM(OrderCount) AS Total_Orders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) BETWEEN 9 AND 11 AND SUM(OrderCount) > 500; 

-- Categorize customers based on their distance from the warehouse to home such
as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km,
'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the churn status breakdown for each distance category.



show columns from customer_churn;

SELECT
CASE
  WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
  WHEN WarehouseToHome <= 10 THEN 'Close Distance'
  WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
  ELSE 'Far Distance'
END AS Distance_Category,
ChurnStatus,
COUNT(*) AS Number_of_Customers
FROM customer_churn
GROUP BY Distance_Category, ChurnStatus
ORDER BY Distance_Category, ChurnStatus; 

-- List the customer’s order details who are married, live in City Tier-1, and their
order counts are more than the average number of orders placed by all
customers.

SELECT *
FROM customer_churn
WHERE MaritalStatus = 'Married'
  AND CityTier = 1
  AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn); 
  
  Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the
following data:

  
  USE ecomm;

CREATE TABLE customer_returns (
  ReturnID INT PRIMARY KEY,
  CustomerID INT,
  ReturnDate DATE,
  RefundAmount DECIMAL(10,2)
);

INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990); 

USE ecomm;

SELECT * FROM customer_returns;

-- Display the return details along with the customer details of those who have
churned and have made complaints.

SELECT 
  cr.ReturnID,
  cr.ReturnDate,
  cr.RefundAmount,
  cc.*
FROM customer_returns cr
JOIN customer_churn cc
  ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
  AND cc.ComplaintReceived = 'Yes';