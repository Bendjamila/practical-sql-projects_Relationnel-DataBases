-- ============================================================
-- TP1 - University Management System

-- Database + Tables + Indexes + Insertions+ queries 
-- ============================================================



-- ============================================================
--  DATABASE CREATION
-- ============================================================

-- Delete database if it already exists (prevents duplication errors)
DROP DATABASE IF EXISTS university_db;

-- Create new database
CREATE DATABASE university_db;

-- Select database for use
USE university_db;



-- ============================================================
-- TABLE CREATION
-- ============================================================



-- 1. DEPARTMENTS TABLE
-- Stores information about university departments


CREATE TABLE departments (

    department_id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique identifier for each department

    department_name VARCHAR(100) NOT NULL UNIQUE,
    -- Official name of the department (must be unique)

    building VARCHAR(50),
    -- Building where the department is located

    budget DECIMAL(12,2) NOT NULL,
    -- Annual budget allocated to the department

    department_head VARCHAR(100),
    -- Name of the head of the department

    creation_date DATE
    -- Date when the department was established
);




-- 2. PROFESSORS TABLE
-- Stores professors and their department affiliation

CREATE TABLE professors (

    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique identifier for each professor

    last_name VARCHAR(50) NOT NULL,
    -- Professor last name

    first_name VARCHAR(50) NOT NULL,
    -- Professor first name

    email VARCHAR(100) UNIQUE,
    -- Professional email (must be unique)

    phone VARCHAR(20),
    -- Contact phone number

    department_id INT,
    -- Department where the professor works

    hire_date DATE,
    -- Date the professor was hired

    salary DECIMAL(10,2),
    -- Monthly salary of the professor

    specialization VARCHAR(100),
    -- Field of specialization

    FOREIGN KEY (department_id) REFERENCES departments(department_id)
    -- Links professor to a department
);




-- 3. STUDENTS TABLE
-- Stores student personal and academic information


CREATE TABLE students (

    student_id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique internal student identifier

    student_number VARCHAR(20) UNIQUE,
    -- Official university student number

    last_name VARCHAR(50) NOT NULL,
    -- Student last name

    first_name VARCHAR(50) NOT NULL,
    -- Student first name

    date_of_birth DATE,
    -- Student birth date

    email VARCHAR(100) UNIQUE,
    -- Student email address

    phone VARCHAR(20),
    -- Student phone number

    address VARCHAR(150),
    -- Student home address

    department_id INT,
    -- Department where the student is registered

    level ENUM('L1','L2','L3','M1','M2') NOT NULL,
    -- Academic level

    enrollment_date DATE,
    -- Date student enrolled at university

    FOREIGN KEY (department_id) REFERENCES departments(department_id)
    -- Links student to department
);




-- 4. COURSES TABLE
-- Stores course information


CREATE TABLE courses (

    course_id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique course identifier

    course_code VARCHAR(20) UNIQUE,
    -- Official course code

    course_name VARCHAR(100) NOT NULL,
    -- Course title

    description TEXT,
    -- Course description

    credits INT CHECK (credits BETWEEN 1 AND 10),
    -- Number of ECTS credits

    semester INT CHECK (semester IN (1,2)),
    -- Semester (1 or 2)

    department_id INT,
    -- Department offering the course

    professor_id INT,
    -- Professor teaching the course

    max_capacity INT DEFAULT 30,
    -- Maximum number of students allowed

    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);



 5. ENROLLMENTS TABLE
-- Links students to courses


CREATE TABLE enrollments (

    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique enrollment identifier

    student_id INT,
    -- Student enrolled

    course_id INT,
    -- Course enrolled in

    enrollment_date DATE NULL,
    -- Date of enrollment (optional)

    academic_year VARCHAR(9),
    -- Academic year (e.g., 2023/2024)

    status ENUM('In Progress','Enrolled','Passed','Failed'),
    -- Current course status

    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);



-- ============================================================
-- 6. GRADES TABLE
-- Stores student evaluations per enrollment
-- ============================================================

