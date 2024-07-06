create database swiggy;
use swiggy;
create table swiggy_info(restaurant_no int not null,
                         restaurant_name varchar(255) not null,
                         city varchar(50) not null,
                         address varchar(255) not null ,
                         rating decimal(2,1) not null,
                         cost_per_person int not null,
                         cuisine varchar(255) not null,
                         restaurant_link varchar(255) not null,
                         menu_category varchar(255) not null,
                         item varchar(255) not null,
                         price int not null,
                         veg_or_nonveg varchar(10) not null);

describe swiggy_info;
select * from swiggy_info;

-- 01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
select count(distinct restaurant_name) as high_rated_restaurants
from swiggy_info
where rating>4.5;

-- 02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
select city, count(distinct restaurant_name) as no_of_resturants
from swiggy_info
group by city
order by no_of_resturants desc
limit 1;

-- 03 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?
select count(distinct restaurant_name) as pizza_restro
from swiggy_info
where restaurant_name like "%pizza%";

-- 04 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
select cuisine,count(*) as cuisine_count
from swiggy_info
group by cuisine
order by cuisine_count desc
limit 1;

-- 05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
select city, avg(rating) as avg_rating
from swiggy_info
group by city;

-- 06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
select restaurant_name,menu_category,max(price)
from swiggy_info
where menu_category="Recommended"
group by restaurant_name,menu_category;


-- 07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE.
select distinct restaurant_name,cuisine,cost_per_person
from swiggy_info
where cuisine not like '%indian%'
order by cost_per_person  desc
limit 5;

-- 08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.
select distinct restaurant_name,cost_per_person
from swiggy_info
where cost_per_person>(select avg(cost_per_person)
					   from(select distinct restaurant_name,cost_per_person
                            from swiggy_info) as t)
order by cost_per_person desc;

-- 09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
select distinct t1.restaurant_name,t1.city as city_1, t2.city as city_2
from swiggy_info t1
inner join swiggy_info t2
on t1.restaurant_name=t2.restaurant_name and t1.city<t2.city;

-- 10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
select restaurant_name, menu_category,count(item) as "max_no_items"
from swiggy_info
where menu_category="main course"
group by restaurant_name,menu_category
order by count(item) desc
limit 1;

-- 11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME
select restaurant_name,(count(case when veg_or_nonveg="veg" then 'veg' end)*100/count(*)) as veg_percentage
from swiggy_info
group by restaurant_name
having veg_percentage=100.00
order by restaurant_name;

-- 12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
select restaurant_name,avg(price) as avg_price
from swiggy_info
group by restaurant_name
order by avg_price 
limit 1;

-- 13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
select restaurant_name,count( distinct menu_category) as no_of_categories
from swiggy_info
group by restaurant_name
order by no_of_categories desc
limit 5;

-- 14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
select restaurant_name,((count(case when veg_or_nonveg="non-veg" then "nonveg" end)*100)/count(*)) as non_veg_percentage
from swiggy_info
group by restaurant_name
order by non_veg_percentage desc
limit 1;

-- 15 Determine the Most Expensive and Least Expensive Cities for Dining:
select city,max(cost_per_person),min(cost_per_person)
from swiggy_info
group by city;

-- 16 Calculate the Rating Rank for Each Restaurant Within Its City
select restaurant_name,city,rating,dense_rank() over(partition by city order by rating desc) as rating_rank_within_city
from swiggy_info
group by restaurant_name,city,rating;



















