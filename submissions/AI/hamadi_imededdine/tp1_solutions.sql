-- ============================================
-- TP1: University Management System Solutions
-- ============================================

CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;


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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) 
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE (student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
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
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Required Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4. INSERT statements for test data (Using North African Names)

-- Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Informatique', 'Bloc A - Alger', 500000.00, 'Dr. Ahmed Zewail', '2010-09-01'),
('Mathématiques', 'Bloc B - Tunis', 350000.00, 'Dr. Cedric Villani', '2010-09-01'),
('Physique', 'Bloc C - Casablanca', 400000.00, 'Dr. Rachid Yazami', '2011-01-15'),
('Génie Civil', 'Bloc D - Oran', 600000.00, 'Dr. Kamal Youcef-Toumi', '2012-03-20');

-- Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Brahimi', 'Yacine', 'yacine.brahimi@univ.dz', '0550112233', 1, '2015-08-20', 75000.00, 'Intelligence Artificielle'),
('Mansouri', 'Sami', 'sami.mansouri@univ.tn', '0216223344', 1, '2016-01-10', 72000.00, 'Data Science'),
('Alami', 'Mehdi', 'mehdi.alami@univ.ma', '0661334455', 1, '2017-03-15', 70000.00, 'Cybersécurité'),
('Hadj', 'Fatima', 'fatima.hadj@univ.dz', '0550445566', 2, '2014-09-01', 68000.00, 'Mathématiques Pures'),
('Benali', 'Sara', 'sara.benali@univ.tn', '0216556677', 3, '2018-02-12', 71000.00, 'Physique Quantique'),
('Cherif', 'Mohamed', 'mohamed.cherif@univ.ma', '0661667788', 4, '2019-05-30', 74000.00, 'Génie des Structures');

-- Students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('STU001', 'Gherbi', 'Anis', '2003-05-15', 'anis.gherbi@student.dz', '0550778899', 'Rue Didouche Mourad, Alger', 1, 'L3', '2022-09-01'),
('STU002', 'Jebbar', 'Meriem', '2004-02-20', 'meriem.jebbar@student.tn', '0216889900', 'Avenue Habib Bourguiba, Tunis', 1, 'L2', '2023-09-01'),
('STU003', 'Idris', 'Omar', '2002-11-10', 'omar.idris@student.ma', '0661990011', 'Quartier Maârif, Casablanca', 2, 'M1', '2021-09-01'),
('STU004', 'Kaci', 'Rachid', '2003-08-05', 'rachid.kaci@student.dz', '0550110022', 'Cité 500 logements, Oran', 3, 'L3', '2022-09-01'),
('STU005', 'Lalami', 'Zineb', '2001-12-25', 'zineb.lalami@student.tn', '0216221133', 'Sousse, Tunisie', 4, 'M2', '2020-09-01'),
('STU006', 'Nait', 'Khadidja', '2004-06-12', 'khadidja.nait@student.ma', '0661332244', 'Rabat, Maroc', 1, 'L2', '2023-09-01'),
('STU007', 'Dahmani', 'Amel', '2003-01-30', 'amel.dahmani@student.dz', '0550443355', 'Constantine, Algérie', 2, 'L3', '2022-09-01'),
('STU008', 'Ezzine', 'Karim', '2002-04-18', 'karim.ezzine@student.tn', '0216554466', 'Sfax, Tunisie', 3, 'M1', '2021-09-01');

-- Courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('INF101', 'Intro à la Programmation', 'Bases de Python', 6, 1, 1, 1, 50),
('INF202', 'Systèmes de Bases de Données', 'SQL et Algèbre Relationnelle', 5, 2, 1, 2, 40),
('MAT101', 'Analyse I', 'Limites et Dérivées', 6, 1, 2, 4, 60),
('PHY101', 'Physique Générale', 'Mécanique et Chaleur', 5, 1, 3, 5, 45),
('GC101', 'Analyse des Structures', 'Statique et Dynamique', 6, 1, 4, 6, 30),
('INF303', 'Machine Learning', 'Introduction aux algorithmes ML', 6, 1, 1, 1, 25),
('MAT202', 'Algèbre Linéaire', 'Matrices et Vecteurs', 5, 2, 2, 4, 50);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2024-2025', 'Passed'),
(1, 2, '2024-2025', 'In Progress'),
(2, 1, '2024-2025', 'Passed'),
(3, 3, '2024-2025', 'In Progress'),
(4, 4, '2024-2025', 'Passed'),
(5, 5, '2024-2025', 'In Progress'),
(6, 1, '2024-2025', 'Failed'),
(7, 3, '2024-2025', 'Passed'),
(8, 4, '2024-2025', 'In Progress'),
(1, 6, '2024-2025', 'In Progress'),
(2, 2, '2024-2025', 'In Progress'),
(3, 7, '2024-2025', 'Passed'),
(7, 7, '2024-2025', 'In Progress'),
(4, 1, '2023-2024', 'Passed'),
(8, 1, '2023-2024', 'Passed');

-- Grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 15.50, 1.00, '2024-12-15', 'Bonne performance'),
(3, 'Exam', 12.00, 1.00, '2024-12-15', 'Satisfaisant'),
(5, 'Exam', 14.00, 1.00, '2024-12-16', 'Bien fait'),
(7, 'Exam', 08.00, 1.00, '2024-12-15', 'Doit s''améliorer'),
(8, 'Exam', 16.00, 1.00, '2024-12-17', 'Excellent'),
(12, 'Exam', 13.50, 1.00, '2024-12-18', 'Bien'),
(14, 'Exam', 11.00, 1.00, '2023-12-15', 'Réussi'),
(15, 'Exam', 17.00, 1.00, '2023-12-15', 'Exceptionnel'),
(1, 'Assignment', 14.00, 0.50, '2024-11-10', 'Bon travail'),
(3, 'Assignment', 13.00, 0.50, '2024-11-10', 'Constant'),
(5, 'Assignment', 15.00, 0.50, '2024-11-11', 'Très bien'),
(12, 'Assignment', 12.50, 0.50, '2024-11-12', 'Correct');

