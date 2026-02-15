-- ============================================
-- TP1: University Management System
-- tp1_solutions.sql
-- ============================================

-- ============================================
-- PART 0: DATABASE CREATION
-- ============================================

CREATE DATABASE IF NOT EXISTS university_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE university_db;

-- ============================================
-- PART 1: TABLE CREATION
-- ============================================

-- 1. Table: departments
CREATE TABLE departments (
    department_id   INT             NOT NULL AUTO_INCREMENT,
    department_name VARCHAR(100)    NOT NULL,
    building        VARCHAR(50),
    budget          DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date   DATE,
    PRIMARY KEY (department_id)
);

-- 2. Table: professors
CREATE TABLE professors (
    professor_id    INT             NOT NULL AUTO_INCREMENT,
    last_name       VARCHAR(50)     NOT NULL,
    first_name      VARCHAR(50)     NOT NULL,
    email           VARCHAR(100)    NOT NULL,
    phone           VARCHAR(20),
    department_id   INT,
    hire_date       DATE,
    salary          DECIMAL(10, 2),
    specialization  VARCHAR(100),
    PRIMARY KEY (professor_id),
    UNIQUE KEY uq_professor_email (email),
    CONSTRAINT fk_prof_dept
        FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 3. Table: students
CREATE TABLE students (
    student_id      INT             NOT NULL AUTO_INCREMENT,
    student_number  VARCHAR(20)     NOT NULL,
    last_name       VARCHAR(50)     NOT NULL,
    first_name      VARCHAR(50)     NOT NULL,
    date_of_birth   DATE,
    email           VARCHAR(100)    NOT NULL,
    phone           VARCHAR(20),
    address         TEXT,
    department_id   INT,
    level           VARCHAR(20),
    enrollment_date DATE            DEFAULT (CURRENT_DATE),
    PRIMARY KEY (student_id),
    UNIQUE KEY uq_student_number (student_number),
    UNIQUE KEY uq_student_email  (email),
    CONSTRAINT chk_student_level
        CHECK (level IN ('L1','L2','L3','M1','M2')),
    CONSTRAINT fk_student_dept
        FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 4. Table: courses
CREATE TABLE courses (
    course_id       INT             NOT NULL AUTO_INCREMENT,
    course_code     VARCHAR(10)     NOT NULL,
    course_name     VARCHAR(150)    NOT NULL,
    description     TEXT,
    credits         INT             NOT NULL,
    semester        INT,
    department_id   INT,
    professor_id    INT,
    max_capacity    INT             DEFAULT 30,
    PRIMARY KEY (course_id),
    UNIQUE KEY uq_course_code (course_code),
    CONSTRAINT chk_credits   CHECK (credits > 0),
    CONSTRAINT chk_semester  CHECK (semester BETWEEN 1 AND 2),
    CONSTRAINT fk_course_dept
        FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_prof
        FOREIGN KEY (professor_id)
        REFERENCES professors (professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 5. Table: enrollments
CREATE TABLE enrollments (
    enrollment_id   INT             NOT NULL AUTO_INCREMENT,
    student_id      INT             NOT NULL,
    course_id       INT             NOT NULL,
    enrollment_date DATE            DEFAULT (CURRENT_DATE),
    academic_year   VARCHAR(9)      NOT NULL,
    status          VARCHAR(20)     DEFAULT 'In Progress',
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_enrollment (student_id, course_id, academic_year),
    CONSTRAINT chk_enrollment_status
        CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES students (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course
        FOREIGN KEY (course_id)
        REFERENCES courses (course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 6. Table: grades
CREATE TABLE grades (
    grade_id        INT             NOT NULL AUTO_INCREMENT,
    enrollment_id   INT             NOT NULL,
    evaluation_type VARCHAR(30),
    grade           DECIMAL(5, 2),
    coefficient     DECIMAL(3, 2)   DEFAULT 1.00,
    evaluation_date DATE,
    comments        TEXT,
    PRIMARY KEY (grade_id),
    CONSTRAINT chk_eval_type
        CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CONSTRAINT chk_grade_range
        CHECK (grade BETWEEN 0 AND 20),
    CONSTRAINT fk_grade_enroll
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments (enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- PART 2: INDEXES
-- ============================================

CREATE INDEX idx_student_department  ON students    (department_id);
CREATE INDEX idx_course_professor    ON courses     (professor_id);
CREATE INDEX idx_enrollment_student  ON enrollments (student_id);
CREATE INDEX idx_enrollment_course   ON enrollments (course_id);
CREATE INDEX idx_grades_enrollment   ON grades      (enrollment_id);

-- ============================================
-- PART 3: TEST DATA
-- ============================================

-- Departments (4)
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Prof. Kamel Bouazza',   '2000-09-01'),
('Mathematics',      'Building B', 350000.00, 'Prof. Sara Hamdi',      '1998-09-01'),
('Physics',          'Building C', 400000.00, 'Prof. Omar Benali',     '1995-09-01'),
('Civil Engineering','Building D', 600000.00, 'Prof. Lamia Cherif',    '2002-09-01');

-- Professors (6)
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Bouazza',  'Kamel',   'k.bouazza@univ.dz',  '0550001001', 1, '2005-09-01', 95000.00, 'Algorithms & Data Structures'),
('Meziane',  'Riad',    'r.meziane@univ.dz',  '0550001002', 1, '2010-09-01', 85000.00, 'Cybersecurity'),
('Taleb',    'Nadia',   'n.taleb@univ.dz',    '0550001003', 1, '2012-09-01', 82000.00, 'Artificial Intelligence'),
('Hamdi',    'Sara',    's.hamdi@univ.dz',    '0550001004', 2, '2008-09-01', 80000.00, 'Linear Algebra'),
('Benali',   'Omar',    'o.benali@univ.dz',   '0550001005', 3, '2007-09-01', 83000.00, 'Quantum Physics'),
('Cherif',   'Lamia',   'l.cherif@univ.dz',   '0550001006', 4, '2009-09-01', 90000.00, 'Structural Engineering');

-- Students (8)
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('STU-2024-001', 'Amrani',   'Yacine',   '2002-03-15', 'y.amrani@etu.dz',   '0660001001', '12 Rue Didouche Mourad, Alger',  1, 'L3', '2022-09-15'),
('STU-2024-002', 'Boudraf',  'Imene',    '2001-07-22', 'i.boudraf@etu.dz',  '0660001002', '5 Cité Universitaire, Alger',    1, 'M1', '2021-09-15'),
('STU-2024-003', 'Chettouf', 'Anis',     '2003-01-08', 'a.chettouf@etu.dz', '0660001003', '34 Boulevard Krim Belkacem',     1, 'L2', '2023-09-15'),
('STU-2024-004', 'Djerbi',   'Fatima',   '2002-11-30', 'f.djerbi@etu.dz',   '0660001004', '9 Rue Larbi Ben Mhidi, Alger',   2, 'L3', '2022-09-15'),
('STU-2024-005', 'Eddine',   'Nassim',   '2001-05-17', 'n.eddine@etu.dz',   '0660001005', '21 Cité des Pins, Alger',        2, 'M1', '2021-09-15'),
('STU-2024-006', 'Ferrah',   'Sonia',    '2003-09-04', 's.ferrah@etu.dz',   '0660001006', '7 Rue Asselah Hocine, Alger',    3, 'L2', '2023-09-15'),
('STU-2024-007', 'Ghouali',  'Khalil',   '2002-06-25', 'k.ghouali@etu.dz',  '0660001007', '18 Avenue de l''Indépendance',   4, 'L3', '2022-09-15'),
('STU-2024-008', 'Hadj',     'Meriem',   '2001-12-11', 'm.hadj@etu.dz',     '0660001008', '3 Cité El Badr, Alger',          1, 'M1', '2021-09-15');

-- Courses (7)
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS301', 'Algorithms & Complexity',      'Advanced algorithms, sorting, graphs and complexity analysis.',           6, 1, 1, 1, 35),
('CS302', 'Network Security',             'Principles of network security, cryptography and attack prevention.',    6, 1, 1, 2, 30),
('CS303', 'Machine Learning',             'Introduction to supervised and unsupervised learning algorithms.',       5, 2, 1, 3, 30),
('MA201', 'Linear Algebra',               'Matrices, vector spaces, eigenvalues and linear transformations.',       5, 1, 2, 4, 40),
('PH201', 'Thermodynamics',               'Laws of thermodynamics and heat transfer applications.',                 5, 2, 3, 5, 35),
('GC301', 'Structural Analysis',          'Load bearing structures, beams and frames analysis.',                   6, 1, 4, 6, 25),
('CS304', 'Operating Systems',            'Process management, memory, file systems and synchronisation.',         6, 2, 1, 1, 30);

-- Enrollments (15)
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
-- Academic year 2024-2025 (current)
(1, 1, '2024-09-20', '2024-2025', 'In Progress'),
(1, 2, '2024-09-20', '2024-2025', 'In Progress'),
(1, 7, '2024-09-20', '2024-2025', 'In Progress'),
(2, 2, '2024-09-20', '2024-2025', 'In Progress'),
(2, 3, '2024-09-20', '2024-2025', 'Passed'),
(3, 1, '2024-09-20', '2024-2025', 'In Progress'),
(3, 4, '2024-09-20', '2024-2025', 'In Progress'),
(4, 4, '2024-09-20', '2024-2025', 'Passed'),
(5, 3, '2024-09-20', '2024-2025', 'In Progress'),
(5, 4, '2024-09-20', '2024-2025', 'In Progress'),
(6, 5, '2024-09-20', '2024-2025', 'In Progress'),
(7, 6, '2024-09-20', '2024-2025', 'In Progress'),
(8, 2, '2024-09-20', '2024-2025', 'Passed'),
-- Academic year 2023-2024 (previous)
(1, 4, '2023-09-20', '2023-2024', 'Passed'),
(2, 7, '2023-09-20', '2023-2024', 'Passed');

-- Grades (12+)
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
-- Enrollment 1: Amrani -> CS301
(1,  'Exam',       14.50, 2.00, '2024-11-15', 'Good understanding of sorting algorithms'),
(1,  'Assignment', 16.00, 1.00, '2024-10-20', 'Excellent graph traversal implementation'),
-- Enrollment 2: Amrani -> CS302
(2,  'Exam',       13.00, 2.00, '2024-11-16', 'Satisfactory on cryptography chapter'),
(2,  'Lab',        17.50, 1.00, '2024-10-25', 'Perfect firewall configuration lab'),
-- Enrollment 3: Amrani -> CS304
(3,  'Exam',       15.00, 2.00, '2024-11-20', 'Good on process scheduling'),
-- Enrollment 4: Boudraf -> CS302
(4,  'Exam',       18.00, 2.00, '2024-11-16', 'Excellent in-depth security analysis'),
(4,  'Project',    17.00, 1.50, '2024-12-01', 'Very well documented pen-testing report'),
-- Enrollment 5: Boudraf -> ML (already Passed)
(5,  'Exam',       16.50, 2.00, '2024-06-10', 'Strong grasp of supervised learning'),
-- Enrollment 6: Chettouf -> CS301
(6,  'Assignment', 12.00, 1.00, '2024-10-20', 'Needs improvement on complexity proofs'),
(6,  'Exam',       10.50, 2.00, '2024-11-15', 'Average performance'),
-- Enrollment 8: Djerbi -> MA201 (already Passed)
(8,  'Exam',       15.50, 2.00, '2024-06-12', 'Good understanding of eigenvalues'),
-- Enrollment 11: Ferrah -> PH201
(11, 'Exam',       11.00, 2.00, '2024-11-18', 'Needs revision on second law'),
-- Enrollment 12: Ghouali -> GC301
(12, 'Project',    13.50, 1.50, '2024-11-30', 'Solid structural bridge design project');

-- ============================================
-- PART 4: 30 SQL QUERIES
-- ============================================

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
SELECT
    last_name,
    first_name,
    email,
    level
FROM students
ORDER BY last_name, first_name;

-- Q2. Display all professors from the Computer Science department
SELECT
    p.last_name,
    p.first_name,
    p.email,
    p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3. Find all courses with more than 5 credits
SELECT
    course_code,
    course_name,
    credits
FROM courses
WHERE credits > 5
ORDER BY credits DESC;

-- Q4. List students enrolled in L3 level
SELECT
    student_number,
    last_name,
    first_name,
    email
FROM students
WHERE level = 'L3'
ORDER BY last_name;

-- Q5. Display courses from semester 1
SELECT
    course_code,
    course_name,
    credits,
    semester
FROM courses
WHERE semester = 1
ORDER BY course_code;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
SELECT
    c.course_code,
    c.course_name,
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id
ORDER BY c.course_code;

-- Q7. List all enrollments with student name and course name
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    c.course_name,
    e.enrollment_date,
    e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses  c ON e.course_id  = c.course_id
ORDER BY s.last_name, c.course_name;

-- Q8. Display students with their department name
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    d.department_name,
    s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
ORDER BY d.department_name, s.last_name;

-- Q9. List grades with student name, course name, and grade obtained
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    c.course_name,
    g.evaluation_type,
    g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id  = e.enrollment_id
JOIN students   s ON e.student_id      = s.student_id
JOIN courses    c ON e.course_id       = c.course_id
ORDER BY s.last_name, c.course_name;

-- Q10. Display professors with the number of courses they teach
SELECT
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COUNT(c.course_id)                     AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
ORDER BY number_of_courses DESC;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Weighted average: SUM(grade * coefficient) / SUM(coefficient)
SELECT
    CONCAT(s.last_name, ' ', s.first_name)           AS student_name,
    ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS average_grade
FROM students   s
JOIN enrollments e ON s.student_id    = e.student_id
JOIN grades      g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC;

-- Q12. Count the number of students per department
SELECT
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY student_count DESC;

-- Q13. Calculate the total budget of all departments
SELECT
    SUM(budget) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
SELECT
    d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name
ORDER BY course_count DESC;

-- Q15. Calculate the average salary of professors per department
SELECT
    d.department_name,
    ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name
ORDER BY average_salary DESC;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
SELECT
    CONCAT(s.last_name, ' ', s.first_name)                        AS student_name,
    ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2)  AS average_grade
FROM students   s
JOIN enrollments e ON s.student_id    = e.student_id
JOIN grades      g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
SELECT
    c.course_code,
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL
ORDER BY c.course_code;

-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Only students where every enrollment has status 'Passed'
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    COUNT(e.enrollment_id)                 AS passed_courses_count
FROM students   s
JOIN enrollments e ON s.student_id = e.student_id
WHERE s.student_id NOT IN (
    SELECT DISTINCT student_id
    FROM enrollments
    WHERE status <> 'Passed'
)
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY passed_courses_count DESC;

-- Q19. Find professors who teach more than 2 courses
SELECT
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COUNT(c.course_id)                     AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2
ORDER BY courses_taught DESC;

-- Q20. List students enrolled in more than 2 courses
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    COUNT(e.enrollment_id)                 AS enrolled_courses_count
FROM students   s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) > 2
ORDER BY enrolled_courses_count DESC;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
WITH student_avg AS (
    SELECT
        s.student_id,
        s.department_id,
        CONCAT(s.last_name, ' ', s.first_name)                        AS student_name,
        ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2)  AS student_avg
    FROM students   s
    JOIN enrollments e ON s.student_id    = e.student_id
    JOIN grades      g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.department_id, s.last_name, s.first_name
),
dept_avg AS (
    SELECT
        s.department_id,
        ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS department_avg
    FROM students   s
    JOIN enrollments e ON s.student_id    = e.student_id
    JOIN grades      g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
)
SELECT
    sa.student_name,
    sa.student_avg,
    da.department_avg
FROM student_avg sa
JOIN dept_avg da ON sa.department_id = da.department_id
WHERE sa.student_avg > da.department_avg
ORDER BY sa.student_avg DESC;

-- Q22. List courses with more enrollments than the average number of enrollments
SELECT
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses    c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(enroll_count)
    FROM (
        SELECT course_id, COUNT(*) AS enroll_count
        FROM enrollments
        GROUP BY course_id
    ) AS sub
)
ORDER BY enrollment_count DESC;

-- Q23. Display professors from the department with the highest budget
SELECT
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (
    SELECT MAX(budget) FROM departments
)
ORDER BY p.last_name;

-- Q24. Find students with no grades recorded
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    s.email
FROM students s
WHERE s.student_id NOT IN (
    SELECT DISTINCT e.student_id
    FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
)
ORDER BY s.last_name;

-- Q25. List departments with more students than the average
SELECT
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(dept_count)
    FROM (
        SELECT department_id, COUNT(*) AS dept_count
        FROM students
        GROUP BY department_id
    ) AS sub
)
ORDER BY student_count DESC;

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT
    c.course_name,
    COUNT(g.grade_id)                                              AS total_grades,
    SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END)                AS passed_grades,
    ROUND(
        100.0 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END)
               / NULLIF(COUNT(g.grade_id), 0),
        2
    )                                                              AS pass_rate_percentage
FROM courses    c
JOIN enrollments e ON c.course_id     = e.course_id
JOIN grades      g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name
ORDER BY pass_rate_percentage DESC;

-- Q27. Display student ranking by descending average
SELECT
    RANK() OVER (ORDER BY ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) DESC) AS `rank`,
    CONCAT(s.last_name, ' ', s.first_name)                                                   AS student_name,
    ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2)                             AS average_grade
FROM students   s
JOIN enrollments e ON s.student_id    = e.student_id
JOIN grades      g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC;

-- Q28. Generate a report card for student with student_id = 1
SELECT
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM grades      g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses     c ON e.course_id     = c.course_id
WHERE e.student_id = 1
ORDER BY c.course_name, g.evaluation_type;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    SUM(c.credits)                         AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
ORDER BY total_credits DESC;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT
    c.course_name,
    COUNT(e.enrollment_id)                               AS current_enrollments,
    c.max_capacity,
    ROUND(100.0 * COUNT(e.enrollment_id) / c.max_capacity, 2) AS percentage_full
FROM courses     c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING (COUNT(e.enrollment_id) / c.max_capacity) > 0.80
ORDER BY percentage_full DESC;

-- ============================================
-- END OF tp1_solutions.sql
-- ============================================
