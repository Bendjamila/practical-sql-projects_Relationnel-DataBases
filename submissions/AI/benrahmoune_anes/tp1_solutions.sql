-- TP1: Gestion de l'Universite
-- by: BENRAHMOUNE Anes

-- Creation de la base de donnees
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- Creation des tables

-- 1. Table Departements
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- 2. Table Professeurs
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
    CONSTRAINT fk_prof_dept FOREIGN KEY (department_id) REFERENCES departments(department_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 3. Table Etudiants
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
    level VARCHAR(20),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT chk_level CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    CONSTRAINT fk_stud_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 4. Table Cours
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    CONSTRAINT chk_credits CHECK (credits > 0),
    CONSTRAINT chk_semester CHECK (semester BETWEEN 1 AND 2),
    CONSTRAINT fk_course_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_course_prof FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 5. Table Inscriptions
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT chk_status CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    CONSTRAINT fk_enrol_stud FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enrol_course FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_id, academic_year)
);

-- 6. Table Notes
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5, 2),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT chk_eval_type CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    CONSTRAINT chk_grade_val CHECK (grade BETWEEN 0 AND 20),
    CONSTRAINT fk_grade_enrol FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexation
CREATE INDEX idx_stud_dept ON students(department_id);
CREATE INDEX idx_crs_prof ON courses(professor_id);
CREATE INDEX idx_enr_stud ON enrollments(student_id);
CREATE INDEX idx_enr_crs ON enrollments(course_id);
CREATE INDEX idx_grd_enr ON grades(enrollment_id);

-- Insertion des donnees (Contexte Algerien)

-- Departements (USTHB)
INSERT INTO departments VALUES (NULL, 'Informatique', 'Bloc A', 500000.00, 'Dr. Mansouri', '1974-09-15');
INSERT INTO departments VALUES (NULL, 'Mathematiques', 'Bloc B', 350000.00, 'Pr. Belhadj', '1974-09-15');
INSERT INTO departments VALUES (NULL, 'Physique', 'Bloc C', 400000.00, 'Dr. Haddad', '1975-10-01');
INSERT INTO departments VALUES (NULL, 'Genie Civil', 'Bloc D', 600000.00, 'Pr. Benali', '1980-01-20');

-- Professeurs
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Brahimi', 'Abdelkader', 'a.brahimi@usthb.dz', '0550123456', 1, '2010-01-15', 95000.00, 'IA'),
('Zitouni', 'Meriem', 'm.zitouni@usthb.dz', '0661987654', 1, '2015-09-01', 82000.00, 'BDD'),
('Kaci', 'Lamine', 'l.kaci@usthb.dz', '0772345678', 1, '2018-02-10', 75000.00, 'Reseaux'),
('Hamidi', 'Saliha', 's.hamidi@usthb.dz', '0555112233', 2, '2005-11-20', 110000.00, 'Analyse'),
('Bouaziz', 'Redouane', 'r.bouaziz@usthb.dz', '0664556677', 3, '2012-03-15', 88000.00, 'Physique Quantique'),
('Saidi', 'Omar', 'o.saidi@usthb.dz', '0770889900', 4, '2008-06-30', 105000.00, 'Beton');

-- Etudiants
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level) VALUES
('24243101', 'Belkacem', 'Anis', '2003-05-12', 'anis.b@etu.usthb.dz', '0551001122', 'Bab Ezzouar, Alger', 1, 'L3'),
('24243102', 'Messaoudi', 'Lina', '2004-11-25', 'lina.m@etu.usthb.dz', '0662003344', 'Alger Centre', 1, 'L2'),
('24243103', 'Gherbi', 'Samy', '2002-02-14', 'samy.g@etu.usthb.dz', '0773005566', 'Draria, Alger', 2, 'M1'),
('24243104', 'Ouali', 'Feriel', '2003-08-30', 'feriel.o@etu.usthb.dz', '0554007788', 'Boumerdes', 3, 'L3'),
('24243105', 'Dahmani', 'Riad', '2001-12-05', 'riad.d@etu.usthb.dz', '0665009900', 'Oran', 4, 'M2'),
('24243106', 'Taleb', 'Imane', '2004-04-18', 'imane.t@etu.usthb.dz', '0776001122', 'Skikda', 1, 'L2'),
('24243107', 'Bensemra', 'Youcef', '2002-07-22', 'youcef.b@etu.usthb.dz', '0557003344', 'Bejaia', 2, 'L3'),
('24243108', 'Amrani', 'Sara', '2003-01-10', 'sara.a@etu.usthb.dz', '0668005566', 'Constantine', 1, 'L3');

