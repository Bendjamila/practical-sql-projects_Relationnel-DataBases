-- University Management System
-- NOTE : we worked with SQLite

-- since we used SQLite
-- in terminal : sqlite3 uni.db
-- then : .read tp1_solutions.sql
--        .tables


--enables foreign key constraints
PRAGMA foreign_keys = ON;

--===========================SCHEMA===========================
CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name TEXT NOT NULL,
    building        TEXT,
    budget          NUMERIC,
    department_head TEXT,
    creation_date   DATETIME
);

CREATE TABLE professors (
    professor_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name       TEXT NOT NULL,
    first_name      TEXT NOT NULL,
    email           TEXT UNIQUE NOT NULL,
    phone           TEXT,
    department_id   INTEGER REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    hire_date       DATETIME,
    salary          NUMERIC,
    specialization  TEXT
);

CREATE TABLE students (
    student_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number    TEXT UNIQUE NOT NULL,
    last_name         TEXT NOT NULL,
    first_name        TEXT NOT NULL,
    date_of_birth     DATETIME,
    email             TEXT UNIQUE NOT NULL,
    phone             TEXT,
    address           TEXT,
    department_id     INTEGER REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    level             TEXT CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date  DATETIME DEFAULT CURRENT_DATE
);

CREATE TABLE courses (
    course_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code     TEXT UNIQUE NOT NULL,
    course_name     TEXT NOT NULL,
    description     TEXT,
    credits         INTEGER NOT NULL CHECK (credits > 0),
    semester        INTEGER CHECK (semester IN (1, 2)),
    department_id   REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    professor_id    INTEGER REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE,
    max_capacity    INTEGER DEFAULT 30
);

CREATE TABLE enrollments (
    enrollment_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id        INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    course_id         INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    enrollment_date   TEXT DEFAULT CURRENT_DATE,
    academic_year     TEXT NOT NULL CHECK (
        academic_year GLOB '2[0-9][0-9][0-9]-2[0-9][0-9][0-9]'
        AND CAST(SUBSTR(academic_year, 6, 4) AS INTEGER) = CAST(SUBSTR(academic_year, 1, 4) AS INTEGER) + 1
    ),
    status            TEXT DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE(student_id, course_id, academic_year)
);

CREATE TABLE grades (
    grade_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id     INTEGER NOT NULL REFERENCES enrollments(enrollment_id) ON UPDATE CASCADE ON DELETE CASCADE,
    evaluation_type   TEXT CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade             NUMERIC CHECK (grade >= 0 AND grade <= 20),
    coefficient       NUMERIC DEFAULT 1,
    evaluation_date   DATETIME,
    comments          TEXT

);


--===========================INDEXES===========================
CREATE INDEX idx_student_departement ON students(departement_id);

CREATE INDEX idx_course_professor ON courses(professor_id);

CREATE INDEX idx_enrollement_student ON enrollements(student_id);

CREATE INDEX idx_enrollement_course ON enrollemnents(course_id);

CREATE INDEX idx_grades_enrollement ON grades(enrollement_id);


--===========================TEST DATA===========================
--departements
INSERT INTO departments (department_name, building, budget, departmnt_head, creation_date) VALUES
  ('Computer Science', 'Building A', 500000, 'Mr. NESRAOUI', '15-06-2023'),
  ('Mathematics', 'Building B', 350000, 'Mrs. MEGUEDMI', '03-05-2013'),
  ('Physics', 'Building C', 400000, 'Mr. MOUGARI', '13-07-2010'),
  ('Civil Engineering', 'Building D', 600000, 'Mrs. FERHAH', '29-08-2011');



--professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
  ('Djamila', 'BENDOUDA', 'djamila.bendouda@ensta.edu.dz', '1234567890', 1,'12-10-2015', 120000, 'Database'),
  ('Kheira', 'LAKHDARI', 'kheira.lakhdari@ensta.edu.dz', '9012345678', 1,'03-05-2022', 100000, 'Data Sience'),
  ('Amina Fatima Zohra', 'MEDJAHED', 'amina.medjahed@ensta.edu.dz', '8901234567', 1,'25-08-2025', 80000, 'AI'),
  ('Yacine', 'BRIEDJ', 'yacine.briedj@ensta.edu.dz', '7890123456', 2,'14-09-2024', 90000, 'Algebra'),
  ('Meriem', 'MEZERDI', 'meriem.mezerdi@ensta.edu.dz', '6789012345', 3,'27-06-2016', 110000, 'Analysis'),
  ('Adel', 'BOUCETTA', 'adel.boucetta@ensta.edu.dz', '56789011234', 4,'07-10-2024', 80000, 'Statistics');



--students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
  ('232335678904', 'Zhour', 'SACI', '10-10-2004', 'az.saci@ensta.edu.dz', '0123456789', 'batna-algeria', 1, 'L3', '26-08-2023'),
  ('232367930261', 'Jazia', 'ABDELKRIM', '03-04-2005', 'aj.abdelkrim@ensta.edu.dz', '9012345678', 'bousaada-algeria', 1, 'L3', '06-08-2023'),
  ('222282905539', 'Aya', 'ZEDDOUN', '23-7-2002', 'aa.zeddouni@ensta.edu.dz', '8901234567', 'telemcen-algeria', 3, 'M1', '14-08-2022'),
  ('242489876324', 'Raounak', 'DJEBIR', '05-08-2005', 'ar.djebiri@ensta.edu.dz', '7890123456', 'oum elbouaghi-algeria', 2, 'L2', '10-08-2024'),
  ('252534261843', 'Sara', 'ARZIM', '17-10-2005', 'as.arzim@ensta.edu.dz', '6789012345', 'algiers-algeria', 2, 'L1', '24-08-2025'),
  ('242499226735', 'Rym', 'MALEK', '19-03-2006', 'ar.maleki@ensta.edu.dz', '5678901234', 'algiers-algeria', 4, 'L2', '03-08-2024'),
  ('212193683483', 'Amel', 'BOUTERBAG', '30-01-2005', 'aa.bouterbag@ensta.edu.dz', '4567890123', 'telemcen-algeria', 1, 'M2', '27-08-2021'),
  ('212112351731', 'Lina', 'DJEDAI', '03-05-2006', 'al.djedai@ensta.edu.dz', '3456789012', 'ouargla-algeria',1, 'M2', '18-08-2021');



--courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
  ('CS101', 'ADB', 'Advanced Databases', 5, 2, 1, 1, 70),
  ('CS102', 'DAS', 'Data Analysis & Data Scinece', 6, 1, 1, 2, 150),
  ('CS103', 'AI', 'Introduction to Artificial Intelligence', 5, 1, 1, 3, 85),
  ('M101', 'ALG1', 'Algebra', 6, 1, 2, 4, 120),
  ('M102', 'LOG', 'Mathematical Logic', 5, 2, 2, 4, 130),
  ('ST101', 'ANA', 'Mathematical Analysis', 6, 1, 3, 5, 50),
  ('ST102', 'PRST', 'Probabilities & Statistics', 5, 2, 2, 6, 100);



--enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
  (1, 1, '13-01-2026', '2025-2026', 'In Progress'),
  (1, 2, '27-09-2025', '2025-2026', 'Passed'),
  (8, 3, '29-09-2025', '2024-2025', 'Passed'),
  (2, 4, '07-09-2025', '2025-2026', 'In Progress'),
  (2, 5, '13-01-2026', '2024-2025', 'Dropped'),
  (3, 6, '13-01-2026', '2021-2022', 'Failed'),
  (3, 7, '27-09-2025', '2025-2026', 'Passed'),
  (8, 6, '22-10-2025', '2024-2025', 'Passed'),
  (4, 4, '07-09-2025', '2025-2026', 'Failed'),
  (5, 5, '13-01-2026', '2022-2023', 'Dropped'),
  (5, 1, '13-01-2026', '2025-2026', 'In Progress'),
  (6, 2, '27-09-2025', '2025-2026', 'Passed'),
  (6, 6, '29-09-2025', '2021-2022', 'Passed'),
  (7, 7, '07-09-2025', '2025-2026', 'In Progress'),
  (7, 5, '13-01-2026', '2025-2026', 'Dropped');



--grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date) VALUES
  (1, 'Assignment', 16, 4, '25-1-2026'),
  (2, 'Assignment', 13, 5, '17-1-2026'),
  (3, 'Assignment', 18, 6, '07-1-2026'),
  (4, 'Lab', 15, 4, '12-10-2025'),
  (5, 'Lab', 17, 4, '06-11-2025'),
  (6, 'Lab', 12, 6, '28-09-2026'),
  (7, 'Exam', 18, 5, '16-2-2026'),
  (8, 'Exam', 10, 3, '10-2-2026'),
  (9, 'Exam', 14, 4, '29-1-2026'),
  (10, 'Project', 16, 5, '31-1-2026'),
  (11, 'Project', 15, 6, '24-1-2026'),
  (15, 'Project', 17, 3, '18-12-2025');



--===========================SQL QUERIES===========================
-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1
SELECT last_name, first_name, email, level FROM students;

-- Q2
SELECT last_name, first_name, email, specialization 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6
SELECT c.course_code, c.course_name, p.last_name, p.first_name
FROM courses c
JOIN professors p ON c.professor_id = p.professor_id;

-- Q7
SELECT s.last_name, s.first_name, c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- Q8
SELECT s.last_name, s.first_name, d.department_name, s.level
FROM students s
JOIN departments d ON d.department_id = s.department_id;

-- Q9
SELECT s.last_name, s.first_name, c.course_name, g.evaluation_type, g.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
JOIN courses c ON c.course_id = e.course_id;

-- Q10
SELECT p.professor_id, p.last_name, p.first_name, COUNT(c.professor_id) AS number_of_courses
FROM courses c
JOIN professors p ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11
SELECT s.student_id, s.last_name, s.first_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14
SELECT d.department_id, d.department_name, COUNT(c.course_id)
FROM departments d
LEFT JOIN courses c ON c.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q15
SELECT d.department_id, d.department_name, AVG(p.salary) AS average_salary
FROM professors p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16
SELECT s.first_name || ' ' || s.last_name AS student_name, ROUND(AVG(g.grade),2) AS average_grade
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
SELECT s.first_name || ' ' || s.last_name AS student_name, COUNT(*) AS curses_passed
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.status != 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19
SELECT p.first_name || ' ' || p.last_name AS professor_name, COUNT(c.course_id) AS prof_courses
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT s.first_name || ' ' || s.last_name AS student_name, COUNT(e.course_id) AS nb_enrollments
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21
SELECT student_name, student_avg, department_avg
FROM (
    SELECT s.student_id, s.department_id, s.first_name || ' ' || s.last_name AS student_name,
        ROUND(AVG(g.grade),2) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) student_data
JOIN (
    SELECT s.department_id, AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) department_data
ON student_data.department_id = department_data.department_id
WHERE student_avg > department_avg;

-- Q22
SELECT course_name, enrollment_nb
FROM(
    SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_nb
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id
) subq
WHERE enrollment_nb > ( 
    SELECT AVG(enrollments_count)
    FROM (
        SELECT COUNT(enrollment_id) AS enrollments_count
        FROM enrollments
        GROUP BY course_id
    )
);

-- Q23
SELECT p.first_name || ' ' || p.last_name AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (
    SELECT MAX(budget) FROM departments
);

-- Q24
SELECT s.first_name || ' ' || s.last_name AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25
SELECT department_name, students_nb
FROM (
    SELECT d.department_name, COUNT(s.student_id) AS students_nb
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id
) subqr
WHERE students_nb > (
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM students
        GROUP BY department_id 
    )
);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26
SELECT c.course_name, COUNT(g.grade_id) AS total_grades,
			SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
			ROUND( 100.0 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
			s.first_name || ' ' || s.last_name AS student_name,
			ROUND(AVG(g.grade),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q28
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
			(g.grade * g.coefficient) AS weighted_grade
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE e.student_id = 1;

-- Q29
SELECT p.first_name || ' ' || p.last_name AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity,
			ROUND(100.0 * COUNT(e.enrollment_id) / c.max_capacity,2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