-- 5. 30 SQL Queries

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
SELECT last_name, first_name, email, level FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.department_name = 'Informatique';

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
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade 
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
SELECT d.department_name, AVG(p.salary) AS average_salary 
FROM departments d 
JOIN professors p ON d.department_id = p.department_id 
GROUP BY d.department_id;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade 
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
WHERE e.status = 'Passed' 
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
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       AVG(g.grade) AS student_avg,
       (SELECT AVG(g2.grade) 
        FROM grades g2 
        JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id 
        JOIN students s2 ON e2.student_id = s2.student_id 
        WHERE s2.department_id = s.department_id) AS department_avg
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id 
HAVING student_avg > department_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count 
FROM courses c 
JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id 
HAVING enrollment_count > (SELECT COUNT(*) / COUNT(DISTINCT course_id) FROM enrollments);

-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, d.department_name, d.budget 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
SELECT CONCAT(last_name, ' ', first_name) AS student_name, email 
FROM students 
WHERE student_id NOT IN (SELECT DISTINCT e.student_id FROM enrollments e JOIN grades g ON e.enrollment_id = g.enrollment_id);

-- Q25. List departments with more students than the average
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id 
HAVING student_count > (SELECT COUNT(*) / COUNT(DISTINCT department_id) FROM students);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT c.course_name, 
       COUNT(g.grade_id) AS total_grades, 
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100 AS pass_rate_percentage 
FROM courses c 
JOIN enrollments e ON c.course_id = e.course_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY c.course_id;

-- Q27. Display student ranking by descending average
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`, 
       CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       AVG(g.grade) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id;

-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, (g.grade * g.coefficient) AS weighted_grade 
FROM grades g 
JOIN enrollments e ON g.enrollment_id = e.enrollment_id 
JOIN courses c ON e.course_id = c.course_id 
WHERE e.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, SUM(c.credits) AS total_credits 
FROM professors p 
JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity, 
       (COUNT(e.enrollment_id) / c.max_capacity) * 100 AS percentage_full 
FROM courses c 
LEFT JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id 
HAVING percentage_full > 80;
