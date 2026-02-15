CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

CREATE TABLE departement(
    departement_idINT INT PRIMARY KEY AUTO_INCREMENT,
    departement_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    departement_head VARCHAR(100),
    creation_date DATE 
);

CREATE TABLE professor(
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    departement_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id) ON DELETE SET NULL ON UPDATE CASCADE

);
CREATE TABLE student(
    student_id  INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    departement_id INT,
    level VARCHAR(20) CHECK(level IN ("L1","L2","L3","M1","M2")),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id) ON DELETE SET NULL ON UPDATE CASCADE
); 
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK(credits>0),
    semester INT CHECK (semester IN (1,2)),
    departement_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollment(
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    academic_year VARCHAR(9) NOT NULL FORMAT "YYYY-YYYY",
    status VARCHAR(20) DEFAULT "In Progress" CHECK (status IN ("In Progress","Passed","Failed","Dropped")),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(student_id,course_id,academic_year)
    
);
CREATE TABLE grade (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(20) CHECK (evaluation_type IN ("Lab","Exam","Project","Assignment")),
    garde DECIMAL(5,2) CHECK(grade>=0,grade<=20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comment TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE

);
 
 CREATE INDEX idx_student_departement ON student(departement_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollment(student_id);
CREATE INDEX idx_enrollment_course ON enrollment(course_id);
CREATE INDEX idx_grade_enrollment ON grade(enrollment_id);