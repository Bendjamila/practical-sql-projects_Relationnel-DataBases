-- Create 
CREATE DATABASE university_db;
USE university_db;

-- Tables
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
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
    ON DELETE SET NULL
    ON UPDATE CASCADE
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
    level VARCHAR(20) CHECK(level IN('L1','L2','L3','M1','M2')),
    enrollment_date DATE,
    FOREIGN KEY(department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);


CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK(credits>0),
    semester INT CHECK(semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY(department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'in progress' 
        CHECK(status IN('in progress','passed','failed','dropped')),
    FOREIGN KEY(student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE(student_id,course_id,academic_year)
);

CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) 
        CHECK(evaluation_type IN('assignment','lab','exam','project')),
    grade DECIMAL(5,2) CHECK(grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY(enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- indexes 

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);


-- Insert Departments
INSERT INTO departments (department_name,building,budget,department_head,creation_date) VALUES
('Computer Science','A',500000,'dr benadji','2010-09-01'),
('Mathematics','B',350000,'dr melboucy','2008-09-01'),
('Physics','C',400000,'dr boumbbar','2009-09-01'),
('Civil Engineering','D',600000,'dr Benbadi','2011-09-01');

-- Insert Professors
INSERT INTO professors (last_name,first_name,email,phone,department_id,hire_date,salary,specialization) VALUES
('Berkane','Amine','a.berkane@univ-alg.dz','0554-123-456',1,'2015-09-01',68500,'AI'),
('Saadi','Leila','l.saadi@univ-alg.dz',NULL,1,'2016-01-15',71200,'Databases'),
('Hamdi','Karim','k_hamdi@univ-alg.dz','0661-789-012',1,'2017-09-01',65800,'Web Dev'),
('Boukhari','Nassim','n.boukhari@univ-alg.dz','0770-234-567',2,'2014-09-01',69300,'Algebra'),
('Ferhat','Yasmine','y.ferhat@univ-alg.dz','0555-345-678',3,'2015-09-01',70100,'Physics'),
('Meziani','Rachid','rachid.meziani@univ-alg.dz','0662-456-789',4,'2016-09-01',72400,'Structures');

-- Insert Students
INSERT INTO students (student_number,last_name,first_name,date_of_birth,email,phone,address,department_id,level,enrollment_date) VALUES
('221034567','Benali','Imane','2003-05-15','i.benali@etu.univ-alg.dz','0555-112-233','Cite 500 logts, Alger',1,'L3','2022-09-01'),
('231045678','Kaci','Mehdi','2004-03-22','m.kaci@etu.univ-alg.dz',NULL,'Hai essalam, Oran',1,'L2','2023-09-01'),
('211023456','Amrani','Yasmine','2002-11-08','y.amrani@etu.univ-alg.dz','0770-998-877','Bab ezzouar, Alger',1,'M1','2021-09-01'),
('221056789','Brahimi','Sofiane','2003-07-30','s_brahimi@etu.univ-alg.dz','0661-223-445','Rue didouche, Constantine',2,'L3','2022-09-01'),
('231067890','Haddad','Nour','2004-01-14','nour.haddad@etu.univ-alg.dz','0554-334-556','Cite merdja, Annaba',2,'L2','2023-09-01'),
('221078901','Meziane','Walid','2003-09-25','w.meziane@etu.univ-alg.dz','0662-445-667','Les platanes, Oran',3,'L3','2022-09-01'),
('211012345','Ziani','Samira','2002-12-18','samira_z@etu.univ-alg.dz',NULL,'Boumerdes centre',3,'M1','2021-09-01'),
('221089012','Toumi','Riad','2003-04-05','r.toumi@etu.univ-alg.dz','0555-556-778','Ouled yaich, Blida',4,'L3','2022-09-01'),
('221201235', 'Khelladi', 'Tarek', '2003-11-17', 't.khelladi@etu.univ-alg.dz', '0554-445-667', 'Casbah, Alger', 1, 'L3', '2022-09-01'),
('231212346', 'Benslimane', 'Nadia', '2004-09-23', 'n.benslimane@etu.univ-alg.dz', NULL, 'Alger centre', 1, 'L2', '2023-09-01');

-- Insert Courses
INSERT INTO courses (course_code,course_name,description,credits,semester,department_id,professor_id,max_capacity) VALUES
('CS101','Intro Programming','Python basics',6,1,1,1,40),
('CS201','Database Systems','SQL and relational DB',6,1,1,2,35),
('CS301','Web Dev','HTML CSS JS frameworks',5,2,1,3,30),
('MATH101','Linear Algebra','Matrices vectors',6,1,2,4,45),
('MATH201','Calculus 2','Integrals and diff equations',6,2,2,4,40),
('PHY101','Mechanics','Newton laws',5,1,3,5,35),
('CE201','Structural Analysis','Beams frames',6,1,4,6,28),
('CS401', 'Advanced AI', 'Networks', 6, 2, 1, 1, 25),
('MATH301', 'Abstract Algebra', 'Groups, rings, and fields', 5, 2, 2, 4, 30);

-- Insert Enrollments
INSERT INTO enrollments (student_id,course_id,enrollment_date,academic_year,status) VALUES
(1,2,'2024-09-10','2024-2025','In Progress'),
(1,3,'2024-09-15','2024-2025','In Progress'),
(2,1,'2024-09-08','2024-2025','In Progress'),
(2,2,'2024-09-10','2024-2025','In Progress'),
(3,2,'2024-09-10','2024-2025','In Progress'),
(3,3,'2024-09-12','2024-2025','In Progress'),
(4,4,'2024-09-11','2024-2025','In Progress'),
(4,5,'2024-09-09','2024-2025','In Progress'),
(5,4,'2024-09-10','2024-2025','In Progress'),
(1,1,'2023-09-05','2023-2024','Passed'),
(2,1,'2023-09-06','2023-2024','Passed'),
(3,1,'2023-09-05','2023-2024','Passed'),
(6,6,'2023-09-07','2023-2024','Passed'),
(7,6,'2023-09-05','2023-2024','Failed'),
(8,7,'2023-09-08','2023-2024','Passed');

-- Insert Grades
INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient,evaluation_date,comments) VALUES
(10,'Assignment',15.5,0.2,'2023-10-15','bon travail'),
(10,'Exam',16,0.8,'2023-12-20','tres bien'),
(11,'Assignment',14,0.2,'2023-10-18','peut mieux faire'),
(11,'Exam',15.5,0.8,'2023-12-20','bien'),
(12,'Lab',17,0.3,'2023-11-10','excellent'),
(12,'Exam',18,0.7,'2023-12-22','parfait'),
(13,'Assignment',16.5,0.4,'2023-10-20','tres bon'),
(13,'Exam',17,0.6,'2023-12-18','excellent'),
(14,'Exam',9.5,1.0,'2023-12-18','insuffisant'),
(15,'Project',15,0.5,'2023-11-25','correct'),
(15,'Exam',16,0.5,'2023-12-22','bien'),
(1,'Assignment',14.5,0.3,'2024-10-15','bon debut');


-- ============================================
-- TP1: 30 SQL Queries to Solve
-- University Management System
-- ============================================
-- INSTRUCTIONS: Write your SQL query below each question
-- Test your queries before submitting!
-- ============================================

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level
SELECT last_name,first_name,email,level
FROM students;


-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization
SELECT p.last_name,p.first_name,p.email,p.specialization
FROM professors p
JOIN departments d ON p.department_id=d.department_id
WHERE d.department_name='Computer Science';


-- Q3. Find all courses with more than 5 credits
-- Expected columns: course_code, course_name, credits
SELECT course_code,course_name,credits
FROM courses
WHERE credits>5;


-- Q4. List students enrolled in L3 level
-- Expected columns: student_number, last_name, first_name, email
SELECT student_number,last_name,first_name,email
FROM students
WHERE level='L3';


-- Q5. Display courses from semester 1
-- Expected columns: course_code, course_name, credits, semester
SELECT course_code,course_name,credits,semester
FROM courses
WHERE semester = 1;


-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
-- Expected columns: course_code, course_name, professor_name (last + first)
SELECT c.course_code,c.course_name,CONCAT(p.first_name,' ',p.last_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id =p.professor_id;


-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,c.course_name,e.enrollment_date,e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, d.department_name,s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;


-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,c.course_name,g.evaluation_type,g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN students s ON e.student_id=s.student_id
JOIN courses c ON e.course_id=c.course_id;


-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT CONCAT(p.first_name,' ',p.last_name) AS professor_name,COUNT(c.course_id) AS number_of_courses
FROM professors p
JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id ,p.first_name ,p.last_name;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
JOIN grades g ON e.enrollment_id=g.enrollment_id
GROUP BY s.student_id,s.first_name,s.last_name;


-- Q12. Count the number of students per department
-- Expected columns: department_name, student_count
SELECT d.department_name,COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id=s.department_id
GROUP BY d.department_id,d.department_name;


-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
SELECT SUM(budget) AS total_budget
FROM departments;


-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count
SELECT d.department_name,COUNT( c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id=c.department_id
GROUP BY d.department_id,d.department_name ;


-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary
SELECT d.department_name,AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id=p.department_id
GROUP BY d.department_id,d.department_name;


-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
JOIN grades g ON e.enrollment_id=g.enrollment_id
GROUP BY s.student_id,s.first_name,s.last_name
ORDER BY average_grade DESC
LIMIT 3;


-- Q17. List courses with no enrolled students
-- Expected columns: course_code, course_name
SELECT c.course_code,c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id=e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Expected columns: student_name, passed_courses_count
SELECT CONCAT(s.first_name, ' ',s.last_name) AS student_name, COUNT(e.enrollment_id) AS nbr_passed
FROM students s
JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Passed'
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e2
    WHERE e2.student_id = s.student_id AND e2.status <> 'Passed'
)
GROUP BY s.student_id, s.first_name, s.last_name;



-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught
SELECT CONCAT(p.first_name,' ',p.last_name) AS professor_name,COUNT(c.course_id) AS p_courses
FROM professors p
JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id,p.first_name,p.last_name
HAVING COUNT(c.course_id)>2;


-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
GROUP BY s.student_id ,s.first_name ,s.last_name
HAVING COUNT(e.enrollment_id)> 2;


-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg
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
);


-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT c.course_name,COUNT(e.enrollment_id) AS enrollment_count
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


-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget
SELECT CONCAT(p.first_name,' ',p.last_name) AS professor_name,
       d.department_name,d.budget
FROM professors p
JOIN departments d ON p.department_id=d.department_id
WHERE d.budget=(SELECT MAX(budget) FROM departments);


-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,s.email
FROM students s
WHERE s.student_id NOT IN(
    SELECT DISTINCT e.student_id
    FROM enrollments e
    JOIN grades g ON e.enrollment_id=g.enrollment_id
);


-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT d.department_name,COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s ON d.department_id=s.department_id
GROUP BY d.department_id ,d.department_name
HAVING COUNT(s.student_id)>(
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM students
        GROUP BY department_id
    ) AS avg_students
);


