
-- TP1: Système de Gestion Universitaire


-- 1. Création de la base de données
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- 2. Création des tables

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
    CONSTRAINT fk_prof_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
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
    CONSTRAINT fk_stud_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
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
    CONSTRAINT fk_course_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_prof FOREIGN KEY (professor_id) 
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    CONSTRAINT fk_enroll_stud FOREIGN KEY (student_id) 
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) 
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_student_course_year UNIQUE (student_id, course_id, academic_year)
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
    CONSTRAINT fk_grade_enroll FOREIGN KEY (enrollment_id) 
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 3. Création des index
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4. Insertion des données de test

-- Départements
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Informatique', 'Bloc A', 500000.00, 'Pr. Belkacem Ahmed', '2010-09-01'),
('Mathématiques', 'Bloc B', 350000.00, 'Pr. Mansouri Fatima', '2010-09-01'),
('Physique', 'Bloc C', 400000.00, 'Pr. Haddad Omar', '2011-01-15'),
('Génie Civil', 'Bloc D', 600000.00, 'Pr. Saidi Meriem', '2012-05-20');

-- Professeurs
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Benali', 'Kamel', 'k.benali@univ-alger.dz', '0550112233', 1, '2015-08-20', 75000.00, 'Intelligence Artificielle'),
('Ziri', 'Lina', 'l.ziri@univ-alger.dz', '0550445566', 1, '2016-01-10', 72000.00, 'Science des Données'),
('Kacimi', 'Yacine', 'y.kacimi@univ-alger.dz', '0550778899', 1, '2018-03-15', 68000.00, 'Cybersécurité'),
('Brahimi', 'Mohamed', 'm.brahimi@univ-alger.dz', '0550110022', 2, '2014-09-01', 80000.00, 'Mathématiques Pures'),
('Ouali', 'Karim', 'k.ouali@univ-alger.dz', '0550334455', 3, '2017-02-28', 74000.00, 'Physique Quantique'),
('Hamidi', 'Fatima', 'f.hamidi@univ-alger.dz', '0550667788', 4, '2019-11-12', 71000.00, 'Génie Parasismique');

-- Étudiants
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('20223101', 'Lamine', 'Sara', '2003-05-14', 's.lamine@etud.univ.dz', '0661112233', '12 Rue des Pins, Alger', 1, 'L3', '2022-09-01'),
('20233102', 'Bouzid', 'Rachid', '2004-11-22', 'r.bouzid@etud.univ.dz', '0661445566', '45 Cité El Hayat, Oran', 1, 'L2', '2023-09-01'),
('20213103', 'Taleb', 'Amel', '2002-02-10', 'a.taleb@etud.univ.dz', '0661778899', '5 Bis Avenue de la Gare, Constantine', 2, 'M1', '2021-09-01'),
('20223104', 'Derradji', 'Ines', '2003-08-30', 'i.derradji@etud.univ.dz', '0661001122', 'Lotissement 54, Annaba', 3, 'L3', '2022-09-01'),
('20243105', 'Mekhloufi', 'Anis', '2005-01-05', 'a.mekhloufi@etud.univ.dz', '0661334455', 'Rue de la Liberté, Béjaïa', 4, 'L1', '2024-09-01'),
('20203106', 'Selmi', 'Ryma', '2001-12-15', 'r.selmi@etud.univ.dz', '0661667788', 'Cité 200 Logements, Sétif', 1, 'M2', '2020-09-01'),
('20233107', 'Abbas', 'Yousra', '2004-04-18', 'y.abbas@etud.univ.dz', '0661990011', 'Quartier Administratif, Tlemcen', 2, 'L2', '2023-09-01'),
('20223108', 'Gherbi', 'Sami', '2003-07-25', 's.gherbi@etud.univ.dz', '0661223344', 'Résidence les Fleurs, Blida', 3, 'L3', '2022-09-01');

