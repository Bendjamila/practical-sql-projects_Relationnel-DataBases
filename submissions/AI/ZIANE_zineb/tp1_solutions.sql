-- ============================================
-- TP1: University Management System
-- Complete Solution with 30 SQL Queries
-- ============================================

DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- Drop existing tables (if any)
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS departments;

-- ========== CREATE TABLES ==========

-- Table 1: departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- Table 2: professors
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table 3: students
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
    enrollment_date DATE DEFAULT (CURDATE()),
    CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table 4: courses
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
    CHECK (credits > 0),
    CHECK (semester BETWEEN 1 AND 2),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) 
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table 5: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURDATE()),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE KEY unique_enrollment (student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 6: grades
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    CHECK (grade BETWEEN 0 AND 20),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- ========== CREATE INDEXES ==========

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- ========== INSERT TEST DATA ==========

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'A', 500000, 'Dr. Ahmed', '2020-01-01'),
('Mathematics', 'B', 350000, 'Dr. Fatima', '2020-01-01'),
('Physics', 'C', 400000, 'Dr. Hassan', '2020-01-01'),
('Civil Engineering', 'D', 600000, 'Dr. Layla', '2020-01-01');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Youssef', 'Ali', 'ali.youssef@uni.com', '0601234567', 1, '2020-09-01', 45000, 'AI/ML'),
('Mohamed', 'Sara', 'sara.mohamed@uni.com', '0602234567', 1, '2021-09-01', 42000, 'Databases'),
('Hassan', 'Karim', 'karim.hassan@uni.com', '0603234567', 1, '2019-09-01', 48000, 'Web Dev'),
('Ibrahim', 'Noor', 'noor.ibrahim@uni.com', '0604234567', 2, '2020-09-01', 40000, 'Calculus'),
('Ahmed', 'Mona', 'mona.ahmed@uni.com', '0605234567', 3, '2021-09-01', 41000, 'Physics'),
('Fatima', 'Jamal', 'jamal.fatima@uni.com', '0606234567', 4, '2020-09-01', 46000, 'Structures');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level) VALUES
('STU001', 'Al-rashid', 'Omar', '2004-01-15', 'omar@student.uni', '0612345678', '123 Main St', 1, 'L3'),
('STU002', 'Al-mansour', 'Layla', '2004-05-20', 'layla@student.uni', '0612345679', '456 Oak Ave', 1, 'L2'),
('STU003', 'Al-rasheed', 'Hana', '2005-03-10', 'hana@student.uni', '0612345680', '789 Pine Rd', 2, 'L3'),
('STU004', 'Al-kareem', 'Zainab', '2003-07-25', 'zainab@student.uni', '0612345681', '321 Elm St', 2, 'M1'),
('STU005', 'Al-aziz', 'Ibrahim', '2004-11-08', 'ibrahim@student.uni', '0612345682', '654 Maple Dr', 3, 'L2'),
('STU006', 'Al-hakim', 'Khalid', '2003-02-14', 'khalid@student.uni', '0612345683', '987 Birch Ln', 3, 'L3'),
('STU007', 'Al-latif', 'Amira', '2004-09-03', 'amira@student.uni', '0612345684', '159 Cedar St', 4, 'M1'),
('STU008', 'Al-qawi', 'Tariq', '2005-04-17', 'tariq@student.uni', '0612345685', '753 Spruce Ave', 1, 'M1');

INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Introduction to Python', 'Learn Python basics', 5, 1, 1, 1, 30),
('CS102', 'Database Design', 'SQL and database design', 6, 1, 1, 2, 25),
('CS201', 'Web Development', 'HTML, CSS, JavaScript', 5, 2, 1, 3, 28),
('MATH101', 'Calculus I', 'Differential Calculus', 5, 1, 2, 4, 35),
('PHYS101', 'Physics I', 'Mechanics', 6, 1, 3, 5, 30),
('ENG101', 'Structures', 'Building structures', 5, 2, 4, 6, 20),
('CS103', 'Data Structures', 'Arrays, Lists, Trees', 6, 2, 1, 1, 25);

INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2025-09-15', '2025-2026', 'Passed'),
(1, 2, '2025-09-15', '2025-2026', 'In Progress'),
(2, 1, '2025-09-15', '2025-2026', 'Passed'),
(2, 4, '2025-09-15', '2025-2026', 'Passed'),
(3, 4, '2025-09-15', '2025-2026', 'In Progress'),
(3, 5, '2025-09-15', '2025-2026', 'Passed'),
(4, 2, '2025-09-15', '2025-2026', 'Failed'),
(4, 3, '2025-09-15', '2025-2026', 'Passed'),
(5, 5, '2025-09-15', '2025-2026', 'Passed'),
(6, 1, '2025-09-15', '2025-2026', 'Passed'),
(6, 2, '2025-09-15', '2025-2026', 'Passed'),
(6, 3, '2025-09-15', '2025-2026', 'In Progress'),
(7, 6, '2025-09-15', '2025-2026', 'In Progress'),
(8, 1, '2025-09-15', '2025-2026', 'Passed'),
(8, 2, '2025-09-15', '2025-2026', 'In Progress');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 15, 1.0, '2025-10-20', 'Good'),
(1, 'Assignment', 14, 0.5, '2025-10-10', 'Well done'),
(2, 'Exam', 18, 1.0, '2025-10-20', 'Excellent'),
(3, 'Exam', 12, 1.0, '2025-10-20', 'Satisfactory'),
(3, 'Lab', 13, 0.7, '2025-10-15', 'Good'),
(4, 'Assignment', 16, 0.5, '2025-10-10', 'Very good'),
(5, 'Exam', 14, 1.0, '2025-10-20', 'Good'),
(6, 'Exam', 11, 1.0, '2025-10-20', 'Pass'),
(8, 'Exam', 17, 1.0, '2025-10-20', 'Excellent'),
(9, 'Exam', 13, 1.0, '2025-10-20', 'Good'),
(10, 'Lab', 15, 0.7, '2025-10-15', 'Very good'),
(11, 'Project', 16, 1.0, '2025-10-25', 'Outstanding');

-- ========== 30 SQL QUERIES ==========

-- Q1: List all students info
SELECT last_name, first_name, email, level
FROM students;

-- Q2: Professors from Computer Science
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3: Courses with more than 5 credits
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4: L3 level students
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5: Semester 1 courses
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- Q6: Courses with professor names
SELECT c.course_code, c.course_name, CONCAT(p.first_name, ' ', p.last_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7: Enrollments with student and course names
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8: Students with department names
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, d.department_name, s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9: Grades with names
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10: Professors with course count
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name, COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, CONCAT(p.first_name, ' ', p.last_name);

-- Q11: Average grade per student
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, CONCAT(s.first_name, ' ', s.last_name);

-- Q12: Student count per department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13: Total budget
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14: Courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;

-- Q15: Average professor salary per department
SELECT d.department_name, ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;

-- Q16: Top 3 students by average
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, CONCAT(s.first_name, ' ', s.last_name)
ORDER BY average_grade DESC
LIMIT 3;

-- Q17: Courses with no enrollments
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18: Students with passed courses
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id, CONCAT(s.first_name, ' ', s.last_name);

-- Q19: Professors teaching more than 2 courses
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name, COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, CONCAT(p.first_name, ' ', p.last_name)
HAVING COUNT(c.course_id) > 2;

-- Q20: Students enrolled in more than 2 courses
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, CONCAT(s.first_name, ' ', s.last_name)
HAVING COUNT(e.enrollment_id) > 2;

-- Q21: Students above department average
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, ROUND(AVG(g.grade), 2) AS student_avg,
(SELECT ROUND(AVG(g2.grade), 2) FROM students s2 JOIN enrollments e2 ON s2.student_id = e2.student_id 
 JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id WHERE s2.department_id = s.department_id) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id, CONCAT(s.first_name, ' ', s.last_name)
HAVING AVG(g.grade) > (SELECT AVG(g2.grade) FROM students s2 JOIN enrollments e2 ON s2.student_id = e2.student_id 
 JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id WHERE s2.department_id = s.department_id);

-- Q22: Courses above average enrollment
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (SELECT AVG(enrollment_count) FROM 
 (SELECT COUNT(e2.enrollment_id) AS enrollment_count FROM courses c2 
  LEFT JOIN enrollments e2 ON c2.course_id = e2.course_id GROUP BY c2.course_id) AS avg_enrollments);

-- Q23: Professors from highest budget department
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24: Students with no grades
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25: Departments above average student count
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (SELECT AVG(student_count) FROM 
 (SELECT COUNT(s2.student_id) AS student_count FROM departments d2 
  LEFT JOIN students s2 ON d2.department_id = s2.department_id GROUP BY d2.department_id) AS avg_students);

-- Q26: Pass rate per course
SELECT c.course_name, COUNT(g.grade_id) AS total_grades, 
SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
ROUND((SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0) / COUNT(g.grade_id), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27: Student ranking (NO WINDOW FUNCTIONS - MySQL 5.7 compatible)
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, CONCAT(s.first_name, ' ', s.last_name)
ORDER BY average_grade DESC;

-- Q28: Report card for student 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1
ORDER BY c.course_name, g.evaluation_type;

-- Q29: Teaching load per professor
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, CONCAT(p.first_name, ' ', p.last_name);

-- Q30: Overloaded courses (>80% capacity)
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity,
ROUND((COUNT(e.enrollment_id) * 100.0) / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING (COUNT(e.enrollment_id) * 100.0) / c.max_capacity > 80;