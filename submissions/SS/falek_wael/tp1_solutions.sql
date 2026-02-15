DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- Create tables

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

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
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

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
    level VARCHAR(20),
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20),
    UNIQUE(student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5, 2),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_student_dept ON students(department_id);
CREATE INDEX idx_course_prof ON courses(professor_id);
CREATE INDEX idx_enroll_student ON enrollments(student_id);

-- Insert data

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 520000.00, 'Wail Falek', '2015-09-01'),
('Mathematics', 'Building B', 360000.00, 'Abdemalek Kaddour', '2014-09-01'),
('Physics', 'Building C', 410000.00, 'Anes Benrahmoune', '2016-09-01'),
('Civil Engineering', 'Building D', 630000.00, 'Karim Bouzid', '2013-09-01');

INSERT INTO professors (last_name, first_name, email, department_id, salary, specialization, hire_date) VALUES
('Falek', 'Wail', 'wail.falek@uni.com', 1, 5200.00, 'Artificial Intelligence', '2018-02-10'),
('Kaddour', 'Abdemalek', 'abdemalek.kaddour@uni.com', 1, 5000.00, 'Databases', '2019-03-15'),
('Benrahmoune', 'Anes', 'anes.benrahmoune@uni.com', 1, 5400.00, 'Networks', '2017-04-20'),
('Bouzid', 'Karim', 'karim.bouzid@uni.com', 2, 4700.00, 'Algebra', '2020-01-12'),
('Rahmani', 'Samira', 'samira.rahmani@uni.com', 3, 4800.00, 'Quantum Physics', '2016-05-18'),
('Touati', 'Nabil', 'nabil.touati@uni.com', 4, 4900.00, 'Structures', '2015-06-25');

INSERT INTO students (student_number, last_name, first_name, email, department_id, level, date_of_birth) VALUES
('S101', 'Haddad', 'Youssef', 'youssef.haddad@uni.com', 1, 'L3', '2002-04-10'),
('S102', 'Benkhaled', 'Amine', 'amine.benkhaled@uni.com', 1, 'L2', '2003-05-12'),
('S103', 'Zerouki', 'Lina', 'lina.zerouki@uni.com', 2, 'M1', '2001-03-08'),
('S104', 'Meziane', 'Sara', 'sara.meziane@uni.com', 3, 'L3', '2002-07-21'),
('S105', 'Mansouri', 'Karim', 'karim.mansouri@uni.com', 1, 'M1', '2001-09-30'),
('S106', 'Belaid', 'Amel', 'amel.belaid@uni.com', 2, 'L2', '2003-11-14'),
('S107', 'Cherif', 'Riad', 'riad.cherif@uni.com', 4, 'L3', '2002-02-19'),
('S108', 'Hamidi', 'Mehdi', 'mehdi.hamidi@uni.com', 3, 'M1', '2001-12-05');

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id) VALUES
('CS201', 'Programming Fundamentals', 6, 1, 1, 1),
('CS202', 'Advanced Databases', 6, 2, 1, 2),
('CS203', 'Computer Networks', 5, 1, 1, 3),
('MA201', 'Linear Algebra', 5, 1, 2, 4),
('PH201', 'Physics I', 6, 2, 3, 5),
('CE201', 'Statics', 5, 1, 4, 6),
('CS204', 'Machine Learning', 6, 2, 1, 1);

INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1,1,'2025-2026','Passed'),
(1,2,'2025-2026','Passed'),
(1,3,'2025-2026','In Progress'),
(2,1,'2025-2026','Passed'),
(2,2,'2025-2026','Failed'),
(3,4,'2025-2026','Passed'),
(3,5,'2025-2026','In Progress'),
(4,5,'2025-2026','Passed'),
(5,1,'2025-2026','In Progress'),
(5,7,'2025-2026','In Progress'),
(6,4,'2025-2026','Passed'),
(7,6,'2025-2026','In Progress'),
(8,5,'2025-2026','Passed'),
(3,2,'2024-2025','Passed'),
(4,3,'2024-2025','Failed');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date) VALUES
(1,'Exam',15,2,'2026-01-10'),
(2,'Exam',14,2,'2026-01-11'),
(3,'Practical',13,1,'2026-01-12'),
(4,'Exam',16,2,'2026-01-13'),
(5,'Exam',8,2,'2026-01-14'),
(6,'Exam',17,2,'2026-01-15'),
(7,'Practical',14,1,'2026-01-16'),
(8,'Exam',12,2,'2026-01-17'),
(9,'Practical',15,1,'2026-01-18'),
(10,'Exam',18,2,'2026-01-19'),
(11,'Exam',11,2,'2026-01-20'),
(12,'Practical',13,1,'2026-01-21');

-- Query 1
SELECT last_name, first_name, email, level FROM students;

-- Query 2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';
-- Query 3
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Query 4
SELECT student_number, last_name, first_name
FROM students
WHERE level = 'L3';

-- Query 5
SELECT course_name, credits, semester
FROM courses
WHERE semester = 1;

-- Query 6
SELECT c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Query 7
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Query 8
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Query 9
SELECT s.last_name,
       c.course_name,
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Query 10
SELECT p.last_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Query 11
SELECT s.last_name,
       AVG(g.grade) AS average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Query 12
SELECT d.department_name,
       COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Query 13
SELECT SUM(budget) AS total_budget
FROM departments;

-- Query 14
SELECT d.department_name,
       COUNT(c.course_id) AS number_of_courses
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Query 15
SELECT d.department_name,
       AVG(p.salary) AS average_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Query 16
SELECT s.last_name,
       AVG(g.grade) AS average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average DESC
LIMIT 3;

-- Query 17
SELECT course_name
FROM courses
WHERE course_id NOT IN (
    SELECT course_id FROM enrollments
);

-- Query 18
SELECT s.last_name,
       COUNT(*) AS passed_courses
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id;

-- Query 19
SELECT p.last_name,
       COUNT(c.course_id) AS total_courses
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING total_courses > 2;

-- Query 20
SELECT s.last_name,
       COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING total_courses > 2;

-- Query 21
SELECT s.last_name,
       AVG(g.grade) AS student_average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id
HAVING student_average > (
    SELECT AVG(g2.grade)
    FROM grades g2
    JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
    JOIN students s2 ON e2.student_id = s2.student_id
    WHERE s2.department_id = s.department_id
);

-- Query 22
SELECT c.course_name,
       COUNT(e.enrollment_id) AS number_of_students
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING number_of_students > (
    SELECT COUNT(*) / COUNT(DISTINCT course_id)
    FROM enrollments
);

-- Query 23
SELECT p.last_name,
       d.department_name
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (
    SELECT MAX(budget) FROM departments
);

-- Query 24
SELECT s.last_name,
       s.email
FROM students s
WHERE s.student_id NOT IN (
    SELECT e.student_id
    FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Query 25
SELECT d.department_name,
       COUNT(s.student_id) AS number_of_students
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING number_of_students > (
    SELECT COUNT(*) / COUNT(DISTINCT department_id)
    FROM students
);

-- Query 26
SELECT c.course_name,
       (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade)) AS success_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Query 27
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank_position,
       CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Query 28
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Query 29
SELECT p.last_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Query 30
SELECT c.course_name,
       (COUNT(e.student_id) * 100.0 / c.max_capacity) AS fill_percentage
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;
