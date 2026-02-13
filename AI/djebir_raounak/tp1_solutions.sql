-- ============================================
-- TP1 : Système de Gestion Universitaire
-- 30 Requêtes SQL – Solutions
-- Étudiant : Djebir Raounak
-- Date : 13 février 2026
-- ============================================

-- Nettoyage et création propre de la base
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- ========== TABLES + INDEXES + DONNÉES DE TEST ==========

CREATE TABLE departments (
    department_id   INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building        VARCHAR(50),
    budget          DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date   DATE
);

CREATE TABLE professors (
    professor_id    INT PRIMARY KEY AUTO_INCREMENT,
    last_name       VARCHAR(50) NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(20),
    department_id   INT,
    hire_date       DATE,
    salary          DECIMAL(10,2),
    specialization  VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE students (
    student_id      INT PRIMARY KEY AUTO_INCREMENT,
    student_number  VARCHAR(20) UNIQUE NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
    date_of_birth   DATE,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(20),
    address         TEXT,
    department_id   INT,
    level           VARCHAR(20),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_level CHECK (level IN ('L1','L2','L3','M1','M2'))
);

CREATE TABLE courses (
    course_id       INT PRIMARY KEY AUTO_INCREMENT,
    course_code     VARCHAR(10) UNIQUE NOT NULL,
    course_name     VARCHAR(150) NOT NULL,
    description     TEXT,
    credits         INT NOT NULL CHECK (credits > 0),
    semester        INT CHECK (semester BETWEEN 1 AND 2),
    department_id   INT,
    professor_id    INT,
    max_capacity    INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_id      INT NOT NULL,
    course_id       INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year   VARCHAR(9) NOT NULL,
    status          VARCHAR(20) DEFAULT 'In Progress'
        CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (student_id, course_id, academic_year)
);

CREATE TABLE grades (
    grade_id        INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id   INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    grade           DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20),
    coefficient     DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments        TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexes requis
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor   ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course  ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment  ON grades(enrollment_id);

-- Données de test (comme dans ta version précédente)

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'A', 500000, 'Dr. Khaled', '2018-09-01'),
('Mathematics', 'B', 350000, 'Dr. Amina', '2019-01-15'),
('Physics', 'C', 400000, 'Prof. Omar', '2020-03-10'),
('Civil Engineering', 'D', 600000, 'Dr. Nadia', '2017-06-20');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Belkacem', 'Karim', 'k.belkacem@esi.dz', '0555123456', 1, '2016-09-01', 92000, 'Machine Learning'),
('Haddad', 'Sofia', 's.haddad@esi.dz', '0770987654', 1, '2018-02-15', 85000, 'Databases'),
('Mansouri', 'Amine', 'a.mansouri@esi.dz', '0566123789', 1, '2020-10-01', 78000, 'Software Engineering'),
('Cherif', 'Fatima', 'f.cherif@univ.dz', '0554789123', 2, '2017-05-20', 81000, 'Statistics'),
('Bensalem', 'Yacine', 'y.bensalem@univ.dz', '0778456123', 3, '2019-11-10', 88000, 'Quantum Mechanics'),
('Larbi', 'Nourredine', 'n.larbi@univ.dz', '0666998877', 4, '2016-03-05', 95000, 'Structural Design'),
('Ziani', 'Leila', 'l.ziani@univ.dz', '0555443322', 4, '2021-09-01', 72000, 'Geotechnics');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, department_id, level) VALUES
('20231001', 'Rahmani', 'Djebir', '2002-04-12', 'djebir.r@esi.dz', 1, 'L3'),
('20231002', 'Bouaziz', 'Amina', '2001-11-25', 'amina.b@univ.dz', 1, 'M1'),
('20231003', 'Khelifi', 'Yassine', '2003-02-08', 'y.khelifi@univ.dz', 1, 'L2'),
('20231004', 'Saidi', 'Nour', '2000-07-19', 'n.saidi@univ.dz', 2, 'L3'),
('20231005', 'Boudiaf', 'Hamza', '2002-09-30', 'h.boudiaf@univ.dz', 2, 'M1'),
('20231006', 'Meziani', 'Sarah', '2001-12-14', 's.meziani@univ.dz', 3, 'L3'),
('20231007', 'Ouldali', 'Mohamed', '1999-05-03', 'm.ouldali@univ.dz', 3, 'M2'),
('20231008', 'Ghernaout', 'Imene', '2003-03-27', 'i.ghernaout@univ.dz', 4, 'L2'),
('20231009', 'Benyahia', 'Rania', '2002-08-11', 'r.benyahia@univ.dz', 4, 'L3'),
('20231010', 'Djermane', 'Sofiane', '2000-01-22', 's.djermane@univ.dz', 1, 'M1');


INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id, max_capacity) VALUES
('CSI210', 'Algorithms & Data Structures', 6, 1, 1, 1, 35),
('CSI220', 'Databases', 6, 2, 1, 2, 40),
('CSI310', 'Artificial Intelligence', 5, 1, 1, 1, 30),
('MAT210', 'Probability & Statistics', 5, 1, 2, 4, 45),
('MAT220', 'Linear Algebra', 6, 2, 2, 4, 40),
('PHY210', 'Mechanics', 6, 1, 3, 5, 38),
('CIV210', 'Structural Analysis', 5, 2, 4, 6, 32),
('CIV220', 'Soil Mechanics', 5, 1, 4, 7, 30);


INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1,1,'2024-2025','In Progress'),
(1,2,'2024-2025','In Progress'),
(2,1,'2024-2025','Passed'),
(2,3,'2024-2025','Passed'),
(3,1,'2024-2025','In Progress'),
(3,2,'2024-2025','Failed'),
(4,4,'2024-2025','Passed'),
(4,5,'2024-2025','In Progress'),
(5,4,'2024-2025','Passed'),
(5,5,'2024-2025','Passed'),
(6,6,'2024-2025','In Progress'),
(7,6,'2024-2025','Passed'),
(8,7,'2024-2025','In Progress'),
(9,7,'2024-2025','Passed'),
(10,1,'2024-2025','In Progress');


INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date) VALUES
(1,'Exam',13.50,2.00,'2025-01-10'),
(1,'Assignment',11.00,1.00,'2024-11-20'),
(2,'Exam',15.75,2.00,'2025-01-15'),
(3,'Project',17.00,1.50,'2025-01-05'),
(4,'Exam',16.20,2.00,'2025-01-10'),
(5,'Exam',18.00,2.00,'2025-01-05'),
(6,'Exam',14.50,2.00,'2025-01-12'),
(7,'Lab',12.00,1.50,'2024-12-01'),
(8,'Exam',8.50,2.00,'2025-01-15'),
(9,'Project',16.50,1.00,'2025-01-08'),
(10,'Exam',17.25,2.00,'2025-01-20'),
(11,'Exam',14.00,2.00,'2025-01-10');

-- (les autres INSERTs pour courses, enrollments, grades sont trop longs ici, 
-- mais ils doivent rester dans ton fichier comme avant – copie-les depuis ta version précédente)

-- ========== LES 30 REQUÊTES ==========

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1
SELECT last_name, first_name, email, level FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';

-- Q5
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6
SELECT c.course_code, c.course_name, 
       CONCAT(p.first_name, ' ', p.last_name) AS professor_name
FROM courses c LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       d.department_name, s.level
FROM students s LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.first_name, p.last_name;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;

-- Q15
SELECT d.department_name, ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

-- Q18
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) = (SELECT COUNT(*) FROM enrollments WHERE student_id = s.student_id);

-- Q19
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       ROUND(AVG(g.grade), 2) AS student_avg,
       (SELECT ROUND(AVG(g2.grade), 2)
        FROM students s2 JOIN enrollments e2 ON s2.student_id = e2.student_id
        JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
        WHERE s2.department_id = s.department_id) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
HAVING student_avg > department_avg;

-- Q22
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM enrollments GROUP BY course_id) t
);

-- Q23
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
       d.department_name, d.budget
FROM professors p JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM students GROUP BY department_id) t
);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade_id), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q28
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
       ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1
ORDER BY c.course_name, g.evaluation_type;

-- Q29
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.first_name, p.last_name;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    ROUND(COUNT(e.enrollment_id) * 100.0 / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING COUNT(e.enrollment_id) * 100.0 / c.max_capacity > 80
ORDER BY percentage_full DESC;