-- How many rolls were ordered
SELECT COUNT(*) AS rolls_ordered FROM customer_orders;

-- How many unique customer orders were made
SELECT COUNT(*) FROM (SELECT customer_id,roll_id FROM customer_orders GROUP BY customer_id,roll_id)a;

-- How many unique customers made order

SELECT COUNT(DISTINCT(customer_id)) FROM customer_orders;


-- How many successful orders were delivered by each driver

SELECT driver_id,COUNT(DISTINCT(order_id)) as successful_order FROM driver_order WHERE cancellation not in ('Cancellation', 'Customer Cancellation') group by driver_id;

-- How many of each type of role was delivered

SELECT c.roll_id,COUNT(c.roll_id) as Rolltype FROM customer_orders c JOIN driver_order d ON c.order_id=d.order_id WHERE d.cancellation not in ('Cancellation', 'Customer Cancellation') GROUP BY c.roll_id;

-- How many Veg and Non veg Rolls were ordered by each customer
SELECT 
    COALESCE(a.customer_id, b.customer_id) AS customer_id,  -- To handle NULLs from FULL JOIN
    ISNULL(a.NonVegRoll, 0) AS NonVegRoll, 
    ISNULL(b.VegRoll, 0) AS VegRoll
FROM
    (SELECT customer_id, COUNT(roll_id) AS NonVegRoll 
     FROM customer_orders 
     WHERE roll_id = 1 
     GROUP BY customer_id) a
FULL OUTER JOIN
    (SELECT customer_id, COUNT(roll_id) AS VegRoll 
     FROM customer_orders 
     WHERE roll_id = 2 
     GROUP BY customer_id) b
ON a.customer_id = b.customer_id;

-- What is the maximum number of rolls delivered in a single order

SELECT TOP 1 order_id,COUNT(roll_id) AS count_roll FROM customer_orders GROUP BY order_id ORDER BY count_roll DESC;

-- For all the roles delivered, how many rolls had atleast one change and how many had no changes at all 
WITH temp_customer_order AS (
    SELECT order_id,
           customer_id,
           roll_id,
           CASE WHEN not_include_items IS NULL OR not_include_items = ' ' THEN '0' ELSE not_include_items END AS new_not_included_items,
           CASE WHEN extra_items_included IS NULL OR extra_items_included = ' ' OR extra_items_included = 'NaN' THEN '0' ELSE extra_items_included END AS new_extra_items_included,
           order_date
    FROM customer_orders
),
driver_order_tables AS (
    SELECT order_id,
           driver_id,
           pickup_time,
           distance,
           duration,
           CASE WHEN cancellation IN ('Cancellation', 'Customer Cancellation') THEN 0 ELSE 1 END AS new_cancellation
    FROM driver_order
)

-- Perform the final select using both CTEs
SELECT COUNT(t.roll_id) AS Atleastonechange
FROM temp_customer_order t
JOIN driver_order_tables d ON t.order_id = d.order_id
WHERE d.new_cancellation = 1 
  AND (t.new_not_included_items != '0' OR t.new_extra_items_included != '0');

-- How many rolls were delivered that had both exclusions and extras

WITH temp_order_table(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date) AS
(
SELECT order_id,customer_id,roll_id, CASE WHEN not_include_items IS NULL OR not_include_items=' ' THEN '0' ELSE not_include_items END AS new_not_include_items,
CASE WHEN extra_items_included IS NULL OR extra_items_included = ' ' OR extra_items_included = 'NaN' THEN '0' ELSE extra_items_included END AS new_extra_items_included,order_date
FROM customer_orders)

SELECT * FROM temp_order_table WHERE not_include_items!='0' and extra_items_included!='0';

-- What were the total numbers of rolls ordered for each hour of the day
SELECT hours_bucket,count(hours_bucket) as count_hour FROM
(SELECT *,concat(cast(datepart(hour,order_date) as varchar),'-', cast(datepart(hour,order_date)+1 as varchar)) hours_bucket FROM customer_orders) a GROUP BY hours_bucket ORDER BY count_hour DESC;

-- What was the number of orders for each day of the week
SELECT dow, COUNT(DISTINCT(order_id)) FROM
(SELECT *, DATENAME(dw,order_date) dow FROM customer_orders) a GROUP BY dow;

