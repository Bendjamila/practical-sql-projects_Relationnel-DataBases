CREATE DATABASE universite_db;
use universite_db;

CREATE TABLE departments (
department_id INT AUTO_INCREMENT PRIMARY KEY,
department_name VARCHAR(100) NOT NULL,
building VARCHAR(50),
budget DECIMAL(12,2),
department_head VARCHAR(100),
creation_date DATE
);

CREATE TABLE professors (
    professor_id INT  AUTO_INCREMENT PRIMARY KEY,
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



CREATE TABLE students (
    student_id INT  AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20) CHECK(level IN('L1','L2','L3','M1','M2')),
    enrollment_date DATE,
    FOREIGN KEY(department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE

);

CREATE TABLE COURSES (
course_id INT AUTO_INCREMENT PRIMARY KEY,
course_code VARCHAR(10) UNIQUE NOT NULL,
course_name VARCHAR(150) NOT NULL,
description TEXT ,
cridits INT NOT NULL,
semaster INT,
department_id INT,
profissor_id INT ,
max_capacity INT DEFAULT 30 ,
FOREIGN KEY (department_id)
REFERENCES departments(department_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (professor_id)
REFERENCES professors(professor_id)
ON DELETE SET NULL
ON UPDATE CASCADE

);

CREATE TABLE enrollments (
enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT NOT NULL,
course_id INT NOT NULL,
enrollment_date DATE DEFAULT CURRENT_DATE,
academic_year VARCHAR(9) NOT NULL,
status VARCHAR(20) DEFAULT 'In Progress',
UNIQUE(student_id,course_id,academic_year),
FOREIGN KEY (student_id)
REFERENCES students(student_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
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
FOREIGN KEY (enrollment_id)
REFERENCES enrollments(enrollment_id)
ON DELETE CASCADE
ON UPDATE CASCADE
);
/*         */

INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES
('Informatique', 'Bâtiment A', 500000, 'Karim Bensalem', '2000-09-01'),
('Mathématiques', 'Bâtiment B', 350000, 'Yasmine Cherif', '1998-06-15'),
('Physique', 'Bâtiment C', 400000, 'Rachid Amrani', '2002-03-20'),
('Génie Civil', 'Bâtiment D', 600000, 'Leila Boukhalfa', '1995-11-12');

-----------------------------------------------------------
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES
('Boudjemaa', 'Sofiane', 'sofiane.boudjemaa@univ.dz', '0555-1010', 1, '2010-08-15', 75000, 'Intelligence Artificielle'),
('Khelifa', 'Amira', 'amira.khelifa@univ.dz', '0555-1020', 1, '2012-02-10', 72000, 'Développement Logiciel'),
('Belkacem', 'Omar', 'omar.belkacem@univ.dz', '0555-1030', 1, '2015-09-05', 70000, 'Cybersécurité'),
('Meziane', 'Nour', 'nour.meziane@univ.dz', '0555-1040', 2, '2011-01-12', 68000, 'Algèbre'),
('Benali', 'Rania', 'rania.benali@univ.dz', '0555-1050', 3, '2009-05-22', 71000, 'Mécanique Quantique'),
('Bouazza', 'Karim', 'karim.bouazza@univ.dz', '0555-1060', 4, '2013-07-18', 73000, 'Structures');
('Bensaid', 'Karima', 'karima.bensaid@univ.dz', '0555-1070', 2, '2014-03-10', 69000, 'Statistiques'),
('Kacem', 'Nadir', 'nadir.kacem@univ.dz', '0555-1080', 3, '2016-09-01', 70500, 'Optique');


--------------------------------------------------------------------------------------------------

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date)
VALUES
('S1001', 'Benkacem', 'Amel', '2002-05-12', 'amel.benkacem@student.univ.dz', '0555-2010', 'Rue Didouche Mourad, Alger', 1, 'L2', '2021-09-01'),
('S1002', 'Haddad', 'Yacine', '2001-11-30', 'yacine.haddad@student.univ.dz', '0555-2020', 'Rue Hassiba Benbouali, Alger', 1, 'L3', '2020-09-01'),
('S1003', 'Boudiaf', 'Sara', '2003-02-17', 'sara.boudiaf@student.univ.dz', '0555-2030', 'Rue Larbi Ben M’hidi, Alger', 1, 'M1', '2023-09-01'),
('S1004', 'Chergui', 'Sami', '2002-08-05', 'sami.chergui@student.univ.dz', '0555-2040', 'Rue Didouche Mourad, Alger', 2, 'L3', '2020-09-01'),
('S1005', 'Zitouni', 'Lina', '2001-12-22', 'lina.zitouni@student.univ.dz', '0555-2050', 'Rue Hassiba Benbouali, Oran', 3, 'L2', '2021-09-01'),
('S1006', 'Belaid', 'Ethan', '2003-03-15', 'ethan.belaid@student.univ.dz', '0555-2060', 'Rue Didouche Mourad, Constantine', 4, 'L3', '2022-09-01'),
('S1007', 'Boualem', 'Chloé', '2002-07-08', 'chloe.boualem@student.univ.dz', '0555-2070', 'Rue Larbi Ben M’hidi, Oran', 2, 'M1', '2023-09-01'),
('S1008', 'Rahmani', 'Karim', '2002-10-25', 'karim.rahmani@student.univ.dz', '0555-2080', 'Rue Didouche Mourad, Alger', 3, 'L3', '2021-09-01');
('S1009', 'Benali', 'Amina', '2002-04-10', 'amina.benali@student.univ.dz', '0555-2090', 'Rue Didouche Mourad, Alger', 1, 'L2', '2021-09-01'),
('S1010', 'Rahmouni', 'Sofiane', '2001-09-12', 'sofiane.rahmouni@student.univ.dz', '0555-2100', 'Rue Larbi Ben M’hidi, Oran', 2, 'L3', '2020-09-01'),
('S1011', 'Bouchareb', 'Samira', '2003-05-20', 'samira.bouchareb@student.univ.dz', '0555-2110', 'Rue Hassiba Benbouali, Constantine', 3, 'M1', '2023-09-01'),
('S1012', 'Messaoudi', 'Karim', '2002-11-11', 'karim.messaoudi@student.univ.dz', '0555-2120', 'Rue Didouche Mourad, Alger', 4, 'L2', '2021-09-01');



---------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO courses (course_code, course_name, description, cridits, semaster, department_id, professor_id, max_capacity)
VALUES
('INFO101', 'Programmation', 'Introduction à la programmation', 5, 1, 1, 1, 30),
('INFO102', 'Bases de Données', 'Concepts fondamentaux des BD', 6, 2, 1, 2, 30),
('INFO103', 'Réseaux', 'Introduction aux réseaux informatiques', 5, 2, 1, 3, 30),
('MATH101', 'Analyse', 'Calcul différentiel et intégral', 6, 1, 2, 4, 30),
('PHYS101', 'Mécanique', 'Mécanique classique et applications', 5, 1, 3, 5, 30),
('GC101', 'Résistance des matériaux', 'Introduction à la résistance des matériaux', 6, 2, 4, 6, 30),
('INFO201', 'Intelligence Artificielle', 'Bases de l’IA', 5, 2, 1, 1, 30);
('MATH201', 'Probabilités', 'Théorie des probabilités et applications', 5, 2, 2, 7, 30),
('PHYS201', 'Électromagnétisme', 'Introduction à l’électromagnétisme', 6, 2, 3, 8, 30),
('GC201', 'Hydraulique', 'Principes de l’hydraulique', 5, 1, 4, 6, 30);
---------------------------------------------------------------------------------------------

INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status)
VALUES
(1, 1, '2023-09-01', '2023/2024', 'In Progress'),
(1, 2, '2023-09-01', '2023/2024', 'In Progress'),
(2, 1, '2022-09-01', '2022/2023', 'Passed'),
(2, 3, '2022-09-01', '2022/2023', 'Passed'),
(3, 2, '2023-09-01', '2023/2024', 'In Progress'),
(3, 7, '2023-09-01', '2023/2024', 'In Progress'),
(4, 4, '2022-09-01', '2022/2023', 'Passed'),
(4, 5, '2022-09-01', '2022/2023', 'Passed'),
(5, 5, '2023-09-01', '2023/2024', 'In Progress'),
(5, 4, '2023-09-01', '2023/2024', 'In Progress'),
(6, 6, '2023-09-01', '2023/2024', 'In Progress'),
(6, 5, '2023-09-01', '2023/2024', 'In Progress'),
(7, 4, '2023-09-01', '2023/2024', 'In Progress'),
(7, 2, '2023-09-01', '2023/2024', 'In Progress'),
(8, 4, '2023-09-01', '2023/2024', 'In Progress');
(9, 1, '2023-09-01', '2023/2024', 'In Progress'),
(9, 7, '2023-09-01', '2023/2024', 'In Progress'),
(10, 4, '2022-09-01', '2022/2023', 'Passed'),
(11, 5, '2023-09-01', '2023/2024', 'In Progress'),
(12, 6, '2023-09-01', '2023/2024', 'In Progress');

------------------------------------------------------------------------------------------------------------------------

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
VALUES
(1, 'Examen Final', 15, 1.5, '2023-12-20', 'Bon travail'),
(2, 'Examen Final', 16, 1.5, '2023-12-22', 'Excellent'),
(3, 'Examen Final', 14, 1.5, '2023-06-15', 'Satisfaisant'),
(4, 'Examen Final', 17, 1.5, '2023-06-16', 'Très bien'),
(5, 'Projet', 18, 2.0, '2023-12-18', 'Excellent projet'),
(6, 'Examen Mi-Semestre', 13, 1.0, '2023-11-10', 'Besoin d’amélioration'),
(7, 'Examen Final', 16, 1.5, '2023-06-17', 'Bien'),
(8, 'Projet', 17, 2.0, '2023-06-18', 'Très bon projet'),
(9, 'Examen Final', 14, 1.5, '2023-12-19', 'Satisfaisant'),
(10, 'Examen Final', 15, 1.5, '2023-12-20', 'Bien'),
(11, 'Examen Final', 12, 1.0, '2023-12-21', 'Moyen'),
(12, 'Projet', 18, 2.0, '2023-12-22', 'Excellent');
(13, 'Examen Final', 15, 1.5, '2023-12-23', 'Bien'),
(14, 'Projet', 16, 2.0, '2023-12-24', 'Excellent projet'),
(15, 'Examen Final', 14, 1.5, '2023-06-19', 'Satisfaisant'),
(16, 'Examen Final', 17, 1.5, '2023-12-20', 'Très bien'),
(17, 'Projet', 18, 2.0, '2023-12-21', 'Excellent projet'),
(18, 'Examen Final', 13, 1.0, '2023-12-22', 'Besoin d’amélioration');



/*INDEXES*/

CREATE INDEX ind_student_department ON students(department_id);
CREATE INDEX ind_course_professor ON courses(profissor_id);
CREATE INDEX ind_enrollment_student ON enrollments(student_id) ;
CREATE INDEX ind_enrollment_course ON enrollments(course_id);
CREATE INDEX ind_grades_enrollment ON grades(enrollment_id);

/*QUERIES*/
--1
SELECT 
last_name ,first_name ,email , level 
FROM students;



--2
SELECT 
last_name ,first_name ,email ,specialization
FROM professors 
WHERE department_id = 1;


--3
SELECT 
course_code,course_name,credits 
FROM courses WHERE credits>5;

--4
SELECT 
student_number,last_name,first_name,email
FROM students 
WHERE level='L3';

--5
SELECT c.course_code,c.course_name,
CONCAT(p.last_name,' ',p.first_name) professor_name
FROM courses c JOIN professors p
ON c.professor_id=p.professor_id;

--6
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
c.course_name,e.enrollment_date,e.status
FROM enrollments e
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;


--7
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
c.course_name,e.enrollment_date,e.status
FROM enrollments e
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;


---8
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
d.department_name,s.level
FROM students s JOIN departments d
ON s.department_id=d.department_id;



--9
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
c.course_name,g.evaluation_type,g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;


--10
SELECT CONCAT(p.last_name,' ',p.first_name) professor_name,
COUNT(c.course_id) number_of_courses
FROM professors p
LEFT JOIN courses c
ON p.professor_id=c.professor_id
GROUP BY p.professor_id;


--11
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
AVG(g.grade) average_grade
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
JOIN grades g ON e.enrollment_id=g.enrollment_id
GROUP BY s.student_id;

--12
select d.department_name,COUNT(s.student_id) student_count
FROM departments d
LEFT JOIN students s
ON d.department_id=s.department_id
GROUP BY d.department_id;

---13
SELECT SUM(budget) total_buget FROM departments;

--14
SELECT d.department_name,COUNT( c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id=c.department_id
GROUP BY d.department_id,d.department_name ;

--15
SELECT d.department_name,AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id=p.department_id
GROUP BY d.department_id,d.department_name;


--16
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
AVG(g.grade) average_grade
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
JOIN grades g ON e.enrollment_id=g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;


--17
SELECT c.course_code,c.course_name
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
WHERE e.enrollment_id IS NULL;

--18
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
COUNT(e.enrollment_id) passed_courses_count
FROM students s
JOIN enrollments e
ON s.student_id=e.student_id
WHERE e.status='Passed'
GROUP BY s.student_id;


----19
SELECT CONCAT(p.last_name,' ',p.first_name) professor_name,
COUNT(c.course_id) courses_taught
FROM professors p
JOIN courses c
ON p.professor_id=c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id)>2;


--20
SELECT CONCAT(s.last_name,' ',s.first_name) student_name,
COUNT(e.course_id) enrolled_courses_count
FROM students s
JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id)>2;

