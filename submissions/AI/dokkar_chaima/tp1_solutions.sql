create database university_db;
use university_db;

create table departments (
    department_id int primary key auto_increment,
    department_name varchar(100) not null,
    building varchar(50),
    budget decimal(12,2),
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
    salary decimal(10,2),
    specialization varchar(100),
    foreign key (department_id) references departments(department_id)
        on delete set null
        on update cascade
);

create table students (
    student_id int primary key auto_increment,
    student_number varchar(20) unique not null,
    last_name varchar(50) not null,
    first_name varchar(50) not null,
    date_of_birth date,
    email varchar(100) unique not null,
    phone varchar(20),
    address text,
    department_id int,
    level varchar(20) check (level in ('L1','L2','L3','M1','M2')),
    enrollment_date date default (current_date),
    foreign key (department_id) references departments(department_id)
        on delete set null
        on update cascade
);
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
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE (student_id, course_id, academic_year)
);
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5, 2),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    CHECK (grade BETWEEN 0 AND 20)
);
-- Index for faster searching of students by department
CREATE INDEX idx_student_department ON students(department_id);

-- Index for faster searching of courses by professor
CREATE INDEX idx_course_professor ON courses(professor_id);

-- Index for faster searching of enrollments by student
CREATE INDEX idx_enrollment_student ON enrollments(student_id);

-- Index for faster searching of enrollments by course
CREATE INDEX idx_enrollment_course ON enrollments(course_id);

-- Index for faster searching of grades by enrollment ID
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- Inserting the 4 required departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Alan Turing', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Katherine Johnson', '2010-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Marie Curie', '2011-01-15'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Gustave Eiffel', '2012-05-20');
-- Inserting 6 professors (3 in CS, 1 in Math, 1 in Physics, 1 in Civil Eng)
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Hopper', 'Grace', 'grace.hopper@univ.edu', '555-0101', 1, '2015-08-20', 75000.00, 'Compiler Design'),
('Knuth', 'Donald', 'donald.knuth@univ.edu', '555-0102', 1, '2012-03-15', 82000.00, 'Algorithms'),
('Berners-Lee', 'Tim', 'tim.bl@univ.edu', '555-0103', 1, '2018-09-10', 78000.00, 'Web Technologies'),
('Noether', 'Emmy', 'emmy.noether@univ.edu', '555-0201', 2, '2014-06-01', 72000.00, 'Abstract Algebra'),
('Einstein', 'Albert', 'albert.e@univ.edu', '555-0301', 3, '2010-10-10', 85000.00, 'Theoretical Physics'),
('Roebling', 'Emily', 'emily.r@univ.edu', '555-0401', 4, '2019-02-14', 70000.00, 'Bridge Construction');
-- Inserting 8 Students (L2, L3, M1 levels distributed across departments)
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, department_id, level) VALUES
('S001', 'Doe', 'Alice', '2003-05-15', 'alice.doe@univ.edu', 1, 'L2'),
('S002', 'Smith', 'Bob', '2002-11-20', 'bob.smith@univ.edu', 1, 'L3'),
('S003', 'Brown', 'Charlie', '2001-02-10', 'charlie.brown@univ.edu', 2, 'M1'),
('S004', 'Davis', 'Diana', '2003-08-30', 'diana.davis@univ.edu', 2, 'L2'),
('S005', 'Wilson', 'Eve', '2002-04-25', 'eve.wilson@univ.edu', 3, 'L3'),
('S006', 'Miller', 'Frank', '2001-12-12', 'frank.miller@univ.edu', 3, 'M1'),
('S007', 'Garcia', 'Grace', '2003-01-05', 'grace.garcia@univ.edu', 4, 'L2'),
('S008', 'Lee', 'Heidi', '2002-09-18', 'heidi.lee@univ.edu', 4, 'L3');

-- Inserting 7 Courses (5-6 credits, different semesters, assigned to professors)
INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id) VALUES
('CS101', 'Introduction to Java', 6, 1, 1, 1),
('CS202', 'Database Systems', 6, 2, 1, 2),
('AI301', 'Artificial Intelligence', 6, 1, 1, 3),
('MATH101', 'Advanced Calculus', 5, 1, 2, 4),
('PHYS101', 'Quantum Physics', 5, 2, 3, 5),
('CIV101', 'Structural Analysis', 6, 1, 4, 6),
('CS303', 'Network Security', 5, 2, 1, 3);

