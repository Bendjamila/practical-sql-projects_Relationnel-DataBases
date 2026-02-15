-- ============================================
-- TP1: University Management System
-- Student: TERFI_CILINE
-- Specialty: Cyber Security (SS)
-- DBMS: MySQL 8+
-- ============================================


-- ============================================
-- CREATS THE DATABASE IF IT'S NOT CREATED BEFORE 
CREATE DATABASE IF NOT EXISTS university_db;
-- ============================================
-- SWITCHES TO THE DATABASE AND WE NOTICES THAT THE PREVIOUT PROMPT INDICATING INDICATING THAT THERE'S NO DATABASE SELECTED "MariaDB [(none)]" IS CHANGED TO "MariaDB [university_db]"
USE university_db;
-- ============================================
--let's verify the current database , it empty for now 
SELECT DATABASE();
--  +---------------+
--  | DATABASE()    |
--  +---------------+
--  | university_db |
--  +---------------+


-- ============================================
-- L'ets Create the departments table
-- Description: Stores information about university departments
-- Columns:
--   department_id    INT, PRIMARY KEY, AUTO_INCREMENT
--   department_name  VARCHAR(100), NOT NULL
--   building         VARCHAR(50)
--   budget           DECIMAL(12,2)
--   department_head  VARCHAR(100)
--   creation_date    DATE
-- ============================================
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each department
    department_name VARCHAR(100) NOT NULL,          -- Name of the department
    building VARCHAR(50),                           -- Building location
    budget DECIMAL(12,2),                           -- Budget of department
    department_head VARCHAR(100),                   -- Head of department
    creation_date DATE                 );           -- Creation date of departmen 

-- ============================================
-- we check by trying to List all tables in the current database 
-- SHOW TABLES;
--  +-------------------------+
--  | Tables_in_university_db |
--  +-------------------------+
--  | departments             |
--  +-------------------------+
-- ============================================

-- we verify the good creation and show the structure of the 'departments' table
-- DESCRIBE departments;
--  +-----------------+---------------+------+-----+---------+----------------+
--  | Field           | Type          | Null | Key | Default | Extra          |
--  +-----------------+---------------+------+-----+---------+----------------+
--  | department_id   | int(11)       | NO   | PRI | NULL    | auto_increment |
--  | department_name | varchar(100)  | NO   |     | NULL    |                |
--  | building        | varchar(50)   | YES  |     | NULL    |                |
--  | budget          | decimal(12,2) | YES  |     | NULL    |                |
--  | department_head | varchar(100)  | YES  |     | NULL    |                |
--  | creation_date   | date          | YES  |     | NULL    |                |
--  +-----------------+---------------+------+-----+---------+----------------+

-- ============================================
-- we continue the creation of other tables 
-- Professors table
CREATE TABLE IF NOT EXISTS professors (professor_id INT AUTO_INCREMENT PRIMARY KEY, last_name VARCHAR(50) NOT NULL, first_name VARCHAR(50) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, phone VARCHAR(20), department_id INT, hire_date DATE, salary DECIMAL(10,2), specialization VARCHAR(100), FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE);

-- Students table
CREATE TABLE IF NOT EXISTS students (student_id INT AUTO_INCREMENT PRIMARY KEY, student_number VARCHAR(20) UNIQUE NOT NULL, last_name VARCHAR(50) NOT NULL, first_name VARCHAR(50) NOT NULL, date_of_birth DATE, email VARCHAR(100) UNIQUE NOT NULL, phone VARCHAR(20), address TEXT, department_id INT, level VARCHAR(20) CHECK (level IN ('L1','L2','L3','M1','M2')), enrollment_date DATE DEFAULT CURRENT_DATE, FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE);

