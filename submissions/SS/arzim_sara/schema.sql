CREATE DATABASE IF NOT EXISTS UNI_DB;

USE UNI_DB;

CREATE TABLE DEPARTMENTS (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2) ,
    department_head VARCHAR(100),
    creation_date DATE
);

CREATE TABLE PROFESSORS (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    specialization VARCHAR(100),
    CONSTRAINT fk_department_professor 
    FOREIGN KEY (department_id) 
    REFERENCES DEPARTMENTS(department_id)
    ON DELETE SET NULL -- if department is deleted in DEPARTMENTS, set department_id to NULL IN PROFESSORS
    ON UPDATE CASCADE -- if department_id is updated in DEPARTMENTS, update it in PROFESSORS as well
);

CREATE TABLE STUDENTS (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE DEFAULT (CURDATE()) ,
    CONSTRAINT fk_department_student
    FOREIGN KEY (department_id)
    REFERENCES DEPARTMENTS(department_id)
    ON DELETE SET NULL 
    ON UPDATE CASCADE
);

CREATE TABLE COURSES (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester IN (1, 2)),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    CONSTRAINT fk_department_course
    FOREIGN KEY (department_id)
    REFERENCES DEPARTMENTS(department_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT fk_professor_course
    FOREIGN KEY (professor_id)
    REFERENCES PROFESSORS(professor_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE ENROLLMENTS (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURDATE()),
    academic_year VARCHAR(9) NOT NULL CHECK (academic_year REGEXP '^[0-9]{4}-[0-9]{4}$'),
    status VARCHAR(20) DEFAULT 'IN PROGRESS' CHECK (status IN ('IN PROGRESS', 'PASSED', 'FAILED', 'DROPPED')),
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT fk_student_enrollment
    FOREIGN KEY (student_id)
    REFERENCES STUDENTS(student_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT fk_course_enrollment
    FOREIGN KEY (course_id)
    REFERENCES COURSES(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE GRADES (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('ASSIGNMENT', 'LAB', 'EXAM','PROJECT')),
    grade DECIMAL(5, 2) CHECK (grade >= 0 AND grade <= 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00 ,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT fk_enrollment_grade
    FOREIGN KEY (enrollment_id)
    REFERENCES ENROLLMENTS(enrollment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE INDEX idx_student_department ON STUDENTS(department_id);
CREATE INDEX idx_course_professor ON COURSES(professor_id);
CREATE INDEX idx_enrollment_student ON ENROLLMENTS(student_id);
CREATE INDEX idx_enrollment_course ON ENROLLMENTS(course_id);
CREATE INDEX idx_grade_enrollment ON GRADES(enrollment_id);

