# Data-Analysis

# Zomato Data Analysis Project

## Project Overview
This project involves analyzing a dataset inspired by Zomato's user, product, sales, and membership data. The dataset was created from scratch with four tables: **Gold Users Signup**, **Product**, **Users**, and **Sales**. Using SQL queries, various business insights were derived by exploring customer purchase behavior, membership impact, and product popularity.

## Dataset Description
The dataset consists of the following tables:

1. **Gold Users Signup Table**: Contains details of Zomato users with Gold membership, including:
   - `user_id`: Unique identifier for the user.
   - `gold_signup_date`: The date on which the Gold membership was purchased.

2. **Product Table**: Lists all available products on Zomato:
   - `product_id`: Unique identifier for the product.
   - `product_name`: Name of the product.
   - `price`: Price of the product.

3. **Users Table**: Stores user details:
   - `user_id`: Unique identifier for the user.
   - `signup_date`: The date when the user signed up for Zomato.

4. **Sales Table**: Represents sales transactions:
   - `user_id`: Unique identifier for the user.
   - `product_id`: Identifier of the purchased product.
   - `created_date`: Date of the transaction.

## Research Questions
The project aims to answer the following research questions using SQL queries:

1. **What is the total amount each customer spent on Zomato?**
   
2. **How many days has each customer visited Zomato?**
   
3. **What was the first product purchased by each customer?**
   
4. **What is the most purchased item and how many times was it purchased by all customers?**
   
5. **Which item was most popular for each customer?**
   
6. **What item was first purchased by the customer after they became a member?**
   
7. **Which item was purchased just before the customer became a member?**
   
8. **What is the total number of orders and the amount spent by each member before they became a Gold member?**
   
9. **How many points did each customer collect and for which product have the most points been given so far?**
   
10. **Who earned more points in the first year after joining the Gold program and what was their earning?**
   
11. **How are all customer transactions ranked?**
   
12. **How are customer transactions ranked when they are a Gold member versus when they are not?**

## Features Implemented
- A file is created to generate a synthetic dataset based on the Zomato structure.
- SQL queries were executed to answer key research questions and extract insights.

## Usage
To replicate the analysis, run the SQL queries provided in the `queries.sql` file on the dataset. The queries can be used for:
- Tracking user behavior.
- Analyzing product sales and membership impact.
- Understanding customer purchase patterns.

## Future Improvements
- Expanding the dataset to include more product categories and user behavior attributes.
- Creating visualizations to represent customer spending and product popularity trends.

## Conclusion
This project provides valuable insights into user interactions, purchase behaviors, and the impact of Zomato's Gold membership program through detailed SQL-based data analysis.


# Fassos Delivery Platform Data Analysis

## Overview
This project involves creating and analyzing a database to track orders, drivers, ingredients, and customer behavior on the Fassos platform. The schema consists of six tables: `driver`, `rolls`, `roll_recipes`, `ingredients`, `customer_orders`, and `driver_order`. The database stores information about drivers, customer orders, the ingredients used in the rolls, and how drivers handle deliveries. Several SQL queries are used to analyze the data, provide insights, and answer specific business questions.

## Database Schema
### 1. **driver**
This table stores information about drivers who have joined the Fassos platform.

- **driver_id**: Unique identifier for each driver.
- **reg_date**: The date the driver registered with the platform.

### 2. **rolls**
This table holds the types of rolls offered by Fassos.

- **roll_id**: Unique identifier for each roll.
- **roll_name**: The type of roll (e.g., Non-Veg Roll, Veg Roll).

### 3. **roll_recipes**
This table stores the ingredients used in each type of roll.

- **roll_id**: Roll identifier linked to the `rolls` table.
- **ingredients**: Comma-separated list of ingredient IDs used in the roll.

### 4. **ingredients**
This table contains all possible ingredients used in the rolls.

- **ingredients_id**: Unique identifier for each ingredient.
- **ingredients_name**: Name of the ingredient (e.g., Chicken, Cheese, BBQ Chicken).

### 5. **customer_orders**
This table stores customer orders along with details of any modifications to the rolls.

- **order_id**: Unique identifier for each order.
- **customer_id**: Identifier for the customer placing the order.
- **roll_id**: The roll ordered, linked to the `rolls` table.
- **not_include_items**: Ingredients removed from the roll.
- **extra_items_included**: Extra ingredients added to the roll.
- **order_date**: The date and time when the order was placed.

### 6. **driver_order**
This table tracks the details of the delivery process.

- **order_id**: Identifier for the order being delivered.
- **driver_id**: Identifier of the driver who handled the order.
- **pickup_time**: Time when the driver picked up the order.
- **distance**: Distance traveled by the driver.
- **duration**: Time taken to complete the delivery.
- **cancellation**: Whether the order was canceled and by whom (Driver/Customer).

## Research Questions
The following research questions are explored in this project using SQL queries:

1. **How many rolls were ordered?**
2. **How many unique customer orders were made?**
3. **How many unique customers made orders?**
4. **How many successful orders were delivered by each driver?**
5. **How many of each type of roll was delivered?**
6. **How many Veg and Non-Veg Rolls were ordered by each customer?**
7. **What is the maximum number of rolls delivered in a single order?**
8. **For all the rolls delivered, how many had at least one change, and how many had no changes at all?**
9. **How many rolls were delivered that had both exclusions and extras?**
10. **What were the total numbers of rolls ordered for each hour of the day?**
11. **What was the number of orders for each day of the week?**
12. **What was the average time in minutes it took for each driver to arrive at Fassos HQ to pick up the order?**
13. **Is there a relationship between the number of rolls and how long the order takes to prepare?**
14. **What was the average distance traveled for each customer?**
15. **What is the difference between the longest and the shortest delivery time of all orders?**
16. **What was the average speed of the driver?**

## Usage
1. **Set up the database** by running the provided SQL scripts to create and populate the tables.
2. Use the **provided queries** to analyze the data and gain insights into customer preferences, delivery efficiency, and driver performance.
3. **Modify the queries** as needed to answer additional business questions.

## Future Enhancements
- **Advanced Analytics**: Incorporating customer feedback data to analyze driver performance and customer satisfaction.
- **Data Visualization**: Building dashboards to visualize order trends, driver efficiency, and roll popularity using tools like Power BI or Tableau.

## Conclusion
This project provides a detailed data model for tracking orders, ingredients, and delivery processes on the Fassos platform. Through SQL queries, valuable insights about customer behavior and operational efficiency are uncovered, which can be used to improve business decisions.

