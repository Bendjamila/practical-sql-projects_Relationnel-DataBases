-- TP1 ENSTA DATA BASE
-- 3rd year eng
-- Student name:DIFFALLAH Imene

CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- ========================
-- TABLES
-- ========================

-- Departments table 
CREATE TABLE departments (
department_id INT PRIMARY KEY AUTO_INCREMENT,
department_name VARCHAR(100) NOT NULL,
building VARCHAR(50),
budget DECIMAL(12,2), -- maybe prevent negative later
department_head VARCHAR(100),
creation_date DATE
);

-- Professors table
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
FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Students table
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
enrollment_date DATE DEFAULT CURRENT_DATE,
CHECK(level IN ('L1','L2','L3','M1','M2')),
FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Courses table
CREATE TABLE courses (
course_id INT PRIMARY KEY AUTO_INCREMENT,
course_code VARCHAR(10) UNIQUE NOT NULL,
course_name VARCHAR(150) NOT NULL,
description TEXT,
credits INT NOT NULL CHECK(credits>0),
semester INT CHECK(semester BETWEEN 1 AND 2),
department_id INT,
professor_id INT,
max_capacity INT DEFAULT 30,
FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Enrollments table
CREATE TABLE enrollments (
enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
student_id INT NOT NULL,
course_id INT NOT NULL,
enrollment_date DATE DEFAULT CURRENT_DATE,
academic_year VARCHAR(9) NOT NULL,
status VARCHAR(20) DEFAULT 'In Progress',
CHECK(status IN('In Progress','Passed','Failed','Dropped')),
UNIQUE(student_id, course_id, academic_year),
FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Grades table
CREATE TABLE grades (
grade_id INT PRIMARY KEY AUTO_INCREMENT,
enrollment_id INT NOT NULL,
evaluation_type VARCHAR(30),
grade DECIMAL(5,2) CHECK(grade BETWEEN 0 AND 20),
coefficient DECIMAL(3,2) DEFAULT 1.00,
evaluation_date DATE,
comments TEXT,
CHECK(evaluation_type IN('Assignment','Lab','Exam','Project')),
FOREIGN KEY(enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ========================
-- INDEXES
-- ========================

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- ========================
-- Now we have the 30 QUERIES
-- ========================

-- Q1 all students
SELECT last_name, first_name, email, level FROM students;

-- Q2 CS profs
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id=d.department_id
WHERE d.department_name='Computer Science';

-- Q3 courses >5 credits
SELECT course_code, course_name, credits FROM courses WHERE credits>5;

-- Q4 L3 students
SELECT student_number, last_name, first_name, email FROM students WHERE level='L3';

-- Q5 semester 1 courses
SELECT course_code, course_name, credits, semester FROM courses WHERE semester=1;

-- Q6 courses + prof
SELECT c.course_code, c.course_name, CONCAT(p.last_name,' ',p.first_name) AS prof_name
FROM courses c
LEFT JOIN professors p ON c.professor_id=p.professor_id;

-- Q7 students + enrollments
SELECT CONCAT(s.last_name,' ',s.first_name) AS stud_name, c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;

-- Q8 students + dept
SELECT CONCAT(s.last_name,' ',s.first_name) AS stud_name, d.department_name, s.level
FROM students s
JOIN departments d ON s.department_id=d.department_id;

-- Q9 grades per course
SELECT CONCAT(s.last_name,' ',s.first_name) AS stud_name, c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;

-- Q10 courses per prof
SELECT CONCAT(p.last_name,' ',p.first_name) AS prof_name, COUNT(c.course_id) AS nb_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id;

-- Q11 avg per student
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
GROUP BY s.student_id;

-- Q12 students per dept
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id=s.department_id
GROUP BY d.department_id;

-- Q13 total budget
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14 courses per dept
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id=c.department_id
GROUP BY d.department_id;

-- Q15 avg salary per dept
SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
JOIN professors p ON d.department_id=p.department_id
GROUP BY d.department_id;

-- Q16 top 3 students
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17 courses w/ no enroll
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id=e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18 students passed all courses
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, COUNT() AS passed_courses_count
FROM enrollments e
JOIN students s ON e.student_id=s.student_id
WHERE e.status='Passed'
GROUP BY s.student_id
HAVING COUNT() = (SELECT COUNT(*) FROM enrollments e2 WHERE e2.student_id=s.student_id);

-- Q19 prof >2 courses
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20 students >2 courses
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, COUNT() AS enrolled_courses_count
FROM enrollments e
JOIN students s ON e.student_id=s.student_id
GROUP BY s.student_id
HAVING COUNT() > 2;

-- Q21 student avg > dept avg (my fav!)
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS student_avg,
(SELECT AVG(g2.grade)
FROM grades g2
JOIN enrollments e2 ON g2.enrollment_id=e2.enrollment_id
JOIN students s2 ON e2.student_id=s2.student_id
WHERE s2.department_id=s.department_id) AS department_avg
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
GROUP BY s.student_id
HAVING student_avg > department_avg;

-- Q22 courses > avg enroll
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) >
(SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM enrollments GROUP BY course_id) tmp);

-- Q23 prof from dept highest budget
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id=d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24 students w/ no grades
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, s.email
FROM students s
WHERE s.student_id NOT IN (SELECT e.student_id FROM enrollments e JOIN grades g ON e.enrollment_id=g.enrollment_id);

-- Q25 dept > avg stud
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id=s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) > (SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM students GROUP BY department_id) tmp);

-- Q26 pass rate per course
SELECT c.course_name, COUNT(g.grade) AS total_grades, SUM(g.grade>=10) AS passed_grades,
ROUND(SUM(g.grade>=10)/COUNT(g.grade)*100,2) AS pass_rate_percentage
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN courses c ON e.course_id=c.course_id
GROUP BY c.course_id;

-- Q27 ranking
SELECT RANK() OVER(ORDER BY AVG(g.grade) DESC) AS rank_position, CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
GROUP BY s.student_id;

-- Q28 report card student_id=1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, (g.grade*g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN courses c ON e.course_id=c.course_id
WHERE e.student_id=1;

-- Q29 teaching load
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id;

-- Q30 overloaded courses
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity,
ROUND(COUNT(e.enrollment_id)/c.max_capacity*100,2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_id
HAVING percentage_full>80;