-- Courses table
CREATE TABLE IF NOT EXISTS courses (course_id INT AUTO_INCREMENT PRIMARY KEY, course_code VARCHAR(10) UNIQUE NOT NULL, course_name VARCHAR(150) NOT NULL, description TEXT, credits INT NOT NULL CHECK (credits>0), semester INT CHECK (semester BETWEEN 1 AND 2), department_id INT, professor_id INT, max_capacity INT DEFAULT 30, FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY(professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE);

-- Enrollments table
CREATE TABLE IF NOT EXISTS enrollments (enrollment_id INT AUTO_INCREMENT PRIMARY KEY, student_id INT NOT NULL, course_id INT NOT NULL, enrollment_date DATE DEFAULT CURRENT_DATE, academic_year VARCHAR(9) NOT NULL, status VARCHAR(20) DEFAULT 'In Progress' CHECK(status IN ('In Progress','Passed','Failed','Dropped')), UNIQUE(student_id, course_id, academic_year), FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE, FOREIGN KEY(course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE);

-- Grades table
CREATE TABLE IF NOT EXISTS grades (grade_id INT AUTO_INCREMENT PRIMARY KEY, enrollment_id INT NOT NULL, evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')), grade DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20), coefficient DECIMAL(3,2) DEFAULT 1.00, evaluation_date DATE, comments TEXT, FOREIGN KEY(enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE);
-- let's check a last time ;

-- we use SHOW TABLES;
--   +-------------------------+
--   | Tables_in_university_db |
--   +-------------------------+
--   | courses                 |
--   | departments             |
--   | enrollments             |
--   | grades                  |
--   | professors              |
--   | students                |
--   +-------------------------+
-- ==========================================================================================
-- Indexes creation 
CREATE INDEX idx_student_department ON students(department_id); 
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id); 
CREATE INDEX idx_enrollment_course ON enrollments(course_id); 
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
-- ===========================================================================================
-- let's start insertions of data 
INSERT INTO departments (department_id, department_name, building, budget, department_head, creation_date)
VALUES
(1, 'Computer Science', 'A', 500000.00, 'Dr. Ahmed', '2024-01-10'),
(2, 'Mathematics', 'B', 350000.00, 'Dr. Salima', '2023-09-15'),
(3, 'Physics', 'C', 400000.00, 'Dr. Karim', '2022-06-20'),
(4, 'Civil Engineering', 'D', 600000.00, 'Dr. Lina', '2021-03-05');

-- ================================================================================

INSERT INTO professors (professor_id, last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES
(1, 'Ahmed', 'Ali', 'ahmed.ali@uni.edu', '1234567890', 1, '2020-01-10', 5000.00, 'Databases'),
(2, 'Sara', 'Ben', 'sara.ben@uni.edu', '1234567891', 1, '2019-03-15', 5200.00, 'AI'),
(3, 'Omar', 'Khalid', 'omar.k@uni.edu', '1234567892', 1, '2018-07-22', 5100.00, 'Networks'),
(4, 'Leila', 'Fares', 'leila.f@uni.edu', '1234567893', 2, '2017-05-18', 4800.00, 'Algebra'),
(5, 'Rami', 'Hassan', 'rami.h@uni.edu', '1234567894', 3, '2021-11-11', 4900.00, 'Quantum Physics'),
(6, 'Nadia', 'Tarek', 'nadia.t@uni.edu', '1234567895', 4, '2016-02-05', 5300.00, 'Civil Structures');

-- =====================================================================================

INSERT INTO students (student_id, student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date)
VALUES
(101, 'S202401', 'Ali', 'Omar', '2002-05-10', 'ali.o@uni.edu', '1111111111', 'alger', 1, 'L2', '2024-09-01'),
(102, 'S202402', 'Sara', 'Ben', '2001-08-12', 'sara.b@uni.edu', '1111111112', 'boumerdes', 1, 'L3', '2024-09-01'),
(103, 'S202403', 'Yacine', 'Khalid', '2000-01-15', 'yacine.k@uni.edu', '1111111113', 'batna', 2, 'M1', '2024-09-01'),
(104, 'S202404', 'Lina', 'Fares', '2002-12-05', 'lina.f@uni.edu', '1111111114', 'setif', 3, 'L3', '2024-09-01'),
(105, 'S202405', 'Rami', 'Hassan', '2001-07-20', 'rami.h@uni.edu', '1111111115', 'bordj mnail', 4, 'M1', '2024-09-01'),
(106, 'S202406', 'Nadia', 'Tarek', '2002-09-17', 'nadia.t@uni.edu', '1111111116', 'isser', 2, 'L2', '2024-09-01'),
(107, 'S202407', 'Omar', 'Ali', '2001-03-21', 'omar.a@uni.edu', '1111111117', 'fouis', 3, 'L3', '2024-09-01'),
(108, 'S202408', 'Sara', 'Lina', '2000-11-30', 'sara.l@uni.edu', '1111111118', 'ali liguia', 4, 'M1', '2024-09-01');

-- ===============================================================================================

INSERT INTO courses (course_id, course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity)
VALUES
(201, 'CS101', 'Databases', 'Intro to Databases', 6, 1, 1, 1, 30),
(202, 'CS102', 'AI Basics', 'Intro to AI', 5, 2, 1, 2, 30),
(203, 'MA101', 'Linear Algebra', 'Matrix theory', 6, 1, 2, 4, 30),
(204, 'PH101', 'Quantum Physics', 'Intro to Quantum', 5, 2, 3, 5, 30),
(205, 'CE101', 'Civil Structures', 'Building structures', 6, 1, 4, 6, 30),
(206, 'CS103', 'Networks', 'Computer Networks', 5, 2, 1, 3, 30),
(207, 'MA102', 'Calculus', 'Advanced Calculus', 5, 1, 2, 4, 30);

-- ===============================================================================================

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, academic_year, status)
VALUES
(301, 101, 201, '2025-01-01', '2025-2026', 'Passed'),
(302, 101, 202, '2020-02-02', '2020-2025', 'Dropped'),
(303, 102, 201, '2022-03-03', '2022-2023', 'Passed'),
(304, 103, 203, '2020-04-04', '2020-2025', 'Failed'),
(305, 104, 204, '2022-05-07', '2022-2023', 'Passed'),
(306, 105, 205, '2024-07-08', '2024-2026', 'In Progress'),
(307, 106, 203, '2022-09-20', '2022-2024', 'Passed'),
(308, 107, 204, '2024-12-25', '2024-2026', 'Failed'),
(309, 108, 205, '2024-11-15', '2024-2026', 'In Progress'),
(310, 101, 206, '2020-05-12', '2020-2025', 'Passed'),
(311, 102, 207, '2024-07-11', '2024-2026', 'In Progress'),
(312, 103, 201, '2021-04-30', '2021-2022', 'Failed'),
(313, 104, 202, '2018-03-19', '2018-2023', 'Passed'),
(314, 105, 203, '2025-01-21', '2025-2025', 'Dropped'),
(315, 106, 204, '2020-12-31', '2020-2026', 'In Progress');

-- =================================================================================================

INSERT INTO grades (grade_id, enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
VALUES
(401, 302, 'Exam', 15.0, 1, '2020-09-01', 'Good'),
(402, 303, 'Project', 14.5, 5, '2022-07-05', 'Well done'),
(403, 304, 'Exam', 10.0, 6, '2023-05-02', 'Do better'),
(404, 307, 'Lab', 12.0, 4, '2025-04-03', 'Needs improvement'),
(405, 310, 'Assignment', 17.0, 2, '2018-06-04', 'Great work'),
(406, 312, 'Exam', 13.0, 7, '2019-11-05', 'Satisfactory'),
(407, 313, 'Project', 18.0, 5, '2017-08-06', 'Excellent'),
(408, 305, 'Exam', 14.0, 4, '2022-10-07', 'Good'),
(409, 308, 'Lab', 15.5, 3, '2024-03-08', 'Well done'),
(410, 311, 'Assignment', 16.0, 1, '2024-02-09', 'Great'),
(411, 301, 'Exam', 12.5, 7, '2025-12-10', 'Average'),
(412, 314, 'Project', 17.5, 6, '2026-01-11', 'Excellent');


-- ======================================================================================================
-- we can check the correct creation by ; SHOW TABLES; and then check each table ex ; SELECT * FROM departments;
--
--   +---------------+-------------------+----------+-----------+-----------------+---------------+
--   | department_id | department_name   | building | budget    | department_head | creation_date |
--   +---------------+-------------------+----------+-----------+-----------------+---------------+
--   |             1 | Computer Science  | A        | 500000.00 | Dr. Ahmed       | 2024-01-10    |
--   |             2 | Mathematics       | B        | 350000.00 | Dr. Salima      | 2023-09-15    |
--   |             3 | Physics           | C        | 400000.00 | Dr. Karim       | 2022-06-20    |
--   |             4 | Civil Engineering | D        | 600000.00 | Dr. Lina        | 2021-03-05    |
--   +---------------+-------------------+----------+-----------+-----------------+---------------+




-- =========================================================================================================
-- L'ets start with quries 
-- =========================================================================================================

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level
SELECT last_name, first_name, email, level 
FROM students;

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
SELECT c.course_code, c.course_name, CONCAT(p.last_name,' ',p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, d.department_name, s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT CONCAT(st.last_name,' ',st.first_name) AS student_name, c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students st ON e.student_id = st.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;
-- there's one student is ùissing and its courses are all in progress so there 's no probleme with  the query result
-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12. Count the number of students per department
-- Expected columns: department_name, student_count
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary
SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
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
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.status != 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, 
       AVG(g.grade) AS student_avg,
       (SELECT AVG(g2.grade)
        FROM students s2
        JOIN enrollments e2 ON s2.student_id = e2.student_id
        JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
        WHERE s2.department_id = s.department_id) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
HAVING student_avg > department_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > (SELECT AVG(ec) FROM (SELECT COUNT(*) ec FROM enrollments GROUP BY course_id) AS avg_sub);


-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) > (SELECT AVG(st_count) FROM (SELECT COUNT(student_id) st_count FROM students GROUP BY department_id) AS avg_sub);


-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id) * 100,2) AS pass_rate_percentage
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
SELECT @rank:=@rank+1 AS rank, student_name, average_grade
FROM (
    SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name, AVG(g.grade) AS average_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
    ORDER BY average_grade DESC
) AS ranked, (SELECT @rank:=0) AS r;


-- Q28. Generate a report card for student with student_id = 101 ( cause we used 101 in tables not 1)
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade  
-- 
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 101;


-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;


-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity, 
       ROUND(COUNT(e.enrollment_id)/c.max_capacity*100,2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;