-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT c.course_name, COUNT(g.grade_id) AS total_grades,
SUM(CASE WHEN g.grade>=10 THEN 1 ELSE 0 END) AS passed_grades,
      (SUM(CASE WHEN g.grade>=10 THEN 1 ELSE 0 END)/COUNT(g.grade_id))*100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id =g.enrollment_id
GROUP BY c.course_id, c.course_name ;


-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
SELECT
    1 + (
        SELECT COUNT(*)
        FROM (
            SELECT AVG(g2.grade) AS avg_grade
            FROM students s2
            JOIN enrollments e2 ON s2.student_id= e2.student_id
            JOIN grades g2 ON e2.enrollment_id= g2.enrollment_id
            GROUP BY s2.student_id) AS all_avgs
        WHERE all_avgs.avg_grade>t.average_grade
    ) AS `rank`,  t.student_name,   t.average_grade
FROM (
    SELECT s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name, AVG(g.grade) AS average_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.first_name, s.last_name
) AS t
ORDER BY `rank`;



-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade
SELECT c.course_name, g.evaluation_type,g.grade, g.coefficient, g.grade * g.coefficient AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id=e.enrollment_id
JOIN courses c ON e.course_id=c.course_id
WHERE e.student_id=1
ORDER BY c.course_name,g.evaluation_date;


-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT CONCAT(p.first_name,' ',p.last_name) AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id=c.professor_id
GROUP BY p.professor_id,p.first_name,p.last_name;


-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments,c.max_capacity,(COUNT(e.enrollment_id)/c.max_capacity)*100 AS percentage_full
FROM courses c
JOIN enrollments e ON c.course_id=e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING (COUNT(e.enrollment_id)/c.max_capacity) *100 > 80
ORDER BY percentage_full DESC;
