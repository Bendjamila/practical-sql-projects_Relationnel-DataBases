-- ============================================
-- Nom : ALIOUCHE PRENOM : LYCIA
-- ==========================================
-- TP1: 30 SQL Queries to Solve
-- University Management System
-- ============================================
-- CRÉATION DE LA BASE
-- ============================================
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE university_db;

-- ============================================
-- CRÉATION DES TABLES
-- ============================================
-- departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- Professors
CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    specialization VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Students
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
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Enrollments
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' 
        CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id, academic_year)
);

-- Grades
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) 
        CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade DECIMAL(5, 2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
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
-- INSERT TEST DATA
-- =============================================
-- Insert Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'North Wing', 520000.00, 'Dr. Amira Bensalem', '2011-08-15'),
('Mathematics', 'East Wing', 360000.00, 'Prof. Karim Benali', '2009-09-01'),
('Physics', 'West Wing', 410000.00, 'Dr. Nadia Khelifi', '2013-03-12'),
('Civil Engineering', 'Central Building', 600000.00, 'Prof. Youssef Touati', '2007-06-20');

-- Insert Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Belkacem', 'Sami', 'sami.belkacem@university.edu', '+213-555-1011', 1, '2017-09-01', 75000.00, 'Machine Learning'),
('Brahimi', 'Leila', 'leila.brahimi@university.edu', '+213-555-1022', 1, '2018-01-15', 72000.00, 'Database Systems'),
('Cherif', 'Karim', 'karim.cherif@university.edu', '+213-555-1033', 1, '2019-09-01', 68000.00, 'Web Development'),
('Amrani', 'Fatiha', 'fatiha.amrani@university.edu', '+213-555-1044', 2, '2016-09-01', 70000.00, 'Statistics'),
('Haddad', 'Rachid', 'rachid.haddad@university.edu', '+213-555-1055', 3, '2015-09-01', 73000.00, 'Quantum Mechanics'),
('Kacem', 'Nadia', 'nadia.kacem@university.edu', '+213-555-1066', 4, '2014-09-01', 78000.00, 'Structural Engineering');
-- Insert Students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('CS2021001', 'Saidi', 'Rania', '2003-06-12', 'rania.saidi@student.edu', '+213-661-0101', '12 Rue Ali, Algiers', 1, 'L3', '2021-09-01'),
('CS2022002', 'Moussa', 'Omar', '2004-03-08', 'omar.moussa@student.edu', '+213-661-0102', '8 Avenue Didouche, Algiers', 1, 'L2', '2022-09-01'),
('MA2021003', 'Fares', 'Sara', '2003-11-21', 'sara.fares@student.edu', '+213-661-0103', '24 Rue Abane, Algiers', 2, 'L3', '2021-09-01'),
('PH2022004', 'Benali', 'Youssef', '2004-01-19', 'youssef.benali@student.edu', '+213-661-0104', '5 Boulevard Amirouche, Algiers', 3, 'L2', '2022-09-01'),
('CS2020005', 'Khaldi', 'Lina', '2002-07-05', 'lina.khaldi@student.edu', '+213-661-0105', '18 Rue Didouche, Algiers', 1, 'M1', '2020-09-01'),
('CE2021006', 'Toumi', 'Hassan', '2003-09-12', 'hassan.toumi@student.edu', '+213-661-0106', '33 Avenue Larbi, Algiers', 4, 'L3', '2021-09-01'),
('CS2022007', 'Ait Ahmed', 'Mila', '2004-02-14', 'mila.aitahmed@student.edu', '+213-661-0107', '40 Rue Didouche, Algiers', 1, 'L2', '2022-09-01'),
('MA2020008', 'Zerrouki', 'Samir', '2002-10-30', 'samir.zerrouki@student.edu', '+213-661-0108', '10 Boulevard Amirouche, Algiers', 2, 'M1', '2020-09-01');


-- Insert Courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS301', 'Database Systems', 'Advanced database design and SQL programming', 6, 1, 1, 2, 35),
('CS302', 'Artificial Intelligence', 'Intro to AI and machine learning', 6, 1, 1, 1, 30),
('CS401', 'Web Development', 'Full-stack web development', 5, 2, 1, 3, 32),
('MA201', 'Linear Algebra', 'Vectors and matrices', 5, 1, 2, 4, 40),
('PH301', 'Quantum Mechanics', 'Basics of quantum physics', 6, 1, 3, 5, 25),
('CE301', 'Structural Analysis', 'Study of building structures', 6, 2, 4, 6, 28),
('CS303', 'Data Structures', 'Algorithms and data structures', 5, 2, 1, 1, 35);