--  Inserting 15 Enrollments (Multiple courses per student, mix of years and statuses)
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2024-2025', 'Passed'),
(1, 2, '2024-2025', 'In Progress'),
(1, 7, '2023-2024', 'Passed'),
(2, 1, '2024-2025', 'Passed'),
(2, 3, '2024-2025', 'In Progress'),
(2, 2, '2023-2024', 'Passed'),
(3, 4, '2024-2025', 'Passed'),
(3, 7, '2023-2024', 'Passed'),
(4, 4, '2024-2025', 'Passed'),
(4, 3, '2024-2025', 'In Progress'),
(5, 5, '2024-2025', 'In Progress'),
(5, 1, '2024-2025', 'Dropped'),
(6, 5, '2024-2025', 'Passed'),
(7, 6, '2024-2025', 'Passed'),
(8, 6, '2024-2025', 'In Progress');

--  Inserting 12 Grades (Different evaluation types, coefficients, range 10-18)
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient) VALUES
(1, 'Exam', 15.50, 2.00),
(1, 'Lab', 14.00, 1.00),
(3, 'Project', 18.00, 1.50),
(4, 'Exam', 12.00, 2.00),
(6, 'Assignment', 16.50, 1.00),
(7, 'Exam', 13.00, 2.00),
(8, 'Project', 17.00, 1.50),
(9, 'Exam', 11.50, 2.00),
(13, 'Lab', 14.50, 1.00),
(14, 'Exam', 15.00, 2.00),
(1, 'Project', 16.00, 1.50),
(4, 'Lab', 10.50, 1.00);
-- queries
-- =========================================================
-- ========== PART 1 : BASIC QUERIES (Q1 → Q5) ==============
-- =========================================================

-- Q1. List all students with their main information
SELECT last_name, first_name, email, level
FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT last_name, first_name, email, specialization
FROM professors
WHERE department_id = 1;

-- Q3. Find all courses with more than 5 credits
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4. List students enrolled in L3 level
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5. Display courses from semester 1
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;


-- =========================================================
-- ========== PART 2 : JOINS (Q6 → Q10) =====================
-- =========================================================

-- Q6. Display all courses with the professor's name
SELECT c.course_code, c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name, s.level
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Q9. List grades with student name, course name, and grade
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;


-- =========================================================
-- ========== PART 3 : AGGREGATES (Q11 → Q15) ===============
-- =========================================================

-- Q11. Average grade per student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12. Number of students per department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13. Total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14. Number of courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;

-- Q15. Average salary per department
SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;


-- =========================================================
-- ========== PART 4 : ADVANCED (Q16 → Q20) =================
-- =========================================================

-- Q16. Top 3 students by average
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. Courses with no students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Students who passed all courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name
FROM students s
WHERE s.student_id NOT IN (
    SELECT student_id FROM enrollments WHERE status <> 'Passed'
);

-- Q19. Professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;

-- Q20. Students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) > 2;
-- =========================================================
-- ========== PART 5 : SUBQUERIES (Q21 → Q25) ================
-- =========================================================

-- Q21. Students with an average higher than their department average
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS student_avg,
       (
         SELECT AVG(g2.grade)
         FROM grades g2
         JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
         JOIN students s2 ON e2.student_id = s2.student_id
         WHERE s2.department_id = s.department_id
       ) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id, s.last_name, s.first_name
HAVING student_avg > department_avg;

-- Q22. Courses with more enrollments than the average
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING enrollment_count >
(
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(enrollment_id) AS cnt
        FROM enrollments
        GROUP BY course_id
    ) AS counts
);

-- Q23. Professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Students with no grades
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25. Departments with more students than the average
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING student_count >
(
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(student_id) AS cnt
        FROM students
        GROUP BY department_id
    ) AS counts
);


-- =========================================================
-- ========== PART 6 : BUSINESS ANALYSIS (Q26 → Q30) =========
-- =========================================================

-- Q26. Pass rate per course
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27. Student ranking by average
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS student_rank,
       CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q28. Report card for student 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
       (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29. Teaching load per professor
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30. Overloaded courses
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       (COUNT(e.enrollment_id) / c.max_capacity) * 100 AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING (COUNT(e.enrollment_id) / c.max_capacity) * 100 > 80;

