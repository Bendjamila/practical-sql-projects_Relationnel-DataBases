-- TP1 university system - darine

-- create db
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- tables

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

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
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
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
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

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
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress'
        CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_enrollment (student_id, course_id, academic_year)
);

CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade DECIMAL(5, 2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- test data

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Informatique', 'Batiment A', 50000000.00, 'Pr. Benali', '2010-01-15'),
('Mathematiques', 'Batiment B', 35000000.00, 'Pr. Khelifi', '2010-02-01'),
('Physique', 'Batiment C', 40000000.00, 'Pr. Amrani', '2010-02-15'),
('Genie Civil', 'Batiment D', 60000000.00, 'Pr. Chaoui', '2011-01-01');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Benali', 'Karim', 'karim.benali@univ.dz', '0550-010101', 1, '2015-09-01', 85000.00, 'Intelligence artificielle'),
('Mebarki', 'Nadia', 'nadia.mebarki@univ.dz', '0550-010102', 1, '2016-03-15', 82000.00, 'Bases de donnees'),
('Khelifi', 'Rachid', 'rachid.khelifi@univ.dz', '0550-010103', 1, '2014-01-10', 90000.00, 'Genie logiciel'),
('Ouali', 'Samira', 'samira.ouali@univ.dz', '0550-020101', 2, '2013-09-01', 78000.00, 'Algebre'),
('Rahmani', 'Amine', 'amine.rahmani@univ.dz', '0550-030101', 3, '2012-01-15', 81000.00, 'Mecanique quantique'),
('Salhi', 'Djamila', 'djamila.salhi@univ.dz', '0550-040101', 4, '2011-09-01', 79000.00, 'Structures');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, department_id, level, enrollment_date) VALUES
('S2024001', 'Taleb', 'Amira', '2002-05-15', 'amira.taleb@student.univ.dz', '0551-100001', 1, 'L3', '2022-09-01'),
('S2024002', 'Ziani', 'Yacine', '2003-01-20', 'yacine.ziani@student.univ.dz', '0551-100002', 1, 'L2', '2023-09-01'),
('S2024003', 'Bouzid', 'Chahinez', '2001-11-08', 'chahinez.bouzid@student.univ.dz', '0551-100003', 1, 'M1', '2020-09-01'),
('S2024004', 'Ferhat', 'Djamel', '2002-07-22', 'djamel.ferhat@student.univ.dz', '0551-100004', 2, 'L3', '2021-09-01'),
('S2024005', 'Larbi', 'Ines', '2003-03-10', 'ines.larbi@student.univ.dz', '0551-100005', 1, 'L2', '2023-09-01'),
('S2024006', 'Hamdi', 'Farid', '2000-09-30', 'farid.hamdi@student.univ.dz', '0551-100006', 3, 'M1', '2019-09-01'),
('S2024007', 'Mansouri', 'Ghania', '2002-12-05', 'ghania.mansouri@student.univ.dz', '0551-100007', 4, 'L3', '2022-09-01'),
('S2024008', 'Belkadi', 'Hakim', '2001-06-18', 'hakim.belkadi@student.univ.dz', '0551-100008', 1, 'M1', '2020-09-01'),
('S2024009', 'Lounis', 'Imane', '2003-04-25', 'imane.lounis@student.univ.dz', '0551-100009', 2, 'L2', '2023-09-01');

INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Introduction to Programming', 'Basic programming concepts', 6, 1, 1, 1, 30),
('CS201', 'Database Systems', 'Relational database design', 6, 1, 1, 2, 25),
('CS301', 'Machine Learning', 'ML algorithms and applications', 5, 2, 1, 1, 20),
('MATH101', 'Linear Algebra', 'Vectors and matrices', 5, 1, 2, 4, 40),
('MATH201', 'Calculus II', 'Advanced calculus', 5, 2, 2, 4, 35),
('PHYS101', 'Mechanics', 'Classical mechanics', 6, 1, 3, 5, 30),
('CE101', 'Structural Analysis', 'Structural engineering basics', 6, 1, 4, 6, 25),
('CS102', 'Data Structures', 'Lists, trees, graphs', 6, 2, 1, 3, 28);

INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2024-09-01', '2024-2025', 'In Progress'),
(1, 2, '2024-09-01', '2024-2025', 'Passed'),
(1, 3, '2024-09-01', '2024-2025', 'In Progress'),
(2, 1, '2024-09-01', '2024-2025', 'In Progress'),
(2, 2, '2024-09-01', '2024-2025', 'In Progress'),
(3, 2, '2024-09-01', '2024-2025', 'Passed'),
(3, 3, '2024-09-01', '2024-2025', 'Passed'),
(4, 4, '2024-09-01', '2024-2025', 'In Progress'),
(4, 5, '2023-09-01', '2023-2024', 'Passed'),
(5, 1, '2024-09-01', '2024-2025', 'In Progress'),
(5, 8, '2024-09-01', '2024-2025', 'In Progress'),
(6, 6, '2024-09-01', '2024-2025', 'Passed'),
(7, 7, '2024-09-01', '2024-2025', 'In Progress'),
(8, 2, '2024-09-01', '2024-2025', 'Passed'),
(8, 3, '2024-09-01', '2024-2025', 'Passed'),
(9, 4, '2024-09-01', '2024-2025', 'In Progress'),
(1, 4, '2023-09-01', '2023-2024', 'Passed'),
(2, 8, '2023-09-01', '2023-2024', 'Failed');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Assignment', 14.50, 0.3, '2024-10-15', NULL),
(1, 'Exam', 16.00, 0.7, '2024-11-20', NULL),
(2, 'Lab', 15.00, 0.4, '2024-10-01', NULL),
(2, 'Exam', 17.00, 0.6, '2024-11-15', NULL),
(3, 'Project', 13.50, 1.00, '2024-12-01', NULL),
(4, 'Assignment', 12.00, 0.3, '2024-10-20', NULL),
(5, 'Lab', 11.00, 0.4, '2024-10-05', NULL),
(6, 'Exam', 18.00, 1.00, '2024-11-10', NULL),
(7, 'Assignment', 14.00, 0.2, '2024-10-25', NULL),
(8, 'Exam', 15.50, 1.00, '2024-11-01', NULL),
(11, 'Lab', 10.50, 0.5, '2024-10-10', NULL),
(15, 'Exam', 16.50, 1.00, '2024-11-25', NULL);

-- queries

-- Q1 students info
SELECT last_name, first_name, email, level FROM students;

-- Q2 profs from informatique dept
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Informatique';

-- Q3 courses > 5 credits
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4 L3 students
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';

-- Q5 semester 1 courses
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;

-- Q6 courses + prof name
SELECT c.course_code, c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7 enrollments with student and course
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8 students + dept
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name, s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9 grades with student course and grade
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10 profs + nb of courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q11 avg grade per student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12 students per dept
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13 total budget
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14 courses per dept
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;

-- Q15 avg salary per dept
SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;

-- Q16 top 3 students
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC LIMIT 3;

-- Q17 courses with no students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18 students who passed
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(*) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q19 profs with >2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING courses_taught > 2;

-- Q20 students in >2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING enrolled_courses_count > 2;

-- Q21 students above dept average
WITH dept_avg AS (
    SELECT s.department_id, AVG(g.grade) AS dept_average
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    WHERE s.department_id IS NOT NULL
    GROUP BY s.department_id
),
student_avg AS (
    SELECT s.student_id, s.last_name, s.first_name, s.department_id,
           AVG(g.grade) AS stud_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.last_name, s.first_name, s.department_id
)
SELECT CONCAT(sa.last_name, ' ', sa.first_name) AS student_name,
       sa.stud_avg AS student_avg, da.dept_average AS department_avg
FROM student_avg sa
JOIN dept_avg da ON sa.department_id = da.department_id
WHERE sa.stud_avg > da.dept_average;

-- Q22 courses with more enrollments than avg
WITH avg_enrollments AS (
    SELECT AVG(cnt) AS avg_cnt FROM (
        SELECT COUNT(*) AS cnt FROM enrollments GROUP BY course_id
    ) t
)
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING enrollment_count > (SELECT avg_cnt FROM avg_enrollments);

-- Q23 profs from dept with highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_id = (SELECT department_id FROM departments ORDER BY budget DESC LIMIT 1);

-- Q24 students with no grades
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, s.email
FROM students s
WHERE s.student_id NOT IN (
    SELECT DISTINCT student_id FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25 depts with more students than avg
WITH avg_students AS (
    SELECT AVG(cnt) AS avg_cnt FROM (
        SELECT COUNT(*) AS cnt FROM students WHERE department_id IS NOT NULL GROUP BY department_id
    ) t
)
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING student_count > (SELECT avg_cnt FROM avg_students);

-- Q26 pass rate per course
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(100.0 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27 student ranking
SELECT ROW_NUMBER() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`,
       CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC;

-- Q28 report card for student 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
       ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE e.student_id = 1;

-- Q29 teaching load per prof
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COALESCE(SUM(c.credits), 0) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30 overloaded courses (>80% full)
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND(100.0 * COUNT(e.enrollment_id) / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id AND e.academic_year = '2024-2025'
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING current_enrollments > (c.max_capacity * 0.8);
