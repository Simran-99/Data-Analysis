-- What is the total amount each customer spent on Zomato

SELECT s.userid,SUM(p.price) AS AmountSpent from SALES s JOIN product p ON s.product_id=p.product_id GROUP BY s.userid;

-- How Many days have each customer visited Zomato

SELECT userid,COUNT(DISTINCT(created_date)) FROM sales GROUP BY userid;

-- What was the first product purchased by each of the customer

SELECT s.userid,p.product_name FROM (SELECT *,rank() over(partition by userid order by created_date) rnk from sales) s JOIN product p ON s.product_id=p.product_id WHERE rnk=1;

-- What is the most purchased item and how many times was it purchased by all the customers
SELECT userid, count(product_id) cnt FROM sales WHERE product_id=
(SELECT top 1 product_id FROM sales GROUP BY product_id ORDER BY COUNT(product_id) DESC) GROUP BY userid;

-- Which Item was most popular for each of the customer
SELECT *, 
       RANK() OVER (PARTITION BY userid ORDER BY cnt DESC) AS rnk 
FROM (
    SELECT userid, product_id, COUNT(product_id) AS cnt 
    FROM sales 
    GROUP BY userid, product_id
) AS subquery_alias;

-- What item was first purchased by the customer after they became member
SELECT * FROM 
(SELECT s.userid,s.created_date,s.product_id, RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date) rnk FROM sales s JOIN goldusers_signup g ON s.userid=g.userid WHERE s.created_date>=g.gold_signup_date) AS a WHERE rnk=1;

-- Which item was purchased just before the customer became a member
SELECT * FROM
(SELECT * ,RANK() OVER(PARTITION BY userid ORDER BY created_date DESC) rnk FROM
(SELECT s.userid, s.created_date,s.product_id FROM sales s JOIN goldusers_signup g ON s.userid=g.userid WHERE s.created_date<g.gold_signup_date) as A) as B WHERE rnk=1;

-- What is the total orders and amount spent for each member before they became a member

SELECT s.userid, COUNT(s.userid) AS product_count, SUM(p.price) AS amt_spent FROM sales s JOIN product p ON s.product_id=p.product_id
JOIN goldusers_signup g
ON s.userid=g.userid
WHERE s.created_date<g.gold_signup_date
GROUP BY s.userid;

-- If buying each product generates points . Foe example 5 rs = 2 Zomato Points and each product has different purchasing points for ef: 5 rs= 1point for p2 10 rs= 5 zomato points
-- and p3 5rs= 1zomato point
-- Calculate points collected by each customer and for which product most points have been given so far
SELECT e.*,total_price/point as total_points FROM (SELECT d.*, 
    CASE 
        WHEN d.product_id = 1 THEN 5 
        WHEN d.product_id = 2 THEN 2 
        WHEN d.product_id = 3 THEN 5 
        ELSE 0 
    END AS point 
FROM (
    SELECT 
        c.userid, 
        c.product_id, 
        SUM(c.price) AS total_price  -- Use c.price since 'price' comes from the inner subquery
    FROM (
        SELECT 
            a.userid,    -- Ensure userid is selected from sales
            a.product_id, 
            b.price 
        FROM 
            sales a 
        JOIN 
            product b ON a.product_id = b.product_id
    ) c
    GROUP BY 
        c.userid, 
        c.product_id
) d)e;


-- In the first one year after a customer joins gold program (including their join date) irrespective of what customer has purchased, the customer earns 5 Zomato points . Who earned more and what was their earning in the first year

SELECT s.userid,s.created_date,s.product_id,p.price,(p.price/10)*5 as pnt FROM sales s
JOIN
product p 
ON s.product_id=p.product_id
JOIN 
goldusers_signup g
ON s.userid=g.userid
WHERE s.created_date>=g.gold_signup_date and s.created_date<=DATEADD(year,1,gold_signup_date);

--Rank all the transactions of the customer

SELECT *, DENSE_RANK() OVER(PARTITION BY s.userid ORDER BY s.created_date) rnk FROM SALES s;

-- Rank the transaction of the customer where they are gold member and when they are not gold member, the transaction should be marked as na
SELECT c.*,CASE WHEN gold_signup_date is NULL then 0 ELSE rank() OVER(PARTITION BY userid ORDER BY created_date DESC) end as rnk FROM
(SELECT s.userid,s.created_date,s.product_id, g.gold_signup_date FROM sales s LEFT JOIN goldusers_signup g ON s.userid=g.userid and s.created_date>=g.gold_signup_date)c;