-- TP1/// University Management System (Written for Sqlite)
-- please madame use  tp1_university.sql | sqlite3 database_one.db OR add "cat" at the beggining if you are using powershell to create tables for this exact script
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;

-- Tables
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name TEXT NOT NULL,
    building TEXT,
    budget REAL,
    department_head TEXT,
    creation_date TEXT
);

CREATE TABLE professors (
    professor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    department_id INTEGER,
    hire_date TEXT,
    salary REAL,
    specialization TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    date_of_birth TEXT,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    address TEXT,
    department_id INTEGER,
    level TEXT CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date TEXT DEFAULT CURRENT_DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    course_name TEXT NOT NULL,
    description TEXT,
    credits INTEGER NOT NULL CHECK (credits > 0),
    semester INTEGER CHECK (semester BETWEEN 1 AND 2),
    department_id INTEGER,
    professor_id INTEGER,
    max_capacity INTEGER DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date TEXT DEFAULT CURRENT_DATE,
    academic_year TEXT NOT NULL,
    status TEXT DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE (student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE grades (
    grade_id INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER NOT NULL,
    evaluation_type TEXT CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade REAL CHECK (grade BETWEEN 0 AND 20),
    coefficient REAL DEFAULT 1.00,
    evaluation_date TEXT,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- Test Data
INSERT INTO departments (department_name, building, budget) VALUES 
('Computer Science', 'Building A', 500000), 
('Mathematics', 'Building B', 350000),
('Physics', 'Building C', 400000), 
('Civil Engineering', 'Building D', 600000);

INSERT INTO professors (last_name, first_name, email, department_id, salary, specialization) VALUES 
('Bensaid', 'Amine', 'a.bensaid@uni.edu', 1, 75000, 'AI'),
('Ziani', 'Rachid', 'r.ziani@uni.edu', 1, 68000, 'Databases'),
('Kacimi', 'Lydia', 'l.kacimi@uni.edu', 1, 70000, 'Cybersecurity'),
('Khelifi', 'Sofia', 's.khelifi@uni.edu', 2, 60000, 'Algebra'),
('Ould', 'Lamia', 'l.ould@uni.edu', 3, 62000, 'Optics'),
('Haddad', 'Mehdi', 'm.haddad@uni.edu', 4, 72000, 'Structures');

INSERT INTO students (student_number, last_name, first_name, email, level, department_id) VALUES 
('S001', 'Meziane', 'Yacine', 'y.mez@mail.com', 'L2', 1), 
('S002', 'Kaci', 'Rania', 'r.kaci@mail.com', 'L3', 2),
('S003', 'Saad', 'Karim', 'k.saad@mail.com', 'M1', 1), 
('S004', 'Yahia', 'Lina', 'l.yahia@mail.com', 'L3', 3),
('S005', 'Benali', 'Omar', 'o.ben@mail.com', 'L2', 1), 
('S006', 'Cherif', 'Meriem', 'm.cherif@mail.com', 'M1', 4),
('S007', 'Zouaoui', 'Samir', 's.zou@mail.com', 'L3', 2), 
('S008', 'Djerbi', 'Sofia', 's.djer@mail.com', 'L2', 1);

INSERT INTO courses (course_code, course_name, credits, semester, department_id, professor_id, max_capacity) VALUES 
('CS101', 'Intro to SQL', 6, 1, 1, 2, 50), 
('CS102', 'Algorithms', 5, 2, 1, 1, 40),
('MA101', 'Calculus', 5, 1, 2, 4, 60), 
('PH101', 'Mechanics', 5, 1, 3, 5, 30),
('CE101', 'Statics', 6, 1, 4, 6, 25), 
('CS201', 'Security', 6, 1, 1, 3, 30),
('MA201', 'Algebra II', 5, 2, 2, 4, 50);

INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES 
(1,1,'2024-2025','Passed'), (1,2,'2024-2025','In Progress'), (2,3,'2024-2025','Passed'),
(3,1,'2024-2025','Passed'), (4,4,'2024-2025','In Progress'), (5,1,'2024-2025','Failed'),
(6,5,'2024-2025','Passed'), (7,3,'2024-2025','Passed'), (8,1,'2024-2025','In Progress'),
(1,6,'2023-2024','Passed'), (2,7,'2023-2024','Passed'), (3,6,'2023-2024','Passed'),
(5,2,'2023-2024','Passed'), (7,7,'2023-2024','Passed'), (8,6,'2024-2025','In Progress');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient) VALUES 
(1,'Exam',15,1.5), (3,'Exam',12,1.5), (4,'Exam',18,1.5), (6,'Exam',8,1.5), (7,'Exam',14,1.5), 
(8,'Exam',16,1.5), (10,'Exam',17,1.5), (11,'Exam',13,1.5), (12,'Project',15,1.0), 
(13,'Assignment',14,0.5), (14,'Lab',12,1.0), (1,'Assignment',14,0.5);

-- Solutions Q1-Q30
-- Q1
SELECT last_name, first_name, email, level FROM students;
-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization FROM professors p JOIN departments d ON p.department_id = d.department_id WHERE d.department_name = 'Computer Science';
-- Q3
SELECT course_code, course_name, credits FROM courses WHERE credits > 5;
-- Q4
SELECT student_number, last_name, first_name, email FROM students WHERE level = 'L3';
-- Q5
SELECT course_code, course_name, credits, semester FROM courses WHERE semester = 1;
-- Q6
SELECT c.course_code, c.course_name, p.last_name || ' ' || p.first_name AS professor_name FROM courses c LEFT JOIN professors p ON c.professor_id = p.professor_id;
-- q7
SELECT s.last_name || ' ' || s.first_name AS student_name, c.course_name, e.enrollment_date, e.status FROM enrollments e JOIN students s ON e.student_id = s.student_id JOIN courses c ON e.course_id = c.course_id;
-- Q8
SELECT s.last_name || ' ' || s.first_name AS student_name, d.department_name, s.level FROM students s JOIN departments d ON s.department_id = d.department_id;
-- Q9
SELECT s.last_name || ' ' || s.first_name AS student_name, c.course_name, g.evaluation_type, g.grade FROM grades g JOIN enrollments e ON g.enrollment_id = e.enrollment_id JOIN students s ON e.student_id = s.student_id JOIN courses c ON e.course_id = c.course_id;
-- Q10
SELECT p.last_name || ' ' || p.first_name AS professor_name, COUNT(c.course_id) AS number_of_courses FROM professors p LEFT JOIN courses c ON p.professor_id = c.professor_id GROUP BY p.professor_id;
-- Q11
SELECT s.last_name || ' ' || s.first_name AS student_name, ROUND(AVG(g.grade), 2) AS average_grade FROM students s JOIN enrollments e ON s.student_id = e.student_id JOIN grades g ON e.enrollment_id = g.enrollment_id GROUP BY s.student_id;
-- Q12
SELECT d.department_name, COUNT(s.student_id) AS student_count FROM departments d LEFT JOIN students s ON d.department_id = s.department_id GROUP BY d.department_id;
-- Q13
SELECT SUM(budget) AS total_budget FROM departments;
-- Q14
SELECT d.department_name, COUNT(c.course_id) AS course_count FROM departments d LEFT JOIN courses c ON d.department_id = c.department_id GROUP BY d.department_id;
-- Q15
SELECT d.department_name, AVG(p.salary) AS average_salary FROM departments d JOIN professors p ON d.department_id = p.department_id GROUP BY d.department_id;
-- Q16
SELECT s.last_name || ' ' || s.first_name AS student_name, AVG(g.grade) AS average_grade FROM students s JOIN enrollments e ON s.student_id = e.student_id JOIN grades g ON e.enrollment_id = g.enrollment_id GROUP BY s.student_id ORDER BY average_grade DESC LIMIT 3;
-- q17
SELECT course_code, course_name FROM courses WHERE course_id NOT IN (SELECT course_id FROM enrollments);
-- Q18
SELECT s.last_name || ' ' || s.first_name AS student_name, COUNT(*) AS passed_courses_count FROM students s JOIN enrollments e ON s.student_id = e.student_id WHERE e.status = 'Passed' GROUP BY s.student_id HAVING COUNT(*) = (SELECT COUNT(*) FROM enrollments e2 WHERE e2.student_id = s.student_id);
-- Q19
SELECT p.last_name || ' ' || p.first_name AS professor_name, COUNT(c.course_id) AS courses_taught FROM professors p JOIN courses c ON p.professor_id = c.professor_id GROUP BY p.professor_id HAVING courses_taught > 2;
-- Q20
SELECT s.last_name || ' ' || s.first_name AS student_name, COUNT(e.enrollment_id) AS enrolled_courses_count FROM students s JOIN enrollments e ON s.student_id = e.student_id GROUP BY s.student_id HAVING enrolled_courses_count > 2;
-- Q21
SELECT s.last_name || ' ' || s.first_name AS student_name, AVG(g.grade) AS student_avg, (SELECT AVG(g2.grade) FROM grades g2 JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id JOIN students s2 ON e2.student_id = s2.student_id WHERE s2.department_id = s.department_id) AS department_avg FROM students s JOIN enrollments e ON s.student_id = e.student_id JOIN grades g ON e.enrollment_id = g.enrollment_id GROUP BY s.student_id HAVING student_avg > department_avg;
-- Q22
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count FROM courses c JOIN enrollments e ON c.course_id = e.course_id GROUP BY c.course_id HAVING enrollment_count > (SELECT COUNT(*) * 1.0 / (SELECT COUNT(DISTINCT course_id) FROM enrollments) FROM enrollments);
-- q3
SELECT p.last_name || ' ' || p.first_name AS professor_name, d.department_name, d.budget FROM professors p JOIN departments d ON p.department_id = d.department_id WHERE d.budget = (SELECT MAX(budget) FROM departments);
-- 24
SELECT s.last_name || ' ' || s.first_name AS student_name, s.email FROM students s WHERE s.student_id NOT IN (SELECT e.student_id FROM enrollments e JOIN grades g ON e.enrollment_id = g.enrollment_id);
-- Q25
SELECT d.department_name, COUNT(s.student_id) AS student_count FROM departments d JOIN students s ON d.department_id = s.department_id GROUP BY d.department_id HAVING student_count > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM students GROUP BY department_id));
-- Q26
SELECT c.course_name, COUNT(g.grade_id) AS total_grades, SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades, ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade_id), 2) AS pass_rate_percentage FROM courses c JOIN enrollments e ON c.course_id = e.course_id JOIN grades g ON e.enrollment_id = g.enrollment_id GROUP BY c.course_id;
-- Q27
SELECT RANK() OVER(ORDER BY AVG(g.grade) DESC) as rank, s.last_name || ' ' || s.first_name AS student_name, AVG(g.grade) AS average_grade FROM students s JOIN enrollments e ON s.student_id = e.student_id JOIN grades g ON e.enrollment_id = g.enrollment_id GROUP BY s.student_id;
-- Q28
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient, (g.grade * g.coefficient) AS weighted_grade FROM grades g JOIN enrollments e ON g.enrollment_id = e.enrollment_id JOIN courses c ON e.course_id = c.course_id WHERE e.student_id = 1;
-- Q29
SELECT p.last_name || ' ' || p.first_name AS professor_name, SUM(c.credits) AS total_credits FROM professors p JOIN courses c ON p.professor_id = c.professor_id GROUP BY p.professor_id;
-- Q30
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity, (COUNT(e.enrollment_id) * 100.0 / c.max_capacity) AS percentage_full FROM courses c JOIN enrollments e ON c.course_id = e.course_id GROUP BY c.course_id HAVING percentage_full > 80;