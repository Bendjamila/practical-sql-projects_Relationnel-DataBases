-- TP1 : SYSTÈME DE GESTION UNIVERSITAIRE

-- On commence par nettoyer si une ancienne base existe pour repartir à neuf
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;


-- 1. CRÉATION DES TABLES (STRUCTURE)

-- Table des départements : gère les différentes facultés/filières
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- Table des professeurs : liée à un département
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
    -- Si on supprime un département, on met le champ à NULL pour ne pas supprimer le prof (SET NULL)
    -- Si l'ID du département change, on met à jour ici automatiquement (CASCADE)
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table des étudiants : contient les infos personnelles et le niveau (L1 à M2)
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
    level VARCHAR(20), -- Exemple: L3, M1
    enrollment_date DATE DEFAULT (CURRENT_DATE),-- Date d'inscription par défaut à aujourd'hui
    -- Même logique : si le département disparaît, l'étudiant reste dans la base mais sans affectation
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table des cours : chaque cours appartient à un département et un professeur
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,-- Limite de places par défaut
    -- Si le département est supprimé, le cours n'a plus lieu d'être (CASCADE)
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
	-- Si le prof part, on garde le cours mais on devra réassigner un prof plus tard (SET NULL)
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table des inscriptions :
-- Table pivot qui gère la relation "Plusieurs-à-Plusieurs" entre Étudiants et Cours
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL, 
    status VARCHAR(20), -- État : En cours, Validé, Échec
    -- Contrainte UNIQUE : Un étudiant ne peut pas s'inscrire deux fois au même cours la même année
    UNIQUE(student_id, course_id, academic_year),
    -- Si l'étudiant ou le cours est supprimé, l'inscription disparaît aussi (CASCADE)
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table des notes :
-- Détaille les résultats obtenus pour chaque inscription
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL, -- Lien direct vers l'inscription concernée
    evaluation_type VARCHAR(30),
    grade DECIMAL(5, 2), -- Note sur 20
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    -- Si l'inscription est supprimée, les notes associées le sont aussi par sécurité
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Création d'index pour accélérer les recherches fréquentes sur les clés étrangères
CREATE INDEX idx_student_dept ON students(department_id);
CREATE INDEX idx_course_prof ON courses(professor_id);
CREATE INDEX idx_enroll_student ON enrollments(student_id);


-- 2. INSERTION DES DONNÉES DE TEST

INSERT INTO departments (department_name, building, budget) VALUES
('Informatique', 'Bâtiment A', 500000.00),
('Mathématiques', 'Bâtiment B', 350000.00),
('Physique', 'Bâtiment C', 400000.00),
('Génie Civil', 'Bâtiment D', 600000.00);

INSERT INTO professors (last_name, first_name, email, department_id, salary, specialization) VALUES
('Smith', 'John', 'john@uni.com', 1, 5000.00, 'IA'),
('Brown', 'Anna', 'anna@uni.com', 1, 4800.00, 'Bases de données'),
('White', 'David', 'david@uni.com', 1, 5200.00, 'Réseaux'),
('Taylor', 'James', 'james@uni.com', 2, 4500.00, 'Algèbre'),
('Wilson', 'Emma', 'emma@uni.com', 3, 4600.00, 'Physique Quantique'),
('Martin', 'Lucas', 'lucas@uni.com', 4, 4700.00, 'Structures');

INSERT INTO students (student_number, last_name, first_name, email, department_id, level) VALUES
('S001', 'Ali', 'Ahmed', 'ali@uni.com', 1, 'L3'),
('S002', 'Ben', 'Omar', 'ben@uni.com', 1, 'L2'),
('S003', 'Sara', 'Yasmine', 'sara@uni.com', 2, 'M1'),
('S004', 'Nina', 'Lina', 'nina@uni.com', 3, 'L3'),
('S005', 'Karim', 'Said', 'karim@uni.com', 1, 'M1'),
('S006', 'Rania', 'Amel', 'rania@uni.com', 2, 'L2'),
('S007', 'Samir', 'Nabil', 'samir@uni.com', 4, 'L3'),
('S008', 'Yacine', 'Mehdi', 'yacine@uni.com', 3, 'M1');

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id) VALUES
('CS101', 'Programmation', 6, 1, 1, 1),
('CS102', 'Bases de données', 6, 2, 1, 2),
('CS103', 'Réseaux', 5, 1, 1, 3),
('MA101', 'Algèbre', 5, 1, 2, 4),
('PH101', 'Physique I', 6, 2, 3, 5),
('CE101', 'Statique', 5, 1, 4, 6),
('CS104', 'Intelligence Artificielle', 6, 2, 1, 1);

INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2024-2025', 'Passed'), (1, 2, '2024-2025', 'Passed'),
(1, 3, '2024-2025', 'In Progress'), (2, 1, '2024-2025', 'Passed'),
(2, 2, '2024-2025', 'Failed'), (3, 4, '2024-2025', 'Passed'),
(3, 5, '2024-2025', 'In Progress'), (4, 5, '2024-2025', 'Passed'),
(5, 1, '2024-2025', 'In Progress'), (5, 7, '2024-2025', 'In Progress'),
(6, 4, '2024-2025', 'Passed'), (7, 6, '2024-2025', 'In Progress'),
(8, 5, '2024-2025', 'Passed'), (3, 2, '2023-2024', 'Passed'),
(4, 3, '2023-2024', 'Failed');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient) VALUES
(1, 'Examen', 15, 2), (2, 'Examen', 14, 2), (3, 'TP', 13, 1),
(4, 'Examen', 16, 2), (5, 'Examen', 08, 2), (6, 'Examen', 17, 2),
(7, 'TP', 14, 1), (8, 'Examen', 12, 2), (9, 'TP', 15, 1),
(10, 'Examen', 18, 2), (11, 'Examen', 11, 2), (12, 'TP', 13, 1);


