-- TP1: University Management System Solutions
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
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
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
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
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- Inserting Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES ('Computer Science', 'Building A', 500000, 'Dr. Mansouri', '2010-09-01');

INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES ('Mathematics', 'Building B', 350000, 'Dr. Belkacem', '2010-09-01');

INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES ('Physics', 'Building C', 400000, 'Dr. Haddad', '2012-09-01');

INSERT INTO departments (department_name, building, budget, department_head, creation_date)
VALUES ('Civil Engineering', 'Building D', 600000, 'Dr. Bouaziz', '2011-09-01');

-- Inserting Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES ('Haddad', 'Mohamed', 'mohamed.haddad93@example.dz', '0550123450', 1, '2015-01-01', 50000, 'AI');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES ('Amrani', 'Abdelkader', 'abdelkader.amrani47@example.dz', '0550123451', 1, '2015-01-01', 55000, 'Database');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES ('Bensmail', 'Brahim', 'brahim.bensmail48@example.dz', '0550123452', 1, '2015-01-01', 60000, 'Networks');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES ('Mansouri', 'Faycal', 'faycal.mansouri36@example.dz', '0550123453', 2, '2015-01-01', 65000, 'Algebra');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES ('Bensmail', 'Riad', 'riad.bensmail81@example.dz', '0550123454', 3, '2015-01-01', 70000, 'Quantum Physics');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES ('Bouaziz', 'Faycal', 'faycal.bouaziz63@example.dz', '0550123455', 4, '2015-01-01', 75000, 'Structural Design');

-- Inserting Students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1000', 'Amrani', 'Brahim', '2000-01-01', 'brahim.amrani89@example.dz', '0660123450', 'Algiers, Algeria', 1, 'L2');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1001', 'Saidi', 'Rania', '2000-01-01', 'rania.saidi92@example.dz', '0660123451', 'Algiers, Algeria', 2, 'L2');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1002', 'Bouaziz', 'Ahmed', '2000-01-01', 'ahmed.bouaziz88@example.dz', '0660123452', 'Algiers, Algeria', 3, 'M1');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1003', 'Benali', 'Leila', '2000-01-01', 'leila.benali59@example.dz', '0660123453', 'Algiers, Algeria', 4, 'M1');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1004', 'Amrani', 'Mohamed', '2000-01-01', 'mohamed.amrani9@example.dz', '0660123454', 'Algiers, Algeria', 1, 'L3');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1005', 'Hamidi', 'Lydia', '2000-01-01', 'lydia.hamidi12@example.dz', '0660123455', 'Algiers, Algeria', 2, 'M1');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1006', 'Haddad', 'Riad', '2000-01-01', 'riad.haddad43@example.dz', '0660123456', 'Algiers, Algeria', 3, 'L2');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1007', 'Amrani', 'Amel', '2000-01-01', 'amel.amrani66@example.dz', '0660123457', 'Algiers, Algeria', 4, 'L3');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1008', 'Belkacem', 'Ahmed', '2000-01-01', 'ahmed.belkacem48@example.dz', '0660123458', 'Algiers, Algeria', 1, 'L2');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level)
VALUES ('STU1009', 'Benali', 'Ines', '2000-01-01', 'ines.benali88@example.dz', '0660123459', 'Algiers, Algeria', 2, 'L3');

-- Inserting Courses
INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('CS101', 'Intro to Programming', 6, 1, 1, 1);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('CS202', 'Database Systems', 6, 2, 1, 2);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('CS303', 'Artificial Intelligence', 5, 1, 1, 3);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('MA101', 'Calculus I', 6, 1, 2, 4);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('PH101', 'General Physics', 6, 1, 3, 5);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('CE101', 'Statics', 6, 1, 4, 6);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id)
VALUES ('CS404', 'Network Security', 5, 2, 1, 1);

-- Inserting Enrollments
INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (1, 1, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (2, 2, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (3, 3, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (4, 4, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (5, 5, '2024-2025', 'Failed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (6, 6, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (7, 7, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (8, 1, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (9, 2, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (10, 3, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (1, 4, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (2, 5, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (3, 6, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (4, 7, '2024-2025', 'Failed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (5, 1, '2024-2025', 'In Progress');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (6, 2, '2024-2025', 'Failed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (7, 3, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (8, 4, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (9, 5, '2024-2025', 'Passed');

INSERT IGNORE INTO enrollments (student_id, course_id, academic_year, status)
VALUES (10, 6, '2024-2025', 'Failed');

-- Inserting Grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (1, 'Assignment', 17.41, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (2, 'Project', 11.24, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (3, 'Assignment', 10.58, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (4, 'Project', 11.66, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (5, 'Exam', 17.99, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (6, 'Project', 10.35, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (7, 'Lab', 11.32, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (8, 'Project', 11.91, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (9, 'Project', 10.19, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (10, 'Project', 10.47, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (11, 'Project', 13.71, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (12, 'Assignment', 14.66, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (13, 'Lab', 17.97, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (14, 'Exam', 14.17, 1.0, '2025-01-15');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES (15, 'Exam', 12.31, 1.0, '2025-01-15');

-- ========== TP1 QUERIES SOLUTIONS ==========

-- Q1.
SELECT last_name, first_name, email, level
FROM students;

-- Q2.
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3.
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4.
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5.
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- Q6.
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, d.department_name, s.level
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Q9.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, c.course_name, g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12.
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13.
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14.
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15.
SELECT d.department_name, AVG(p.salary) AS average_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17.
SELECT course_code, course_name
FROM courses
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM enrollments);

-- Q18.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) = (SELECT COUNT(*) FROM enrollments e2 WHERE e2.student_id = s.student_id);

-- Q19.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 2;

-- Q21.
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS student_avg,
    (SELECT AVG(g2.grade)
     FROM grades g2
     JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
     JOIN students s2 ON e2.student_id = s2.student_id
     WHERE s2.department_id = s.department_id) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
HAVING student_avg > department_avg;

-- Q22.
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING enrollment_count > (SELECT COUNT(*) / COUNT(DISTINCT course_id) FROM enrollments);

-- Q23.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24.
SELECT CONCAT(last_name, ' ', first_name) AS student_name, email
FROM students
WHERE student_id NOT IN (SELECT DISTINCT e.student_id FROM enrollments e JOIN grades g ON e.enrollment_id = g.enrollment_id);

-- Q25.
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING student_count > (SELECT COUNT(*) / COUNT(DISTINCT department_id) FROM departments);

-- Q26.
SELECT c.course_name, COUNT(g.grade_id) AS total_grades,
    SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
    (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id)) * 100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27.
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS `rank`,
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q28.
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, (g.grade * g.coefficient) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30.
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity,
    (COUNT(e.enrollment_id) / c.max_capacity) * 100 AS percentage_full
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
