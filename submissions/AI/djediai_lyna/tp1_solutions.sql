-- ============================================
-- TP1: University Management System
-- Student: DJEDIDI Lyna
-- ============================================


-- ============================================
-- PART I : SCHEMA (TABLE CREATION)
-- ============================================
CREATE DATABASE university_db;
-- =========================================
-- TABLE 1: departments
-- =========================================
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- =========================================
-- TABLE 2: professors
-- =========================================
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    specialization VARCHAR(100),

    CONSTRAINT fk_prof_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- =========================================
-- TABLE 3: students
-- =========================================
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20),
    enrollment_date DATE DEFAULT CURRENT_DATE,

    CONSTRAINT chk_student_level
        CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),

    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- =========================================
-- TABLE 4: courses
-- =========================================
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,

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

-- =========================================
-- TABLE 5: enrollments
-- =========================================
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress'
        CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),

    CONSTRAINT uq_student_course_year
        UNIQUE (student_id, course_id, academic_year),

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

-- =========================================
-- TABLE 6: grades
-- =========================================
CREATE TABLE grades (
    grade_id SERIAL PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30)
        CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade DECIMAL(5,2)
        CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,

    CONSTRAINT fk_grade_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================================
-- INDEXES
-- =========================================
CREATE INDEX idx_student_department 
ON students(department_id);

CREATE INDEX idx_course_professor 
ON courses(professor_id);

CREATE INDEX idx_enrollment_student 
ON enrollments(student_id);

CREATE INDEX idx_enrollment_course 
ON enrollments(course_id);

CREATE INDEX idx_grades_enrollment 
ON grades(enrollment_id);

-- ============================================
-- PART II: DATA INSERTION
-- ============================================
-- DEPARTMENTS
-- =========================================
INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES
('Computer Science', 'Building A', 500000, 'Dr. Ahmed Benali', DATE '2005-09-01'),
('Mathematics', 'Building B', 350000, 'Dr. Sara Khelifi', DATE '2003-09-01'),
('Physics', 'Building C', 400000, 'Dr. Yacine Haddad', DATE '2004-09-01'),
('Civil Engineering', 'Building D', 600000, 'Dr. Nadia Mansouri', DATE '2006-09-01');


-- =========================================
-- PROFESSORS
-- =========================================
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES
('Benali', 'Karim', 'karim.benali@univ.dz', '0550000001', 1, DATE '2015-09-01', 120000, 'Artificial Intelligence'),
('Rahmani', 'Lina', 'lina.rahmani@univ.dz', '0550000002', 1, DATE '2017-09-01', 110000, 'Databases'),
('Toumi', 'Amine', 'amine.toumi@univ.dz', '0550000003', 1, DATE '2018-09-01', 100000, 'Networks'),
('Khelifi', 'Samir', 'samir.khelifi@univ.dz', '0550000004', 2, DATE '2016-09-01', 95000, 'Algebra'),
('Haddad', 'Rania', 'rania.haddad@univ.dz', '0550000005', 3, DATE '2014-09-01', 105000, 'Quantum Mechanics'),
('Mansouri', 'Adel', 'adel.mansouri@univ.dz', '0550000006', 4, DATE '2013-09-01', 115000, 'Structural Engineering');


-- =========================================
-- STUDENTS
-- =========================================
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES
('S1001','Ali','Youssef',DATE '2003-05-12','youssef.ali@etu.dz','0661000001','Algiers',1,'L2'),
('S1002','Ziani','Imane',DATE '2002-07-20','imane.ziani@etu.dz','0661000002','Oran',1,'L3'),
('S1003','Boukhalfa','Nassim',DATE '2001-03-15','nassim.b@etu.dz','0661000003','Constantine',1,'M1'),
('S1004','Cherif','Aya',DATE '2003-11-02','aya.cherif@etu.dz','0661000004','Blida',2,'L2'),
('S1005','Saadi','Omar',DATE '2002-01-18','omar.saadi@etu.dz','0661000005','Setif',2,'L3'),
('S1006','Hamdi','Salma',DATE '2001-09-09','salma.hamdi@etu.dz','0661000006','Annaba',3,'M1'),
('S1007','Farouk','Riad',DATE '2003-06-30','riad.farouk@etu.dz','0661000007','Tlemcen',4,'L2'),
('S1008','Bensaid','Nour',DATE '2002-12-25','nour.bensaid@etu.dz','0661000008','Bejaia',4,'L3');


-- =========================================
-- COURSES
-- =========================================
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity)
VALUES
('CS101','Database Systems','Introduction to relational databases',6,1,1,2,40),
('CS102','Artificial Intelligence','AI concepts and algorithms',6,2,1,1,35),
('CS103','Computer Networks','Networking fundamentals',5,1,1,3,30),
('MATH201','Linear Algebra','Matrices and vector spaces',5,1,2,4,30),
('PHYS301','Quantum Physics','Introduction to quantum theory',6,2,3,5,25),
('CIV401','Structural Analysis','Structures and forces',6,1,4,6,30),
('CS104','Web Development','Frontend and backend basics',5,2,1,2,30);