-- 3. RÉPONSES AUX QUESTIONS (REQUÊTES SQL)

-- Q1. Liste de tous les étudiants
SELECT last_name, first_name, email, level FROM students;

-- Q2. Professeurs en Informatique
SELECT p.last_name, p.first_name, p.email, p.specialization 
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Informatique';

-- Q3. Cours avec plus de 5 crédits
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4. Étudiants en L3
SELECT student_number, last_name, first_name FROM students WHERE level = 'L3';

-- Q5. Cours du semestre 1
SELECT course_name, credits, semester FROM courses WHERE semester = 1;

-- Q6. Cours avec le nom de leur professeur respectif
SELECT c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS prof_nom
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. Inscriptions avec noms des étudiants et des cours
SELECT CONCAT(s.last_name, ' ', s.first_name) AS etudiant, c.course_name, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Étudiants et leur département
SELECT CONCAT(s.last_name, ' ', s.first_name) AS etudiant, d.department_name
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Q9. Notes détaillées par étudiant et par cours
SELECT s.last_name, c.course_name, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Nombre de cours enseignés par chaque professeur
SELECT p.last_name, COUNT(c.course_id) AS nb_cours
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11. Moyenne générale de chaque étudiant
SELECT s.last_name, AVG(g.grade) AS moyenne
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12. Nombre d'étudiants par département
SELECT d.department_name, COUNT(s.student_id) AS total_etudiants
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13. Budget total cumulé de l'université
SELECT SUM(budget) AS budget_total FROM departments;

-- Q14. Nombre de cours proposés par département
SELECT d.department_name, COUNT(c.course_id) AS nb_cours
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15. Salaire moyen des professeurs par département
SELECT d.department_name, AVG(p.salary) AS salaire_moyen
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16. Top 3 des meilleurs étudiants (moyenne la plus haute)
SELECT s.last_name, AVG(g.grade) AS moy
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id ORDER BY moy DESC LIMIT 3;

-- Q17. Cours qui n'ont actuellement aucune inscription
SELECT course_name FROM courses 
WHERE course_id NOT IN (SELECT course_id FROM enrollments);

-- Q18. Nombre de cours validés par étudiant
SELECT s.last_name, COUNT(*) AS nb_valide
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
WHERE e.status = 'Passed' GROUP BY s.student_id;

-- Q19. Professeurs chargés (plus de 2 cours)
SELECT p.last_name, COUNT(c.course_id) AS nb
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id HAVING nb > 2;

-- Q20. Étudiants inscrits à plus de 2 cours
SELECT s.last_name, COUNT(e.course_id) AS nb
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id HAVING nb > 2;

-- Q21. Étudiants plus performants que la moyenne de leur département
SELECT s.last_name, AVG(g.grade) AS moy_etudiant
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id
HAVING moy_etudiant > (
    SELECT AVG(g2.grade) FROM grades g2 
    JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
    JOIN students s2 ON e2.student_id = s2.student_id
    WHERE s2.department_id = s.department_id
);

-- Q22. Cours plus populaires que la moyenne
SELECT c.course_name, COUNT(e.enrollment_id) AS nb_inscrits
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING nb_inscrits > (SELECT COUNT(*) / COUNT(DISTINCT course_id) FROM enrollments);

-- Q23. Profs travaillant dans le département le plus riche
SELECT p.last_name, d.department_name FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Étudiants n'ayant aucune note saisie
SELECT s.last_name, s.email FROM students s
WHERE s.student_id NOT IN (
    SELECT e.student_id FROM enrollments e 
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25. Départements plus grands (en nb étudiants) que la moyenne
SELECT d.department_name, COUNT(s.student_id) AS nb
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING nb > (SELECT COUNT(*) / COUNT(DISTINCT department_id) FROM students);
-- la moyenne est le nombre d'étudiants / nombre de departments 

-- Q26. Taux de réussite par cours (Note >= 10)
SELECT c.course_name, (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade)) AS taux_reussite
-- cette formulle mathematique calculle le pourcentage de reussite 
-- CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END ; si la note est >= 10 ca sera 1 si non 0 la somme nous donne le nombre d'etudiant qui on reussie
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27. Classement des étudiants par moyenne générale
-- RANK()  ; permet de fair un classement cellon un liste donner OVER (ORDER BY AVG(g.grade) DESC) 
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rang,
       CONCAT(s.last_name, ' ', s.first_name) AS nom,
       AVG(g.grade) AS moyenne
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q28. Relevé de notes pour l'étudiant ID 1
SELECT c.course_name, g.evaluation_type, g.grade, (g.grade * g.coefficient) AS note_ponderee
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29. Charge de travail (total crédits) par prof
SELECT p.last_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30. État de remplissage des cours (pourcentage par rapport à la capacité max)
SELECT c.course_name, (COUNT(e.student_id) * 100.0 / c.max_capacity) AS remplissage_pct -- pourcentage de remplissage
-- le nombre d'etudiant par enrollments * 100 pour avoir un pourcentage le tous sur la capacité du cours 
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;