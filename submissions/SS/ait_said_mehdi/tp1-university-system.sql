DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;
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
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    CONSTRAINT fk_prof_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
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
    level VARCHAR(20),
    enrollment_date DATE,
    CONSTRAINT chk_level CHECK (level IN ('L1','L2','L3','M1','M2')),
    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
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
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT chk_status CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT chk_eval_type CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CONSTRAINT chk_grade CHECK (grade BETWEEN 0 AND 20),
    CONSTRAINT fk_grade_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES
('Computer Science','Building A',500000,'Dr. Smith','2005-02-04'),
('Mathematics','Building B',350000,'Dr. Brown','2001-01-01'),
('Physics','Building C',400000,'Dr. Taylor','2007-06-07'),
('Civil Engineering','Building D',600000,'Dr. Wilson','2003-11-11');
INSERT INTO professors (last_name, first_name, email, department_id, hire_date, salary, specialization)
VALUES
('Johnson','Mark','mark.johnson@uni.com',1,'2015-09-01',70000,'AI'),
('Williams','Anna','anna.williams@uni.com',1,'2017-03-10',68000,'Databases'),
('Anderson','Paul','paul.anderson@uni.com',1,'2012-06-20',75000,'Networks'),
('Martin','Claire','claire.martin@uni.com',2,'2018-02-15',65000,'Algebra'),
('Thomas','David','david.thomas@uni.com',3,'2016-11-11',72000,'Quantum Physics'),
('Moore','Emma','emma.moore@uni.com',4,'2019-05-05',71000,'Structures');
INSERT INTO students (student_number,last_name,first_name,date_of_birth,email,department_id,level)
VALUES
('S001','Ali','Karim','2002-05-10','ali@uni.com',1,'L2'),
('S002','Sara','Ben','2001-04-12','sara@uni.com',1,'L3'),
('S003','Omar','Hadi','2000-03-14','omar@uni.com',2,'M1'),
('S004','Lina','Amir','2002-07-21','lina@uni.com',3,'L3'),
('S005','Yassine','Nour','2001-01-18','yassine@uni.com',4,'M1'),
('S006','Maya','Rami','2003-02-11','maya@uni.com',1,'L2'),
('S007','Nabil','Sam','2002-12-01','nabil@uni.com',2,'L3'),
('S008','Aya','Zaid','2001-09-09','aya@uni.com',3,'M1');
INSERT INTO courses (course_code,course_name,credits,semester,department_id,professor_id,max_capacity)
VALUES
('CS101','Programming',6,1,1,1,40),
('CS202','Databases',5,2,1,2,35),
('CS303','Networks',6,1,1,3,30),
('MATH201','Linear Algebra',5,1,2,4,30),
('PHY101','Mechanics',6,2,3,5,25),
('CE101','Statics',5,1,4,6,30),
('CS404','Machine Learning',6,2,1,1,20);
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status)
VALUES
(1, 1, '2024-09-01', '2024-2025', 'Passed'),
(1, 2, '2024-09-01', '2024-2025', 'In Progress'),
(2, 1, '2024-09-01', '2024-2025', 'Passed'),
(2, 3, '2024-09-01', '2024-2025', 'Failed'),
(3, 4, '2024-09-01', '2024-2025', 'Passed'),
(4, 5, '2023-09-01', '2023-2024', 'Passed'),
(5, 6, '2024-09-01', '2024-2025', 'In Progress'),
(6, 1, '2024-09-01', '2024-2025', 'Passed'),
(6, 7, '2024-09-01', '2024-2025', 'In Progress'),
(7, 4, '2024-09-01', '2024-2025', 'Passed'),
(8, 5, '2024-09-01', '2024-2025', 'Passed'),
(3, 2, '2024-09-01', '2024-2025', 'In Progress'),
(4, 3, '2024-09-01', '2024-2025', 'Dropped'),
(5, 7, '2024-09-01', '2024-2025', 'Passed'),
(8, 1, '2023-09-01', '2023-2024', 'Passed');
INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient,evaluation_date)
VALUES
(1,'Exam',15,1.5,'2024-06-01'),
(1,'Assignment',14,1,'2024-05-01'),
(3,'Exam',16,1.5,'2024-06-01'),
(4,'Exam',9,1.5,'2024-06-01'),
(5,'Project',17,2,'2024-06-01'),
(6,'Exam',12,1.5,'2024-06-01'),
(8,'Lab',13,1,'2024-05-01'),
(9,'Exam',14,1.5,'2024-06-01'),
(10,'Exam',18,1.5,'2024-06-01'),
(11,'Assignment',15,1,'2024-05-01'),
(14,'Exam',16,1.5,'2024-06-01'),
(15,'Exam',14,1.5,'2024-06-01');
-- q1
SELECT last_name, first_name, email, level
FROM students;
-- q2
SELECT p.last_name, p.first_name , p.email , p.specialization
FROM professors p
JOIN departments d
 ON d.department_id = p.department_id