-- =========================================
-- ENROLLMENTS (15)
-- =========================================
INSERT INTO enrollments (student_id, course_id, academic_year, status)
VALUES
(1,1,'2024-2025','In Progress'),
(1,2,'2024-2025','In Progress'),
(2,1,'2024-2025','Passed'),
(2,3,'2024-2025','In Progress'),
(3,2,'2024-2025','Passed'),
(3,7,'2024-2025','In Progress'),
(4,4,'2024-2025','In Progress'),
(5,4,'2023-2024','Passed'),
(6,5,'2024-2025','In Progress'),
(7,6,'2024-2025','In Progress'),
(8,6,'2023-2024','Failed'),
(1,3,'2023-2024','Passed'),
(2,2,'2023-2024','Failed'),
(4,1,'2024-2025','In Progress'),
(5,7,'2024-2025','In Progress');


-- =========================================
-- GRADES (12)
-- =========================================
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
SELECT enrollment_id, 'Assignment', 15, 1.00, DATE '2024-11-10', 'Good work'
FROM enrollments
ORDER BY enrollment_id
LIMIT 3;

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
SELECT enrollment_id, 'Exam', 14, 2.00, DATE '2024-12-15', 'Well done'
FROM enrollments
ORDER BY enrollment_id
LIMIT 3 OFFSET 3;

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
SELECT enrollment_id, 'Project', 16, 2.00, DATE '2024-12-20', 'Excellent'
FROM enrollments
ORDER BY enrollment_id
LIMIT 3 OFFSET 6;

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
SELECT enrollment_id, 'Lab', 13, 1.00, DATE '2024-11-25', 'Good lab'
FROM enrollments
ORDER BY enrollment_id
LIMIT 3 OFFSET 9;

-- ============================================
-- PART III: QUERIES (Q1–Q30)
-- ============================================
-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information
SELECT last_name,
       first_name,
       email,
       level
FROM students;


-- Q2. Display all professors from the Computer Science department
SELECT p.last_name,
       p.first_name,
       p.email,
       p.specialization
FROM professors p
JOIN departments d 
     ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';


-- Q3. Find all courses with more than 5 credits
SELECT course_code,
       course_name,
       credits
FROM courses
WHERE credits > 5;


-- Q4. List students enrolled in L3 level
SELECT student_number,
       last_name,
       first_name,
       email
FROM students
WHERE level = 'L3';


-- Q5. Display courses from semester 1
SELECT course_code,
       course_name,
       credits,
       semester
FROM courses
WHERE semester = 1;


-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
SELECT c.course_code,
       c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p
       ON c.professor_id = p.professor_id;


-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s 
     ON e.student_id = s.student_id
JOIN courses c 
     ON e.course_id = c.course_id;


-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d
       ON s.department_id = d.department_id;


-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e 
     ON g.enrollment_id = e.enrollment_id
JOIN students s 
     ON e.student_id = s.student_id
JOIN courses c 
     ON e.course_id = c.course_id;


-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c
       ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
ORDER BY number_of_courses DESC;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(AVG(g.grade * g.coefficient) / NULLIF(AVG(g.coefficient),0), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC;


-- Q12. Count the number of students per department
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY student_count DESC;


-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;


-- Q14. Find the total number of courses per department
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name
ORDER BY course_count DESC;


-- Q15. Calculate the average salary of professors per department
SELECT d.department_name,
       ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name
ORDER BY average_salary DESC;


-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(AVG(g.grade * g.coefficient) / NULLIF(AVG(g.coefficient),0), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC
LIMIT 3;


-- Q17. List courses with no enrolled students
SELECT c.course_code,
       c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;


-- Q18. Display students who have passed all their courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) > 0
   AND COUNT(e.enrollment_id) = 
       COUNT(CASE WHEN e.status = 'Passed' THEN 1 END);


-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2
ORDER BY courses_taught DESC;


-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.course_id) > 2
ORDER BY enrolled_courses_count DESC;


-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
WITH student_avg AS (
    SELECT s.student_id,
           s.department_id,
           CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           AVG(g.grade) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.department_id, s.last_name, s.first_name
),
department_avg AS (
    SELECT s.department_id,
           AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
)
SELECT sa.student_name,
       ROUND(sa.student_avg, 2) AS student_avg,
       ROUND(da.department_avg, 2) AS department_avg
FROM student_avg sa
JOIN department_avg da
     ON sa.department_id = da.department_id
WHERE sa.student_avg > da.department_avg;



-- Q22. List courses with more enrollments than the average number of enrollments
SELECT c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) >
       (SELECT AVG(course_count)
        FROM (
            SELECT COUNT(*) AS course_count
            FROM enrollments
            GROUP BY course_id
        ) sub);



-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);



-- Q24. Find students with no grades recorded
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;



-- Q25. List departments with more students than the average
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) >
       (SELECT AVG(student_count)
        FROM (
            SELECT COUNT(*) AS student_count
            FROM students
            GROUP BY department_id
        ) sub);



-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10)
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       COUNT(CASE WHEN g.grade >= 10 THEN 1 END) AS passed_grades,
       ROUND(
           (COUNT(CASE WHEN g.grade >= 10 THEN 1 END) * 100.0) 
           / NULLIF(COUNT(g.grade_id),0), 2
       ) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;



-- Q27. Display student ranking by descending average
WITH student_avg AS (
    SELECT s.student_id,
           CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           AVG(g.grade) AS average_grade
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id, s.last_name, s.first_name
)
SELECT RANK() OVER (ORDER BY average_grade DESC) AS rank,
       student_name,
       ROUND(average_grade,2) AS average_grade
FROM student_avg;



-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;



-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
ORDER BY total_credits DESC;



-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND((COUNT(e.enrollment_id) * 100.0) / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING COUNT(e.enrollment_id) > (0.8 * c.max_capacity);
