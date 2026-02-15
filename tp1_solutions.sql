-- j'ai travaillé sur SQLite donc je n'ai pas utilisé CREATE TABLE  AS 


-- POUR SUPPRIMER SI elles existes 
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS departments;

PRAGMA foreign_keys = ON;

-- creation des tables 
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

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
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
    level TEXT,
    enrollment_date TEXT DEFAULT CURRENT_DATE,

    CHECK (level IN ('L1','L2','L3','M1','M2')),

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    course_name TEXT NOT NULL,
    description TEXT,
    credits INTEGER NOT NULL,
    semester INTEGER,
    department_id INTEGER,
    professor_id INTEGER,
    max_capacity INTEGER DEFAULT 30,

    CHECK (credits > 0),
    CHECK (semester BETWEEN 1 AND 2),

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date TEXT DEFAULT CURRENT_DATE,
    academic_year TEXT NOT NULL,
    status TEXT DEFAULT 'In Progress',

    CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    UNIQUE (student_id, course_id, academic_year),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE grades (
    grade_id INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER NOT NULL,
    evaluation_type TEXT,
    grade REAL,
    coefficient REAL DEFAULT 1.00,
    evaluation_date TEXT,
    comments TEXT,

    CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CHECK (grade BETWEEN 0 AND 20),

    FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--  creation des Indexes
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


 
-- insertion  des donnes 
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. hedibel  mohamed', '2012-09-11'),
('Mathematics', 'Building B', 350000.00, 'Dr. ramy  younes', '2012-09-01'),
('Physics', 'Building C', 400000.00, 'Dr.  elakel samir', '2014-02-11'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. souami said  ', '2013-12-17');

INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
-- Computer Science (2 professors)
('Mahrez', 'Riyad', 'riyad.mahrez@university.edu', '01-23-45-67-01', 1, '2010-09-01', 75000.00, 'Artificial Intelligence'),
('Benzema', 'Karim', 'karim.benzema@university.edu', '01-23-45-67-02', 1, '2012-09-01', 72000.00, 'Algorithms'),

-- Mathematics (1 professor)
('Feghouli', 'Sofiane', 'sofiane.feghouli@university.edu', '01-23-45-67-03', 2, '2011-09-01', 68000.00, 'Numerical Analysis'),

-- Physics (1 professor)
('Slimani', 'Islam', 'islam.slimani@university.edu', '01-23-45-67-04', 3, '2013-09-01', 71000.00, 'Quantum Physics'),

-- Civil Engineering (1 professor)
('Mandi', 'Aïssa', 'aissa.mandi@university.edu', '01-23-45-67-05', 4, '2014-09-01', 69000.00, 'Structural Engineering');

INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
-- Computer Science (2 students)
('CS2023001', 'Bounedjah', 'Baghdad', '2002-05-15', 'baghdad.bounedjah@student.edu', '06-11-22-33-01', '123 Rue Didouche Mourad, Alger', 1, 'L3', '2023-09-01'),
('CS2024001', 'Belaïli', 'Youcef', '2003-08-22', 'youcef.belailli@student.edu', '06-11-22-33-02', '456 Boulevard Mohamed V, Oran', 1, 'L2', '2024-09-01'),

-- Mathematics (2 students)
('MATH2023001', 'Ghezzal', 'Rachid', '2002-11-30', 'rachid.ghezzal@student.edu', '06-11-22-33-03', '321 Rue Khemisti, Blida', 2, 'L3', '2023-09-01'),
('MATH2022001', 'Soudani', 'Hillel', '2001-07-18', 'hillel.soudani@student.edu', '06-11-22-33-04', '654 Avenue de l''ALN, Tizi Ouzou', 2, 'M1', '2022-09-01'),

-- Physics (2 students)
('PHY2023001', 'Zerrouki', 'Ramiz', '2002-09-25', 'ramiz.zerrouki@student.edu', '06-11-22-33-05', '987 Rue Emir Abdelkader, Annaba', 3, 'L3', '2023-09-01'),
('PHY2022001', 'Brahimi', 'Yacine', '2001-12-12', 'yacine.brahimi@student.edu', '06-11-22-33-06', '147 Cité des Frères Abbès, Sétif', 3, 'M1', '2022-09-01'),

-- Civil Engineering (2 students)
('CE2024001', 'Atal', 'Youcef', '2003-10-20', 'youcef.atal@student.edu', '06-11-22-33-07', '369 Boulevard du 1er Novembre, Béjaïa', 4, 'L2', '2024-09-01'),
('CE2022001', 'Bensebaini', 'Ramy', '2001-04-05', 'ramy.bensebaini@student.edu', '06-11-22-33-08', '258 Rue Mostefa Ben Boulaïd, Batna', 4, 'M1', '2022-09-01');

INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
-- Computer Science (2 courses)
('CS101', 'Introduction to Programming', 'Basic programming concepts', 5, 1, 1, 1, 30),
('CS201', 'Data Structures', 'Advanced data structures and algorithms', 6, 2, 1, 2, 25),

-- Mathematics (2 courses)
('MATH101', 'Calculus I', 'Limits, derivatives, integrals', 5, 1, 2, 3, 35),
('MATH201', 'Linear Algebra', 'Matrices, vectors, linear transformations', 6, 2, 2, 3, 30),

-- Physics (2 courses)
('PHY101', 'Classical Mechanics', 'Newtonian physics', 5, 1, 3, 4, 25),
('PHY201', 'Electromagnetism', 'Electric and magnetic fields', 6, 2, 3, 4, 20),

-- Civil Engineering (2 courses) -- FIXED: Changed professor_id from 6 to 5 for CE201
('CE101', 'Structural Analysis', 'Analysis of structures', 5, 1, 4, 5, 25),
('CE201', 'Fluid Mechanics', 'Properties of fluids', 5, 2, 4, 5, 20);

INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES

(1, 1, '2024-09-01', '2024-2025', 'In Progress'), -- Baghdad Bounedjah
(1, 2, '2024-09-01', '2024-2025', 'In Progress'), -- Baghdad Bounedjah (2nd course)
(2, 1, '2024-09-01', '2024-2025', 'In Progress'), -- Youcef Belaïli
(3, 3, '2024-09-01', '2024-2025', 'In Progress'), -- Rachid Ghezzal
(3, 4, '2024-09-01', '2024-2025', 'In Progress'), -- Rachid Ghezzal (2nd course)
(4, 4, '2024-09-01', '2024-2025', 'In Progress'), -- Hillel Soudani
(5, 5, '2024-09-01', '2024-2025', 'In Progress'), -- Ramiz Zerrouki
(5, 6, '2024-09-01', '2024-2025', 'In Progress'), -- Ramiz Zerrouki (2nd course)
(6, 5, '2024-09-01', '2024-2025', 'In Progress'), -- Yacine Brahimi
(6, 6, '2024-09-01', '2024-2025', 'In Progress'), -- Yacine Brahimi (2nd course)
(7, 7, '2024-09-01', '2024-2025', 'In Progress'), -- Youcef Atal
(7, 8, '2024-09-01', '2024-2025', 'In Progress'), -- Youcef Atal (2nd course)
(8, 7, '2024-09-01', '2024-2025', 'In Progress'), -- Ramy Bensebaini
(8, 8, '2024-09-01', '2024-2025', 'In Progress'), -- Ramy Bensebaini (2nd course)


(1, 1, '2023-09-01', '2023-2024', 'Passed'), -- Baghdad Bounedjah
(1, 3, '2023-09-01', '2023-2024', 'Passed'), -- Baghdad Bounedjah
(3, 3, '2023-09-01', '2023-2024', 'Passed'), -- Rachid Ghezzal
(4, 4, '2023-09-01', '2023-2024', 'Failed'), -- Hillel Soudani
(5, 5, '2023-09-01', '2023-2024', 'Passed'), -- Ramiz Zerrouki
(6, 6, '2023-09-01', '2023-2024', 'Dropped'), -- Yacine Brahimi
(7, 7, '2023-09-01', '2023-2024', 'Passed'), -- Youcef Atal
(8, 8, '2023-09-01', '2023-2024', 'Passed'); -- Ramy Bensebaini

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES


(1, 'Assignment', 17.5, 1.00, '2024-10-15', 'Excellent travail - Bounedjah'), -- Baghdad Bounedjah
(1, 'Exam', 18.0, 2.00, '2024-12-10', 'Comme un but en finale'), -- Baghdad Bounedjah
(2, 'Lab', 16.0, 1.50, '2024-11-05', 'Bon travail'), -- Baghdad Bounedjah
(3, 'Assignment', 15.5, 1.00, '2024-10-20', 'Bon début'), -- Youcef Belaïli
(4, 'Exam', 14.0, 2.00, '2024-12-12', 'Peut mieux faire'), -- Rachid Ghezzal
(5, 'Assignment', 13.5, 1.00, '2024-10-18', 'Moyen'), -- Rachid Ghezzal
(6, 'Exam', 11.0, 2.00, '2024-12-14', 'Doit travailler plus'), -- Hillel Soudani
(7, 'Lab', 16.5, 1.00, '2024-11-10', 'Bon potentiel'), -- Ramiz Zerrouki
(8, 'Assignment', 17.0, 1.00, '2024-10-25', 'Très bon'), -- Ramiz Zerrouki
(9, 'Exam', 18.5, 2.00, '2024-12-08', 'Excellent - Brahimi'), -- Yacine Brahimi
(10, 'Lab', 17.5, 1.50, '2024-11-18', 'Très technique'), -- Yacine Brahimi
(11, 'Project', 18.0, 2.00, '2024-11-28', 'Projet créatif - Atal'), -- Youcef Atal
(11, 'Exam', 17.0, 2.00, '2024-12-05', 'Bon travail'), -- Youcef Atal
(12, 'Assignment', 16.5, 1.00, '2024-10-22', 'Solide'), -- Youcef Atal
(13, 'Exam', 15.5, 2.00, '2024-12-09', 'Bon - Bensebaini'), -- Ramy Bensebaini
(14, 'Project', 17.0, 2.00, '2024-11-15', 'Bon projet'), -- Ramy Bensebaini


(15, 'Assignment', 16.0, 1.00, '2023-10-12', 'Bon travail'), -- Baghdad Bounedjah
(15, 'Exam', 17.5, 2.00, '2023-12-08', 'Très bon'), -- Baghdad Bounedjah
(16, 'Project', 18.5, 2.00, '2023-11-20', 'Projet exceptionnel'), -- Baghdad Bounedjah
(17, 'Exam', 15.0, 2.00, '2023-12-10', 'Bon'), -- Rachid Ghezzal
(18, 'Assignment', 9.0, 1.00, '2023-10-15', 'Insuffisant'), -- Hillel Soudani
(18, 'Exam', 8.5, 2.00, '2023-12-12', 'Échec'), -- Hillel Soudani
(19, 'Lab', 14.0, 1.50, '2023-11-08', 'Passable'), -- Ramiz Zerrouki
(20, 'Assignment', 10.5, 1.00, '2023-10-22', 'À améliorer'), -- Yacine Brahimi


-- Q1
SELECT last_name, first_name, email, level 
FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
INNER JOIN departments d ON p.department_id = d.department_id
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

-- Q6
SELECT 
    c.course_code,
    c.course_name,
    (p.last_name || ' ' || p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id
ORDER BY c.course_code;

-- Q7
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    c.course_name,
    e.enrollment_date,
    e.status
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- Q8
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    d.department_name,
    s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    c.course_name,
    g.evaluation_type,
    g.grade
FROM grades g
INNER JOIN enrollments e ON g.enrollment_id = e.enrollment_id
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- Q10
SELECT 
    (p.last_name || ' ' || p.first_name) AS professor_name,
    COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14
SELECT 
    d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15
SELECT 
    d.department_name,
    AVG(p.salary) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17
SELECT 
    c.course_code,
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id;

-- Q19
SELECT 
    (p.last_name || ' ' || p.first_name) AS professor_name,
    COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 2;



-- Q22
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(enrollment_count)
    FROM (
        SELECT COUNT(enrollment_id) AS enrollment_count
        FROM enrollments
        GROUP BY course_id
    ) AS avg_enrollments
);

-- Q23
SELECT 
    (p.last_name || ' ' || p.first_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT 
    (s.last_name || ' ' || s.first_name) AS student_name,
    s.email
FROM students s
WHERE s.student_id NOT IN (
    SELECT DISTINCT e.student_id
    FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) > (
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM students
        GROUP BY department_id
    ) AS avg_students
);



-- Q27
SELECT 
    RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
    (s.last_name || ' ' || s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;



-- Q29
SELECT 
    (p.last_name || ' ' || p.first_name) AS professor_name,
    SUM(c.credits) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
ORDER BY total_credits DESC;

-- Q30
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    (COUNT(e.enrollment_id) * 100 / c.max_capacity) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING (COUNT(e.enrollment_id) * 100 / c.max_capacity) > 80
ORDER BY percentage_full DESC;