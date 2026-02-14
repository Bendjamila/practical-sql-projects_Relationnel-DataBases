-- TP1 SOLUTION - University Management System


DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;


-- 1) TABLES

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
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    CONSTRAINT fk_prof_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

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
    level VARCHAR(20),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT chk_students_level CHECK (level IN ('L1','L2','L3','M1','M2')),
    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    CONSTRAINT chk_course_credits CHECK (credits > 0),
    CONSTRAINT chk_course_semester CHECK (semester BETWEEN 1 AND 2),
    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_professor
        FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT chk_enrollment_status CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    CONSTRAINT uq_student_course_year UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT chk_grade_type CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CONSTRAINT chk_grade_value CHECK (grade BETWEEN 0 AND 20),
    CONSTRAINT fk_grade_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 2) INDEXES

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 3) TEST DATA

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Nadia Khelifi', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Samir Mebarki', '2008-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Laila Benziane', '2009-09-01'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Yacine Ferhat', '2007-09-01');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Benali', 'Youssef', 'y.benali@uni.dz', '0550-100001', 1, '2016-10-15', 125000.00, 'Artificial Intelligence'),
('Kaci', 'Meriem', 'm.kaci@uni.dz', '0550-100002', 1, '2018-03-20', 115000.00, 'Databases'),
('Haddad', 'Riad', 'r.haddad@uni.dz', '0550-100003', 1, '2020-09-01', 98000.00, 'Networks'),
('Touati', 'Sonia', 's.touati@uni.dz', '0550-100004', 2, '2015-01-12', 110000.00, 'Applied Mathematics'),
('Cherif', 'Amine', 'a.cherif@uni.dz', '0550-100005', 3, '2017-05-11', 112000.00, 'Quantum Mechanics'),
('Bensaid', 'Karim', 'k.bensaid@uni.dz', '0550-100006', 4, '2014-11-08', 130000.00, 'Structural Engineering');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('S2024001', 'Mansouri', 'Aya', '2004-02-10', 'aya.mansouri@student.dz', '0661-200001', 'Algiers', 1, 'L3', '2024-09-15'),
('S2024002', 'Bouzid', 'Nour', '2005-06-02', 'nour.bouzid@student.dz', '0661-200002', 'Oran', 1, 'L2', '2024-09-15'),
('S2024003', 'Rahmani', 'Ilyes', '2003-11-19', 'ilyes.rahmani@student.dz', '0661-200003', 'Constantine', 1, 'M1', '2023-09-20'),
('S2024004', 'Hamdi', 'Yasmine', '2004-08-30', 'yasmine.hamdi@student.dz', '0661-200004', 'Setif', 2, 'L3', '2024-09-15'),
('S2024005', 'Zerrouki', 'Walid', '2002-01-14', 'walid.zerrouki@student.dz', '0661-200005', 'Annaba', 2, 'M1', '2023-09-20'),
('S2024006', 'Meziane', 'Lina', '2005-03-27', 'lina.meziane@student.dz', '0661-200006', 'Blida', 3, 'L2', '2024-09-15'),
('S2024007', 'Ait', 'Sofiane', '2004-07-04', 'sofiane.ait@student.dz', '0661-200007', 'Bejaia', 4, 'L3', '2024-09-15'),
('S2024008', 'Brahimi', 'Sara', '2003-05-22', 'sara.brahimi@student.dz', '0661-200008', 'Tlemcen', 4, 'M1', '2023-09-20');

INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS301', 'Database Systems', 'Relational modeling and SQL', 6, 1, 1, 2, 5),
('CS302', 'Machine Learning', 'Supervised and unsupervised learning', 6, 2, 1, 1, 40),
('CS303', 'Computer Networks', 'Network protocols and architecture', 5, 1, 1, 3, 35),
('MATH301', 'Advanced Statistics', 'Probability and statistical inference', 5, 1, 2, 4, 30),
('PHY301', 'Modern Physics', 'Relativity and quantum concepts', 5, 2, 3, 5, 25),
('CE301', 'Structural Analysis', 'Load and resistance analysis', 6, 1, 4, 6, 30),
('CE302', 'Hydraulics', 'Fluid mechanics for civil systems', 5, 2, 4, 6, 20);

INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2024-09-20', '2024-2025', 'Passed'),
(1, 2, '2024-09-20', '2024-2025', 'Passed'),
(1, 3, '2024-09-20', '2024-2025', 'Passed'),
(2, 1, '2024-09-21', '2024-2025', 'In Progress'),
(2, 3, '2024-09-21', '2024-2025', 'Passed'),
(3, 1, '2023-09-22', '2023-2024', 'Passed'),
(3, 2, '2023-09-22', '2023-2024', 'Failed'),
(3, 4, '2024-09-18', '2024-2025', 'In Progress'),
(4, 4, '2024-09-20', '2024-2025', 'Passed'),
(4, 1, '2024-09-20', '2024-2025', 'Passed'),
(5, 4, '2023-09-22', '2023-2024', 'Passed'),
(5, 5, '2023-09-22', '2023-2024', 'Dropped'),
(6, 5, '2024-09-23', '2024-2025', 'In Progress'),
(7, 6, '2024-09-23', '2024-2025', 'Passed'),
(8, 6, '2023-09-18', '2023-2024', 'Passed'),
(8, 1, '2023-09-18', '2023-2024', 'Failed');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 16.00, 2.00, '2025-01-20', 'Good final exam'),
(1, 'Project', 17.50, 1.50, '2025-01-10', 'Excellent project'),
(2, 'Lab', 15.00, 1.00, '2025-05-05', 'Consistent work'),
(3, 'Exam', 14.00, 2.00, '2025-01-25', 'Solid understanding'),
(4, 'Assignment', 11.00, 1.00, '2024-11-15', 'Needs improvement'),
(5, 'Exam', 12.50, 2.00, '2025-01-25', 'Pass'),
(6, 'Exam', 13.00, 2.00, '2024-01-28', 'Pass'),
(7, 'Exam', 8.50, 2.00, '2024-01-28', 'Below average'),
(8, 'Project', 14.50, 1.50, '2025-05-10', 'Good progress'),
(9, 'Exam', 15.50, 2.00, '2025-01-26', 'Well done'),
(10, 'Lab', 13.50, 1.00, '2024-12-12', 'Good participation'),
(11, 'Exam', 16.50, 2.00, '2024-01-29', 'Excellent'),
(12, 'Assignment', 9.00, 1.00, '2024-02-11', 'Incomplete tasks'),
(13, 'Lab', 12.00, 1.00, '2024-11-20', 'Acceptable'),
(14, 'Exam', 14.80, 2.00, '2025-01-30', 'Good mastery'),
(15, 'Project', 15.20, 1.50, '2024-01-12', 'Very good report'),
(16, 'Exam', 7.50, 2.00, '2024-01-30', 'Failed'),
(2, 'Exam', 16.20, 2.00, '2025-06-01', 'Strong final score');

-- 4) 30 SQL QUERIES ANSWERS

-- Q1
SELECT last_name, first_name, email, level
FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON d.department_id = p.department_id
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
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON p.professor_id = c.professor_id;

-- Q7
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- Q8
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d ON d.department_id = s.department_id;

-- Q9
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON e.enrollment_id = g.enrollment_id
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- Q10
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q11
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / NULLIF(SUM(g.coefficient), 0), 2) AS average_grade
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q13
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON c.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q15
SELECT d.department_name,
       ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
LEFT JOIN professors p ON p.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q16
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / NULLIF(SUM(g.coefficient), 0), 2) AS average_grade
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC
LIMIT 3;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
WHERE e.enrollment_id IS NULL;

-- Q18
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) > 0
   AND SUM(CASE WHEN e.status <> 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.course_id) > 2;

-- Q21
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(sa.student_avg, 2) AS student_avg,
       ROUND(da.department_avg, 2) AS department_avg
FROM students s
JOIN (
    SELECT e.student_id,
           SUM(g.grade * g.coefficient) / NULLIF(SUM(g.coefficient), 0) AS student_avg
    FROM enrollments e
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    GROUP BY e.student_id
) sa ON sa.student_id = s.student_id
JOIN (
    SELECT s2.department_id,
           AVG(sub.student_avg) AS department_avg
    FROM students s2
    JOIN (
        SELECT e2.student_id,
               SUM(g2.grade * g2.coefficient) / NULLIF(SUM(g2.coefficient), 0) AS student_avg
        FROM enrollments e2
        JOIN grades g2 ON g2.enrollment_id = e2.enrollment_id
        GROUP BY e2.student_id
    ) sub ON sub.student_id = s2.student_id
    GROUP BY s2.department_id
) da ON da.department_id = s.department_id
WHERE sa.student_avg > da.department_avg;

-- Q22
SELECT c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(course_enrollments)
    FROM (
        SELECT COUNT(*) AS course_enrollments
        FROM enrollments
        GROUP BY course_id
    ) x
);

-- Q23
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d ON d.department_id = p.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       s.email
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name, s.email
HAVING COUNT(g.grade_id) = 0;

-- Q25
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(dep_count)
    FROM (
        SELECT COUNT(*) AS dep_count
        FROM students
        GROUP BY department_id
    ) t
);

-- Q26
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(100 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / NULLIF(COUNT(g.grade_id), 0), 2) AS pass_rate_percentage
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27
SELECT DENSE_RANK() OVER (ORDER BY avg_table.average_grade DESC) AS rank,
       avg_table.student_name,
       avg_table.average_grade
FROM (
    SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           ROUND(SUM(g.grade * g.coefficient) / NULLIF(SUM(g.coefficient), 0), 2) AS average_grade
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    GROUP BY s.student_id, s.last_name, s.first_name
) avg_table
ORDER BY rank;

-- Q28
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
WHERE e.student_id = 1;

-- Q29
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COALESCE(SUM(c.credits), 0) AS total_credits
FROM professors p
LEFT JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND((COUNT(e.enrollment_id) / c.max_capacity) * 100, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING COUNT(e.enrollment_id) > 0.8 * c.max_capacity;