--21

SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,AVG(g.grade) AS student_avg,
       (SELECT AVG(g2.grade)
        FROM students s2
        JOIN enrollments e2 ON s2.student_id=e2.student_id
        JOIN grades g2 ON e2.enrollment_id=g2.enrollment_id
        WHERE s2.department_id=s.department_id) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
JOIN grades g ON e.enrollment_id=g.enrollment_id
GROUP BY s.student_id,s.first_name ,s.last_name ,s.department_id
HAVING AVG(g.grade)>(
    SELECT AVG(g2.grade)
    FROM students s2
    JOIN enrollments e2 ON s2.student_id=e2.student_id
    JOIN grades g2 ON e2.enrollment_id=g2.enrollment_id
    WHERE s2.department_id=s.department_id


--22

FROM courses c
JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name
HAVING COUNT(e.enrollment_id)>(
    SELECT AVG(enrollment_count)
    FROM (
        SELECT COUNT(enrollment_id) AS enrollment_count
        FROM enrollments
        GROUP BY course_id
    ) AS avg_enrollments
);

--23
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

--24
SELECT 
distinct concat(s.last_name,' ',s.first_name) as student_name, s.email
from students s
left join enrollments e on s.student_id = e.student_id
left join grades g on e.enrollment_id = g.enrollment_id
where g.grade_id is null

--25
SELECT d.department_name, COUNT(s.student_id) AS num_students
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING num_students > 
(SELECT COUNT(*) / COUNT(DISTINCT department_id) FROM students);

--26
SELECT c.course_name,
COUNT(g.grade) total_grades,
SUM(g.grade) passed_grades,
SUM()
/*nweli*/
From courses c 
group by c.course_id;

--27
SELECT 
    RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
    (s.last_name || ' ' || s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

--28
SELECT c.course_name,g.evaluation_type,
g.grade,g.coefficient,
from students s
/*lazem nweli*/
where s.student_id =1;



--29
SELECT CONCAT(p.last_name,' ',p.first_name) professor_name,
SUM(c.credits) total_credits
FROM professors p
JOIN courses c
ON p.professor_id=c.professor_id
GROUP BY p.professor_id;

--30

SELECT c.course_name,
COUNT(e.enrollment_id) current_enrollments,
c.max_capacity,
COUNT(e.enrollment_id)/c.max_capacity*100 percentage_full
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id)>
(c.max_capacity*0.8);
