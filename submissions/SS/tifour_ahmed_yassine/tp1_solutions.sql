-- ======================================================
-- TP1: University Management System
-- Student: TIFOUR Ahmed Yassine
-- ======================================================

-- 1. Database creation
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- 2. Tables creation
-- Table: departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- Table: professors
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    specialization VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: students
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
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (student_id, course_id, academic_year)
);

-- Table: grades
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade DECIMAL(5, 2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4. Test Data Insertion
-- Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Alan Turing', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Ada Lovelace', '2010-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Marie Curie', '2011-01-15'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Gustave Eiffel', '2012-05-20');

-- Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Smith', 'John', 'john.smith@univ.edu', '555-0101', 1, '2015-08-20', 75000.00, 'Artificial Intelligence'),
('Johnson', 'Alice', 'alice.johnson@univ.edu', '555-0102', 1, '2016-01-10', 72000.00, 'Software Engineering'),
('Williams', 'Robert', 'robert.williams@univ.edu', '555-0103', 1, '2018-09-05', 68000.00, 'Databases'),
('Brown', 'Emily', 'emily.brown@univ.edu', '555-0104', 2, '2014-03-15', 80000.00, 'Applied Mathematics'),
('Jones', 'Michael', 'michael.jones@univ.edu', '555-0105', 3, '2017-11-12', 74000.00, 'Quantum Physics'),
('Garcia', 'Maria', 'maria.garcia@univ.edu', '555-0106', 4, '2019-06-01', 71000.00, 'Structural Engineering');

-- Students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('STU001', 'Doe', 'Jane', '2003-05-15', 'jane.doe@student.univ.edu', '555-0201', '123 Main St', 1, 'L3', '2023-09-01'),
('STU002', 'Miller', 'David', '2004-11-20', 'david.miller@student.univ.edu', '555-0202', '456 Oak Ave', 1, 'L2', '2024-09-01'),
('STU003', 'Wilson', 'Sarah', '2002-02-10', 'sarah.wilson@student.univ.edu', '555-0203', '789 Pine Rd', 2, 'M1', '2023-09-01'),
('STU004', 'Taylor', 'James', '2001-08-30', 'james.taylor@student.univ.edu', '555-0204', '101 Elm St', 3, 'M1', '2022-09-01'),
('STU005', 'Anderson', 'Linda', '2003-12-05', 'linda.anderson@student.univ.edu', '555-0205', '202 Maple Dr', 4, 'L3', '2023-09-01'),
('STU006', 'Thomas', 'Charles', '2005-04-12', 'charles.thomas@student.univ.edu', '555-0206', '303 Birch Ln', 1, 'L2', '2024-09-01'),
('STU007', 'Jackson', 'Barbara', '2002-09-25', 'barbara.jackson@student.univ.edu', '555-0207', '404 Cedar St', 2, 'L3', '2023-09-01'),
('STU008', 'White', 'Joseph', '2003-01-18', 'joseph.white@student.univ.edu', '555-0208', '505 Walnut Ave', 3, 'L3', '2023-09-01');

-- Courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Introduction to CS', 'Basics of computing', 6, 1, 1, 1, 50),
('CS202', 'Database Systems', 'Relational database design', 5, 2, 1, 3, 40),
('MATH301', 'Calculus III', 'Advanced calculus', 6, 1, 2, 4, 30),
('PHYS101', 'General Physics', 'Mechanics and heat', 5, 1, 3, 5, 35),
('CE201', 'Statics', 'Equilibrium of bodies', 6, 2, 4, 6, 25),
('CS303', 'Artificial Intelligence', 'Machine learning basics', 6, 1, 1, 1, 30),
('MATH101', 'Linear Algebra', 'Vector spaces and matrices', 5, 2, 2, 4, 45);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2023-2024', 'Passed'),
(1, 2, '2024-2025', 'In Progress'),
(1, 6, '2024-2025', 'In Progress'),
(2, 1, '2024-2025', 'In Progress'),
(2, 2, '2024-2025', 'In Progress'),
(3, 3, '2023-2024', 'Passed'),
(3, 7, '2024-2025', 'In Progress'),
(4, 4, '2023-2024', 'Passed'),
(5, 5, '2023-2024', 'Passed'),
(6, 1, '2024-2025', 'In Progress'),
(7, 3, '2023-2024', 'Passed'),
(8, 4, '2023-2024', 'Passed'),
(1, 3, '2023-2024', 'Passed'),
(2, 7, '2024-2025', 'In Progress'),
(5, 2, '2024-2025', 'In Progress');

-- Grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 15.50, 1.00, '2024-01-15', 'Good performance'),
(6, 'Exam', 17.00, 1.00, '2024-01-15', 'Excellent'),
(8, 'Exam', 12.00, 1.00, '2024-01-20', 'Satisfactory'),
(9, 'Project', 14.00, 1.50, '2024-01-25', 'Well structured'),
(11, 'Lab', 16.00, 0.50, '2024-01-10', 'Very accurate'),
(12, 'Exam', 11.00, 1.00, '2024-01-20', 'Passed'),
(13, 'Assignment', 18.00, 0.20, '2023-11-05', 'Outstanding'),
(1, 'Lab', 14.00, 0.50, '2023-12-10', 'Good lab work'),
(6, 'Project', 16.50, 1.00, '2023-12-15', 'Great project'),
(8, 'Assignment', 13.00, 0.30, '2023-11-20', 'Good'),
(9, 'Exam', 15.00, 1.00, '2024-01-15', 'Solid'),
(11, 'Exam', 14.50, 1.00, '2024-01-15', 'Good');

