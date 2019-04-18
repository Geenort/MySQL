USE sakila;

SELECT first_name, last_name from actor;

SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE "Joe";

SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";

SELECT *
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor
ADD COLUMN description BLOB;

ALTER TABLE actor
DROP COLUMN description;

SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

UPDATE actor
SET first_name = "HARPO"
WHERE actor_id = 172;

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

SELECT first_name, last_name, address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

SELECT first_name, last_name, payment.staff_id, SUM(amount) AS "Total Amount Rung Up"
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY staff_id;

SELECT title, COUNT(actor_id) AS "Number of Listed Actors"
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY actor_id;

SELECT title, 
	(SELECT COUNT(film_id)
	FROM inventory
	WHERE title = "Hunchback Impossible") AS "Number of Copies in Inventory"
FROM FILM
WHERE title = "Hunchback Impossible";

SELECT first_name, last_name, customer.customer_id, SUM(amount) AS "Total Paid by Customer"
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;

SELECT title
FROM film
WHERE language_id IN (
	SELECT language_id
    FROM `language`
    WHERE `name` = "English")
	AND title LIKE "K%" OR title LIKE "Q%";

SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"));

SELECT first_name, last_name, email, address, city, country
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country = "Canada";

SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = "Family"));

SELECT title, film.film_id, COUNT(rental_id) AS number_of_times_rented
FROM rental
INNER JOIN inventory on rental.inventory_id = inventory.inventory_id
INNER JOIN film on inventory.film_id = film.film_id
GROUP BY film_id
ORDER BY number_of_times_rented DESC;

SELECT store.store_id, address, SUM(Amount) AS total_business_brought_in
FROM payment
INNER JOIN staff on payment.staff_id = staff.staff_id
INNER JOIN store on staff.store_id = store.store_id
INNER JOIN address on store.address_id = address.address_id
GROUP BY store_id;

SELECT store_id, city, country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city on address.city_id = city.city_id
INNER JOIN country on city.country_id = country.country_id;

SELECT category.name, SUM(amount) AS gross_revenue
FROM payment
INNER JOIN rental on payment.rental_id = rental.rental_id
INNER JOIN inventory on rental.inventory_id = inventory.inventory_id
INNER JOIN film_category on inventory.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

CREATE VIEW Top_Five_Genres AS
SELECT category.name, SUM(amount) AS gross_revenue
FROM payment
INNER JOIN rental on payment.rental_id = rental.rental_id
INNER JOIN inventory on rental.inventory_id = inventory.inventory_id
INNER JOIN film_category on inventory.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

SELECT * FROM Top_Five_Genres;

DROP VIEW Top_Five_Genres;