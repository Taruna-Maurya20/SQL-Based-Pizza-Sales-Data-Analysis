/*create table order_details ( 
order_details_id int not null,
order_id int not null,
pizza_id text  not null,
quantity int not null,
primary key (order_details_id) ); */



-- 1) Retrieve the total number of orders placed.
select count(order_id) as total_order  from orders; 



-- 2) Calculate the total revenue generated from pizza sales.
select
round(sum(order_details.quantity * pizzas.price),2) as total_revenue      -- ( round is the rounfoff to 2 decimal points, so we have writtern (, 2))
from order_details join pizzas 
on pizzas.pizza_id = order_details.pizza_id   




-- 3)Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1 ;                       -- limit 1 is for the 1 row only


-- 4)Identify the most common pizza size ordered.
select quantity, count(order_details_id)
from order_details group by quantity;
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;





-- 5) List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name , sum(order_details.quantity) as order_sum
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by  pizza_types.name  order by order_sum desc limit 5;       -- upar sum kiya hai to group by lgana padega 




-- 6)Join the necessary tables to find the total quantity of each pizza category ordered.
 select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by  pizza_types.category order by quantity ; 



-- 7)Determine the distribution of orders by hour of the day. 
 select hour(order_time) as hours_timing, count(order_id) as order_count from orders
group by  hour(order_time) order by order_count ; 




-- 8)Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) from pizza_types
group by category ;  



-- 9)Group the orders by date and calculate the average number of pizzas ordered per day.
select orders.order_date, sum(order_details.quantity)
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date ;




-- 10) to find the avg of the above: 
select round(avg(quantity),0) from 
(select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity ;




-- 11) Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name , 
sum(pizzas.price * order_details.quantity) as revenue
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name order by revenue desc limit 3;



-- 12)Calculate the percentage contribution of each pizza type to total revenue. 
select pizza_types.category , 
sum(pizzas.price * order_details.quantity) as revenue
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category order by revenue desc ;







-- 13)Analyze the cumulative revenue generated over time.
select order_date, sum(revenue) over(order by order_date) as cum_revenue
from                                                                            
(select orders.order_date, sum(order_details.quantity * pizzas.price) as revenue       -- above content is to show cummulative values
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id= order_details.order_id
group by orders.order_date) as sales  ;





-- 14)Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category, name, revenue, 
rank() over(partition by category order by revenue desc) as rank_obtained
from
(select pizza_types.name, pizza_types.category, sum((order_details.quantity) * pizzas.price) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name, pizza_types.category order by revenue) as A ;