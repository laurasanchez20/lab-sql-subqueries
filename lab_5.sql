USE sakila;

SELECT 
    f.title, 
    COUNT(i.inventory_id) AS num_copies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

SELECT 
    title, 
    length
FROM film
WHERE length > (SELECT AVG(length) FROM film)
ORDER BY length DESC;

SELECT 
    a.first_name, 
    a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    WHERE f.title = 'Alone Trip'
)
ORDER BY a.last_name, a.first_name;

SELECT 
    f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family'
ORDER BY f.title;

SELECT 
    first_name, 
    last_name, 
    email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

SELECT 
    c.first_name, 
    c.last_name, 
    c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada'
ORDER BY c.last_name, c.first_name;

SELECT 
    a.actor_id, 
    a.first_name, 
    a.last_name, 
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;


SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;


SELECT AVG(total_spent) AS avg_spent
FROM (
    SELECT 
        customer_id, 
        SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_totals;

SELECT 
    customer_id, 
    total_spent
FROM (
    SELECT 
        customer_id, 
        SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_totals
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT 
            customer_id, 
            SUM(amount) AS total_spent
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_spent DESC;


