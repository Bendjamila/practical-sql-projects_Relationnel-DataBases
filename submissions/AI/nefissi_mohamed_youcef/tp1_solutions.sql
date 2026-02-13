create database university_db;
use university_db;


-- creating tables --


create table departments (
    department_id int primary key auto_increment,
    department_name varchar(100) not null,
    building varchar(50),
    budget decimal(12, 2),
    department_head varchar(100),
    creation_date date
);

create table professors (
    professor_id int primary key auto_increment,
    last_name varchar(50) not null,
    first_name varchar(50) not null,
    email varchar(100) unique not null,
    phone varchar(20),
    department_id int,
    hire_date date,
    salary decimal(10, 2),
    specialization varchar(100),
    foreign key(department_id) references departments(department_id)
        on delete set null
        on update cascade
);

create table students (
    student_id int primary key auto_increment,
    student_number varchar(20) UNIQUE NOT NULL,
    last_name varchar(50) NOT NULL,
    first_name varchar(50) NOT NULL,
    date_of_birth DATE,
    email varchar(100) UNIQUE NOT NULL,
    phone varchar(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    foreign key (department_id) references departments(department_id)
        on delete set null
        on update cascade
);

create table courses (
    course_id int primary key auto_increment,
    course_code varchar(10) UNIQUE NOT NULL,
    course_name varchar(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    foreign key (department_id) references departments(department_id)
        on delete cascade
        on update cascade,
    foreign key (professor_id) references professors(professor_id)
        on delete set null
        on update cascade
);

create table enrollments (
    enrollment_id int primary key auto_increment,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year varchar(9) NOT NULL,
    status varchar(20) DEFAULT 'In Progress' 
        CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    foreign key (student_id) references students(student_id)
        on delete cascade
        on update cascade,
    foreign key (course_id) references courses(course_id)
        on delete cascade
        on update cascade,
    UNIQUE KEY unique_enrollment (student_id, course_id, academic_year)
);

create table grades (
    grade_id int primary key auto_increment,
    enrollment_id int not null,
    evaluation_type varchar(30) 
        CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade decimal(5, 2) check (grade BETWEEN 0 AND 20),
    coefficient decimal(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    foreign key (enrollment_id) references enrollments(enrollment_id)
        on delete cascade
        on update cascade
);

create index idx_student_department on students(department_id);
create index idx_course_professor on courses(professor_id);
create index idx_enrollment_student on enrollments(student_id);
create index idx_enrollment_course on enrollments(course_id);
create index idx_grades_enrollment on grades(enrollment_id);


-- inserting data --


INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Belhadj', 'Youcef', 'y.belhadj@univ-alger.dz', '+213-555-0101', 1, '2015-08-15', 95000.00, 'Intelligence Artificielle'),
('Toumi', 'Ahmed', 'a.toumi@univ-alger.dz', '+213-555-0102', 1, '2016-09-01', 92000.00, 'Algorithmique Avancée'),
('Bensalem', 'Lynda', 'l.bensalem@univ-alger.dz', '+213-555-0103', 1, '2014-01-10', 98000.00, 'Génie Logiciel'),
('Benmoussa', 'Fatima', 'f.benmoussa@univ-alger.dz', '+213-555-0104', 2, '2017-03-20', 88000.00, 'Analyse Numérique'),
('Boualem', 'Karim', 'k.boualem@univ-alger.dz', '+213-555-0105', 3, '2016-11-05', 91000.00, 'Physique Théorique'),
('Cherif', 'Nadia', 'n.cherif@univ-alger.dz', '+213-555-0106', 4, '2015-05-12', 89000.00, 'Génie Parasismique');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('CS2021001', 'Benali', 'Youcef', '2003-05-12', 'y.benali@etu.univ-alger.dz', '+213-661-123456', '15 Rue Didouche Mourad, Alger-Centre', 1, 'L3', '2021-09-01'),
('CS2022005', 'Bouzid', 'Ahmed', '2004-08-23', 'a.bouzid@etu.univ-alger.dz', '+213-662-234567', '23 Boulevard Zighout Youcef, Bab Ezzouar', 1, 'L2', '2022-09-01'),
('CS2020002', 'Haddad', 'Amel', '2002-11-30', 'a.haddad@etu.univ-alger.dz', '+213-663-345678', '7 Cité 5 Juillet, Ben Aknoun', 1, 'M1', '2020-09-01'),
('MATH2021003', 'Meziane', 'Omar', '2003-02-18', 'o.meziane@etu.univ-alger.dz', '+213-664-456789', '42 Rue Hassiba Ben Bouali, Hydra', 2, 'L3', '2021-09-01'),
('MATH2022007', 'Slimani', 'Sofia', '2004-07-07', 's.slimani@etu.univ-alger.dz', '+213-665-567890', '18 Cité des Frères Arfaoui, Kouba', 2, 'L2', '2022-09-01'),
('PHY2021004', 'Khelif', 'Mohamed', '2003-09-25', 'm.khelif@etu.univ-alger.dz', '+213-666-678901', '31 Rue Larbi Ben M\'hidi, Bir Mourad Rais', 3, 'L3', '2021-09-01'),
('PHY2020001', 'Hamidi', 'Lamia', '2002-04-14', 'l.hamidi@etu.univ-alger.dz', '+213-667-789012', '55 Cité 20 Août, Saoula', 3, 'M1', '2020-09-01'),
('CE2022006', 'Guerfi', 'Abdelkader', '2004-12-01', 'a.guerfi@etu.univ-alger.dz', '+213-668-890123', '9 Rue Mohamed Belouizdad, Belouizdad', 4, 'L2', '2022-09-01'),
('CE2021002', 'Mansouri', 'Nesrine', '2003-06-19', 'n.mansouri@etu.univ-alger.dz', '+213-669-901234', '27 Cité Djebel Lakhdar, El Harrach', 4, 'L3', '2021-09-01'),
('CS2022008', 'Bahloul', 'Rayan', '2004-01-30', 'r.bahloul@etu.univ-alger.dz', '+213-670-012345', '11 Rue Abane Ramdane, Kouba', 1, 'L2', '2022-09-01');

INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Introduction à la Programmation', 'Fondamentaux de la programmation avec Python', 5, 1, 1, 2, 35),
('CS201', 'Structures de Données', 'Structures de données avancées et algorithmes', 6, 2, 1, 2, 30),
('CS301', 'Intelligence Artificielle', 'Principes et applications de l\'IA', 6, 1, 1, 1, 25),
('MATH101', 'Analyse I', 'Limites, dérivées et intégrales', 5, 1, 2, 4, 40),
('MATH201', 'Algèbre Linéaire', 'Vecteurs, matrices et transformations linéaires', 5, 2, 2, 4, 35),
('PHY101', 'Mécanique du Point', 'Mouvement et forces', 5, 1, 3, 5, 30),
('PHY202', 'Électromagnétisme', 'Champs électriques et magnétiques', 6, 2, 3, 5, 25),
('CE101', 'Introduction au Génie Civil', 'Aperçu des disciplines du génie civil', 5, 1, 4, 6, 35),
('CE201', 'Résistance des Matériaux', 'Comportement mécanique des structures', 6, 2, 4, 6, 30),
('CS350', 'Bases de Données', 'Conception et implémentation de bases de données', 5, 2, 1, 3, 32);

INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2023-09-05', '2023-24', 'Passed'),
(1, 2, '2024-01-15', '2023-24', 'In Progress'),
(1, 5, '2023-09-05', '2023-24', 'Passed'),
(2, 1, '2024-01-15', '2023-24', 'In Progress'),
(2, 3, '2024-01-15', '2023-24', 'In Progress'),
(3, 1, '2022-09-03', '2022-23', 'Passed'),
(3, 2, '2023-01-10', '2022-23', 'Passed'),
(3, 3, '2023-09-04', '2023-24', 'In Progress'),
(4, 4, '2023-09-05', '2023-24', 'Passed'),
(4, 5, '2024-01-15', '2023-24', 'In Progress'),
(5, 4, '2023-09-05', '2023-24', 'Passed'),
(5, 5, '2024-01-15', '2023-24', 'In Progress'),
(6, 6, '2023-09-05', '2023-24', 'Failed'),
(6, 7, '2024-01-15', '2023-24', 'Dropped'),
(7, 6, '2022-09-03', '2022-23', 'Passed'),
(7, 7, '2023-01-10', '2022-23', 'Passed'),
(8, 8, '2023-09-05', '2023-24', 'Passed'),
(8, 9, '2024-01-15', '2023-24', 'In Progress'),
(9, 8, '2023-09-05', '2023-24', 'Passed'),
(10, 1, '2024-01-15', '2023-24', 'In Progress'),
(10, 10, '2024-01-15', '2023-24', 'In Progress');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 16.50, 2.00, '2023-12-15', 'Très bonne compréhension'),
(1, 'Assignment', 18.00, 1.00, '2023-10-20', 'Excellent travail'),
(1, 'Project', 17.00, 1.50, '2023-11-30', 'Code bien structuré'),
(2, 'Lab', 14.00, 1.00, '2024-02-10', 'Bon travail, quelques erreurs'),
(3, 'Exam', 15.00, 2.00, '2023-12-18', 'Bonne performance'),
(4, 'Assignment', 12.50, 1.00, '2024-02-05', 'Peut mieux faire'),
(5, 'Exam', 13.00, 2.00, '2024-03-01', 'Résultats moyens'),
(6, 'Exam', 17.50, 2.00, '2022-12-16', 'Excellent'),
(7, 'Exam', 16.00, 2.00, '2023-05-20', 'Très bien'),
(8, 'Project', 15.50, 1.50, '2023-12-05', 'Bon projet'),
(9, 'Exam', 14.50, 2.00, '2023-12-14', 'Satisfaisant'),
(10, 'Assignment', 11.00, 1.00, '2024-02-08', 'En dessous de la moyenne'),
(13, 'Exam', 8.00, 2.00, '2023-12-17', 'Insuffisant - Échec'),
(16, 'Exam', 15.50, 2.00, '2023-01-15', 'Bien'),
(17, 'Exam', 14.00, 2.00, '2023-05-18', 'Acceptable'),
(18, 'Assignment', 13.50, 1.00, '2023-10-25', 'Travail correct');


-- SQL queries --

-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level
SELECT 
    last_name,
    first_name, 
    email,
    level
FROM students ;

-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization
SELECT 
    p.last_name,
    p.first_name,
    p.email,
    p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization
SELECT 
    last_name,
    first_name,
    email,
    specialization
FROM professors
WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Computer Science') ;

-- Q3. Find all courses with more than 5 credits
-- Expected columns: course_code, course_name, credits
SELECT 
    course_code,
    course_name,
    credits
FROM courses
WHERE credits > 5 ;

-- Q4. List students enrolled in L3 level
-- Expected columns: student_number, last_name, first_name, email
SELECT 
    student_number,
    last_name,
    first_name,
    email
FROM students
WHERE level = 'L3' ;

-- Q5. Display courses from semester 1
-- Expected columns: course_code, course_name, credits, semester
SELECT 
    course_code,
    course_name,
    credits,
    semester
FROM courses
WHERE semester = 1 ;

-- Q6. Display all courses with the professor's name
-- Expected columns: course_code, course_name, professor_name (last + first)
SELECT 
    course_code,
    course_name,
    CONCAT(professors.last_name, ' ', professors.first_name) AS professor_name
FROM courses
LEFT JOIN professors ON courses.professor_id = professors.professor_id;

-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT 
    CONCAT(students.last_name, ' ', students.first_name) AS student_name,
    courses.course_name,
    enrollments.enrollment_date,
    enrollments.status
FROM enrollments
JOIN students ON enrollments.student_id = students.student_id
JOIN courses ON enrollments.course_id = courses.course_id ;

-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT 
    CONCAT(last_name, ' ', first_name) AS student_name,
    department_name,
    level
FROM students
LEFT JOIN departments ON students.department_id = departments.department_id ;

-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT 
    CONCAT(students.last_name, ' ', students.first_name) AS student_name,
    courses.course_name,
    grades.evaluation_type,
    grades.grade
FROM grades
JOIN enrollments ON grades.enrollment_id = enrollments.enrollment_id
JOIN students ON enrollments.student_id = students.student_id
JOIN courses ON enrollments.course_id = courses.course_id ;

-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT 
    CONCAT(professors.last_name, ' ', professors.first_name) AS professor_name,
    COUNT(courses.course_id) AS number_of_courses
FROM professors
LEFT JOIN courses ON professors.professor_id = courses.professor_id
GROUP BY professors.professor_id ;

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT 
    CONCAT(students.last_name, ' ', students.first_name) AS student_name,
    ROUND(AVG(grades.grade), 2) AS average_grade
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
JOIN grades ON enrollments.enrollment_id = grades.enrollment_id
GROUP BY students.student_id;

-- Q12. Count the number of students per department
-- Expected columns: department_name, student_count
SELECT 
    departments.department_name,
    COUNT(students.student_id) AS student_count
FROM departments
LEFT JOIN students ON departments.department_id = students.department_id
GROUP BY departments.department_id;

-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
SELECT 
    SUM(budget) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count
SELECT 
    departments.department_name,
    COUNT(courses.course_id) AS course_count
FROM departments
LEFT JOIN courses ON departments.department_id = courses.department_id
GROUP BY departments.department_id;

-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary
SELECT 
    departments.department_name,
    ROUND(AVG(professors.salary), 2) AS average_salary
FROM departments
LEFT JOIN professors ON departments.department_id = professors.department_id
GROUP BY departments.department_id;

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3
SELECT 
    CONCAT(students.last_name, ' ', students.first_name) AS student_name,
    ROUND(AVG(grades.grade), 2) AS average_grade
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
JOIN grades ON enrollments.enrollment_id = grades.enrollment_id
GROUP BY students.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
-- Expected columns: course_code, course_name
SELECT 
    courses.course_code,
    courses.course_name
FROM courses
LEFT JOIN enrollments ON courses.course_id = enrollments.course_id
WHERE enrollments.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Expected columns: student_name, passed_courses_count
SELECT 
    CONCAT(students.last_name, ' ', students.first_name) AS student_name,
    COUNT(*) AS passed_courses_count
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
WHERE enrollments.status = 'Passed'
GROUP BY students.student_id
HAVING COUNT(*) = (
    SELECT COUNT(*) 
    FROM enrollments e2 
    WHERE e2.student_id = students.student_id
);

-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught
SELECT 
    CONCAT(professors.last_name, ' ', professors.first_name) AS professor_name,
    COUNT(courses.course_id) AS courses_taught
FROM professors
JOIN courses ON professors.professor_id = courses.professor_id
GROUP BY professors.professor_id
HAVING courses_taught > 2;

-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count
SELECT 
    CONCAT(students.last_name, ' ', students.first_name) AS student_name,
    COUNT(DISTINCT enrollments.course_id) AS enrolled_courses_count
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
GROUP BY students.student_id
HAVING enrolled_courses_count > 2;

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg
WITH department_averages AS (
    SELECT 
        s.department_id,
        AVG(g.grade) AS dept_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
)
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS student_avg,
    ROUND(da.dept_avg, 2) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
JOIN department_averages da ON s.department_id = da.department_id
GROUP BY s.student_id, s.last_name, s.first_name, da.dept_avg
HAVING AVG(g.grade) > da.dept_avg ;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(enrollment_count)
    FROM (
        SELECT COUNT(e2.enrollment_id) AS enrollment_count
        FROM courses c2
        LEFT JOIN enrollments e2 ON c2.course_id = e2.course_id
        GROUP BY c2.course_id
    ) AS course_counts
);

-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (
    SELECT MAX(budget)
    FROM departments
);

-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL
GROUP BY s.student_id;

-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(s2.student_id) AS student_count
        FROM departments d2
        LEFT JOIN students s2 ON d2.department_id = s2.department_id
        GROUP BY d2.department_id
    ) AS dept_counts
);

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT 
    c.course_name,
    COUNT(g.grade_id) AS total_grades,
    SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
    ROUND((SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade_id)), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
SELECT 
    RANK() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`,
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade
SELECT 
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT 
    CONCAT(last_name, ' ', first_name) AS professor_name,
    SUM(credits) AS total_credits
FROM professors
LEFT JOIN courses ON professors.professor_id = courses.professor_id
GROUP BY professors.professor_id ;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    ROUND((COUNT(e.enrollment_id) * 100.0 / c.max_capacity), 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING percentage_full > 80 ;