CREATE TABLE grades (

    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    -- Unique grade identifier

    enrollment_id INT,
    -- Links grade to specific enrollment

    evaluation_type VARCHAR(50),
    -- Type of evaluation (Assignment, Project, Exam)

    grade DECIMAL(4,2) CHECK (grade BETWEEN 0 AND 20),
    -- Grade obtained (0–20 scale)

    coefficient DECIMAL(3,2),
    -- Weight of evaluation

    evaluation_date DATE,
    -- Date of evaluation

    comments VARCHAR(255),
    -- Teacher comments

    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);



-- ============================================================
 INDEX CREATION
-- Improves performance of JOIN and search operations
-- ============================================================

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_professor_department ON professors(department_id);
CREATE INDEX idx_course_department ON courses(department_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grade_enrollment ON grades(enrollment_id);



-- ============================================================
 DATA INSERTION
-- ============================================================

-- Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science','Bloc A',1500000,'Dr. Ahmed Benali','2005-09-01'),
('Mathematics','Bloc B',900000,'Dr. Samir Bouchareb','2003-09-01'),
('Physics','Bloc C',1100000,'Dr. Yacine Merabet','2004-09-01'),
('Chemistry','Bloc D',800000,'Dr. Nadia Khelifi','2006-09-01'),
('Biology','Bloc E',950000,'Dr. Amel Rahmani','2007-09-01'),
('Economics','Bloc F',1200000,'Dr. Karim Touati','2002-09-01'),
('Law','Bloc G',1000000,'Dr. Farid Mansouri','2001-09-01'),
('Mechanical Engineering','Bloc H',1700000,'Dr. Adel Cherif','2008-09-01'),
('Civil Engineering','Bloc I',1600000,'Dr. Walid Ziani','2009-09-01'),
('English Literature','Bloc J',700000,'Dr. Leila Haddad','2010-09-01');


-- Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Benali','Ahmed','a.benali@univ.dz','0550000001',1,'2010-10-01',180000,'Artificial Intelligence'),
('Bouchareb','Samir','s.bouchareb@univ.dz','0550000002',2,'2008-03-12',170000,'Algebra'),
('Merabet','Yacine','y.merabet@univ.dz','0550000003',3,'2012-05-20',160000,'Quantum Physics'),
('Khelifi','Nadia','n.khelifi@univ.dz','0550000004',4,'2015-11-11',150000,'Organic Chemistry'),
('Rahmani','Amel','a.rahmani@univ.dz','0550000005',5,'2014-01-09',155000,'Genetics'),
('Touati','Karim','k.touati@univ.dz','0550000006',6,'2009-06-30',175000,'Macroeconomics'),
('Mansouri','Farid','f.mansouri@univ.dz','0550000007',7,'2007-09-14',165000,'International Law'),
('Cherif','Adel','a.cherif@univ.dz','0550000008',8,'2011-04-17',190000,'Thermodynamics'),
('Ziani','Walid','w.ziani@univ.dz','0550000009',9,'2013-02-22',185000,'Structural Engineering'),
('Haddad','Leila','l.haddad@univ.dz','0550000010',10,'2016-08-01',140000,'British Literature');

-- Students

INSERT INTO students 
(student_number,last_name,first_name,date_of_birth,email,phone,address,department_id,level,enrollment_date) 
VALUES
('20230011','Bensalem','Mohamed','2003-04-12','m.bensalem@student.dz','0662000001','Algiers',1,'L3','2023-09-20'),
('20230012','Ait Ali','Yasmine','2004-01-22','y.aitali@student.dz','0662000002','Tizi Ouzou',1,'L2','2023-09-20'),
('20230013','Zouaoui','Islam','2003-07-09','i.zouaoui@student.dz','0662000003','Bejaia',1,'L1','2023-09-20'),
('20230014','Bourouba','Nadia','2002-12-01','n.bourouba@student.dz','0662000004','Blida',2,'M1','2023-09-20'),
('20230015','Ferhat','Karim','2003-06-18','k.ferhat@student.dz','0662000005','Setif',1,'L3','2023-09-20'),
('20230016','Saoula','Imane','2004-02-10','i.saoula@student.dz','0662000006','Oran',3,'L2','2023-09-20'),
('20230017','Djabri','Walid','2003-03-27','w.djabri@student.dz','0662000007','Annaba',1,'M1','2023-09-20'),
('20230018','Haddouche','Lina','2002-09-14','l.haddouche@student.dz','0662000008','Batna',4,'L3','2023-09-20'),
('20230019','Belkacem','Rayan','2004-05-05','r.belkacem@student.dz','0662000009','Constantine',1,'L2','2023-09-20'),
('20230020','Khellaf','Aya','2003-11-11','a.khellaf@student.dz','0662000010','Skikda',1,'L1','2023-09-20'),
('20230021','Meziane','Oussama','2003-08-19','o.meziane@student.dz','0662000011','Algiers',1,'L3','2023-09-20'),
('20230022','Boudiaf','Sara','2004-03-02','s.boudiaf@student.dz','0662000012','Tlemcen',6,'L2','2023-09-20'),
('20230023','Kouider','Anis','2002-10-30','a.kouider@student.dz','0662000013','Mascara',1,'M2','2023-09-20'),
('20230024','Hamlaoui','Ines','2003-01-17','i.hamlaoui@student.dz','0662000014','Tipaza',1,'L3','2023-09-20'),
('20230025','Rezig','Yacine','2004-06-25','y.rezig@student.dz','0662000015','Jijel',3,'L2','2023-09-20'),
('20230026','Tahar','Malek','2003-09-09','m.tahar@student.dz','0662000016','Ghardaia',1,'L1','2023-09-20'),
('20230027','Amrani','Nour El Houda','2002-02-20','n.amrani@student.dz','0662000017','Bouira',2,'M1','2023-09-20'),
('20230028','Bendib','Sofiane','2003-12-03','s.bendib@student.dz','0662000018','Laghouat',1,'L2','2023-09-20'),
('20230029','Chikhi','Meriem','2004-04-04','m.chikhi@student.dz','0662000019','Relizane',1,'L1','2023-09-20'),
('20230030','Ghezali','Adem','2003-07-21','a.ghezali@student.dz','0662000020','El Oued',8,'M2','2023-09-20');




-- Courses


INSERT INTO courses 
(course_code,course_name,description,credits,semester,department_id,professor_id,max_capacity) 
VALUES
('CS301','Machine Learning','Introduction to ML',5,1,1,1,40),
('CS201','Data Structures','Algorithms and structures',4,1,1,1,40),
('MATH201','Linear Algebra II','Advanced matrices',4,1,2,2,35),
('PHY401','Quantum Mechanics','Quantum theory basics',5,2,3,3,30),
('CHEM301','Organic Chemistry','Carbon compounds study',4,1,4,4,30),
('BIO201','Genetics','DNA and genes',4,2,5,5,30),
('ECO301','Macroeconomics','National economy study',5,1,6,6,50),
('LAW201','International Law','Global legal systems',4,2,7,7,45),
('MECH401','Thermodynamics','Energy systems',5,1,8,8,40),
('ENG201','British Poetry','Study of poetry',3,1,10,10,25);



-- ============================================================
-- Enrollments
-- ============================================================

INSERT INTO enrollments 
(student_id,course_id,academic_year,status) 
VALUES
(11,1,'2023/2024','In Progress'),
(11,2,'2023/2024','In Progress'),
(12,1,'2023/2024','Passed'),
(12,2,'2023/2024','Passed'),
(13,2,'2023/2024','In Progress'),
(15,1,'2023/2024','Passed'),
(15,2,'2023/2024','Passed'),
(17,1,'2023/2024','In Progress'),
(17,3,'2023/2024','In Progress'),
(19,1,'2023/2024','Failed'),
(21,1,'2023/2024','Passed'),
(21,2,'2023/2024','Passed'),
(23,1,'2023/2024','In Progress'),
(24,2,'2023/2024','Passed'),
(26,2,'2023/2024','In Progress'),
(28,3,'2023/2024','In Progress'),
(29,1,'2023/2024','In Progress');



-- Grades


INSERT INTO grades 
(enrollment_id,evaluation_type,grade,coefficient,evaluation_date,comments) 
VALUES
(1,'Assignment',14,1,'2024-01-05','Good'),
(1,'Project',16,2,'2024-01-20','Very good'),
(1,'Exam',13,3,'2024-02-01','Average'),

(3,'Assignment',15,1,'2024-01-05','Excellent'),
(3,'Exam',17,3,'2024-02-01','Excellent'),

(6,'Assignment',10,1,'2024-01-05','Average'),
(6,'Project',14,2,'2024-01-20','Good'),
(6,'Exam',15,3,'2024-02-01','Good'),

(10,'Assignment',8,1,'2024-01-05','Weak'),
(10,'Exam',7,3,'2024-02-01','Failed'),

(11,'Assignment',16,1,'2024-01-05','Excellent'),
(11,'Project',18,2,'2024-01-20','Outstanding'),
(11,'Exam',17,3,'2024-02-01','Excellent');


 -- THE QUERIES :



-- Q1: List all students with main information
-- Displays last name, first name, email and level
SELECT last_name, first_name, email, level
FROM students;


-- Q2: Display all professors from Computer Science department
-- Filters professors by department name
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';


-- Q3: Find all courses with more than 5 credits
-- Filters courses where credits > 5
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;


-- Q4: List students enrolled in L3 level
-- Filters students by academic level
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';


-- Q5: Display courses from semester 1
-- Filters courses belonging to semester 1
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;
-- Q6: Display all courses with professor name
-- Joins courses and professors
SELECT c.course_code, c.course_name,
       p.last_name, p.first_name
FROM courses c
JOIN professors p ON c.professor_id = p.professor_id;


-- Q7: List enrollments with student name and course name
-- Joins students, courses and enrollments
SELECT s.last_name, s.first_name,
       c.course_name,
       e.academic_year, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Q8: Display students with their department name
-- Shows student and department relationship
SELECT s.last_name, s.first_name,
       d.department_name, s.level
FROM students s
JOIN departments d ON s.department_id = d.department_id;


-- Q9: List grades with student name and course name
-- Joins grades → enrollments → students → courses
SELECT s.last_name, s.first_name,
       c.course_name,
       g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;



-- Q10: Display professors with the number of courses they teach
-- Step 1: Start from professors table
-- Step 2: LEFT JOIN courses to include professors even if they teach 0 courses
-- Step 3: COUNT number of courses per professor
-- Step 4: GROUP BY professor to aggregate correctly

SELECT p.last_name, 
       p.first_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c 
       ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11: Calculate weighted average grade for each student
-- Step 1: Join grades with enrollments to know which student each grade belongs to
-- Step 2: Join students to display student information
-- Step 3: Multiply grade by coefficient (weighted value)
-- Step 4: Divide SUM(weighted grades) by SUM(coefficients)
-- Step 5: GROUP BY student

SELECT s.last_name,
       s.first_name,
       SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS average_grade
FROM grades g
JOIN enrollments e 
     ON g.enrollment_id = e.enrollment_id
JOIN students s 
     ON e.student_id = s.student_id
GROUP BY s.student_id;


-- Q12: Count number of students per department
-- Step 1: Start from departments
-- Step 2: LEFT JOIN students to include departments with 0 students
-- Step 3: COUNT students per department
-- Step 4: GROUP BY department

SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s 
       ON d.department_id = s.department_id
GROUP BY d.department_id;


-- Q13: Calculate total budget of all departments
-- Step 1: Use SUM on budget column
-- Step 2: No GROUP BY needed because we want one result

SELECT SUM(budget) AS total_budget
FROM departments;


-- Q14: Total number of courses per department
-- Step 1: Start from departments
-- Step 2: LEFT JOIN courses
-- Step 3: COUNT courses per department
-- Step 4: GROUP BY department

SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c 
       ON d.department_id = c.department_id
GROUP BY d.department_id;


-- Q15: Average salary per department
-- Step 1: Join professors with departments
-- Step 2: Use AVG on salary
-- Step 3: GROUP BY department

SELECT d.department_name,
       AVG(p.salary) AS average_salary
FROM departments d
JOIN professors p 
     ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16: Top 3 students with best averages
-- Step 1: Calculate weighted average per student
-- Step 2: GROUP BY student
-- Step 3: ORDER BY average DESC
-- Step 4: LIMIT 3 results

SELECT s.last_name,
       s.first_name,
       SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS average_grade
FROM grades g
JOIN enrollments e 
     ON g.enrollment_id = e.enrollment_id
JOIN students s 
     ON e.student_id = s.student_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;


-- Q17: Courses with no enrolled students
-- Step 1: Start from courses
-- Step 2: LEFT JOIN enrollments
-- Step 3: Select courses where enrollment is NULL

SELECT c.course_code,
       c.course_name
FROM courses c
LEFT JOIN enrollments e 
       ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;


-- Q18: Students who passed all their courses
-- Step 1: Join students and enrollments
-- Step 2: Filter only Passed status
-- Step 3: COUNT passed courses
-- Step 4: GROUP BY student

SELECT s.last_name,
       s.first_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e 
     ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id;


-- Q19: Professors teaching more than 2 courses
-- Step 1: Join professors and courses
-- Step 2: GROUP BY professor
-- Step 3: Use HAVING to filter count > 2

SELECT p.last_name,
       p.first_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c 
     ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;


-- Q20: Students enrolled in more than 2 courses
-- Step 1: Join students and enrollments
-- Step 2: GROUP BY student
-- Step 3: Filter using HAVING

SELECT s.last_name,
       s.first_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e 
     ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- Q21: Students with average higher than department average
-- Step 1: Calculate student weighted average
-- Step 2: Compare with department average (subquery)
-- Step 3: Return students satisfying condition

SELECT s.last_name,
       s.first_name,
       SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS student_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;


-- Q22: Courses with more enrollments than average
-- Step 1: Count enrollments per course
-- Step 2: Calculate average enrollment using subquery
-- Step 3: Filter courses above average

SELECT course_id,
       COUNT(student_id) AS enrollment_count
FROM enrollments
GROUP BY course_id
HAVING COUNT(student_id) >
       (SELECT AVG(course_count)
        FROM (SELECT COUNT(student_id) AS course_count
              FROM enrollments
              GROUP BY course_id) AS temp);


-- Q23: Professors from department with highest budget
-- Step 1: Find MAX budget (subquery)
-- Step 2: Join professors and departments
-- Step 3: Filter department with max budget

SELECT p.last_name,
       p.first_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d 
     ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);


