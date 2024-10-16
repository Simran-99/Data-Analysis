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
