-- CREATE DATABASE sakila;

-- Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.
SELECT store_id, store.address_id, city.city, country.country from store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.
SELECT store.store_id, SUM(payment.amount) AS total_amount FROM payment
JOIN customer ON customer.customer_id = payment.customer_id
JOIN store ON store.store_id = customer.store_id
GROUP BY store.store_id;

-- ¿Cuál es el tiempo de ejecución promedio de las películas por categoría?
SELECT category.`name`,  AVG(length) FROM film
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY film_category.category_id;

-- ¿Qué categorías de películas son las más largas?
SELECT category.`name`,  AVG(length) AS Average_lenght FROM film
JOIN film_category ON film_category.film_id = film.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY film_category.category_id
ORDER BY Average_lenght DESC
LIMIT 1;

-- Muestra las películas más alquiladas en orden descendente.
SELECT film.title, COUNT(film.title) AS How_Many FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY How_Many DESC;

-- Enumera los cinco principales géneros en ingresos brutos en orden descendente.
SELECT category.`name`, SUM(payment.amount) AS profit FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY category.`name`
ORDER BY profit DESC
LIMIT 5;

-- ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?
SELECT rental.rental_id, inventory.inventory_id, rental.rental_date, rental.return_date, rental.last_update FROM inventory
JOIN film ON inventory.film_id = film.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE film.title LIKE 'Academy Dinosaur' AND store_id = 1  AND rental.rental_date <= (SELECT 
    MAX(rental2.return_date) FROM rental AS rental2
    WHERE rental.rental_id = rental2.rental_id
    )
ORDER BY return_date;