-- Cours
INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id) VALUES
('INF301', 'Bases de Donnees', 6, 1, 1, 2),
('INF302', 'Systemes Exploitation', 5, 1, 1, 3),
('MAT301', 'Algebre', 6, 1, 2, 4),
('PHY301', 'Thermodynamique', 5, 2, 3, 5),
('CIV301', 'RDM', 6, 1, 4, 6),
('INF303', 'IA', 6, 2, 1, 1),
('INF304', 'Web', 4, 2, 1, 2);

-- Inscriptions
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2024-2025', 'In Progress'),
(1, 2, '2024-2025', 'In Progress'),
(1, 6, '2024-2025', 'In Progress'),
(2, 1, '2024-2025', 'In Progress'),
(2, 7, '2024-2025', 'In Progress'),
(3, 3, '2024-2025', 'In Progress'),
(4, 4, '2024-2025', 'In Progress'),
(5, 5, '2024-2025', 'In Progress'),
(6, 2, '2024-2025', 'In Progress'),
(7, 3, '2024-2025', 'In Progress'),
(8, 1, '2024-2025', 'In Progress'),
(8, 6, '2024-2025', 'In Progress'),
(1, 1, '2023-2024', 'Passed'),
(3, 3, '2023-2024', 'Passed'),
(5, 5, '2023-2024', 'Passed');

-- Notes
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date) VALUES
(13, 'Exam', 14.50, 2.00, '2024-01-20'),
(13, 'Assignment', 16.00, 1.00, '2023-11-15'),
(14, 'Exam', 12.00, 2.00, '2024-01-22'),
(14, 'Lab', 15.00, 1.00, '2023-12-10'),
(15, 'Exam', 11.50, 2.00, '2024-01-25'),
(1, 'Assignment', 17.00, 1.00, '2024-11-05'),
(2, 'Assignment', 13.00, 1.00, '2024-11-10'),
(3, 'Assignment', 15.50, 1.00, '2025-02-01'),
(4, 'Assignment', 14.00, 1.00, '2024-11-12'),
(6, 'Assignment', 12.50, 1.00, '2024-11-15'),
(8, 'Assignment', 18.00, 1.00, '2024-11-20'),
(11, 'Assignment', 10.00, 1.00, '2024-11-22');

-- Solutions des requetes

-- Q1
SELECT last_name, first_name, email, level FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization 
FROM professors p, departments d 
WHERE p.department_id = d.department_id AND d.department_name = 'Informatique';

-- Q3
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';

-- Q5
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;

-- Q6
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS prof 
FROM courses c LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, c.course_name, e.enrollment_date, e.status 
FROM enrollments e, students s, courses c 
WHERE e.student_id = s.student_id AND e.course_id = c.course_id;

-- Q8
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, d.department_name, s.level 
FROM students s LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, c.course_name, g.evaluation_type, g.grade 
FROM grades g, enrollments e, students s, courses c 
WHERE g.enrollment_id = e.enrollment_id AND e.student_id = s.student_id AND e.course_id = c.course_id;

-- Q10
SELECT CONCAT(p.last_name, ' ', p.first_name) AS prof, COUNT(c.course_id) AS nb_cours 
FROM professors p LEFT JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id;

-- Q11
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, ROUND(AVG(g.grade), 2) AS moyenne 
FROM students s, enrollments e, grades g 
WHERE s.student_id = e.student_id AND e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id;

