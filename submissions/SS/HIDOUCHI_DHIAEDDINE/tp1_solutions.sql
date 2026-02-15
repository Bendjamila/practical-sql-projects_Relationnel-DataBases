-- ============================================
-- TP1: University Management System - Solutions
-- ============================================

-- 1) Database creation
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

-- 2) Tables
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
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
    CONSTRAINT fk_professors_department
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
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date DATE,
    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
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
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_courses_professor
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
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    CONSTRAINT fk_enrollments_student
        FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enrollments_course
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_enrollment_unique
        UNIQUE (student_id, course_id, academic_year)
);

CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade DECIMAL(5, 2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT fk_grades_enrollment
        FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 3) Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4) Test data inserts
INSERT INTO departments (department_id, department_name, building, budget, department_head, creation_date) VALUES
(1, 'Computer Science', 'Building A', 500000.00, 'Dr. Turing', '2010-09-01'),
(2, 'Mathematics', 'Building B', 350000.00, 'Dr. Noether', '2008-09-01'),
(3, 'Physics', 'Building C', 400000.00, 'Dr. Einstein', '2005-09-01'),
(4, 'Civil Engineering', 'Building D', 600000.00, 'Dr. Brunel', '2012-09-01');

INSERT INTO professors (professor_id, last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
(1, 'Turing', 'Alan', 'alan.turing@univ.edu', '555-1001', 1, '2015-09-01', 72000.00, 'Algorithms'),
(2, 'Hopper', 'Grace', 'grace.hopper@univ.edu', '555-1002', 1, '2012-09-01', 78000.00, 'Programming Languages'),
(3, 'Dijkstra', 'Edsger', 'edsger.dijkstra@univ.edu', '555-1003', 1, '2018-09-01', 70000.00, 'Software Engineering'),
(4, 'Noether', 'Emmy', 'emmy.noether@univ.edu', '555-2001', 2, '2010-09-01', 68000.00, 'Algebra'),
(5, 'Einstein', 'Albert', 'albert.einstein@univ.edu', '555-3001', 3, '2009-09-01', 75000.00, 'Relativity'),
(6, 'Brunel', 'Isambard', 'isambard.brunel@univ.edu', '555-4001', 4, '2014-09-01', 69000.00, 'Structures');

INSERT INTO students (student_id, student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
(1, 'S1001', 'Doe', 'John', '2002-05-15', 'john.doe@univ.edu', '555-9001', '12 Main St', 1, 'L3', '2021-09-01'),
(2, 'S1002', 'Smith', 'Jane', '2001-11-20', 'jane.smith@univ.edu', '555-9002', '34 Oak St', 1, 'M1', '2020-09-01'),
(3, 'S1003', 'Ahmed', 'Ali', '2003-02-10', 'ali.ahmed@univ.edu', '555-9003', '56 Pine St', 2, 'L2', '2022-09-01'),
(4, 'S1004', 'Lee', 'Sara', '2002-07-08', 'sara.lee@univ.edu', '555-9004', '78 Cedar St', 3, 'L3', '2021-09-01'),
(5, 'S1005', 'Brown', 'Mark', '2003-03-12', 'mark.brown@univ.edu', '555-9005', '90 Birch St', 4, 'L2', '2022-09-01'),
(6, 'S1006', 'Chen', 'Lina', '2000-12-01', 'lina.chen@univ.edu', '555-9006', '102 Maple St', 1, 'M2', '2019-09-01'),
(7, 'S1007', 'Khaled', 'Omar', '2002-09-25', 'omar.khaled@univ.edu', '555-9007', '11 Elm St', 2, 'L3', '2021-09-01'),
(8, 'S1008', 'Patel', 'Nina', '2001-04-18', 'nina.patel@univ.edu', '555-9008', '22 Walnut St', 3, 'M1', '2020-09-01');

INSERT INTO courses (course_id, course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
(1, 'CS101', 'Introduction to Programming', 'Basics of programming in C', 6, 1, 1, 1, 5),
(2, 'CS102', 'Data Structures', 'Lists, trees, graphs', 6, 2, 1, 2, 30),
(3, 'CS201', 'Algorithms', 'Algorithm design and analysis', 5, 1, 1, 3, 30),
(4, 'MATH101', 'Calculus I', 'Limits, derivatives, integrals', 5, 1, 2, 4, 30),
(5, 'PHYS101', 'Mechanics', 'Classical mechanics', 5, 2, 3, 5, 30),
(6, 'CIV101', 'Statics', 'Forces and equilibrium', 5, 1, 4, 6, 30),
(7, 'CS301', 'Databases', 'Relational database systems', 6, 2, 1, 2, 30),
(8, 'CS202', 'Operating Systems', 'Processes, memory, and files', 5, 2, 1, 2, 30);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, 1, '2024-09-10', '2024-2025', 'Passed'),
(2, 1, 2, '2024-09-10', '2024-2025', 'Passed'),
(3, 1, 4, '2024-09-12', '2024-2025', 'Passed'),
(4, 2, 1, '2024-09-10', '2024-2025', 'In Progress'),
(5, 2, 3, '2024-09-11', '2024-2025', 'Failed'),
(6, 3, 4, '2023-09-10', '2023-2024', 'Passed'),
(7, 3, 5, '2023-09-12', '2023-2024', 'Dropped'),
(8, 4, 5, '2024-09-10', '2024-2025', 'In Progress'),
(9, 4, 1, '2024-09-10', '2024-2025', 'Passed'),
(10, 5, 6, '2024-09-10', '2024-2025', 'Passed'),
(11, 6, 7, '2024-09-10', '2024-2025', 'In Progress'),
(12, 6, 2, '2024-09-10', '2024-2025', 'Passed'),
(13, 6, 3, '2024-09-11', '2024-2025', 'In Progress'),
(14, 7, 4, '2024-09-12', '2024-2025', 'In Progress'),
(15, 8, 5, '2024-09-10', '2024-2025', 'Passed'),
(16, 8, 2, '2024-09-10', '2024-2025', 'Passed');

INSERT INTO grades (grade_id, enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 1, 'Exam', 16.00, 0.60, '2024-12-15', 'Final exam'),
(2, 1, 'Lab', 18.00, 0.40, '2024-11-20', 'Lab work'),
(3, 2, 'Exam', 14.00, 0.70, '2024-12-16', 'Final exam'),
(4, 2, 'Project', 15.00, 0.30, '2024-12-01', 'Course project'),
(5, 3, 'Exam', 13.00, 1.00, '2024-12-18', 'Final exam'),
(6, 4, 'Exam', 9.00, 1.00, '2024-12-15', 'Final exam'),
(7, 5, 'Exam', 8.00, 1.00, '2024-12-15', 'Final exam'),
(8, 6, 'Exam', 12.00, 1.00, '2023-12-15', 'Final exam'),
(9, 9, 'Exam', 11.00, 1.00, '2024-12-15', 'Final exam'),
(10, 10, 'Exam', 17.00, 1.00, '2024-12-15', 'Final exam'),
(11, 12, 'Exam', 15.00, 1.00, '2024-12-16', 'Final exam'),
(12, 15, 'Exam', 16.00, 1.00, '2024-12-16', 'Final exam');

-- 5) Queries (Q1-Q30)

-- Q1. List all students with their main information (name, email, level)
SELECT last_name, first_name, email, level
FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON d.department_id = p.department_id
WHERE d.department_name = 'Computer Science';

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

-- Q6. Display all courses with the professor's name
SELECT c.course_code, c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON p.professor_id = c.professor_id;

-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d ON d.department_id = s.department_id;

-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON e.enrollment_id = g.enrollment_id
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12. Count the number of students per department
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON c.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q15. Calculate the average salary of professors per department
SELECT d.department_name,
       AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON p.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q16. Find the top 3 students with the best averages
SELECT student_name, average_grade
FROM (
    SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           AVG(g.grade) AS average_grade
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    GROUP BY s.student_id, s.last_name, s.first_name
) AS student_avgs
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(*) > 0
   AND SUM(CASE WHEN e.status <> 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.course_id) > 2;

-- Q21. Find students with an average higher than their department's average
SELECT sa.student_name,
       sa.student_avg,
       da.department_avg
FROM (
    SELECT s.student_id,
           s.department_id,
           CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           AVG(g.grade) AS student_avg
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    GROUP BY s.student_id, s.department_id, s.last_name, s.first_name
) AS sa
JOIN (
    SELECT s.department_id,
           AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    GROUP BY s.department_id
) AS da
ON da.department_id = sa.department_id
WHERE sa.student_avg > da.department_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
SELECT c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(course_enrollments) FROM (
        SELECT COUNT(enrollment_id) AS course_enrollments
        FROM courses c2
        LEFT JOIN enrollments e2 ON e2.course_id = c2.course_id
        GROUP BY c2.course_id
    ) AS avg_counts
);

