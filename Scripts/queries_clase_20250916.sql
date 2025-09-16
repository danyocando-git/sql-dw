SELECT 
  invoice_date,
  EXTRACT(DAY from invoice_date) as day,
  EXTRACT(MONTH from invoice_date) as month,
  EXTRACT(YEAR from invoice_date) as year
FROM keepcoding.invoice;

SELECT 
  current_timestamp() as now,
  current_date('UTC') as today,
  current_time('UTC') as hour
  ;
--AÑADIR Y RESTAR FECHA
SELECT
  DATE_ADD(invoice_date, INTERVAL 1 DAY) AS add_one_day,
  DATE_SUB(invoice_date, INTERVAL 1 DAY) AS sub_one_day,
  DATE_ADD(invoice_date, INTERVAL 1 MONTH) AS add_one_month,
  DATE_SUB(invoice_date, INTERVAL 1 MONTH) AS sub_one_month,
  DATE_ADD(invoice_date, INTERVAL -1 MONTH) AS sub_one_month
FROM keepcoding.invoice;

-- DIFEENCIA ENTRE DOS FECHAS
SELECT DATETIME_DIFF('2024-12-05 15:30:23', '2024-12-04 23:30:23', HOUR)
;

--TRUNCAR FECHA
SELECT 
  DATETIME_TRUNC('2024-12-05 15:30:23', YEAR) as year,
  DATETIME_TRUNC('2024-12-05 15:30:23', MONTH) as month,
  DATETIME_TRUNC('2024-12-05 15:30:23', DAY) as day,
  DATETIME_TRUNC('2024-12-05 15:30:23', HOUR) as hour
  ;

SELECT 
  DATETIME_TRUNC(invoice_date, YEAR) as year,
  DATETIME_TRUNC(invoice_date, MONTH) as month,
  DATETIME_TRUNC(invoice_date, DAY) as day,
  DATETIME_TRUNC(invoice_date, HOUR) as hour
FROM keepcoding.invoice;

-- FORMATO DE FECHA
SELECT invoice_id,
  invoice_date,
  FORMAT_DATE('%d-%m-%y', invoice_date) as date_type_one,
  FORMAT_DATE('%d-%m-%Y', invoice_date) as date_type_two,
  FORMAT_DATE('%A', invoice_date) as date_type_three,
  FORMAT_DATE('%B', invoice_date) as date_type_four
  FROM keepcoding.invoice
;

-- ÚLTIMO DÍA
SELECT invoice_id
     , invoice_date
     , LAST_DAY(invoice_date, MONTH)
     , LAST_DAY(invoice_date, WEEK)
  FROM keepcoding.invoice
  ;

-- PARSEAR FECHAS
SELECT 
  PARSE_DATE('%Y%m%d', '20250525') as parsed_one,
  PARSE_DATE('%d/%m/%Y', '25/05/2025') as parsed_two
FROM keepcoding.invoice
;

--STRINGS
--Consultar los clientes con edades entre los 20 y los 30 de 3 formas diferentes

SELECT *
FROM keepcoding.customer
WHERE age BETWEEN 20 AND 30
;

SELECT *
FROM keepcoding.customer
WHERE age >= 20
AND age < 30
;

SELECT * 
FROM keepcoding.customer
WHERE age IN (21,23,25,27,29)
;

SELECT name,
age
FROM keepcoding.customer 
GROUP BY 1,2
HAVING age BETWEEN 20 AND 30;

SELECT *
FROM keepcoding.customer
WHERE name = 'Enzo';

SELECT 
name,
LOWER(name) as lower_name,
UPPER(name) AS upper_name 
from keepcoding.customer;

SELECT 
name,
LOWER(name) as lower_name,
UPPER(name) AS upper_name 
from keepcoding.customer
WHERE lower(name) = 'enzo lópez';

SELECT
name,
lOWER(NAME) AS LOWER_NAME,
UPPER(NAME) AS upper_name
from keepcoding.customer
WHERE lower(name) like 'e%';

select name
from keepcoding.customer
WHERE lower(name) like '%z';

SELECT name 
FROM keepcoding.customer
WHERE lower(name) like '%enzo%'
;

SELECT

SPLIT(name, ' ') name_split
FROM keepcoding.customer;

SELECT
name,
SPLIT(name, ' ')[OFFset(0)] as first_name,
SPLIT(name,' ')[OFFSET(1)] as surname
FROM keepcoding.customer;

SELECT
name,
REPLACE(name, ' ', '--') AS name_one,
REPLACE(name, ' ','') AS name_second
FROM keepcoding.customer;

SELECT
'  Rosa Perez  ' as name,
'Rosa Perez' as name_two,
LTRIM('   Rosa Perez   ') as name_three,
RTRIM('   Rosa Perez   ') as name_four,
TRIM('   Rosa Perez   ') as name_five;

select leads.uuid, --minuscula
customer.uuid--mayuscula
FROM leads --minuscula
LEFT join customer --mayuscula
ON lower(leads.uuid) = lower(customer.uuid);


--CASE WHEN aND IF

WITH classified_month AS (
  SELECT
  DISTINCT month,
  CASE 
    WHEN month IN ('ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO') THEN 1
    WHEN month = 'FEBRERO' THEN 3
    ELSE 2
  END AS QUARTER_IDENTIFICATION
FROM keepcoding.invoice
)
SELECT
  month,
  quarter_identification,
  IF(quarter_identification = 1, 'H 1', 'H 2') as half
FROM classified_month

;
/*Clasificación de facturas
 - cuando el mes esté en el primer semestre y la factura sea superior a 20, clasificar como '1 - 1' 
 - cuando el mes esté en el primer semestre y la factura sea inferior a 20, clasificar como '1 - 2'
 - cuando el mes esté en el segundo semestre y la factura sea superior a 20, clasificar como '2 - 1'
 - cuando el mes esté en el segundo semestre y la factura sea inferior a 20, clasificar como '2 - 2'
campo tipo_de_factura

 Cuantas facturas hay de cada tipo? 
*/
WITH total_facturas AS (
  SELECT
  month,
  total_amount,
  CASE 
    WHEN month IN ('ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO') AND total_amount > 20 THEN '1 - 1'
    WHEN month IN ('ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO') AND total_amount <= 20 THEN '1 - 2'
    WHEN month IN ('JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE') AND total_amount > 20 THEN '2 - 1'
    ELSE '2 - 2'
  END AS tipo_factura
FROM keepcoding.invoice
)
SELECT tipo_factura,
COUNT(tipo_factura) AS total_facturas_tipo
FROM total_facturas
GROUP BY 1;



--redondear precio hacia arriba y hacia abajo

--comprobar el uso de la función COALESCE

--comprobar el uso de SUBSTRING