-- Cours
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('INF101', 'Intro à la Programmation', 'Concepts de base en C/C++', 6, 1, 1, 1, 50),
('INF202', 'Systèmes de BDD', 'Conception relationnelle et SQL', 5, 2, 1, 2, 40),
('MAT101', 'Analyse I', 'Calcul différentiel et intégral', 6, 1, 2, 4, 60),
('PHY101', 'Physique Générale', 'Mécanique et thermodynamique', 6, 1, 3, 5, 45),
('GVC101', 'Statique', 'Analyse des forces sur les structures', 5, 1, 4, 6, 30),
('INF303', 'Machine Learning', 'Introduction aux algorithmes de ML', 6, 2, 1, 1, 25),
('MAT202', 'Algèbre Linéaire', 'Espaces vectoriels et matrices', 5, 2, 2, 4, 50);

-- Inscriptions
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2024-2025', 'Passed'),
(1, 2, '2024-2025', 'In Progress'),
(2, 1, '2024-2025', 'In Progress'),
(3, 3, '2023-2024', 'Passed'),
(3, 7, '2023-2024', 'Passed'),
(4, 4, '2024-2025', 'In Progress'),
(5, 5, '2024-2025', 'In Progress'),
(6, 6, '2023-2024', 'Passed'),
(7, 3, '2024-2025', 'In Progress'),
(8, 4, '2024-2025', 'Failed'),
(1, 6, '2024-2025', 'In Progress'),
(2, 2, '2024-2025', 'In Progress'),
(3, 1, '2022-2023', 'Passed'),
(4, 3, '2023-2024', 'Passed'),
(6, 1, '2021-2022', 'Passed');

-- Notes
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 15.50, 1.00, '2024-12-15', 'Excellent travail'),
(4, 'Assignment', 14.00, 0.50, '2023-11-20', 'Bon effort'),
(4, 'Exam', 16.00, 1.00, '2024-01-10', 'Très bonne performance'),
(5, 'Project', 17.50, 1.00, '2024-01-15', 'Solution innovante'),
(8, 'Exam', 18.00, 1.00, '2024-01-12', 'Note parfaite'),
(13, 'Exam', 12.00, 1.00, '2023-01-20', 'Satisfaisant'),
(14, 'Lab', 13.50, 0.50, '2023-11-05', 'Résultats précis'),
(14, 'Exam', 15.00, 1.00, '2024-01-10', 'Bien préparé'),
(15, 'Exam', 14.50, 1.00, '2022-01-15', 'Constant'),
(10, 'Exam', 08.00, 1.00, '2025-01-15', 'Échec aux exigences'),
(1, 'Lab', 16.00, 0.50, '2024-11-10', 'Très bon compte rendu'),
(5, 'Lab', 15.00, 0.50, '2023-12-01', 'Bonne compréhension');

-- 5. Requêtes SQL

-- Q1. Liste des étudiants (Nom, Email, Niveau)
SELECT last_name, first_name, email, level 
FROM students;

-- Q2. Professeurs du département Informatique
SELECT p.last_name, p.first_name, p.email, p.specialization 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.department_name = 'Informatique';

-- Q3. Cours avec plus de 5 crédits
SELECT course_code, course_name, credits 
FROM courses 
WHERE credits > 5;

-- Q4. Étudiants de niveau L3
SELECT student_number, last_name, first_name, email 
FROM students 
WHERE level = 'L3';

-- Q5. Cours du semestre 1
SELECT course_code, course_name, credits, semester 
FROM courses 
WHERE semester = 1;

-- Q6. Cours avec le nom du professeur
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name 
FROM courses c 
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. Inscriptions avec nom étudiant et nom cours
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, e.enrollment_date, e.status 
FROM enrollments e 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Étudiants avec leur département
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, d.department_name, s.level 
FROM students s 
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9. Notes avec étudiant, cours et valeur
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, g.evaluation_type, g.grade 
FROM grades g 
JOIN enrollments e ON g.enrollment_id = e.enrollment_id 
JOIN students s ON e.student_id = s.student_id 
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Nombre de cours par professeur
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS number_of_courses 
FROM professors p 
LEFT JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id;

-- Q11. Moyenne générale par étudiant
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, ROUND(AVG(g.grade), 2) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id;

-- Q12. Nombre d'étudiants par département
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
LEFT JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id;

-- Q13. Budget total de tous les départements
SELECT SUM(budget) AS total_budget 
FROM departments;

