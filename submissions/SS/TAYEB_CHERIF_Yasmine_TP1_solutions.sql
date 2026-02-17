CREATE DATABASE uni_db;
USE uni_db;
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
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_level
        CHECK (level IN ('L1','L2','L3','M1','M2')),

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
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',

    CONSTRAINT chk_status
        CHECK (status IN ('In Progress','Passed','Failed','Dropped')),

    CONSTRAINT unique_enrollment
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
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,

    CONSTRAINT chk_eval_type
        CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),

    CONSTRAINT chk_grade
        CHECK (grade BETWEEN 0 AND 20),

    CONSTRAINT fk_grade_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
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

INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Grace Hopper', '2000-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Carl Gauss', '1998-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Marie Curie', '1995-09-01'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Isambard Brunel', '2005-09-01');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Williams', 'Alice', 'alice.williams@uni.com', '0550000001', 1, '2015-09-01', 90000.00, 'Artificial Intelligence'),
('Davis', 'Robert', 'robert.davis@uni.com', '0550000002', 1, '2017-09-01', 85000.00, 'Data Science'),
('Miller', 'Sophia', 'sophia.miller@uni.com', '0550000003', 1, '2018-09-01', 80000.00, 'Cybersecurity'),
('Wilson', 'James', 'james.wilson@uni.com', '0550000004', 2, '2016-09-01', 78000.00, 'Algebra'),
('Moore', 'Olivia', 'olivia.moore@uni.com', '0550000005', 3, '2014-09-01', 92000.00, 'Quantum Physics'),
('Taylor', 'Ethan', 'ethan.taylor@uni.com', '0550000006', 4, '2019-09-01', 87000.00, 'Structural Engineering');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level) VALUES
('S1001', 'Benali', 'Lina', '2003-05-10', 'lina.benali@uni.com', '0660000001', 'Algiers', 1, 'L2'),
('S1002', 'Mansour', 'Karim', '2002-07-12', 'karim.mansour@uni.com', '0660000002', 'Oran', 1, 'L3'),
('S1003', 'Cherif', 'Amira', '2001-03-22', 'amira.cherif@uni.com', '0660000003', 'Constantine', 1, 'M1'),
('S1004', 'Bouhassoun', 'Sami', '2003-11-02', 'sami.bouhassoun@uni.com', '0660000004', 'Blida', 2, 'L2'),
('S1005', 'Zerguine', 'Nour', '2002-09-15', 'nour.zerguine@uni.com', '0660000005', 'Setif', 2, 'L3'),
('S1006', 'Karim', 'Youssef', '2001-01-20', 'youssef.karim@uni.com', '0660000006', 'Annaba', 3, 'M1'),
('S1007', 'Bensalem', 'Salma', '2003-06-18', 'salma.bensalem@uni.com', '0660000007', 'Tlemcen', 4, 'L2'),
('S1008', 'Amrani', 'Rami', '2002-12-30', 'rami.amrani@uni.com', '0660000008', 'Batna', 4, 'L3');
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Database Systems', 'Introduction to databases', 6, 1, 1, 1, 30),
('CS102', 'Machine Learning', 'Supervised and unsupervised learning', 5, 2, 1, 2, 30),
('CS103', 'Cybersecurity Fundamentals', 'Security principles', 5, 1, 1, 3, 30),
('MATH201', 'Linear Algebra', 'Matrices and vector spaces', 6, 1, 2, 4, 30),
('PHY301', 'Quantum Mechanics', 'Quantum theory basics', 5, 2, 3, 5, 30),
('CE401', 'Structural Analysis', 'Structures and forces', 6, 1, 4, 6, 30),
('CS104', 'Data Structures', 'Algorithms and structures', 5, 2, 1, 1, 30);
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES
(1,1,'2024-2025','Passed'),
(1,2,'2024-2025','Failed'),
(2,1,'2024-2025','Passed'),
(2,3,'2023-2024','Passed'),
(3,2,'2024-2025','In Progress'),
(3,4,'2023-2024','Passed'),
(4,4,'2024-2025','In Progress'),
(5,4,'2024-2025','In Progress'),
(6,5,'2024-2025','In Progress'),
(7,6,'2024-2025','In Progress'),
(8,6,'2023-2024','Passed'),
(2,7,'2024-2025','In Progress'),
(3,7,'2024-2025','In Progress'),
(5,2,'2024-2025','Passed'),
(6,3,'2023-2024','Passed');
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(20,'Assignment',15,1,'2024-11-10','Good work'),
(18,'Exam',14,2,'2024-12-15','Solid performance'),
(16,'Exam',16,2,'2024-06-10','Very good'),
(17,'Project',17,1.5,'2024-05-20','Excellent'),
(12,'Exam',14,2,'2024-06-18','Good'),
(6,'Exam',10,2,'2024-12-20','Needs improvement'),
(9,'Lab',13,1,'2024-11-22','Satisfactory'),
(11,'Exam',18,2,'2024-05-15','Outstanding'),
(12,'Assignment',12,1,'2024-11-18','Correct'),
(13,'Exam',15,2,'2024-12-10','Good'),
(16,'Project',16,1.5,'2024-12-12','Very good'),
(15,'Exam',14,2,'2024-06-10','Good');


-- Q1
SELECT last_name, first_name, email, level FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';

-- Q5
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;

-- Q6
SELECT c.course_code,
       c.course_name,
       CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12
SELECT d.department_name,
       COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13
SELECT SUM(budget) AS total_budget FROM departments;

-- Q14
SELECT d.department_name,
       COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15
SELECT d.department_name,
       AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.status != 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- Q21
SELECT student_name, student_avg, department_avg
FROM (
    SELECT s.student_id,
           CONCAT(s.last_name,' ',s.first_name) AS student_name,
           s.department_id,
           AVG(g.grade) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) AS student_avg_table
JOIN (
    SELECT s.department_id,
           AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) AS dept_avg_table
ON student_avg_table.department_id = dept_avg_table.department_id
WHERE student_avg > department_avg;

-- Q22
SELECT c.course_name,
       COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM enrollments
        GROUP BY course_id
    ) AS avg_table
);

-- Q23
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT CONCAT(s.last_name,' ',s.first_name) AS student_name,
       s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25
SELECT department_name, student_count
FROM (
    SELECT d.department_name,
           COUNT(s.student_id) AS student_count
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id
) AS dept_counts
WHERE student_count > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM students
        GROUP BY department_id
    ) AS avg_table
);

-- Q26
SELECT c.course_name,
       COUNT(g.grade_id) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(
           SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0
           / COUNT(g.grade_id), 2
       ) AS pass_rate_percentage
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_id;

-- Q27
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank_position,
       CONCAT(s.last_name,' ',s.first_name) AS student_name,
       AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q28
SELECT c.course_name,
       g.evaluation_type,
       g.grade,
       g.coefficient,
       (g.grade * g.coefficient) AS weighted_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_id = 1;

-- Q29
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND(COUNT(e.enrollment_id) * 100.0 / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > (0.8 * c.max_capacity);



  