-- Q12
SELECT d.department_name, COUNT(s.student_id) AS nb_etudiants 
FROM departments d LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id;

-- Q13
SELECT SUM(budget) AS budget_total FROM departments;

-- Q14
SELECT d.department_name, COUNT(c.course_id) AS nb_cours 
FROM departments d LEFT JOIN courses c ON d.department_id = c.department_id 
GROUP BY d.department_id;

-- Q15
SELECT d.department_name, AVG(p.salary) AS salaire_moyen 
FROM departments d, professors p 
WHERE d.department_id = p.department_id 
GROUP BY d.department_id;

-- Q16
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, AVG(g.grade) AS moy 
FROM students s, enrollments e, grades g 
WHERE s.student_id = e.student_id AND e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id ORDER BY moy DESC LIMIT 3;

-- Q17
SELECT course_code, course_name FROM courses 
WHERE course_id NOT IN (SELECT course_id FROM enrollments);

-- Q18
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, COUNT(e.enrollment_id) AS nb 
FROM students s, enrollments e 
WHERE s.student_id = e.student_id AND e.status = 'Passed' 
GROUP BY s.student_id;

-- Q19
SELECT CONCAT(p.last_name, ' ', p.first_name) AS prof, COUNT(c.course_id) AS nb 
FROM professors p, courses c 
WHERE p.professor_id = c.professor_id 
GROUP BY p.professor_id HAVING nb > 2;

-- Q20
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, COUNT(e.enrollment_id) AS nb 
FROM students s, enrollments e 
WHERE s.student_id = e.student_id 
GROUP BY s.student_id HAVING nb > 2;

-- Q21
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, AVG(g.grade) AS moy 
FROM students s, enrollments e, grades g 
WHERE s.student_id = e.student_id AND e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id, s.department_id 
HAVING moy > (SELECT AVG(g2.grade) FROM grades g2, enrollments e2, students s2 
              WHERE g2.enrollment_id = e2.enrollment_id AND e2.student_id = s2.student_id 
              AND s2.department_id = s.department_id);

-- Q22
SELECT c.course_name, COUNT(e.enrollment_id) AS nb 
FROM courses c, enrollments e 
WHERE c.course_id = e.course_id 
GROUP BY c.course_id 
HAVING nb > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM enrollments GROUP BY course_id) t);

-- Q23
SELECT CONCAT(p.last_name, ' ', p.first_name) AS prof, d.department_name 
FROM professors p, departments d 
WHERE p.department_id = d.department_id AND d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT CONCAT(last_name, ' ', first_name) AS student, email 
FROM students 
WHERE student_id NOT IN (SELECT DISTINCT e.student_id FROM enrollments e, grades g WHERE e.enrollment_id = g.enrollment_id);

-- Q25
SELECT d.department_name, COUNT(s.student_id) AS nb 
FROM departments d LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id 
HAVING nb > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM students GROUP BY department_id) t);

-- Q26
SELECT c.course_name, 
       COUNT(g.grade_id) AS total, 
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS admis,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100 AS taux
FROM courses c, enrollments e, grades g
WHERE c.course_id = e.course_id AND e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student, AVG(g.grade) AS moy 
FROM students s, enrollments e, grades g 
WHERE s.student_id = e.student_id AND e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id ORDER BY moy DESC;

-- Q28
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient 
FROM grades g, enrollments e, courses c 
WHERE g.enrollment_id = e.enrollment_id AND e.course_id = c.course_id AND e.student_id = 1;

-- Q29
SELECT CONCAT(p.last_name, ' ', p.first_name) AS prof, SUM(c.credits) AS total_credits 
FROM professors p, courses c 
WHERE p.professor_id = c.professor_id 
GROUP BY p.professor_id;

-- Q30
SELECT c.course_name, COUNT(e.enrollment_id) AS inscrits, c.max_capacity 
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id 
HAVING (inscrits / c.max_capacity) > 0.8;