-- What was the average time in minutes it took for each customer to arrive at Fassoos HQ to pickup the order
-- To do this we would have to calculate difference between order time and the time at which the order was picked up
SELECT driver_id, sum(diff)/count(order_id) FROM
(SELECT * FROM
(SELECT *, row_number() over(partition by order_id order by diff ) rnk FROM 
(SELECT a.order_id,
       a.customer_id,
       a.roll_id,
       a.not_include_items,
       a.extra_items_included,
       a.order_date,
       b.driver_id,
       b.pickup_time,
       b.distance,
       b.duration,
       b.cancellation,
	   datediff(minute,a.order_date,b.pickup_time) diff
FROM customer_orders a
JOIN driver_order b ON a.order_id = b.order_id
WHERE b.pickup_time IS NOT NULL) a) b WHERE rnk=1) c GROUP BY driver_id;

-- IS there a relationship between number of rolls and how long the order takes to prepare
SELECT order_id,COUNT(roll_id) as num_rolls,SUM(diff) as total_time FROM
(SELECT a.order_id,
       a.customer_id,
       a.roll_id,
       a.not_include_items,
       a.extra_items_included,
       a.order_date,
       b.driver_id,
       b.pickup_time,
       b.distance,
       b.duration,
       b.cancellation,
	   datediff(minute,a.order_date,b.pickup_time) diff
FROM customer_orders a
JOIN driver_order b ON a.order_id = b.order_id
WHERE b.pickup_time IS NOT NULL AND b.pickup_time>a.order_date) a GROUP BY order_id;


--What was the avergae distance travelled for each customer
SELECT customer_id,AVG(distance_in_km) as Avg_distance_travelled FROM
(SELECT a.order_id,
       a.customer_id,
       a.roll_id,
       a.not_include_items,
       a.extra_items_included,
       a.order_date,
       b.driver_id,
       b.pickup_time,
       CASE 
           WHEN b.distance IS NOT NULL AND b.distance LIKE '%km%' THEN	
               TRY_CAST(REPLACE(b.distance, 'km', '') AS FLOAT)
           ELSE
               TRY_CAST(b.distance AS FLOAT)
       END AS distance_in_km,
       b.duration,
       b.cancellation
FROM customer_orders a
JOIN driver_order b ON a.order_id = b.order_id
WHERE b.pickup_time IS NOT NULL)c GROUP BY customer_id;

-- What is the difference between the longest and the shortest delivery time of all orders
SELECT max(new_duration)-min(new_duration) AS Time_Difference FROM
(SELECT driver_id,
       pickup_time,
       distance,
       CASE 
           WHEN duration IS NOT NULL 
           THEN TRY_CAST(TRIM(REPLACE(REPLACE(REPLACE(duration, 'minutes', ''), 'minute', ''), 'mins', '')) AS FLOAT)
           ELSE NULL -- Default to NULL if duration is NULL or non-numeric
       END AS new_duration,
       cancellation
FROM driver_order  
WHERE pickup_time IS NOT NULL) a;

-- What was the avergae speed of the driver
SELECT driver_id,AVG(distance_in_km/new_duration) as Speed FROM
(SELECT a.order_id,
       a.customer_id,
       a.roll_id,
       a.not_include_items,
       a.extra_items_included,
       a.order_date,
       b.driver_id,
       b.pickup_time,
       CASE 
           WHEN b.distance IS NOT NULL AND b.distance LIKE '%km%' THEN	
               TRY_CAST(REPLACE(b.distance, 'km', '') AS FLOAT)
           ELSE
               TRY_CAST(b.distance AS FLOAT)
       END AS distance_in_km,
       CASE 
           WHEN duration IS NOT NULL 
           THEN TRY_CAST(TRIM(REPLACE(REPLACE(REPLACE(duration, 'minutes', ''), 'minute', ''), 'mins', '')) AS FLOAT)
           ELSE NULL -- Default to NULL if duration is NULL or non-numeric
       END AS new_duration,
       b.cancellation
FROM customer_orders a
JOIN driver_order b ON a.order_id = b.order_id
WHERE b.pickup_time IS NOT NULL) c GROUP BY driver_id;
