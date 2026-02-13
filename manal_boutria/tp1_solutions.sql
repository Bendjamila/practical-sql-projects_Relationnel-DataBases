DROP DATABASE IF EXISTS university_db;
CREATE DATABASE IF NOT EXISTS university_db;
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
    level ENUM('L1','L2','L3','M1','M2'),
    enrollment_date DATE,
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
    semester INT CHECK (semester IN (1,2)),
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

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURDATE()),
    academic_year VARCHAR(9) NOT NULL,
    status ENUM('In Progress','Passed','Failed','Dropped') DEFAULT 'In Progress',
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, academic_year)
);

CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type ENUM('Assignment','Lab','Exam','Project'),
    grade DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
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





-- 4.1 Insert departments (4 departments)
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Ahmed hadad ', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Fatima khayat', '2012-03-15'),
('Physics', 'Building C', 400000.00, 'Dr. Omar chatri', '2011-07-20'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Khalid Tamimi', '2013-01-10');

-- 4.2 Insert professors 
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('hadad', 'Ahmed', 'ahmed.hadad@university.edu', '555-0101', 1, '2015-08-15', 85000.00, 'Artificial Intelligence'),
('khayat', 'Fatima', 'fatima.kh@university.edu', '555-0102', 2, '2016-02-20', 78000.00, 'Statistics'),
('Chatri', 'Omar', 'omar.chatri@university.edu', '555-0103', 3, '2014-09-10', 82000.00, 'Physics'),
('Tamimi', 'Khalid', 'khalid.tamimi@university.edu', '555-0104', 4, '2017-03-25', 76000.00, 'Structural Engineering'),
('Bendouda', 'Djamila', 'dja.bendouda@university.edu', '555-0106', 1, '2019-08-30', 96000.00, 'Database Systems'),
('Benkhrouf', 'Yousef', 'yousef.Ben@university.edu', '555-0107', 1, '2020-04-12', 71000.00, 'Software Engineering');

-- 4.3 Insert students 
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('CS2023001', 'Ait_hocine', 'Anas', '2002-03-15', 'anas@student.edu', '555-0201', 'Oran', 1, 'L3', '2023-09-01'),
('CS2023002', 'Bouras', 'Sara', '2003-05-22', 'sara@student.edu', '555-0202', 'Alger', 1, 'L2', '2023-09-01'),
('CS2023003', 'zegari', 'Mohamed', '2001-11-30', 'mohamed@student.edu', '555-0203', 'Skikda', 1, 'M1', '2023-09-01'),
('MATH2023001', 'Benrached', 'Hiba', '2002-07-18', 'hiba@student.edu', '555-0204', 'collo', 2, 'L3', '2023-09-01'),
('MATH2023002', 'Touati', 'Karim', '2003-02-25', 'karim@student.edu', '555-0205', 'tebessa', 2, 'L2', '2023-09-01'),
('PHY2023001', 'Braik', 'Layla', '2002-09-14', 'layla@student.edu', '555-0206', 'Ourgla', 3, 'L3', '2023-09-01'),
('CE2023001', 'Benhadef', 'Ali', '2001-12-05', 'ali@student.edu', '555-0207', 'Blida', 4, 'M1', '2023-09-01'),
('CE2023002', 'Al-Mahdi', 'Noor', '2003-04-30', 'noor@student.edu', '555-0208', 'Alger', 4, 'L2', '2023-09-01');

-- 4.4 Insert courses (7 courses)
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Introduction to Programming', 'Basic programming concepts using Python', 6, 1, 1, 1, 30),
('CS201', 'Database Systems', 'Introduction to relational databases and SQL', 5, 1, 1, 5, 25),
('CS301', 'Artificial Intelligence', 'Fundamentals of AI and machine learning', 6, 2, 1, 1, 20),
('MATH101', 'Calculus I', 'Differential and integral calculus', 6, 1, 2, 2, 35),
('MATH201', 'Linear Algebra', 'Vector spaces and linear transformations', 5, 2, 2, 2, 30),
('PHY101', 'General Physics', 'Mechanics and thermodynamics', 6, 1, 3, 3, 30),
('CE101', 'Introduction to Civil Engineering', 'Basic principles of civil engineering', 6, 1, 4, 4, 25);

-- 4.5 Insert enrollments (15 enrollments)
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1, 1, '2023-2024', 'Passed'),
(1, 2, '2023-2024', 'In Progress'),
(1, 3, '2023-2024', 'In Progress'),
(2, 1, '2023-2024', 'Passed'),
(2, 2, '2023-2024', 'In Progress'),
(3, 1, '2023-2024', 'Passed'),
(3, 3, '2023-2024', 'In Progress'),
(4, 4, '2023-2024', 'Passed'),
(4, 5, '2023-2024', 'In Progress'),
(5, 4, '2023-2024', 'In Progress'),
(6, 6, '2023-2024', 'In Progress'),
(7, 7, '2023-2024', 'In Progress'),
(8, 7, '2023-2024', 'In Progress'),
(1, 4, '2022-2023', 'Passed'),
(2, 4, '2022-2023', 'Failed');

