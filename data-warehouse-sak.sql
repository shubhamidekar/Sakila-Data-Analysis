create database sales;

CREATE TABLE sales.cust_california AS 
SELECT cus.customer_id
	  ,adr.address_id
	  ,adr.district
	  ,adr.city_id
	  ,cty.city
FROM sakila.customer cus
JOIN sakila.address adr
ON cus.address_id = adr.address_id
JOIN sakila.city cty
ON adr.city_id = cty.city_id
WHERE adr.district = 'California'
;

select * from sales.cust_california;

ALTER TABLE sales.cust_california ADD UNIQUE INDEX (customer_id, address_id, city_id);
ALTER TABLE sales.cust_california ADD KEY (customer_id);
ALTER TABLE sales.cust_california ADD KEY (address_id);
ALTER TABLE sales.cust_california ADD KEY (city_id);

CREATE TABLE sales.cus_pay_detail AS
SELECT cus.customer_id
      ,pay.payment_id
      ,pay.rental_id
      ,pay.amount
      ,pay.payment_date      
      ,inv.inventory_id
      ,flm.title
      ,str.store_id
      ,adr.address_id
      ,adr.address 
      ,adr.district

  FROM sales.cust_california cus
  
  JOIN sakila.payment pay
    ON cus.customer_id = pay.customer_id
    
  LEFT JOIN sakila.rental ren
    ON pay.rental_id = ren.rental_id

  JOIN sakila.inventory inv
    ON ren.inventory_id = inv.inventory_id
    
  JOIN sakila.film flm
    ON inv.film_id = flm.film_id
    
  JOIN sakila.store	str
    ON inv.store_id = str.store_id

  JOIN sakila.address adr
    ON str.address_id = adr.address_id
 ;   
 
CREATE TABLE sales.cus_pay_total AS
SELECT cpd.address_id
	  ,max(cpd.address) as shop_address
      ,max(cpd.district) as shop_district
      ,adr.district as customer_district
      ,year(cpd.payment_date) as payment_year
      ,month(cpd.payment_date) as payment_month
      ,sum(cpd.amount) as payment_total
      ,count(cpd.payment_id) as payment_count
      ,count(distinct cpd.customer_id) as cust_count
	   
  FROM sales.cus_pay_detail cpd
  
  JOIN sakila.customer cus
    ON cpd.customer_id = cus.customer_id

  JOIN sakila.address adr
    ON cus.address_id = adr.address_id
  
 GROUP BY cpd.address_id
      ,adr.district
      ,year(cpd.payment_date)
      ,month(cpd.payment_date)
;