-- Insert Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2024-09-15', '2024-2025', 'In Progress'),
(1, 2, '2024-09-15', '2024-2025', 'In Progress'),
(1, 3, '2024-09-15', '2024-2025', 'In Progress'),
(2, 1, '2024-09-15', '2024-2025', 'In Progress'),
(2, 7, '2024-09-15', '2024-2025', 'In Progress'),
(5, 1, '2024-09-15', '2024-2025', 'Passed'),
(5, 2, '2024-09-15', '2024-2025', 'Passed'),
(5, 3, '2024-09-15', '2024-2025', 'In Progress'),
(7, 1, '2024-09-15', '2024-2025', 'In Progress'),
(7, 7, '2024-09-15', '2024-2025', 'In Progress'),
(3, 4, '2023-09-10', '2023-2024', 'Passed'),
(4, 5, '2023-09-10', '2023-2024', 'Passed'),
(6, 6, '2023-09-10', '2023-2024', 'Passed'),
(8, 4, '2023-09-10', '2023-2024', 'Passed'),
(1, 7, '2023-09-10', '2023-2024', 'Failed');

-- Insert Grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Assignment', 15.50, 0.20, '2024-10-15', 'Good understanding of normalization'),
(1, 'Exam', 14.00, 0.60, '2024-12-10', 'Solid performance'),
(2, 'Lab', 16.00, 0.30, '2024-11-05', 'Excellent implementation'),
(2, 'Project', 17.50, 0.50, '2024-12-15', 'Outstanding project work'),
(6, 'Assignment', 18.00, 0.20, '2024-10-15', 'Excellent work'),
(6, 'Exam', 16.50, 0.60, '2024-12-10', 'Very good understanding'),
(7, 'Lab', 17.00, 0.30, '2024-11-05', 'Great implementation'),
(7, 'Exam', 15.50, 0.50, '2024-12-18', 'Good performance'),
(11, 'Exam', 14.50, 1.00, '2024-01-20', 'Passed'),
(12, 'Exam', 13.00, 1.00, '2024-01-22', 'Passed'),
(13, 'Project', 16.00, 1.00, '2024-05-15', 'Excellent project'),
(14, 'Exam', 12.50, 1.00, '2024-01-20', 'Passed');
-- ======================================================
-- ========== SQL QUERIES TO SOLVE ==========
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
SELECT c.course_code, c.course_name,
       CONCAT(p.last_name,' ',p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;


-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
JOIN departments d ON s.department_id = d.department_id;


-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
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
SELECT d.department_name, ROUND(AVG(p.salary),2) AS avg_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;


-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
AVG(g.grade) AS average_grade
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
SELECT CONCAT(s.last_name,' ',s.first_name) AS student,
COUNT(*) AS passed_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id
HAVING COUNT(*) = (
SELECT COUNT(*)
FROM enrollments e2
WHERE e2.student_id = s.student_id
);


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
-- Q21. Students with average higher than their department average

SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       ROUND(AVG(g.grade),2) AS student_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id
HAVING AVG(g.grade) > (
    SELECT AVG(g2.grade)
    FROM students s2
    JOIN enrollments e2 ON s2.student_id = e2.student_id
    JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
    WHERE s2.department_id = s.department_id
    GROUP BY s2.department_id
);

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollments
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > (
SELECT AVG(cnt)
FROM (
SELECT COUNT(*) AS cnt
FROM enrollments
GROUP BY course_id
) x
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
SELECT CONCAT(s.last_name,' ',s.first_name) AS student, s.email
FROM students s
WHERE s.student_id NOT IN (
SELECT DISTINCT e.student_id
FROM enrollments e
JOIN grades g ON e.enrollment_id = g.enrollment_id
);


-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT d.department_name, COUNT(s.student_id) AS students
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) > (
SELECT AVG(cnt)
FROM (
SELECT COUNT(*) AS cnt
FROM students
GROUP BY department_id
) t
);


-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT c.course_name,
COUNT(g.grade_id) AS total_grades,
SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END)*100.0/COUNT(g.grade_id),2)
AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;


-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
SELECT 
RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank_position,
CONCAT(s.last_name,' ',s.first_name) AS student_name,
ROUND(AVG(g.grade),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;


-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
g.grade * g.coefficient AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;


-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor,
SUM(c.credits) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT c.course_name,
COUNT(e.enrollment_id) AS enrolled,
c.max_capacity
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > 0.8 * c.max_capacity;

