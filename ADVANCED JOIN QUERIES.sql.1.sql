USE sakila;
#36. Retrieve the film titles along with the names of customers who rented them and the rental dates.

SELECT f.title AS film_title,
CONCAT (c.first_name, ' ' , c.last_name) AS customer_name,
r.rental_date as Rental_Date
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
ORDER BY Rental_Date DESC;


#37. Find all stores with their respective revenue generated from rentals.

SELECT s.store_id AS Store_ID,
SUM(p.amount) AS Total_Revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id
ORDER BY Total_Revenue DESC;

#38. List all staff members and the films they have rented out. 

SELECT 
CONCAT(st.first_name, ' ' , st.last_name) AS Staff_Name,
f.title AS Film_Title,
r.rental_date AS Rental_Date
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN staff st ON r.staff_id = st.staff_id
ORDER BY st.staff_id, r.rental_date DESC;

#39. Retrieve the total revenue for each film category. 

SELECT 
c.name AS Category_Name,
SUM(p.amount) AS Total_Revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id 
ORDER BY Total_Revenue DESC;

#40. List the most rented film in each store. 

SELECT s.store_id, f.title AS Film_Title, COUNT(r.rental_id) AS Rental_Count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id 
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id, f.film_id
HAVING Rental_Count = (
 SELECT MAX(rental_count)
 FROM (
 SELECT i.store_id, i.film_id, COUNT(r.rental_id) AS rental_count
 FROM rental r 
 JOIN inventory i ON r.inventory_id = i.inventory_id
 GROUP BY i.store_id, i.film_id
) AS subquery
WHERE subquery.store_id = s.store_id
)
ORDER BY s.store_id;

