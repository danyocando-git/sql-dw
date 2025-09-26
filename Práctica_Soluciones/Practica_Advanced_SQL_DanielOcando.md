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




-- EJERCICIO 3: CREAR TABLA ivr_detail

 



