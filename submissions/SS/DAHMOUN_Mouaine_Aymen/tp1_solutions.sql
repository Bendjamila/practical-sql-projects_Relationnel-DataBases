-- ============================================
-- TP1: University Management System - Solution
-- File: tp1_solutions.sql
-- Created for the assignment requirements
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- ========== TABLES ==========

-- 1) departments
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date DATE
) ENGINE=InnoDB;

-- 2) professors
CREATE TABLE IF NOT EXISTS professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department_id INT NULL,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    CONSTRAINT fk_prof_dept FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3) students
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(20) NOT NULL UNIQUE,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    department_id INT NULL,
    level VARCHAR(20),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT chk_student_level CHECK (level IN ('L1','L2','L3','M1','M2')),
    CONSTRAINT fk_student_dept FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4) courses
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) NOT NULL UNIQUE,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT NULL,
    max_capacity INT DEFAULT 30,
    CONSTRAINT chk_credits CHECK (credits > 0),
    CONSTRAINT chk_semester CHECK (semester BETWEEN 1 AND 2),
    CONSTRAINT fk_course_dept FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_prof FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5) enrollments
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL, -- format '2024-2025'
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT chk_status CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uc_enrollment_unique UNIQUE (student_id, course_id, academic_year)
) ENGINE=InnoDB;

-- 6) grades
CREATE TABLE IF NOT EXISTS grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT chk_eval_type CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CONSTRAINT chk_grade_range CHECK (grade >= 0 AND grade <= 20),
    CONSTRAINT fk_grade_enrollment FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ========== INDEXES ==========

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- ========== TEST DATA INSERTION ==========

-- Departments (4)
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Alan Turing', '2000-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Ada Lovelace', '2001-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Marie Curie', '2002-09-01'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. I. K. Brunel', '2003-09-01');

-- Professors (6) - at least 3 in Computer Science
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Smith','John','john.smith@uni.edu','+213600000001', 1, '2010-08-15', 70000.00, 'Algorithms'),
('Doe','Jane','jane.doe@uni.edu','+213600000002', 1, '2012-09-01', 65000.00, 'Databases'),
('Brown','Alice','alice.brown@uni.edu','+213600000003', 1, '2015-01-10', 60000.00, 'Artificial Intelligence'),
('Green','Bob','bob.green@uni.edu','+213600000004', 2, '2011-07-20', 62000.00, 'Topology'),
('White','Carol','carol.white@uni.edu','+213600000005', 3, '2013-05-05', 63000.00, 'Quantum Mechanics'),
('Black','Dave','dave.black@uni.edu','+213600000006', 4, '2009-03-12', 75000.00, 'Structural Engineering');

-- Students (8) - mix of levels, distributed across departments
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('S2024001','Ali','Aymen','2002-05-10','aymen.ali@uni.edu','+213661000001','Addr 1', 1, 'L3', '2023-09-01'),
('S2024002','Ben','Sara','2003-03-22','sara.ben@uni.edu','+213661000002','Addr 2', 1, 'L2', '2024-09-01'),
('S2024003','Chen','Lina','2002-11-02','lina.chen@uni.edu','+213661000003','Addr 3', 2, 'L3', '2023-09-01'),
('S2024004','Diaz','Omar','1998-07-15','omar.diaz@uni.edu','+213661000004','Addr 4', 3, 'M1', '2023-09-01'),
('S2024005','Elbaz','Maya','2004-02-28','maya.elbaz@uni.edu','+213661000005','Addr 5', 4, 'L2', '2024-09-01'),
('S2024006','Fares','Nora','1997-12-11','nora.fares@uni.edu','+213661000006','Addr 6', 1, 'M1', '2023-09-01'),
('S2024007','Garcia','Leo','2003-06-30','leo.garcia@uni.edu','+213661000007','Addr 7', 2, 'L3', '2024-09-01'),
('S2024008','Hassan','Rima','2004-09-09','rima.hassan@uni.edu','+213661000008','Addr 8', 3, 'L2', '2024-09-01');

-- Courses (7) - various credits, semesters, assigned to professors
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101','Intro to Programming','Basics of programming in Python', 6, 1, 1, 1, 40),
('CS201','Data Structures','In-depth data structures', 6, 2, 1, 2, 35),
('CS301','Machine Learning','Intro to ML concepts', 6, 1, 1, 3, 30),
('CS350','Advanced Databases','Distributed DB systems', 5, 2, 1, 2, 30),
('MATH201','Linear Algebra II','Vector spaces and matrices', 5, 1, 2, 4, 30),
('PHYS101','Classical Mechanics','Newtonian mechanics', 5, 2, 3, 5, 25),
('CE101','Statics','Forces and equilibrium', 6, 1, 4, 6, 30);

