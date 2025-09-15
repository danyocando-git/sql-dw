
--Comprueba que todos los apartments tienen reservas y que todas las reservas tienen apartments
SELECT apartment.apartment_id,
count(reservation.reservation_id) as total_reservas 
FROM apartment 
LEFT JOIN reservation 
ON apartment.apartment_id = reservation.apartment_id 
GROUP BY 1
HAVING COUNT(reservation.reservation_id) =0
;

SELECT reservation.reservation_id
FROM reservation 
LEFT JOIN apartment 
ON reservation.apartment_id = reservation.apartment_id 
WHERE reservation.apartment_id IS NULL;

SELECT apartment.apartment_id
FROM apartment 
LEFT JOIN reservation 
ON apartment.apartment_id = reservation.apartment_id 
WHERE reservation.apartment_id IS NULL


SELECT apartment_id 
FROM reservation 
WHERE apartment_id IS NULL;

--TEnemos que comprobar que todos los apartaments de la tabla reservation están en la tabla apartment

SELECT DISTINCT
	reservation.apartment_id,
	apartment.apartment_id,
	apartment.location
FROM reservation 
LEFT JOIN apartment 
ON reservation.apartment_id = apartment.apartment_id
WHERE apartment.apartment_id IS NULL
--GROUP BY 1,2


--Cuenta el número de reservas por clientes y selecciona nombre y apellido de los clientes que tienen más de 1 reserva
SELECT 
customer_id,
reservation_id,
COUNT(*) AS total_reservations
FROM reservation
GROUP By 1,2
HAVING COUNT(*)>1; 

SELECT customer.customer_id,
customer.name,
customer.surname,
COUNT(reservation.reservation_id) as total_reservation_per_customer
FROM reservation
LEFT JOIN customer 
ON reservation.customer_id = customer.customer_id
GROUP BY 1,2,3
HAVING COUNT(reservation.reservation_id) > 1;

SELECT DISTINCT CONCAT(name, ' ', surname) as nombre_completo
FROM customer
ORDER BY 1;

--Recupera el nombre y la ubicación de los apartamentos propiedad del owner_id 7

SELECT name,
surname,
location 
FROM owner 
LEFT JOIN apartment 
ON owner.owner_id = apartment.owner_id
WHERE owner.owner_id = 7;



--Muestra las comodidades asociadas al apartment_id 9

WITH comodidades_nueve AS (
	SELECT amenity_id,
	apartment_id
	FROM apt_amenity
	WHERE apartment_id = 9
)
SELECT name
FROM amenity
INNER JOIN comodidades_nueve 
ON amenity.amenity_id = comodidades_nueve.amenity_id;

WITH comodidades_nueve AS (
	SELECT 
	ame.name as amenity_name
	FROM amenity ame
	INNER JOIN apt_amenity apt
	ON ame.amenity_id = apt.amenity_id
	WHERE apt.apartment_id = 9
)
SELECT 
amenity_name
FROM comodidades_nueve



--Encuentra los clientes que no han realizado ninguna reserva

SELECT 
customer.customer_id,
customer.name,
customer.surname 
FROM customer 
LEFT JOIN reservation 
ON customer.customer_id = reservation.customer_id 
GROUP BY 1,2,3
HAVING COUNT(reservation.customer_id) = 0;

WITH total_customer_reservation as (
SELECT 
	customer_id,
	COUNT(reservation_id) as total_reservation
FROM reservation 
GROUP BY 1
)
SELECT 
customer.name, 
customer.surname
FROM customer
LEFT JOIN total_customer_reservation tot
ON customer.customer_id = tot.customer_id 
WHERE tot.total_reservation IS NULL;

SELECT 
	customer.customer_id 
FROM customer 
LEFT JOIN reservation 
ON customer.customer_id = reservation.customer_id 
WHERE reservation.reservation_id IS NULL;

--seleccionar el apartment_id para aquellos que tienen un precio superior a la media de los apartment (uso WITH)

WITH media AS (
	SELECT AVG(price) AS avg_price
	FROM apartment
)
SELECT apartment_id 
FROM apartment 
INNER JOIN media 
ON apartment.price > media.avg_price;

--Redondear el precio medio
SELECT ROUND(AVG(price)::numeric, 2) AS avg_price
	FROM apartment