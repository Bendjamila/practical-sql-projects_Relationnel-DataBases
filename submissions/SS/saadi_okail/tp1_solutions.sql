-- ============================================
 TP1: University Management System
-- ============================================
CREATE DATABASE university_db;
USE university_db;

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date DATE
);

CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    CHECK (level IN ('L1','L2','L3','M1','M2')),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT CHECK (credits > 0),
    semester INT CHECK (semester IN (1,2)),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    UNIQUE (student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- INDEXES
-- ============================================
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- ============================================
-- DATA INSERTION
-- ============================================

INSERT INTO departments (department_name, building, budget)
VALUES
('Computer Science','Building A',500000),
('Mathematics','Building B',350000),
('Physics','Building C',400000),
('Civil Engineering','Building D',600000);

INSERT INTO professors (last_name, first_name, email, department_id, salary, specialization)
VALUES
('Smith','John','john.smith@uni.edu',1,4500,'AI'),
('Martin','Claire','claire.martin@uni.edu',1,4700,'Databases'),
('Brown','Oliver','oliver.brown@uni.edu',1,4300,'Networks'),
('Dubois','Pierre','pierre.dubois@uni.edu',2,4200,'Algebra'),
('Moreau','Luc','luc.moreau@uni.edu',3,4400,'Quantum Physics'),
('Taylor','Emily','emily.taylor@uni.edu',4,4800,'Structures');

INSERT INTO students (student_number,last_name,first_name,email,department_id,level)
VALUES
('S001','Durand','Lucas','lucas.durand@uni.edu',1,'L3'),
('S002','Wilson','James','james.wilson@uni.edu',1,'M1'),
('S003','Bernard','Sophie','sophie.bernard@uni.edu',2,'L2'),
('S004','Thomas','Harry','harry.thomas@uni.edu',3,'L3'),
('S005','Petit','Emma','emma.petit@uni.edu',4,'M1'),
('S006','Walker','Noah','noah.walker@uni.edu',1,'L2'),
('S007','Lefevre','Chloe','chloe.lefevre@uni.edu',2,'L3'),
('S008','King','Leo','leo.king@uni.edu',3,'M1');

INSERT INTO courses (course_code,course_name,credits,semester,department_id,professor_id)
VALUES
('CS101','Databases',6,1,1,2),
('CS102','AI Basics',6,2,1,1),
('CS103','Networks',5,1,1,3),
('MA201','Linear Algebra',5,1,2,4),
('PH301','Quantum Mechanics',6,2,3,5),
('CE101','Statics',5,1,4,6),
('CE102','Materials',6,2,4,6);

INSERT INTO enrollments (student_id,course_id,academic_year,status)
VALUES
(1,1,'2024-2025','Passed'),
(1,2,'2024-2025','Passed'),
(2,1,'2024-2025','In Progress'),
(3,4,'2024-2025','Passed'),
(4,5,'2023-2024','Failed'),
(5,6,'2024-2025','Passed'),
(6,1,'2024-2025','In Progress'),
(7,4,'2024-2025','Passed'),
(8,5,'2024-2025','In Progress'),
(2,3,'2024-2025','Passed'),
(3,3,'2024-2025','In Progress'),
(4,1,'2024-2025','Passed'),
(5,7,'2024-2025','Passed'),
(6,2,'2024-2025','In Progress'),
(7,2,'2024-2025','Passed');

INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient)
VALUES
(1,'Exam',15,1),
(1,'Project',16,1.5),
(2,'Exam',14,1),
(3,'Exam',12,1),
(4,'Exam',17,1),
(5,'Exam',10,1),
(6,'Exam',18,1),
(7,'Lab',13,0.5),
(8,'Exam',16,1),
(9,'Project',14,1.5),
(10,'Exam',15,1),
(11,'Lab',11,0.5),
(12,'Exam',17,1);

-- ========== 30 SQL Queries to Solution ==========
-- Q1

SELECT last_name, first_name, email, level FROM students;

-- Q2

SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3

SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4

SELECT student_number, last_name, first_name, email
FROM students WHERE level = 'L3';

-- Q5

SELECT course_code, course_name, credits, semester
FROM courses WHERE semester = 1;

-- Q6

SELECT c.course_code, c.course_name,
       CONCAT(p.last_name,' ',p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       d.department_name, s.level
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Q9

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10

SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
GROUP BY s.student_id;

-- Q12

SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13

SELECT SUM(budget) AS total_budget FROM departments;

-- Q14

SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15

SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16

SELECT student_name, average_grade
FROM (
    SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
           AVG(g.grade) AS average_grade
    FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.enrollment_id
    JOIN students s ON e.student_id = s.student_id
    GROUP BY s.student_id
) t
ORDER BY average_grade DESC
LIMIT 3;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

-- Q18

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       COUNT(e.course_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id;

-- Q19

SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- Q21

SELECT student_name, student_avg, department_avg
FROM (
    SELECT s.student_id,
           CONCAT(s.last_name,' ',s.first_name) AS student_name,
           AVG(g.grade) AS student_avg,
           (
             SELECT AVG(g2.grade)
             FROM grades g2
             JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
             JOIN students s2 ON e2.student_id = s2.student_id
             WHERE s2.department_id = s.department_id
           ) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) t
WHERE student_avg > department_avg;

-- Q22

SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) >
(
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(enrollment_id) AS cnt
        FROM enrollments
        GROUP BY course_id
    ) sub
);

-- Q23

SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade IS NULL;

-- Q25

SELECT department_name, student_count
FROM (
    SELECT d.department_name, COUNT(s.student_id) AS student_count
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id
) t
WHERE student_count >
(
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM students
        GROUP BY department_id
    ) sub
);

-- Q26

SELECT c.course_name,
       COUNT(g.grade) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade)) * 100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27

SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
       CONCAT(s.last_name,' ',s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q28

SELECT c.course_name, g.evaluation_type, g.grade,
       g.coefficient, g.grade * g.coefficient AS weighted_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 1;

-- Q29

SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30

SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       (COUNT(e.enrollment_id) / c.max_capacity) * 100 AS percentage_full
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
