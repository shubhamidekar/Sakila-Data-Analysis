use sakila;

/*
	Q1
	How many number of films do we have in each category
*/ 

select c.name as 'Category name'
	   ,count(fc.film_id) as 'Number of Films'
from film_category fc
join category c
on fc.category_id=c.category_id
group by c.name

/*
    Q2
	The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
	Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
*/

with cat_fil as
(
select film_id
		,name as category_name
from film_category
join category
on film_category.category_id = category.category_id
)
,ren_inv as
(select rental_id
		,film_id
from rental 
join inventory
on rental.inventory_id = inventory.inventory_id
)
select c.category_name
       ,count(r.rental_id) as Count_rents
from film f
join ren_inv r
on r.film_id = f.film_id
join cat_fil c
on f.film_id = c.film_id
group by category_name
having category_name IN ('Animation','Children','Classics','Comedy','Family','Music')

/*
	Q3
    The time period for how long movies have been rented for in descending order, also show movie name and category 
*/


with film_inventory as
(
select i.*
		,f.title
        ,c.name
from film f
join inventory i
on f.film_id=i.film_id
join film_category fc
on fc.film_id=f.film_id
join category c
on c.category_id=fc.category_id
)
select rental_id
       ,fi.title
       ,fi.name as 'category_name'
       ,DATEDIFF(return_date,rental_date) as 'Length_Rental' 
from rental r
join film_inventory fi
on r.inventory_id=fi.inventory_id
order by Length_Rental desc,rental_id;

/*
	Q4
    List the top genres in gross revenue in descending order. 
    
*/

select c.name category_name
	   , sum( IFNULL(p.amount, 0) ) revenue
from category c
left join film_category fc
on c.category_id = fc.category_id
left join film f
on fc.film_id = f.film_id
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.rental_id = p.rental_id
group by c.name
order by revenue desc;

/*
	Q5
	Using the tables payment and customer and the JOIN command, list the total paid by 
    each customer. List the customers by amount paid descending
    
*/

select c.first_name
		,c.last_name
        ,sum(p.amount) as 'Total Amount Paid' 
from payment p
join customer c
on p.customer_id = c.customer_id
group by c.first_name, c.last_name
order by sum(p.amount) desc;

/*
	Q6
    List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
    
*/

select f.title
		,count(*) as 'number_of_actors'
from film f
inner join film_actor fa
on f.film_id = fa.film_id
group by f.title
order by number_of_actors desc;

/*
	Q7
    Which kind of rating has the longest average rental rates grouped by store?
    
*/
with fil_inv as (
	select 	f.film_id as movie_id
			,f.rating as film_rating
			,f.rental_duration as rental_duration
			,i.store_id as store
			,ROUND(avg(f.rental_duration) over(partition by f.rating), 1) as average_rental
	from film f
	join inventory i
	on f.film_id = i.inventory_id
	group by 1, 2, 3, 4
	order by 2)
select store
		,film_rating
        ,average_rental
from fil_inv
group by store, film_rating, average_rental
order by store, average_rental;

/*
	Q8
    City wise rental revenue
*/

select city
	   ,round(sum(amount), 2) as city_wise_payments
       ,sum(round(sum(amount), 2)) over (order by round(sum(amount), 2) desc, city ) as cummulative_total
from city b 
join address c on c.city_id = b.city_id
join customer d on d.address_id = c.address_id
join payment e on d.customer_id = e.customer_id
group by 1
order by 2 desc;