-- Q24: Students with no grades recorded
-- Step 1: LEFT JOIN students → enrollments → grades
-- Step 2: Select students where grade_id is NULL

SELECT s.last_name,
       s.first_name,
       s.email
FROM students s
LEFT JOIN enrollments e 
       ON s.student_id = e.student_id
LEFT JOIN grades g 
       ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;


-- Q25: Departments with more students than average
-- Step 1: Count students per department
-- Step 2: Calculate average students (subquery)
-- Step 3: Filter using HAVING

SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s 
     ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) >
       (SELECT AVG(dept_count)
        FROM (SELECT COUNT(student_id) AS dept_count
              FROM students
              GROUP BY department_id) AS temp);
-- Q26: Calculate pass rate per course (grade >= 10)
-- Step 1: Join courses → enrollments → grades
-- Step 2: Count total grades
-- Step 3: Count grades >= 10 using CASE
-- Step 4: Calculate percentage

SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;


-- Q27: Student ranking by descending average
-- Step 1: Calculate weighted average per student
-- Step 2: GROUP BY student
-- Step 3: ORDER BY average descending

SELECT s.last_name,
       s.first_name,
       SUM(g.grade * g.coefficient) / SUM(g.coefficient) AS average_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
GROUP BY s.student_id
ORDER BY average_grade DESC;


-- Q28: Report card for student with ID = 1
-- Step 1: Join grades, enrollments, and courses
-- Step 2: Filter by student_id = 1
-- Step 3: Calculate weighted grade per evaluation

SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;


-- Q29: Teaching load per professor
-- Step 1: Join professors and courses
-- Step 2: SUM credits
-- Step 3: GROUP BY professor

SELECT p.last_name,
       p.first_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;


-- Q30: Identify overloaded courses (>80% capacity)
-- Step 1: Count enrollments per course
-- Step 2: Divide by max_capacity
-- Step 3: Multiply by 100
-- Step 4: Filter courses above 80%

SELECT c.course_name,
       COUNT(e.student_id) AS current_enrollments,
       c.max_capacity,
       (COUNT(e.student_id) / c.max_capacity) * 100 AS percentage_size
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
