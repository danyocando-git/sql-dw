-- EJERCICIO 2: CREACIÓN DE TABLAS PARA LA PRÁCTICA KEEP CODING

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




-- EJERCICIO 3: CREACIÓN DE LA TABLA ivr_detail

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id;




  -- EJERCICIO 4: CREACIÓN DE ivr_detail CON EL CAMPO vdn_aggregation

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH vdn_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), ',') AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN vdn_per_call v
  ON c.ivr_id = v.ivr_id;




-- EJERCICIO 5: CREACIÓN DE ivr_detail CON EL CAMPO document_type_aggregation

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH doc_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT document_type ORDER BY document_type), ',') AS document_type_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,
  d.document_type_aggregation,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), ',') AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
) v
  ON c.ivr_id = v.ivr_id
LEFT JOIN doc_per_call d
  ON c.ivr_id = d.ivr_id;




  -- EJERCICIO 5: CREACIÓN DE ivr_detail CON EL CAMPO document_type_aggregation

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH doc_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT document_type ORDER BY document_type), ',') AS document_type_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,
  d.document_type_aggregation,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), ',') AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
) v
  ON c.ivr_id = v.ivr_id
LEFT JOIN doc_per_call d
  ON c.ivr_id = d.ivr_id;




-- EJERCICIO 6: CREACIÓN DE ivr_detail CON EL CAMPO customer_phone_aggregation

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH phone_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT customer_phone ORDER BY customer_phone), ',') AS customer_phone_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,
  d.document_type_aggregation,
  p.customer_phone_aggregation,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), ',') AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
) v
  ON c.ivr_id = v.ivr_id
LEFT JOIN (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT document_type ORDER BY document_type), ',') AS document_type_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
) d
  ON c.ivr_id = d.ivr_id
LEFT JOIN phone_per_call p
  ON c.ivr_id = p.ivr_id;
  



-- EJERCICIO 7: CREACIÓN DE ivr_detail CON EL CAMPO billing_account_id_aggregation

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH billing_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(
      ARRAY_AGG(DISTINCT billing_account_id ORDER BY billing_account_id), 
      ','
    ) AS billing_account_id_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
vdn_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(
      ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), 
      ','
    ) AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
),
doc_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(
      ARRAY_AGG(DISTINCT document_type ORDER BY document_type), 
      ','
    ) AS document_type_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
phone_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(
      ARRAY_AGG(DISTINCT customer_phone ORDER BY customer_phone), 
      ','
    ) AS customer_phone_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,
  d.document_type_aggregation,
  p.customer_phone_aggregation,
  b.billing_account_id_aggregation,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN vdn_per_call v
  ON c.ivr_id = v.ivr_id
LEFT JOIN doc_per_call d
  ON c.ivr_id = d.ivr_id
LEFT JOIN phone_per_call p
  ON c.ivr_id = p.ivr_id
LEFT JOIN billing_per_call b
  ON c.ivr_id = b.ivr_id;




  -- EJERCICIO 8: CREACIÓN DE ivr_detail CON EL CAMPO total_modules

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH modules_per_call AS (
  SELECT
    ivr_id,
    COUNT(DISTINCT module_sequece) AS total_modules
  FROM keepcoding.ivr_modules
  GROUP BY ivr_id
),
vdn_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), ',') AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
),
doc_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT document_type ORDER BY document_type), ',') AS document_type_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
phone_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT customer_phone ORDER BY customer_phone), ',') AS customer_phone_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
billing_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT billing_account_id ORDER BY billing_account_id), ',') AS billing_account_id_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,
  d.document_type_aggregation,
  p.customer_phone_aggregation,
  b.billing_account_id_aggregation,
  mpc.total_modules,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN vdn_per_call v
  ON c.ivr_id = v.ivr_id
LEFT JOIN doc_per_call d
  ON c.ivr_id = d.ivr_id
LEFT JOIN phone_per_call p
  ON c.ivr_id = p.ivr_id
