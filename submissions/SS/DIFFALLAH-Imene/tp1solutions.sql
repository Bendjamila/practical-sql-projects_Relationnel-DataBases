-- TP1 ENSTA DATA BASE
-- 3rd year eng
-- Student name:DIFFALLAH Imene

CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- ========================
-- Tablessss
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
-- Indexes
-- ========================

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
USE university_db;

-- ========================
-- Deps (4)
-- ========================

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science','Building A',500000,'Dr. Karim Bensalem','2005-09-01'),
('Mathematics','Building B',350000,'Dr. Samira Belkacem','2004-09-01'),
('Physics','Building C',400000,'Dr. Nabil Cherif','2006-09-01'),
('Civil Engineering','Building D',600000,'Dr. Mourad Bouziane','2003-09-01');

-- ========================
-- Poffs (6)
-- ========================

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Bensalem','Karim','karim.bensalem@uni.com','0550000001',1,'2015-09-01',90000,'Artificial Intelligence'),
('Amrani','Sofia','sofia.amrani@uni.com','0550000002',1,'2017-09-01',85000,'Computer Networks'),
('Khaldi','Yacine','yacine.khaldi@uni.com','0550000003',1,'2018-09-01',80000,'Databases'),
('Belkacem','Samira','samira.belkacem@uni.com','0550000004',2,'2016-09-01',78000,'Algebra'),
('Cherif','Nabil','nabil.cherif@uni.com','0550000005',3,'2014-09-01',92000,'Theoretical Physics'),
('Bouziane','Mourad','mourad.bouziane@uni.com','0550000006',4,'2013-09-01',95000,'Structural Engineering');

-- ========================
-- Studs (8)
-- ========================

INSERT INTO students (student_number,last_name,first_name,date_of_birth,email,phone,address,department_id,level,enrollment_date) VALUES
('CS001','Benali','Yasmine','2003-05-12','yasmine.benali@uni.com','0660000001','Algiers',1,'L2','2023-09-01'),
('CS002','Kaci','Amine','2002-03-10','amine.kaci@uni.com','0660000002','Oran',1,'L3','2022-09-01'),
('CS003','Bouzid','Sara','2001-07-22','sara.bouzid@uni.com','0660000003','Setif',1,'M1','2021-09-01'),
('MA001','Rahmani','Nour','2003-11-02','nour.rahmani@uni.com','0660000004','Blida',2,'L2','2023-09-01'),
('PH001','Hamdi','Karim','2002-09-15','karim.hamdi@uni.com','0660000005','Annaba',3,'L3','2022-09-01'),
('CE001','Ziani','Lina','2001-12-30','lina.ziani@uni.com','0660000006','Tlemcen',4,'M1','2021-09-01'),
('CS004','Ferhat','Rania','2003-04-18','rania.ferhat@uni.com','0660000007','Algiers',1,'L2','2023-09-01'),
('MA002','Haddad','Omar','2002-01-08','omar.haddad@uni.com','0660000008','Oran',2,'L3','2022-09-01');

-- ========================
-- Courses (7)
-- ========================

INSERT INTO courses (course_code,course_name,description,credits,semester,department_id,professor_id,max_capacity) VALUES
('CS101','Databases','Intro to DB systems',6,1,1,3,30),
('CS102','Artificial Intelligence','Basics of AI',5,2,1,1,30),
('CS103','Computer Networks','Network fundamentals',6,1,1,2,30),
('MA101','Linear Algebra','Matrices and vectors',5,1,2,4,30),
('PH101','Mechanics','Classical mechanics',6,2,3,5,30),
('CE101','Structures I','Intro to structures',5,1,4,6,30),
('CS201','Advanced Databases','Advanced SQL concepts',6,2,1,3,25);

-- ========================
-- Enrollements (15)
-- ========================

INSERT INTO enrollments (student_id,course_id,enrollment_date,academic_year,status) VALUES
(1,1,'2024-09-10','2024-2025','In Progress'),
(1,2,'2024-09-10','2024-2025','In Progress'),
(2,1,'2024-09-10','2024-2025','Passed'),
(2,3,'2024-09-10','2024-2025','Passed'),
(3,2,'2023-09-10','2023-2024','Passed'),
(3,7,'2024-09-10','2024-2025','In Progress'),
(4,4,'2024-09-10','2024-2025','In Progress'),
(5,5,'2024-09-10','2024-2025','Passed'),
(6,6,'2023-09-10','2023-2024','Passed'),
(7,1,'2024-09-10','2024-2025','In Progress'),
(7,3,'2024-09-10','2024-2025','In Progress'),
(8,4,'2023-09-10','2023-2024','Passed'),
(2,7,'2024-09-10','2024-2025','In Progress'),
(1,3,'2024-09-10','2024-2025','In Progress'),
(5,3,'2024-09-10','2024-2025','Failed');

-- ========================
-- Grades (12)
-- ========================

INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient,evaluation_date,comments) VALUES
(3,'Exam',15,2,'2025-01-10','good'),
(4,'Project',17,1.5,'2025-01-15','very good'),
(5,'Exam',14,2,'2024-01-10','good'),
(8,'Exam',16,2,'2025-01-12','very good'),
(9,'Project',18,2,'2024-01-15','excellent'),
(12,'Exam',13,2,'2024-01-10','average'),
(15,'Exam',10,2,'2025-01-12','pass'),
(2,'Assignment',12,1,'2024-12-01','mid'),
(6,'Lab',14,1,'2024-12-15','good'),
(10,'Assignment',11,1,'2024-12-05','ok'),
(11,'Lab',13,1,'2024-12-07','fine'),
(1,'Assignment',12,1,'2024-11-20','intro');
;


-- ========================
-- Now we have the 30 Queries
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
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) = (
    SELECT COUNT(*)
    FROM enrollments e2
    WHERE e2.student_id = s.student_id
);
 s.student_id
HAVING COUNT() = (SELECT COUNT(*) FROM enrollments e2 WHERE e2.student_id=s.student_id);

-- Q19 prof >2 courses
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20 students >2 courses
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS enrolled_courses_count
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 2;


-- Q21 student avg > dept avg
SELECT student_name, student_avg, department_avg
FROM (
    SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
           s.department_id,
           AVG(g.grade) AS student_avg,
           (
               SELECT AVG(g2.grade)
               FROM grades g2
               JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
               JOIN students s2 ON e2.student_id = s2.student_id
               WHERE s2.department_id = s.department_id
           ) AS department_avg
    FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.enrollment_id
    JOIN students s ON e.student_id = s.student_id
    GROUP BY s.student_id
) tmp
WHERE student_avg > department_avg;


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
