
--seleccionar el apartamento, precio, propietario y localización de 5 apartamentos
SELECT apartment_id,
	price,
	owner_id,
	location 
FROM apartment 
limit 5;

--contar el número de reservas que se han hecho entre 1 Enero 2024 y 30 Enero 2024
SELECT 
	COUNT(*)AS numero_reservas
FROM reservation
WHERE start_date > '2024-01-01' 
AND end_date < '2024-01-30';

SELECT 
	COUNT(*)AS numero_reservas
FROM reservation
WHERE start_date >= '2024-01-01' 
AND start_date <= '2024-01-30';

SELECT 
	COUNT(*)AS numero_reservas
FROM reservation
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-30';

--cuál es la fecha mínima en la tabla de reservas
SELECT 
	min(start_date) as min_start_date,
	min(end_date) as min_end_date
FROM reservation
;

--cuántos nombres de propietarios diferentes tenemos en la tabla owner
SELECT 
	count(distinct name) as dis_nombres
FROM owner;

Ana Gonzalez
Ana Perez

WITH base AS (
	SELECT DISTINCT
		name,
		surname
	FROM OWNER
)
SELECT count(*) as unique_name_surname
FROM base;





	
--seleccionar el apartment_id y el price para los apartamentos que tengan un precio mayor a la media
SELECT 
	apartment_id,
	price 
FROM apartment 
WHERE price > (
	SELECT 
		AVG(price)
	FROM apartment
	)
;

SELECT *
from apartment
limit 1;

--cuáles son los propietarios con más de un apartamento
SELECT 
	owner_id,
	COUNT(apartment_id) as total_apartments
FROM apartment 
GROUP BY 1
HAVING COUNT(apartment_id) > 1;

WITH total_apartments_per_owner AS (
	SELECT 
		owner_id,
		COUNT(apartment_id) as total_apartments
	FROM apartment 
	GROUP BY 1
)
SELECT *
FROM total_apartments_per_owner
WHERE total_apartments > 1;

SELECT 
	COUNT(*) as total_records,
	COUNT(apartment_id) as total_apartments,
	COUNT(DISTINCT apartment_id) as unique_apartments,
	COUNT(owner_id) as total_owners,
	COUNT(DISTINCT owner_id) as unique_owners
FROM apartment;

--inner join
SELECT res.id,
	res.apartment_id,
	cus.email,
	res.customer_id
FROM reservations AS res
INNER JOIN customers AS cus
ON res.customer_id = cus.id;


---left join
SELECT 
	reservation.reservation_id,
	customer.name,
	customer.surname
FROM reservation 
LEFT JOIN customer  
on reservation.customer_id = customer.customer_id;

SELECT
	apartment.owner_id,
	owner.owner_id,
	owner.name as owner_name,
	COUNT(apartment.apartment_id) as total_apartments
FROM apartment 
LEFT join owner 
ON apartment.owner_id = owner.owner_id
GROUP BY 1,2,3 ;

SELECT 
	apartment.apartment_id,
	apartment.location,
	COUNT(reservation.reservation_id) AS total_reservations
FROM apartment 
LEFT JOIN reservation 
ON apartment.apartment_id = reservation.apartment_id
GROUP BY 1,2;

--por localización cuántos apartamentos tenemos y cuántas reservas hay, donde el customer_id > 2
SELECT 
apartment.location,
COUNT(DISTINCT apartment.apartment_id) AS total_apartments,
COUNT(reservation.reservation_id) AS total_reservations
FROM apartment 
LEFT join reservation
ON apartment.apartment_id = reservation.apartment_id
WHERE reservation.customer_id > 2
GROUP BY 1;

SELECT apartment_id,
reservation_id 
FROM reservation ;

SELECT 
apartment.location,
COUNT(DISTINCT apartment.apartment_id) AS total_apartments,
COUNT(reservation.reservation_id) AS total_reservations
FROM reservation 
LEFT join apartment
ON reservation.apartment_id = apartment.apartment_id
WHERE reservation.customer_id > 2
GROUP BY 1;