-- Enrollments (15) - mix of academic years and statuses
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2024-09-05', '2024-2025', 'In Progress'),   -- e1
(1, 2, '2023-09-03', '2023-2024', 'Passed'),        -- e2
(1, 4, '2024-09-06', '2024-2025', 'In Progress'),   -- e3
(2, 1, '2024-09-07', '2024-2025', 'In Progress'),   -- e4
(2, 4, '2024-09-07', '2024-2025', 'In Progress'),   -- e5
(3, 5, '2023-09-04', '2023-2024', 'Passed'),        -- e6
(3, 2, '2024-09-05', '2024-2025', 'In Progress'),   -- e7
(4, 6, '2024-09-02', '2024-2025', 'In Progress'),   -- e8
(5, 7, '2024-09-03', '2024-2025', 'In Progress'),   -- e9
(6, 1, '2023-09-03', '2023-2024', 'Failed'),        -- e10
(6, 3, '2024-09-05', '2024-2025', 'In Progress'),   -- e11
(7, 5, '2024-09-05', '2024-2025', 'In Progress'),   -- e12
(8, 6, '2023-09-06', '2023-2024', 'Dropped'),       -- e13
(4, 3, '2023-09-05', '2023-2024', 'Passed'),        -- e14
(5, 2, '2023-09-05', '2023-2024', 'Passed');        -- e15

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(2, 'Exam', 15.50, 2.00, '2024-01-10', 'Final exam'),     -- grade for e2 (student1, CS201)
(6, 'Exam', 14.00, 2.00, '2024-01-12', 'Final exam'),     -- e6 (student3, MATH201)
(10,'Exam', 9.50, 2.00, '2024-01-15','Final exam'),       -- e10 (student6, CS101) -> Failed
(14,'Exam', 16.00, 2.00, '2024-01-11','Final exam'),      -- e14 (student4, CS301)
(15,'Exam', 12.50, 2.00, '2024-01-09','Final exam'),      -- e15 (student5, CS201)
(1, 'Assignment', 17.00, 1.00, '2024-10-20','Good work'), -- e1 (student1, CS101)
(1, 'Lab', 16.00, 1.00, '2024-11-05','Lab exercises'),    -- e1
(3, 'Assignment', 13.00, 1.00, '2024-10-25','Ok'),        -- e3
(4, 'Project', 14.50, 1.50, '2024-11-10','Team project'), -- e4
(5, 'Assignment', 11.00, 1.00, '2024-11-01','Late'),      -- e5
(11,'Exam', 18.00, 2.00, '2025-01-15','Excellent'),      -- e11
(7, 'Lab', 12.00, 1.00, '2024-11-12','Labs');             -- e7



-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level
SELECT last_name, first_name, email, level
FROM students
ORDER BY last_name, first_name;

-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3. Find all courses with more than 5 credits
-- Expected columns: course_code, course_name, credits
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4. List students enrolled in L3 level
-- Expected columns: student_number, last_name, first_name, email
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5. Display courses from semester 1
-- Expected columns: course_code, course_name, credits, semester
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
-- Expected columns: course_code, course_name, professor_name (last + first)
SELECT c.course_code, c.course_name, 
       CASE WHEN p.professor_id IS NOT NULL THEN CONCAT(p.last_name, ' ', p.first_name) ELSE 'TBA' END AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id
ORDER BY c.course_code;

-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY e.enrollment_date DESC;

-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
ORDER BY d.department_name, s.last_name;

-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT CONCAT(st.last_name,' ',st.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students st ON e.student_id = st.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY st.last_name, g.evaluation_date;

-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
ORDER BY number_of_courses DESC;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       ROUND(AVG(g.grade),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q12. Count the number of students per department
-- Expected columns: department_name, student_count
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
ORDER BY student_count DESC;

-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
SELECT ROUND(SUM(budget),2) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id
ORDER BY course_count DESC;

-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary
SELECT d.department_name,
       ROUND(AVG(p.salary),2) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id
ORDER BY average_salary DESC;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade (order desc, limit 3)
SELECT student_name, average_grade
FROM (
    SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
           AVG(g.grade) AS average_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) t
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
-- Expected columns: course_code, course_name
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Expected columns: student_name, passed_courses_count
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.status = 'Passed' THEN 0 ELSE 1 END) = 0
   AND COUNT(e.enrollment_id) > 0;

-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg
SELECT t.student_name, ROUND(t.student_avg,2) AS student_avg, ROUND(d.department_avg,2) AS department_avg
FROM (
    SELECT s.student_id, CONCAT(s.last_name,' ',s.first_name) AS student_name,
           AVG(g.grade) AS student_avg, s.department_id
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) t
JOIN (
    SELECT s.department_id, AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) d ON t.department_id = d.department_id
WHERE t.student_avg > d.department_avg
ORDER BY (t.student_avg - d.department_avg) DESC;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT course_name, enrollment_count
FROM (
    SELECT c.course_id, c.course_name, COUNT(e.enrollment_id) AS enrollment_count
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id
) cc
WHERE enrollment_count > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM enrollments GROUP BY course_id
    ) sub
);

-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, s.email
FROM students s
WHERE NOT EXISTS (
    SELECT 1 FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    WHERE e.student_id = s.student_id
);

-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT d.department_name, dept_count.student_count
FROM departments d
JOIN (
    SELECT s.department_id, COUNT(s.student_id) AS student_count
    FROM students s
    GROUP BY s.department_id
) dept_count ON d.department_id = dept_count.department_id
WHERE dept_count.student_count > (
    SELECT AVG(cnt) FROM (
        SELECT COUNT(*) AS cnt FROM students GROUP BY department_id
    ) sub_avg
)
ORDER BY dept_count.student_count DESC;

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(100.0 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / NULLIF(COUNT(g.grade_id),0),2) AS pass_rate_percentage
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id
ORDER BY pass_rate_percentage DESC;

-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
-- Using window function to rank (MySQL 8+)
WITH student_avgs AS (
    SELECT s.student_id, CONCAT(s.last_name,' ',s.first_name) AS student_name,
           ROUND(AVG(g.grade),2) AS average_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
)
SELECT RANK() OVER (ORDER BY average_grade DESC) AS rank,
       student_name,
       average_grade
FROM student_avgs
ORDER BY rank;

-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       ROUND(g.grade * g.coefficient,2) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1
ORDER BY c.course_name, g.evaluation_date;

-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       COALESCE(SUM(c.credits),0) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
ORDER BY total_credits DESC;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND(100.0 * COUNT(e.enrollment_id) / NULLIF(c.max_capacity,0),2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
    AND e.status <> 'Dropped'
GROUP BY c.course_id
HAVING percentage_full > 80
ORDER BY percentage_full DESC;

