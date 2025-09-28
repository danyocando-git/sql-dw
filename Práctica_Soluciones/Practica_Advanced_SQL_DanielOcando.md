-- EJERCICIO 2: CREACIÓN DE BASES DE DATOS

-- Tabla PROFESORES
CREATE TABLE profesores (
    profesor_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    anio_incorporacion INT
);

-- Tabla BOOTCAMPS
CREATE TABLE bootcamps (
    bootcamp_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edicion VARCHAR(50),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Tabla ALUMNOS
CREATE TABLE alumnos (
    alumno_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    bootcamp_id INT,
    CONSTRAINT fk_alumno_bootcamp FOREIGN KEY (bootcamp_id)
        REFERENCES bootcamps (bootcamp_id)
        ON DELETE SET NULL
);

-- Tabla CURSOS ONLINE
CREATE TABLE cursos_online (
    curso_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    profesor_id INT,
    CONSTRAINT fk_curso_profesor FOREIGN KEY (profesor_id)
        REFERENCES profesores (profesor_id)
        ON DELETE SET NULL
);

-- Tabla MÓDULOS
CREATE TABLE modulos (
    modulo_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    curso_id INT,
    profesor_id INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    CONSTRAINT fk_modulo_bootcamp FOREIGN KEY (bootcamp_id)
        REFERENCES bootcamps (bootcamp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_modulo_curso FOREIGN KEY (curso_id)
        REFERENCES cursos_online (curso_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_modulo_profesor FOREIGN KEY (profesor_id)
        REFERENCES profesores (profesor_id)
        ON DELETE SET NULL
);

-- Tabla intermedia BOOTCAMP_PROFESOR (N:N)
CREATE TABLE bootcamp_profesor (
    bootcamp_id INT,
    profesor_id INT,
    PRIMARY KEY (bootcamp_id, profesor_id),
    CONSTRAINT fk_bp_bootcamp FOREIGN KEY (bootcamp_id)
        REFERENCES bootcamps (bootcamp_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_bp_profesor FOREIGN KEY (profesor_id)
        REFERENCES profesores (profesor_id)
        ON DELETE CASCADE
);

-- Tabla intermedia ALUMNO_CURSO_ONLINE (N:N)
CREATE TABLE alumno_curso_online (
    alumno_id INT,
    curso_id INT,
    PRIMARY KEY (alumno_id, curso_id),
    CONSTRAINT fk_aco_alumno FOREIGN KEY (alumno_id)
        REFERENCES alumnos (alumno_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_aco_curso FOREIGN KEY (curso_id)
        REFERENCES cursos_online (curso_id)
        ON DELETE CASCADE
);




-- EJERCICIO 3: CREAR TABLA DE ivr_detail

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  c.ivr_id                 AS calls_ivr_id,
  c.phone_number           AS calls_phone_number,
  c.ivr_result             AS calls_ivr_result,
  c.vdn_label              AS calls_vdn_label,
  c.start_date             AS calls_start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS calls_start_date_id,
  c.end_date               AS calls_end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS calls_end_date_id,
  c.total_duration         AS calls_total_duration,
  c.customer_segment       AS calls_customer_segment,
  c.ivr_language           AS calls_ivr_language,
  c.steps_module           AS calls_steps_module,
  c.module_aggregation     AS calls_module_aggregation,
  m.module_sequece         AS module_sequece,
  m.module_name            AS module_name,
  m.module_duration        AS module_duration,
  m.module_result          AS module_result,
  s.step_sequence          AS step_sequence,
  s.step_name              AS step_name,
  s.step_result            AS step_result,
  s.step_description_error AS step_description_error,
  s.document_type          AS document_type,
  s.document_identification AS document_identification,
  s.customer_phone         AS customer_phone,
  s.billing_account_id     AS billing_account_id
FROM keepcoding.ivr_calls c
INNER JOIN keepcoding.ivr_modules m
  ON c.ivr_id = m.ivr_id
INNER JOIN keepcoding.ivr_steps s
  ON m.ivr_id = s.ivr_id
 AND m.module_sequece = s.module_sequece;




-- EJERCICIO 4: Generar el campo vdn_aggregation

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  CASE
    WHEN calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
    WHEN calls_vdn_label LIKE 'TECH%' THEN 'TECH'
    WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
    ELSE 'RESTO'
  END AS vdn_aggregation
FROM keepcoding.ivr_detail;




-- EJERCICIO 5: Generar los campos document_type y document_identification

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  MIN(document_type) AS document_type,
  MIN(document_identification) AS document_identification
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;



-- EJERCICIO 6: Generar el campo customer_phone

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  MIN(customer_phone) AS customer_phone
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;




-- EJERCICIO 7: Generar el campo billing_account_id

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  MIN(billing_account_id) AS billing_account_id
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;




-- EJERCICIO 8: Generar el campo masiva_lg

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  CASE
    WHEN SUM(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) > 0 
      THEN 1 
    ELSE 0
  END AS masiva_lg
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;




-- EJERCICIO 9: Generar el campo info_by_phone_lg

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  CASE
    WHEN SUM(CASE 
                WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' 
                 AND step_result = 'OK' 
                THEN 1 ELSE 0 
              END) > 0 
      THEN 1 
    ELSE 0
  END AS info_by_phone_lg
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;




-- EJERCICIO 10: Generar el campo info_by_dni_lg

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  calls_ivr_id,
  CASE
    WHEN SUM(CASE 
                WHEN step_name = 'CUSTOMERINFOBYDNI.TX' 
                 AND step_result = 'OK' 
                THEN 1 ELSE 0 
              END) > 0 
      THEN 1 
    ELSE 0
  END AS info_by_dni_lg
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;



 
-- EJERCICIO 11: Generar los campos repeated_phone_24H y cause_recall_phone_24H

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH base AS (
  SELECT
    calls_ivr_id,
    calls_phone_number,
    calls_end_date,
    LAG(calls_end_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_end_date) AS prev_call,
    LEAD(calls_end_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_end_date) AS next_call
  FROM keepcoding.ivr_detail
)
SELECT
  calls_ivr_id,
  CASE 
    WHEN prev_call IS NOT NULL 
         AND TIMESTAMP_DIFF(calls_end_date, prev_call, HOUR) <= 24 
    THEN 1 ELSE 0 
  END AS repeated_phone_24H,
  CASE 
    WHEN next_call IS NOT NULL 
         AND TIMESTAMP_DIFF(next_call, calls_end_date, HOUR) <= 24 
    THEN 1 ELSE 0 
  END AS cause_recall_phone_24H
FROM base;




-- EJERCICIO 12: Crear tabla ivr_summary
-- Lo intenté hacer con ROW_NUMBER pero no me salió y ya no tengo más tiempo ni cabeza

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
SELECT
  calls_ivr_id              AS ivr_id,
  MIN(calls_phone_number)   AS phone_number,
  MIN(calls_ivr_result)     AS ivr_result,
  MIN(vdn_aggregation)      AS vdn_aggregation,
  MIN(calls_start_date)     AS start_date,
  MAX(calls_end_date)       AS end_date,
  MAX(calls_total_duration) AS total_duration,
  MIN(calls_customer_segment) AS customer_segment,
  MIN(calls_ivr_language)   AS ivr_language,
  MAX(calls_steps_module)   AS steps_module,
  MAX(calls_module_aggregation) AS module_aggregation,
  MIN(document_type)        AS document_type,
  MIN(document_identification) AS document_identification,
  MIN(customer_phone)       AS customer_phone,
  MIN(billing_account_id)   AS billing_account_id,
  MAX(masiva_lg)            AS masiva_lg,
  MAX(info_by_phone_lg)     AS info_by_phone_lg,
  MAX(info_by_dni_lg)       AS info_by_dni_lg,
  MAX(repeated_phone_24H)   AS repeated_phone_24H,
  MAX(cause_recall_phone_24H) AS cause_recall_phone_24H
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;




-- EJERCICIO 13: CREAR FUNCIÓN DE LIMPIEZA DE ENTEROS
-- Lo que encontré investigando fue la función clean_integer

CREATE OR REPLACE FUNCTION keepcoding.clean_integer(val INT64)
RETURNS INT64
AS (
  IFNULL(val, -999999)
);
