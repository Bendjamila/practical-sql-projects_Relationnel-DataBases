/* 
   DATABASE CREATION
*/
CREATE DATABASE university_db;
USE university_db;

/* 
   1. TABLE: departments
*/
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date DATE
);

/*
   2. TABLE: professors
 */
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    CONSTRAINT fk_prof_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

/* 
   3. TABLE: students
 */
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20),
    enrollment_date DATE ,
    CONSTRAINT chk_level CHECK (level IN ('L1','L2','L3','M1','M2')),
    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

/*
   4. TABLE: courses
 */
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    CONSTRAINT chk_credits CHECK (credits > 0),
    CONSTRAINT chk_semester CHECK (semester BETWEEN 1 AND 2),
    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_professor
        FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

/*
   5. TABLE: enrollments
 */
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT chk_status CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE(student_id, course_id, academic_year)
);

/*
   6. TABLE: grades
*/
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT chk_eval_type CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CONSTRAINT chk_grade CHECK (grade BETWEEN 0 AND 20),
    CONSTRAINT fk_grade_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/*
   INDEXES
 */
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

/*
   INSERT TEST DATA
*/

/* Departments */
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science','Building A',500000,'Dr. Smith','2000-01-01'),
('Mathematics','Building B',350000,'Dr. Johnson','1998-05-10'),
('Physics','Building C',400000,'Dr. Brown','1995-09-15'),
('Civil Engineering','Building D',600000,'Dr. Wilson','2005-03-20');

/* Professors */
INSERT INTO professors (last_name, first_name, email, department_id, hire_date, salary, specialization) VALUES
('Smith','John','john.smith@uni.edu',1,'2010-01-01',80000,'AI'),
('Doe','Jane','jane.doe@uni.edu',1,'2012-03-12',75000,'Databases'),
('White','Alan','alan.white@uni.edu',1,'2015-07-19',72000,'Networks'),
('Taylor','Emma','emma.taylor@uni.edu',2,'2011-02-14',70000,'Algebra'),
('Green','Robert','robert.green@uni.edu',3,'2009-06-30',78000,'Quantum Mechanics'),
('Black','Laura','laura.black@uni.edu',4,'2013-11-21',82000,'Structures');

/* Students */
INSERT INTO students (student_number,last_name,first_name,date_of_birth,email,department_id,level) VALUES
('S1001','Ali','Karim','2003-05-10','ali@uni.edu',1,'L2'),
('S1002','Nadia','Ben','2002-03-15','nadia@uni.edu',1,'L3'),
('S1003','Omar','Haddad','2001-09-20','omar@uni.edu',2,'M1'),
('S1004','Sara','Khan','2003-11-01','sara@uni.edu',3,'L2'),
('S1005','Yassine','Moussa','2002-07-18','yassine@uni.edu',4,'L3'),
('S1006','Lina','Amir','2001-12-05','lina@uni.edu',1,'M1'),
('S1007','Hassan','Ali','2003-04-22','hassan@uni.edu',2,'L2'),
('S1008','Meriem','Saad','2002-10-30','meriem@uni.edu',3,'L3');

/* Courses */
INSERT INTO courses (course_code,course_name,credits,semester,department_id,professor_id) VALUES
('CS101','Database Systems',6,1,1,2),
('CS102','Artificial Intelligence',6,2,1,1),
('CS103','Computer Networks',5,1,1,3),
('MATH201','Linear Algebra',5,1,2,4),
('PHY301','Quantum Physics',6,2,3,5),
('CIV401','Structural Analysis',6,1,4,6),
('CS104','Operating Systems',5,2,1,2);

/* Enrollments (15+) */
INSERT INTO enrollments (student_id,course_id,academic_year,status) VALUES
(1,1,'2024-2025','In Progress'),
(1,2,'2024-2025','In Progress'),
(2,1,'2024-2025','Passed'),
(2,3,'2023-2024','Passed'),
(3,4,'2024-2025','In Progress'),
(4,5,'2024-2025','In Progress'),
(5,6,'2024-2025','In Progress'),
(6,2,'2023-2024','Passed'),
(7,4,'2024-2025','In Progress'),
(8,5,'2023-2024','Failed'),
(3,1,'2023-2024','Passed'),
(4,3,'2023-2024','Passed'),
(5,1,'2024-2025','In Progress'),
(6,7,'2024-2025','In Progress'),
(7,3,'2024-2025','In Progress');

/* Grades (12+) */
INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient,evaluation_date) VALUES
(3,'Exam',15,2,'2024-06-10'),
(4,'Project',17,1.5,'2024-05-20'),
(8,'Exam',16,2,'2024-06-15'),
(10,'Exam',11,2,'2024-06-18'),
(11,'Assignment',14,1,'2024-04-01'),
(12,'Lab',13,1,'2024-03-20'),
(3,'Project',18,1,'2024-05-01'),
(4,'Exam',12,2,'2024-06-01'),
(8,'Lab',15,1,'2024-04-15'),
(11,'Exam',16,2,'2024-06-20'),
(12,'Project',17,1.5,'2024-05-10'),
(10,'Assignment',10,1,'2024-03-30');

/* =========================================
   30 SQL ANALYSIS QUERIES
========================================= */

-- 1
SELECT * FROM students;

-- 2
SELECT * FROM professors WHERE salary > 75000;

-- 3
SELECT course_name, credits FROM courses WHERE semester = 1;

-- 4
SELECT COUNT(*) FROM students;

-- 5
SELECT department_name, budget FROM departments ORDER BY budget DESC;

-- 6
SELECT level, COUNT(*) FROM students GROUP BY level;

-- 7
SELECT AVG(salary) FROM professors;

-- 8
SELECT MAX(grade), MIN(grade) FROM grades;

-- 9
SELECT s.first_name, s.last_name, c.course_name
FROM enrollments e
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;

-- 10
SELECT department_id, COUNT(*) FROM professors GROUP BY department_id;

-- 11
SELECT * FROM enrollments WHERE status='Passed';

-- 12
SELECT * FROM students WHERE level='M1';

-- 13
SELECT course_name FROM courses WHERE credits=6;

-- 14
SELECT academic_year, COUNT(*) FROM enrollments GROUP BY academic_year;

-- 15
SELECT s.first_name, AVG(g.grade)
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
GROUP BY s.student_id;

-- 16
SELECT professor_id, COUNT(*) FROM courses GROUP BY professor_id;

-- 17
SELECT * FROM courses WHERE max_capacity=30;

-- 18
SELECT * FROM grades WHERE grade>=15;

-- 19
SELECT s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id=e.student_id
WHERE e.enrollment_id IS NULL;

-- 20
SELECT COUNT(*) FROM enrollments WHERE status='Failed';

-- 21
SELECT SUM(budget) FROM departments;

-- 22
SELECT * FROM professors WHERE specialization='AI';

-- 23
SELECT DISTINCT status FROM enrollments;

-- 24
SELECT course_name FROM courses WHERE semester=2;

-- 25
SELECT COUNT(*) FROM grades;

-- 26
SELECT AVG(grade) FROM grades;

-- 27
SELECT * FROM students ORDER BY enrollment_date DESC;

-- 28
SELECT s.first_name, COUNT(e.enrollment_id)
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
GROUP BY s.student_id;

-- 29
SELECT c.course_name, COUNT(e.student_id)
FROM courses c
LEFT JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_id;

-- 30
SELECT s.first_name, s.last_name, e.status
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
WHERE e.academic_year='2024-2025';