-- 4.6 Insert grades (12 grades)
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 16.50, 0.60, '2024-01-15', 'Excellent performance'),
(1, 'Assignment', 18.00, 0.20, '2023-12-10', 'Well done'),
(1, 'Lab', 15.00, 0.20, '2023-12-20', 'Good work'),
(2, 'Assignment', 14.50, 0.30, '2024-02-10', 'Needs improvement'),
(2, 'Project', 16.00, 0.70, '2024-03-01', 'Good project'),
(4, 'Exam', 12.00, 0.60, '2024-01-20', 'Average performance'),
(4, 'Assignment', 13.50, 0.40, '2023-12-15', 'Satisfactory'),
(6, 'Exam', 17.25, 0.60, '2024-01-15', 'Very good'),
(6, 'Lab', 16.00, 0.40, '2023-12-18', 'Good practical skills'),
(8, 'Exam', 15.50, 0.60, '2024-01-25', 'Above average'),
(8, 'Assignment', 14.00, 0.40, '2023-12-20', 'Acceptable'),
(9, 'Project', 10.50, 1.00, '2024-02-28', 'Needs more effort');

USE university_db;
SELECT last_name, first_name, email, level
FROM students;
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d 
    ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;
SELECT 
    c.course_code,
    c.course_name,
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
JOIN professors p 
    ON c.professor_id = p.professor_id;
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    c.course_name,
    e.enrollment_date,
    e.status
FROM enrollments e
JOIN students s 
    ON e.student_id = s.student_id
JOIN courses c 
    ON e.course_id = c.course_id;
    SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    d.department_name,
    s.level
FROM students s
JOIN departments d
    ON s.department_id = d.department_id;
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
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
    SELECT
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c 
    ON p.professor_id = c.professor_id
GROUP BY p.professor_id;
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM grades g
JOIN enrollments e 
    ON g.enrollment_id = e.enrollment_id
JOIN students s 
    ON e.student_id = s.student_id
GROUP BY s.student_id;
SELECT
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s 
    ON d.department_id = s.department_id
GROUP BY d.department_id;
SELECT SUM(budget) AS total_budget
FROM departments;
SELECT
    d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c 
    ON d.department_id = c.department_id
GROUP BY d.department_id;
SELECT
    d.department_name,
    AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p 
    ON d.department_id = p.department_id
GROUP BY d.department_id;
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(e.status != 'Passed') = 0;
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    AVG(g.grade) AS student_avg,
    (
        SELECT AVG(g2.grade)
        FROM students s2
        JOIN enrollments e2 ON s2.student_id = e2.student_id
        JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
        WHERE s2.department_id = s.department_id
    ) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
HAVING student_avg > department_avg;
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e 
    ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING enrollment_count > (
    SELECT AVG(course_total)
    FROM (
        SELECT COUNT(*) AS course_total
        FROM enrollments
        GROUP BY course_id
    ) AS avg_table
);
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d 
    ON p.department_id = d.department_id
WHERE d.budget = (
    SELECT MAX(budget)
    FROM departments
);
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    s.email
FROM students s
LEFT JOIN enrollments e 
    ON s.student_id = e.student_id
LEFT JOIN grades g 
    ON e.enrollment_id = g.enrollment_id
WHERE g.grade IS NULL;
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s 
    ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING student_count > (
    SELECT AVG(dept_total)
    FROM (
        SELECT COUNT(*) AS dept_total
        FROM students
        GROUP BY department_id
    ) AS avg_table
);
SELECT 
    c.course_name,
    COUNT(g.grade_id) AS total_grades,
    SUM(g.grade >= 10) AS passed_grades,
    (SUM(g.grade >= 10) / COUNT(g.grade_id)) * 100 AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;
SELECT 
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    g.grade * g.coefficient AS weighted_grade
FROM grades g
JOIN enrollments e 
    ON g.enrollment_id = e.enrollment_id
JOIN courses c 
    ON e.course_id = c.course_id
WHERE e.student_id = 1;
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c 
    ON p.professor_id = c.professor_id
GROUP BY p.professor_id;
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    (COUNT(e.enrollment_id) / c.max_capacity) * 100 AS percentage_full
FROM courses c
LEFT JOIN enrollments e 
    ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;