-- 5. SQL Queries (Q1-Q30)

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
SELECT last_name, first_name, email, level FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.department_name = 'Computer Science';

-- Q3. Find all courses with more than 5 credits
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4. List students enrolled in L3 level
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';

-- Q5. Display courses from semester 1
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name 
FROM courses c 
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, e.enrollment_date, e.status 
FROM enrollments e 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, d.department_name, s.level 
FROM students s 
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, g.evaluation_type, g.grade 
FROM grades g 
JOIN enrollments e ON g.enrollment_id = e.enrollment_id 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS number_of_courses 
FROM professors p 
LEFT JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, ROUND(AVG(g.grade), 2) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id;

-- Q12. Count the number of students per department
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id;

-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14. Find the total number of courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count 
FROM departments d 
LEFT JOIN courses c ON d.department_id = c.department_id 
GROUP BY d.department_id;

-- Q15. Calculate the average salary of professors per department
SELECT d.department_name, ROUND(AVG(p.salary), 2) AS average_salary 
FROM departments d 
JOIN professors p ON d.department_id = p.department_id 
GROUP BY d.department_id;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, ROUND(AVG(g.grade), 2) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id 
ORDER BY average_grade DESC 
LIMIT 3;

-- Q17. List courses with no enrolled students
SELECT course_code, course_name 
FROM courses 
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM enrollments);

-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS passed_courses_count 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
WHERE s.student_id NOT IN (SELECT student_id FROM enrollments WHERE status != 'Passed')
GROUP BY s.student_id;

-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught 
FROM professors p 
JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id 
HAVING courses_taught > 2;

-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
GROUP BY s.student_id 
HAVING enrolled_courses_count > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
WITH StudentAvg AS (
    SELECT s.student_id, s.department_id, CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) as avg_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
),
DeptAvg AS (
    SELECT department_id, AVG(grade) as dept_avg_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY department_id
)
SELECT sa.student_name, ROUND(sa.avg_grade, 2) AS student_avg, ROUND(da.dept_avg_grade, 2) AS department_avg
FROM StudentAvg sa
JOIN DeptAvg da ON sa.department_id = da.department_id
WHERE sa.avg_grade > da.dept_avg_grade;

-- Q22. List courses with more enrollments than the average number of enrollments
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count 
FROM courses c 
LEFT JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id 
HAVING enrollment_count > (
    SELECT AVG(cnt) FROM (SELECT COUNT(enrollment_id) as cnt FROM enrollments GROUP BY course_id) as sub
);

-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, d.department_name, d.budget 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
SELECT CONCAT(last_name, ' ', first_name) AS student_name, email 
FROM students 
WHERE student_id NOT IN (
    SELECT DISTINCT e.student_id 
    FROM enrollments e 
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25. List departments with more students than the average
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id 
HAVING student_count > (
    SELECT AVG(cnt) FROM (SELECT COUNT(student_id) as cnt FROM students GROUP BY department_id) as sub
);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT 
    c.course_name, 
    COUNT(g.grade_id) AS total_grades,
    SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
    ROUND((SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100, 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27. Display student ranking by descending average
SELECT 
    RANK() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`,
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q28. Generate a report card for student with student_id = 1
SELECT 
    c.course_name, 
    g.evaluation_type, 
    g.grade, 
    g.coefficient, 
    ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name, 
    SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT 
    c.course_name, 
    COUNT(e.enrollment_id) AS current_enrollments, 
    c.max_capacity, 
    ROUND((COUNT(e.enrollment_id) / c.max_capacity) * 100, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