-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d ON d.department_id = p.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       s.email
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name, s.email
HAVING COUNT(g.grade_id) = 0;

-- Q25. List departments with more students than the average
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(dept_student_count) FROM (
        SELECT COUNT(s2.student_id) AS dept_student_count
        FROM departments d2
        LEFT JOIN students s2 ON s2.department_id = d2.department_id
        GROUP BY d2.department_id
    ) AS avg_dept_counts
);

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id) * 100, 2) AS pass_rate_percentage
FROM grades g
JOIN enrollments e ON e.enrollment_id = g.enrollment_id
JOIN courses c ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- Q27. Display student ranking by descending average
SELECT (@r := @r + 1) AS `rank`,
       t.student_name,
       t.average_grade
FROM (
    SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
           AVG(g.grade) AS average_grade
    FROM students s
    JOIN enrollments e ON e.student_id = s.student_id
    JOIN grades g ON g.enrollment_id = e.enrollment_id
    GROUP BY s.student_id, s.last_name, s.first_name
) AS t
CROSS JOIN (SELECT @r := 0) AS vars
ORDER BY t.average_grade DESC;

-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       (g.grade * g.coefficient) AS weighted_grade
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN courses c ON c.course_id = e.course_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
WHERE s.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
LEFT JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND(COUNT(e.enrollment_id) / c.max_capacity * 100, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING COUNT(e.enrollment_id) > (0.8 * c.max_capacity);