WHERE d.department_name = 'Computer Science';
-- q3
SELECT course_code , course_name, credits
FROM courses
WHERE credits > 5 ;
-- q4
SELECT student_number, last_name , first_name, email
FROM students
WHERE level = 'L3';
-- q5
SELECT course_code, course_name , credits, semester
FROM courses
WHERE semester = 1 ;
-- q6
SELECT c.course_code , c.course_name , p.first_name , p.last_name 
FROM courses c
JOIN professors p ON p.professor_id = c.professor_id;
-- q7
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;
-- q8
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d ON d.department_id = s.department_id;
-- q9
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON e.enrollment_id = g.enrollment_id
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;
-- q10
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;
-- q11
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;
-- q12
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
-- q13
SELECT SUM(budget) AS total_budget
FROM departments;
-- q14
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON c.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
-- q15
SELECT d.department_name,
       ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
LEFT JOIN professors p ON p.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
-- q16
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC
LIMIT 3;
-- q17
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
WHERE e.enrollment_id IS NULL;
-- q18
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) > 0
   AND SUM(CASE WHEN e.status <> 'Passed' THEN 1 ELSE 0 END) = 0;
   -- q19
   SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;
-- q20
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) > 2;
-- q21 do not know the answer 
-- q22
WITH course_counts AS (
    SELECT c.course_id, c.course_name, COUNT(e.enrollment_id) AS enrollment_count
    FROM courses c
    LEFT JOIN enrollments e ON e.course_id = c.course_id
    GROUP BY c.course_id, c.course_name
),
avg_count AS (
    SELECT AVG(enrollment_count) AS avg_enrollments
    FROM course_counts
)
SELECT cc.course_name, cc.enrollment_count
FROM course_counts cc
CROSS JOIN avg_count a
WHERE cc.enrollment_count > a.avg_enrollments;
-- q23
SELECT CONCAT(p.last_name, '' , p.first_name ) AS professor_name ,
     d.department_name,
       d.budget
FROM professors p
JOIN departments d ON d.department_id = p.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);
-- q24 
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       s.email
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    WHERE e.student_id = s.student_id
); 
-- q25
WITH dept_counts AS (
    SELECT d.department_id, d.department_name, COUNT(s.student_id) AS student_count
    FROM departments d
    LEFT JOIN students s ON s.department_id = d.department_id
    GROUP BY d.department_id, d.department_name
),
avg_students AS (
    SELECT AVG(student_count) AS avg_count
    FROM dept_counts
)
SELECT dc.department_name, dc.student_count
FROM dept_counts dc
CROSS JOIN avg_students a
WHERE dc.student_count > a.avg_count;
-- q26
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(
           (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / NULLIF(COUNT(g.grade_id), 0)) * 100
       , 2) AS pass_rate_percentage
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY c.course_id, c.course_name;
-- q27
-- q28
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM enrollments e
JOIN courses c ON c.course_id = e.course_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
WHERE e.student_id = 1
ORDER BY c.course_name, g.evaluation_type;
-- q29
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COALESCE(SUM(c.credits), 0) AS total_credits
FROM professors p
LEFT JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;
-- q30
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND((COUNT(e.enrollment_id) / c.max_capacity) * 100, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING (COUNT(e.enrollment_id) / c.max_capacity) > 0.80;

  
   


 


























