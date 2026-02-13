CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

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
email  VARCHAR(50) NOT NULL UNIQUE,
phone VARCHAR(20),
department_id INT,
hire_date DATE,
salary DECIMAL(12,2),
specialization VARCHAR(100),
CONSTRAINT fk_prof_depatment 
	FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE 
    );

CREATE TABLE students (
student_id INT AUTO_INCREMENT PRIMARY KEY,
student_number VARCHAR(20) NOT NULL UNIQUE,
last_name VARCHAR (50) NOT NULL,
first_name VARCHAR (50) NOT NULL,
date_of_birth DATE,
email VARCHAR(100) NOT NULL UNIQUE,
phone VARCHAR(20),
address TEXT,
department_id INT,
level VARCHAR(20),
enrollment_date DATE DEFAULT (CURRENT_DATE),
CONSTRAINT chk_level CHECK (LEVEL in ('L1','L2','L3','M1','M2')),
CONSTRAINT fk_student_department 
	FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE 
);    

CREATE TABLE courses (
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_code VARCHAR(10) NOT NULL UNIQUE,    
course_name VARCHAR(150) NOT NULL,
description TEXT,
credits INT NOT NULL,
semester INT,
department_id INT,
professor_id INT,
max_capacity INT DEFAULT 30,
CONSTRAINT chk_credits CHECK (credits > 0),
CONSTRAINT chk_semester CHECK (semester BETWEEN 1 AND 2),
CONSTRAINT fk_course_professor
	FOREIGN KEY (professor_id)
    REFERENCES professors(professor_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE  enrollments(
 enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
 student_id INT NOT NULL,
 course_id INT NOT NULL,
 enrollment_date DATE DEFAULT (CURRENT_DATE),
 academic_year VARCHAR(9) NOT NULL,
 status VARCHAR(20) DEFAULT 'In Progress',
 CONSTRAINT chk_status CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
 CONSTRAINT fk_enroll_student
 FOREIGN KEY (student_id)
 REFERENCES students(student_id)
 ON DELETE CASCADE
 ON UPDATE CASCADE,
 CONSTRAINT fk_enroll_course
 FOREIGN KEY (course_id)
 REFERENCES courses(course_id)
  ON DELETE CASCADE
 ON UPDATE CASCADE,
 CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, academic_year)
);
    
CREATE TABLE grades(
grade_id INT AUTO_INCREMENT PRIMARY KEY,
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

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

INSERT INTO departments (department_name, building, budget)
VALUES 
('Computer Science', 'Building A', 500000),
('Mathematics', 'Building B', 350000),
('Physics', 'Building C', 400000),
('Civil Engineering', 'Building D', 600000);

INSERT INTO professors (last_name, first_name, email, department_id, salary, specialization)
VALUES
('Benkhelifa','Amine','a.benkhelifa@uni.com',1,70000,'AI'),
('Bouaziz','Sara','s.bouaziz@uni.com',1,72000,'Databases'),
('Mansouri','Yacine','y.mansouri@uni.com',1,69000,'Networks'),
('Haddad','Lina','l.haddad@uni.com',2,65000,'Algebra'),
('Boudjemaa','Karim','k.boudjemaa@uni.com',3,68000,'Quantum Physics'),
('Zerouki','Nabil','n.zerouki@uni.com',4,75000,'Structures');


INSERT INTO students (student_number,last_name,first_name,email,department_id,level)
VALUES
('S001','Ali','Karim','karim@uni.com',1,'L2'),
('S002','Ben','Sara','sara@uni.com',1,'L3'),
('S003','Khan','Yassine','yas@uni.com',2,'M1'),
('S004','Omar','Lina','lina@uni.com',3,'L2'),
('S005','Zed','Amine','amine@uni.com',4,'L3'),
('S006','Noor','Aya','aya@uni.com',1,'M1'),
('S007','Hadi','Nour','nour@uni.com',2,'L2'),
('S008','Sam','Rami','rami@uni.com',3,'M1');

INSERT INTO courses (course_code,course_name,credits,semester,department_id,professor_id)
VALUES
('CS101','Algorithms',6,1,1,1),
('CS102','Databases',5,2,1,2),
('CS103','Networks',5,1,1,3),
('MA101','Linear Algebra',6,1,2,4),
('PH101','Mechanics',5,2,3,5),
('CE101','Structures',6,1,4,6),
('CS201','AI Basics',6,2,1,1);

INSERT INTO enrollments (student_id, course_id, academic_year, status)
VALUES
(1,1,'2024-2025','In Progress'),
(1,2,'2024-2025','In Progress'),
(2,1,'2024-2025','Passed'),
(2,3,'2023-2024','Passed'),
(3,4,'2024-2025','In Progress'),
(4,5,'2024-2025','Failed'),
(5,6,'2024-2025','In Progress'),
(6,1,'2023-2024','Passed'),
(6,7,'2024-2025','In Progress'),
(7,4,'2024-2025','In Progress'),
(8,5,'2023-2024','Passed'),
(8,1,'2024-2025','In Progress'),
(3,2,'2024-2025','In Progress'),
(4,3,'2024-2025','Dropped'),
(5,2,'2023-2024','Passed');

INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient)
VALUES
(1,'Exam',15,1.5),
(1,'Assignment',14,1),
(2,'Exam',16,1.5),
(3,'Exam',18,2),
(4,'Project',17,1.5),
(5,'Exam',12,1),
(6,'Exam',10,1),
(7,'Lab',13,1),
(8,'Exam',16,1.5),
(9,'Project',15,1),
(10,'Exam',14,1),
(11,'Exam',17,1.5);

-- queries
-- Q1
SELECT last_name, first_name, email, level
FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p 
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5
SELECT course_code, course_name, credits, semester
FROM courses 
WHERE semester = 1;

-- Q6
SELECT c.course_code,
	   c.course_name,
       CONCAT(p.last_name,' ',p.first_name) AS professor_name
FROM courses c 
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
c.course_name,
e.enrollment_date,
e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8
SELECT CONCAT(s.last_name,' ',S.first_name) AS student_name,
d.department_name,
s.level
FROM students s 
LEFT JOIN departments d ON s.department_id = d.department_id;
    
-- Q9
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
c.course_name,
g.evaluation_type,
g.grade
FROM  grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10
SELECT CONCAT(p.last_name, ' ',p.first_name) AS professor_name,
	COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11
 SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
  AVG(g.grade) AS average_grade
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN grades g ON e.enrollment_id = g.enrollment_id
  GROUP BY s.student_id;
  
  -- Q12
  SELECT d.department_name,
	COUNT(s.student_id) AS student_count
FROM departments d 
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13
SELECT SUM(budget) AS total_budget
FROM departments ;

-- Q14
SELECT d.department_name,
	COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15
SELECT d.department_name,
AVG(p.salary)  AS average_salary
FROM departments d 
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
	AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id  
GROUP BY s.student_id
ORDER BY average_grade DESC 
LIMIT 3;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c 
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
COUNT(e.enrollment_id) AS passed_courses_count
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
WHERE e.status = 'Passed'
GROUP BY s.student_id;

-- Q19
SELECT  CONCAT(p.last_name,' ',p.first_name) AS professor_name,
COUNT(c.course_id) AS courses_taught
FROM professors p 
JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id 
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- Q21
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
AVG(g.grade) AS student_avg,
(
	SELECT AVG(g2.grade)
    FROM students s2
    JOIN enrollments e2 ON s2.student_id = e2.student_id
    JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
    WHERE s2.department_id = s.department_id 
) AS department_avg
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
HAVING student_avg > department_avg;

-- Q22
SELECT c.course_name,
COUNT(e.enrollment_id) AS enrollment_count
FROM courses c 
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > 
(SELECT AVG(cnt)
FROM (SELECT COUNT(*) AS cnt
	FROM enrollments
	GROUP BY course_id) AS sub);
    
-- Q23
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
   d.department_name,
   d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
 s.email
 FROM students s 
 WHERE s.student_id NOT IN (
    SELECT e.student_id
    FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25
SELECT d.department_name,
 COUNT(s.student_id) AS student_count
 FROM departments d 
 JOIN students s ON d.department_id = s.department_id 
 GROUP BY d.department_id
 HAVING COUNT(s.student_id) > 
		(SELECT AVG(cnt)
         FROM (SELECT COUNT(*) AS cnt
			FROM students
            GROUP BY department_id) AS sub);
            
-- Q26
SELECT c.course_name,
  COUNT(g.grade) AS total_grades,
  SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
  ROUND(SUM(CASE WHEN g.grade >=10 THEN 1 ELSE 0 END) *100 / COUNT(g.grade), 2)
  AS pass_rate_percentage
  FROM courses c 
  JOIN enrollments e ON c.course_id = e.course_id
  JOIN grades g ON e.enrollment_id = g.enrollment_id
  GROUP BY c.course_id;
  
-- Q27
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rankk,
   CONCAT(s.last_name, ' ',s.first_name) AS student_name,
   AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id;

-- Q28
SELECT c.course_name,
	g.evaluation_type,
    g.coefficient,
    g.grade * g.coefficient AS weighted_grade
FROM grades g 
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
		SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30
SELECT c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    ROUND(COUNT(e.enrollment_id) * 100 / c.max_capacity, 2) AS percentage_full
    FROM courses c
    JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id
    HAVING percentage_full > 80;
    
    
    