-- Q14. Nombre total de cours par département
SELECT d.department_name, COUNT(c.course_id) AS course_count 
FROM departments d 
LEFT JOIN courses c ON d.department_id = c.department_id 
GROUP BY d.department_id;

-- Q15. Salaire moyen des professeurs par département
SELECT d.department_name, ROUND(AVG(p.salary), 2) AS average_salary 
FROM departments d 
JOIN professors p ON d.department_id = p.department_id 
GROUP BY d.department_id;

-- Q16. Top 3 des meilleurs étudiants par moyenne
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, ROUND(AVG(g.grade), 2) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id 
ORDER BY average_grade DESC 
LIMIT 3;

-- Q17. Cours sans aucune inscription
SELECT course_code, course_name 
FROM courses 
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM enrollments);

-- Q18. Étudiants ayant réussi tous leurs cours (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS passed_courses_count 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
GROUP BY s.student_id 
HAVING SUM(CASE WHEN e.status = 'Passed' THEN 1 ELSE 0 END) = COUNT(e.enrollment_id);

-- Q19. Professeurs enseignant plus de 2 cours
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught 
FROM professors p 
JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id 
HAVING COUNT(c.course_id) > 2;

-- Q20. Étudiants inscrits à plus de 2 cours
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
GROUP BY s.student_id 
HAVING COUNT(e.enrollment_id) > 2;

-- Q21. Étudiants avec moyenne supérieure à celle de leur département
WITH StudentAvg AS (
    SELECT s.student_id, s.department_id, CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) as avg_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.department_id
),
DeptAvg AS (
    SELECT department_id, AVG(grade) as dept_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY department_id
)
SELECT sa.student_name, ROUND(sa.avg_grade, 2) as student_avg, ROUND(da.dept_avg, 2) as department_avg
FROM StudentAvg sa
JOIN DeptAvg da ON sa.department_id = da.department_id
WHERE sa.avg_grade > da.dept_avg;

-- Q22. Cours avec plus d'inscriptions que la moyenne
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count 
FROM courses c 
JOIN enrollments e ON c.course_id = e.course_id 
GROUP BY c.course_id 
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(cnt) FROM (SELECT COUNT(enrollment_id) as cnt FROM enrollments GROUP BY course_id) as sub
);

-- Q23. Professeurs du département avec le plus gros budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, d.department_name, d.budget 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id 
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Étudiants sans aucune note enregistrée
SELECT CONCAT(last_name, ' ', first_name) AS student_name, email 
FROM students 
WHERE student_id NOT IN (
    SELECT DISTINCT e.student_id 
    FROM enrollments e 
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25. Départements avec plus d'étudiants que la moyenne
SELECT d.department_name, COUNT(s.student_id) AS student_count 
FROM departments d 
JOIN students s ON d.department_id = s.department_id 
GROUP BY d.department_id 
HAVING COUNT(s.student_id) > (
    SELECT AVG(cnt) FROM (SELECT COUNT(student_id) as cnt FROM students GROUP BY department_id) as sub
);

-- Q26. Taux de réussite par cours (notes >= 10/20)
SELECT c.course_name, 
       COUNT(g.grade_id) AS total_grades, 
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade_id), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27. Classement des étudiants par moyenne décroissante
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) as `rank`, 
       CONCAT(s.last_name, ' ', s.first_name) AS student_name, 
       ROUND(AVG(g.grade), 2) AS average_grade 
FROM students s 
JOIN enrollments e ON s.student_id = e.student_id 
JOIN grades g ON e.enrollment_id = g.enrollment_id 
GROUP BY s.student_id;

-- Q28. Relevé de notes pour l'étudiant ID = 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, 
       (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29. Charge horaire par professeur (total crédits)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, SUM(c.credits) AS total_credits 
FROM professors p 
JOIN courses c ON p.professor_id = c.professor_id 
GROUP BY p.professor_id;

-- Q30. Cours surchargés (> 80% capacité)
SELECT c.course_name, 
       COUNT(e.enrollment_id) AS current_enrollments, 
       c.max_capacity, 
       ROUND(COUNT(e.enrollment_id) * 100.0 / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING (COUNT(e.enrollment_id) * 100.0 / c.max_capacity) > 80;