LEFT JOIN billing_per_call b
  ON c.ivr_id = b.ivr_id
LEFT JOIN modules_per_call mpc
  ON c.ivr_id = mpc.ivr_id;




-- EJERCICIO 9: CREACIÓN DE ivr_detail CON EL CAMPO total_steps

  CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
WITH steps_per_call AS (
  SELECT
    ivr_id,
    COUNT(DISTINCT step_sequence) AS total_steps
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
modules_per_call AS (
  SELECT
    ivr_id,
    COUNT(DISTINCT module_sequece) AS total_modules
  FROM keepcoding.ivr_modules
  GROUP BY ivr_id
),
vdn_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT vdn_label ORDER BY vdn_label), ',') AS vdn_aggregation
  FROM keepcoding.ivr_calls
  GROUP BY ivr_id
),
doc_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT document_type ORDER BY document_type), ',') AS document_type_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
phone_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT customer_phone ORDER BY customer_phone), ',') AS customer_phone_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
),
billing_per_call AS (
  SELECT
    ivr_id,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT billing_account_id ORDER BY billing_account_id), ',') AS billing_account_id_aggregation
  FROM keepcoding.ivr_steps
  GROUP BY ivr_id
)
SELECT
  -- Campos de ivr_calls
  c.ivr_id,
  c.phone_number,
  c.ivr_result,
  c.vdn_label,
  c.start_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS INT64) AS start_date_id,
  c.end_date,
  CAST(FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS INT64)   AS end_date_id,
  c.total_duration,
  c.customer_segment,
  c.ivr_language,
  c.steps_module,
  c.module_aggregation,
  v.vdn_aggregation,
  d.document_type_aggregation,
  p.customer_phone_aggregation,
  b.billing_account_id_aggregation,
  mpc.total_modules,
  spc.total_steps,

  -- Campos de ivr_modules
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,

  -- Campos de ivr_steps
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id

FROM keepcoding.ivr_steps s
JOIN keepcoding.ivr_modules m
  ON s.ivr_id = m.ivr_id
 AND s.module_sequece = m.module_sequece
JOIN keepcoding.ivr_calls c
  ON m.ivr_id = c.ivr_id
LEFT JOIN vdn_per_call v
  ON c.ivr_id = v.ivr_id
LEFT JOIN doc_per_call d
  ON c.ivr_id = d.ivr_id
LEFT JOIN phone_per_call p
  ON c.ivr_id = p.ivr_id
LEFT JOIN billing_per_call b
  ON c.ivr_id = b.ivr_id
LEFT JOIN modules_per_call mpc
  ON c.ivr_id = mpc.ivr_id
LEFT JOIN steps_per_call spc
  ON c.ivr_id = spc.ivr_id;
 



-- EJERCICIO 12: CREAR TABLA ivr_summary
-- Usé sólo ROW_NUMBER y QUALIFY que vimos - Hasta aquí legué, no supe como investigar más para completarlo

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
SELECT
  CAST(ivr_id AS STRING) AS ivr_id,
  phone_number,
  ivr_result,
  vdn_aggregation,
  start_date,
  end_date,
  total_duration,
  customer_segment,
  ivr_language,
  steps_module,
  module_aggregation,
  document_type_aggregation AS document_type,
  document_identification,
  customer_phone_aggregation AS customer_phone,
  billing_account_id_aggregation AS billing_account_id,

  -- placeholders de columnas que se crearán en ejercicios posteriores
  NULL AS masiva_lg,
  NULL AS info_by_phone_lg,
  NULL AS info_by_dni_lg,
  NULL AS repeated_phone_24H,
  NULL AS cause_recall_phone_24H,

  ROW_NUMBER() OVER (PARTITION BY CAST(ivr_id AS STRING) ORDER BY end_date DESC) AS rn
FROM keepcoding.ivr_detail
QUALIFY rn = 1;
