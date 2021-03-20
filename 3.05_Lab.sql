-- Lab 3.05
-- 1

SELECT count(inventory_id)
FROM sakila.inventory
WHERE film_id in (SELECT film_id FROM sakila.film WHERE title = "Hunchback Impossible");

-- 2

SELECT title
FROM sakila.film
WHERE length > (
SELECT avg(length)
FROM sakila.film);

-- 3

SELECT first_name,last_name
FROM sakila.actor
WHERE actor_id in (SELECT distinct actor_id
FROM sakila.film_actor
WHERE film_id in (SELECT film_id FROM sakila.film WHERE title = 'Alone Trip'));

-- 4

SELECT title
FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.film_category WHERE category_id in (SELECT category_id FROM sakila.category WHERE name = 'Family'));

-- 5

-- Using subqueries

SELECT email
FROM sakila.customer
WHERE address_id in (SELECT address_id FROM sakila.address WHERE city_id in (SELECT city_id FROM sakila.city WHERE country_id in ( SELECT country_id FROM sakila.country WHERE country = 'Canada')));


-- Joins tables

SELECT email 
FROM sakila.customer as customer_table
JOIN sakila.address as address_tabe on customer_table.address_id = address_tabe.address_id
JOIN sakila.city as city_table on address_tabe.city_id = city_table.city_id
JOIN sakila.country as country_table on city_table.country_id = country_table.country_id
WHERE country = 'Canada';

-- 6

SELECT title
FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.film_actor WHERE actor_id in (SELECT actor_id
FROM (SELECT actor_id, count(film_id), dense_rank() over (order by count(film_id) desc) as ranking
FROM sakila.film_actor
GROUP BY actor_id) as sub1
WHERE ranking = 1));


-- 7
select payment.customer_id, sum(payment.amount) as total_amount_spent
from sakila.payment
group by payment.customer_id
order by sum(payment.amount) desc
limit 1;

select f.film_id, f.title, p.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name
from sakila.payment as p
join sakila.rental as r
on p.rental_id = r.rental_id
join sakila.customer as c
on r.customer_id = c.customer_id
join sakila.inventory as i
on r.inventory_id = i.inventory_id
join sakila.film as f
on f.film_id = i.film_id
where p.customer_id = (  #select only actor_id in subquery. Use =  instead of in
    select customer_id from (
    select p.customer_id, sum(p.amount) as total_amount_spent
	from sakila.payment as p
	group by p.customer_id
	order by sum(p.amount) desc
	limit 1) sub1
);
-- 8
select concat(c.first_name, ' ', c.last_name) as customer_name, sum(p.amount) as spent_more_than_average
from sakila.payment as p
join sakila.rental as r
on p.rental_id = r.rental_id
join sakila.customer as c
on r.customer_id = c.customer_id
group by customer_name
having sum(p.amount) > (  #select only actor_id in subquery. Use =  instead of in
    select avg(average_amount_spent) from (
    select sum(p.amount) as average_amount_spent
	from sakila.payment as p
    group by p.customer_id
	) sub1
);