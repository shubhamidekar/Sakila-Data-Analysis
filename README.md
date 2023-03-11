# Sakila-Data-Analysis
Understanding some OLAP functions and using CTE to create queries which meet certain business requirements

The Sakila database is a nicely normalised schema modelling a DVD rental store, featuring things like films, actors, film-actor relationships, and a central inventory table that connects films, stores, and rentals.

![sakila](https://user-images.githubusercontent.com/114885651/224454769-5f5531c9-011e-459e-a8d8-ec78a601bca8.png)


We are taking certain widely available business requirement questions and producing the sql queriers for the same

Questions 
1) How many number of films do we have in each category

2) The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
	Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

3) The time period for how long movies have been rented for in descending order, also show movie name and category 

4) List the top genres in gross revenue in descending order. 

5) Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers by amount paid descending
    
6) List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join

7) Which kind of rating has the longest average rental rates grouped by store?

8) City wise rental revenue
