-- TP1: University Management System
-- Step 1: Create Database
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;
-- Step 2: Create table departement :
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date DATE
);
-- Step 3: Create table professors :
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
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT chk_level CHECK (level IN ('L1','L2','L3','M1','M2')),
    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
-- Step5: Create table courses :
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
-- Step6: Create table enrollments :
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT chk_status CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- Step7: Create table grades :
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
-- Step7: required indexes :
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
-- Step8: inserting data :
INSERT INTO departments (department_name, building, budget)
VALUES
('Computer Science','Building A',500000),
('Mathematics','Building B',350000),
('Physics','Building C',400000),
('Civil Engineering','Building D',600000);
INSERT INTO professors (last_name, first_name, email, department_id, hire_date, salary, specialization)
VALUES
('Smith','John','john.smith@uni.com',1,'2015-09-01',70000,'AI'),
('Brown','Emma','emma.brown@uni.com',1,'2018-01-15',65000,'Databases'),
('Wilson','David','david.wilson@uni.com',1,'2016-06-20',72000,'Networks'),
('Taylor','Sarah','sarah.taylor@uni.com',2,'2014-03-10',60000,'Algebra'),
('Anderson','Michael','michael.anderson@uni.com',3,'2012-11-05',75000,'Quantum Physics'),
('Thomas','Laura','laura.thomas@uni.com',4,'2019-02-18',68000,'Structural Engineering');
INSERT INTO students (student_number,last_name,first_name,date_of_birth,email,department_id,level)
VALUES
('S001','Ali','Karim','2003-04-10','ali@uni.com',1,'L2'),
('S002','Ben','Yacine','2002-07-15','ben@uni.com',1,'L3'),
('S003','Sara','Ahmed','2001-01-20','sara@uni.com',2,'M1'),
('S004','Lina','Said','2003-09-09','lina@uni.com',3,'L2'),
('S005','Omar','Nadir','2002-05-12','omar@uni.com',4,'L3'),
('S006','Nina','Khaled','2001-08-30','nina@uni.com',1,'M1'),
('S007','Rami','Haddad','2003-02-11','rami@uni.com',2,'L2'),
('S008','Yara','Fares','2002-12-22','yara@uni.com',3,'L3');
INSERT INTO courses (course_code,course_name,credits,semester,department_id,professor_id,max_capacity)
VALUES
('CS101','Programming',6,1,1,1,40),
('CS102','Databases',5,2,1,2,35),
('CS103','Networks',5,1,1,3,30),
('MATH201','Linear Algebra',6,1,2,4,30),
('PHY301','Quantum Mechanics',6,2,3,5,25),
('CE101','Statics',5,1,4,6,30),
('CS201','Machine Learning',6,2,1,1,30);
INSERT INTO enrollments (student_id,course_id,academic_year,status)
VALUES
(1,1,'2024-2025','Passed'),
(1,2,'2024-2025','Passed'),
(1,3,'2024-2025','In Progress'),
(2,1,'2024-2025','Passed'),
(2,7,'2024-2025','Passed'),
(3,4,'2024-2025','Passed'),
(3,2,'2023-2024','Passed'),
(4,5,'2024-2025','In Progress'),
(5,6,'2024-2025','Failed'),
(6,7,'2024-2025','Passed'),
(6,2,'2024-2025','Passed'),
(7,4,'2024-2025','Passed'),
(8,5,'2024-2025','Passed'),
(8,1,'2023-2024','Passed'),
(2,3,'2023-2024','Passed');
INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient)
VALUES
(1,'Exam',15,2),
(1,'Assignment',14,1),
(2,'Exam',16,2),
(3,'Lab',12,1),
(4,'Exam',18,2),
(5,'Project',17,2),
(6,'Exam',13,2),
(7,'Exam',14,2),
(9,'Exam',9,2),
(10,'Exam',16,2),
(11,'Assignment',15,1),
(12,'Exam',11,2);

--------------------------------------------------------------- queries----------------------------------------------------------------------------------------------
-- Q1: Select basic student information
SELECT last_name, first_name, email, level
FROM students;
-- Q2: Retrieve professors belonging to the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d 
    ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';
-- Q3: Select courses where the number of credits is greater than 5
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;
-- Q4: Retrieve students whose academic level is 'L3'
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';
-- Q5: Select all courses that belong to semester 1
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;
-- Q6: Display courses with the full name of the assigned professor
SELECT c.course_code,
       c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p
    ON c.professor_id = p.professor_id;
     -- Q7: Retrieve enrollment details
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s 
    ON e.student_id = s.student_id
JOIN courses c 
    ON e.course_id = c.course_id;
-- Q8: Show each student with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d
    ON s.department_id = d.department_id;
-- Q9: Retrieve detailed grade information
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e 
    ON g.enrollment_id = e.enrollment_id
JOIN students s 
    ON e.student_id = s.student_id
JOIN courses c 
    ON e.course_id = c.course_id; 
-- Q10: Count how many courses each professor teaches
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c
    ON p.professor_id = c.professor_id
GROUP BY p.professor_id; 
-- Q11: Calculate the overall weighted average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;
-- Q12: Count the number of students per department
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;
-- Q13: Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;  
-- Q13: Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;
-- Q14: Find the total number of courses per department
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id; 
-- Q15: Calculate the average salary of professors per department
SELECT d.department_name,
       ROUND(AVG(p.salary),2) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id; 
-- Q16: Find the top 3 students with the best weighted averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;
-- Q17: List courses with no enrolled students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;
-- Q18: Display students who have passed all their courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(CASE WHEN e.status != 'Passed' THEN 1 END) = 0;
-- Q19: Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;
-- Q20: List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;
-- Q21: Find students with an average higher than their department's average
SELECT student_name, student_avg, department_avg
FROM (
    SELECT s.student_id,
           CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           s.department_id,
           SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) student_data
JOIN (
    SELECT s.department_id,
           SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) dept_data
ON student_data.department_id = dept_data.department_id
WHERE student_avg > department_avg;
-- Q22: List courses with more enrollments than the average number of enrollments
SELECT c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) >
       (SELECT AVG(course_count)
        FROM (SELECT COUNT(*) AS course_count
              FROM enrollments
              GROUP BY course_id) AS subquery);
 -- Q23: Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments); 
-- Q24: Find students with no grades recorded
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL; 
-- Q25: List departments with more students than the average number of students per department
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) >
       (SELECT AVG(student_total)
        FROM (SELECT COUNT(*) AS student_total
              FROM students
              GROUP BY department_id) AS subquery); 
-- Q26: Calculate the pass rate per course (grades >= 10)
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND((SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100,2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;                       
-- Q27: Display student ranking by descending weighted average
SELECT DENSE_RANK() OVER (ORDER BY average_grade DESC) AS rank_position,
       student_name,
       average_grade
FROM (
    SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS average_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) ranked_students;
-- Q28: Generate a report card for student with student_id = 1
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;
-- Q29: Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;
-- Q30: Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND((COUNT(e.enrollment_id) / c.max_capacity) * 100,2) AS percentage_full
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING (COUNT(e.enrollment_id) / c.max_capacity) > 0.8;
USE university_db;
