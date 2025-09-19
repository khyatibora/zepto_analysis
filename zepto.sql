create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) not null,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
dscountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
OutOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
select * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
dscountedSellingPrice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outOfStock,COUNT(sku_id)
FROM zepto
group by outOfStock;

--product names present multiple times
select name, count(sku_id) as "Number of SKUs"
FROM zepto
group by name
Having count(sku_id)>1
order by count(sku_id) desc;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp=0 OR dscountedSellingPrice = 0;

delete from zepto
where mrp=0;

--convert paise into rupees
UPDATE zepto
SET mrp = mrp/100.0,
DscountedSellingPrice=DscountedSellingPrice/100.0;

Select mrp,DscountedSellingPrice From zepto;

--Q1. Find the top 10 best-value products based on the discount percentage.

select Distinct name,mrp, discountpercent from zepto
order  by discountpercent desc
limit 10;

--Q2.What are the Products with High MRP but out of stock?
select Distinct name,mrp from zepto
where outofstock = TRUE AND mrp > 300
Order by mrp desc;

--Q3.Calculate estimated Revenue for each category.
select category,SUM(availablequantity * dscountedSellingPrice) as revenue from zepto
group by category
order by revenue;

--Q4. Find all products where MRP is greater than rs.500 and discount is less than 10%
select distinct name, mrp, discountPercent
from zepto
where mrp>500 and discountpercent<10 
order by mrp desc,discountPercent Desc;

--Q5.Identify the top 5 categories offering the highest average discount percentage

select  distinct category, avg(discountpercent) as avg_discount 
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms, dscountedsellingprice,
ROUND(dscountedsellingprice/weightingms,2) AS price_per_gram
from zepto
where weightingms>=100
order by price_per_gram;

--Q7. Group the products into categories like Low, Medium,Bulk.
select distinct name, weightingms,
case when weightingms<1000 then 'Low'
   when weightingms<5000 then 'Medium'
   else 'Bulk'
  end as  weight_category
from zepto;

--Q8. What is the total inventory Weight Per Category
select category,sum(weightingms * availablequantity) as total_weight from zepto
group by category
order by total_weight;

