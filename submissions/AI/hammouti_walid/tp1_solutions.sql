-- 1. DATABASE CREATION
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;
-- 2. TABLE CREATION WITH CONSTRAINTS
-- Table: departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);
-- Table: professors
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE
    SET NULL ON UPDATE CASCADE
);
-- Table: students
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE
    SET NULL ON UPDATE CASCADE
);
-- Table: courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semester INT CHECK (
        semester BETWEEN 1 AND 2
    ),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE
    SET NULL ON UPDATE CASCADE
);
-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress' CHECK (
        status IN ('In Progress', 'Passed', 'Failed', 'Dropped')
    ),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (student_id, course_id, academic_year)
);
-- Table: grades
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30) CHECK (
        evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')
    ),
    grade DECIMAL(5, 2) CHECK (
        grade BETWEEN 0 AND 20
    ),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- 3. INDEX CREATION
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
-- 4. TEST DATA INSERTION
-- Insert Departments
INSERT INTO departments (
        department_name,
        building,
        budget,
        department_head,
        creation_date
    )
VALUES (
        'Computer Science',
        'Building A',
        500000.00,
        'Dr. Ahmed Benali',
        '2010-09-01'
    ),
    (
        'Mathematics',
        'Building B',
        350000.00,
        'Prof. Sarah Martin',
        '2008-09-01'
    ),
    (
        'Physics',
        'Building C',
        400000.00,
        'Dr. Mohamed Cherif',
        '2009-09-01'
    ),
    (
        'Civil Engineering',
        'Building D',
        600000.00,
        'Prof. Jean Dupont',
        '2011-09-01'
    );
-- Insert Professors
INSERT INTO professors (
        last_name,
        first_name,
        email,
        phone,
        department_id,
        hire_date,
        salary,
        specialization
    )
VALUES (
        'Smith',
        'John',
        'john.smith@university.dz',
        '0555-123-456',
        1,
        '2015-09-01',
        85000.00,
        'Artificial Intelligence'
    ),
    (
        'Johnson',
        'Emily',
        'emily.johnson@university.dz',
        '0555-234-567',
        1,
        '2016-09-01',
        80000.00,
        'Database Systems'
    ),
    (
        'Williams',
        'Michael',
        'michael.williams@university.dz',
        '0555-345-678',
        1,
        '2017-09-01',
        78000.00,
        'Software Engineering'
    ),
    (
        'Brown',
        'Sarah',
        'sarah.brown@university.dz',
        '0555-456-789',
        2,
        '2014-09-01',
        82000.00,
        'Applied Mathematics'
    ),
    (
        'Davis',
        'Robert',
        'robert.davis@university.dz',
        '0555-567-890',
        3,
        '2015-09-01',
        83000.00,
        'Quantum Physics'
    ),
    (
        'Martinez',
        'Carlos',
        'carlos.martinez@university.dz',
        '0555-678-901',
        4,
        '2016-09-01',
        87000.00,
        'Structural Engineering'
    );
-- Insert Students
INSERT INTO students (
        student_number,
        last_name,
        first_name,
        date_of_birth,
        email,
        phone,
        address,
        department_id,
        level,
        enrollment_date
    )
VALUES (
        'CS2023001',
        'Boudiaf',
        'Yacine',
        '2003-05-15',
        'yacine.boudiaf@student.dz',
        '0666-111-222',
        '123 Rue Didouche Mourad, Algiers',
        1,
        'L3',
        '2023-09-15'
    ),
    (
        'CS2023002',
        'Benali',
        'Amira',
        '2003-08-22',
        'amira.benali@student.dz',
        '0666-222-333',
        '456 Rue Larbi Ben Mhidi, Algiers',
        1,
        'L2',
        '2023-09-15'
    ),
    (
        'MA2023001',
        'Khelifi',
        'Sofiane',
        '2002-11-10',
        'sofiane.khelifi@student.dz',
        '0666-333-444',
        '789 Rue Hassiba Ben Bouali, Algiers',
        2,
        'M1',
        '2023-09-15'
    ),
    (
        'PH2023001',
        'Mansouri',
        'Lydia',
        '2003-03-18',
        'lydia.mansouri@student.dz',
        '0666-444-555',
        '321 Boulevard Mohamed V, Algiers',
        3,
        'L3',
        '2023-09-15'
    ),
    (
        'CE2023001',
        'Saidi',
        'Rami',
        '2002-07-25',
        'rami.saidi@student.dz',
        '0666-555-666',
        '654 Rue des Martyrs, Algiers',
        4,
        'M1',
        '2023-09-15'
    ),
    (
        'CS2024001',
        'Hamidi',
        'Nadia',
        '2004-01-30',
        'nadia.hamidi@student.dz',
        '0666-666-777',
        '987 Rue Frantz Fanon, Algiers',
        1,
        'L2',
        '2024-09-15'
    ),
    (
        'MA2024001',
        'Touati',
        'Karim',
        '2003-09-12',
        'karim.touati@student.dz',
        '0666-777-888',
        '147 Rue Ali Boumendjel, Algiers',
        2,
        'L3',
        '2024-09-15'
    ),
    (
        'CS2024002',
        'Zerrouki',
        'Selma',
        '2004-06-08',
        'selma.zerrouki@student.dz',
        '0666-888-999',
        '258 Rue Abane Ramdane, Algiers',
        1,
        'L2',
        '2024-09-15'
    );
-- Insert Courses
INSERT INTO courses (
        course_code,
        course_name,
        description,
        credits,
        semester,
        department_id,
        professor_id,
        max_capacity
    )
VALUES (
        'CS301',
        'Database Systems',
        'Introduction to relational databases, SQL, and database design',
        6,
        1,
        1,
        2,
        40
    ),
    (
        'CS302',
        'Artificial Intelligence',
        'Fundamentals of AI including search algorithms and machine learning',
        6,
        1,
        1,
        1,
        35
    ),
    (
        'CS303',
        'Software Engineering',
        'Software development methodologies and project management',
        5,
        2,
        1,
        3,
        40
    ),
    (
        'MA201',
        'Linear Algebra',
        'Vector spaces, matrices, and linear transformations',
        5,
        1,
        2,
        4,
        50
    ),
    (
        'PH301',
        'Quantum Mechanics',
        'Introduction to quantum theory and applications',
        6,
        2,
        3,
        5,
        30
    ),
    (
        'CE401',
        'Structural Analysis',
        'Analysis of structures under various loads',
        6,
        1,
        4,
        6,
        30
    ),
    (
        'CS304',
        'Computer Networks',
        'Network protocols, architecture, and security',
        5,
        2,
        1,
        2,
        35
    );
-- Insert Enrollments
INSERT INTO enrollments (
        student_id,
        course_id,
        enrollment_date,
        academic_year,
        status
    )
VALUES -- Student 1 (Yacine) - L3 Computer Science
    (1, 1, '2024-09-20', '2024-2025', 'In Progress'),
    (1, 2, '2024-09-20', '2024-2025', 'In Progress'),
    (1, 3, '2024-09-20', '2024-2025', 'In Progress'),
    -- Student 2 (Amira) - L2 Computer Science
    (2, 1, '2024-09-20', '2024-2025', 'In Progress'),
    (2, 7, '2024-09-20', '2024-2025', 'In Progress'),
    -- Student 3 (Sofiane) - M1 Mathematics
    (3, 4, '2024-09-20', '2024-2025', 'Passed'),
    (3, 1, '2024-09-20', '2024-2025', 'In Progress'),
    -- Student 4 (Lydia) - L3 Physics
    (4, 5, '2024-09-20', '2024-2025', 'In Progress'),
    (4, 4, '2024-09-20', '2024-2025', 'Passed'),
    -- Student 5 (Rami) - M1 Civil Engineering
    (5, 6, '2024-09-20', '2024-2025', 'In Progress'),
    -- Student 6 (Nadia) - L2 Computer Science
    (6, 1, '2024-09-20', '2024-2025', 'In Progress'),
    (6, 2, '2024-09-20', '2024-2025', 'Failed'),
    -- Student 7 (Karim) - L3 Mathematics
    (7, 4, '2024-09-20', '2024-2025', 'In Progress'),
    -- Student 8 (Selma) - L2 Computer Science
    (8, 1, '2024-09-20', '2024-2025', 'In Progress'),
    (8, 7, '2024-09-20', '2024-2025', 'Passed');
-- Insert Grades
INSERT INTO grades (
        enrollment_id,
        evaluation_type,
        grade,
        coefficient,
        evaluation_date,
        comments
    )
VALUES -- Enrollment 1: Student 1 - Database Systems
    (
        1,
        'Assignment',
        15.50,
        1.00,
        '2024-10-15',
        'Good understanding of SQL'
    ),
    (
        1,
        'Lab',
        16.00,
        1.50,
        '2024-11-20',
        'Excellent practical work'
    ),
    (
        1,
        'Exam',
        14.00,
        2.00,
        '2024-12-15',
        'Solid performance'
    ),
    -- Enrollment 2: Student 1 - AI
    (
        2,
        'Project',
        17.00,
        2.00,
        '2024-11-30',
        'Outstanding project implementation'
    ),
    -- Enrollment 4: Student 2 - Database Systems
    (
        4,
        'Assignment',
        13.00,
        1.00,
        '2024-10-15',
        'Needs improvement in optimization'
    ),
    (
        4,
        'Exam',
        12.50,
        2.00,
        '2024-12-15',
        'Average performance'
    ),
    -- Enrollment 6: Student 3 - Linear Algebra (Passed)
    (
        6,
        'Exam',
        16.50,
        2.00,
        '2024-12-10',
        'Excellent mathematical skills'
    ),
    -- Enrollment 9: Student 4 - Linear Algebra (Passed)
    (
        9,
        'Assignment',
        15.00,
        1.00,
        '2024-10-20',
        'Good work'
    ),
    (
        9,
        'Exam',
        14.50,
        2.00,
        '2024-12-10',
        'Solid understanding'
    ),
    -- Enrollment 11: Student 6 - Database Systems
    (
        11,
        'Assignment',
        11.00,
        1.00,
        '2024-10-15',
        'Needs more practice'
    ),
    -- Enrollment 12: Student 6 - AI (Failed)
    (
        12,
        'Exam',
        8.00,
        2.00,
        '2024-12-12',
        'Insufficient preparation'
    ),
    -- Enrollment 15: Student 8 - Computer Networks (Passed)
    (
        15,
        'Lab',
        18.00,
        1.50,
        '2024-11-25',
        'Excellent practical skills'
    );
-- 5. SQL QUERIES (30 QUERIES)
-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========
-- Q1. List all students with their main information (name, email, level)
SELECT last_name,
    first_name,
    email,
    level
FROM students
ORDER BY last_name,
    first_name;
-- Q2. Display all professors from the Computer Science department
SELECT p.last_name,
    p.first_name,
    p.email,
    p.specialization
FROM professors p
    JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science'
ORDER BY p.last_name;
-- Q3. Find all courses with more than 5 credits
SELECT course_code,
    course_name,
    credits
FROM courses
WHERE credits > 5
ORDER BY credits DESC,
    course_name;
-- Q4. List students enrolled in L3 level
SELECT student_number,
    last_name,
    first_name,
    email
FROM students
WHERE level = 'L3'
ORDER BY last_name;
-- Q5. Display courses from semester 1
SELECT course_code,
    course_name,
    credits,
    semester
FROM courses
WHERE semester = 1
ORDER BY course_name;
-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========
-- Q6. Display all courses with the professor's name
SELECT c.course_code,
    c.course_name,
    CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
    LEFT JOIN professors p ON c.professor_id = p.professor_id
ORDER BY c.course_code;
-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    c.course_name,
    e.enrollment_date,
    e.status
FROM enrollments e
    JOIN students s ON e.student_id = s.student_id
    JOIN courses c ON e.course_id = c.course_id
ORDER BY e.enrollment_date DESC,
    student_name;
-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    d.department_name,
    s.level
FROM students s
    LEFT JOIN departments d ON s.department_id = d.department_id
ORDER BY d.department_name,
    student_name;
-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    c.course_name,
    g.evaluation_type,
    g.grade
FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.enrollment_id
    JOIN students s ON e.student_id = s.student_id
    JOIN courses c ON e.course_id = c.course_id
ORDER BY student_name,
    c.course_name,
    g.evaluation_date;
-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COUNT(c.course_id) AS number_of_courses
FROM professors p
    LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id,
    professor_name
ORDER BY number_of_courses DESC,
    professor_name;
-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========
-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(
        AVG(g.grade * g.coefficient) / AVG(g.coefficient),
        2
    ) AS average_grade
FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id,
    student_name
ORDER BY average_grade DESC;
-- Q12. Count the number of students per department
SELECT d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id,
    d.department_name
ORDER BY student_count DESC,
    d.department_name;
-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;
-- Q14. Find the total number of courses per department
SELECT d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
    LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id,
    d.department_name
ORDER BY course_count DESC,
    d.department_name;
-- Q15. Calculate the average salary of professors per department
SELECT d.department_name,
    ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
    LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id,
    d.department_name
ORDER BY average_salary DESC;
-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========
-- Q16. Find the top 3 students with the best averages
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(
        AVG(g.grade * g.coefficient) / AVG(g.coefficient),
        2
    ) AS average_grade
FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id,
    student_name
ORDER BY average_grade DESC
LIMIT 3;
-- Q17. List courses with no enrolled students
SELECT c.course_code,
    c.course_name
FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL
ORDER BY c.course_code;
-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id,
    student_name
HAVING COUNT(e.enrollment_id) = (
        SELECT COUNT(*)
        FROM enrollments e2
        WHERE e2.student_id = s.student_id
    )
ORDER BY passed_courses_count DESC,
    student_name;
-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COUNT(c.course_id) AS courses_taught
FROM professors p
    JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id,
    professor_name
HAVING COUNT(c.course_id) > 2
ORDER BY courses_taught DESC;
-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id,
    student_name
HAVING COUNT(e.enrollment_id) > 2
ORDER BY enrolled_courses_count DESC,
    student_name;
-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========
-- Q21. Find students with an average higher than their department's average
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(
        AVG(g.grade * g.coefficient) / AVG(g.coefficient),
        2
    ) AS student_avg,
    (
        SELECT ROUND(
                AVG(g2.grade * g2.coefficient) / AVG(g2.coefficient),
                2
            )
        FROM grades g2
            JOIN enrollments e2 ON g2.enrollment_id = e2.enrollment_id
            JOIN students s2 ON e2.student_id = s2.student_id
        WHERE s2.department_id = s.department_id
    ) AS department_avg
FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id,
    s.department_id,
    student_name
HAVING student_avg > department_avg
ORDER BY student_avg DESC;
-- Q22. List courses with more enrollments than the average number of enrollments
SELECT c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
    JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id,
    c.course_name
HAVING COUNT(e.enrollment_id) > (
        SELECT AVG(enrollment_count)
        FROM (
                SELECT COUNT(e2.enrollment_id) AS enrollment_count
                FROM courses c2
                    LEFT JOIN enrollments e2 ON c2.course_id = e2.course_id
                GROUP BY c2.course_id
            ) AS avg_enrollments
    )
ORDER BY enrollment_count DESC;
-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
    JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (
        SELECT MAX(budget)
        FROM departments
    )
ORDER BY professor_name;
-- Q24. Find students with no grades recorded
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    s.email
FROM students s
WHERE s.student_id NOT IN (
        SELECT DISTINCT e.student_id
        FROM enrollments e
            JOIN grades g ON e.enrollment_id = g.enrollment_id
    )
ORDER BY student_name;
-- Q25. List departments with more students than the average
SELECT d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id,
    d.department_name
HAVING COUNT(s.student_id) > (
        SELECT AVG(student_count)
        FROM (
                SELECT COUNT(s2.student_id) AS student_count
                FROM departments d2
                    LEFT JOIN students s2 ON d2.department_id = s2.department_id
                GROUP BY d2.department_id
            ) AS avg_students
    )
ORDER BY student_count DESC;
-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========
-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT c.course_name,
    COUNT(g.grade_id) AS total_grades,
    SUM(
        CASE
            WHEN g.grade >= 10 THEN 1
            ELSE 0
        END
    ) AS passed_grades,
    ROUND(
        (
            SUM(
                CASE
                    WHEN g.grade >= 10 THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(g.grade_id),
        2
    ) AS pass_rate_percentage
FROM courses c
    JOIN enrollments e ON c.course_id = e.course_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id,
    c.course_name
ORDER BY pass_rate_percentage DESC;
-- Q27. Display student ranking by descending average
SELECT RANK() OVER (
        ORDER BY AVG(g.grade * g.coefficient) / AVG(g.coefficient) DESC
    ) AS rank,
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(
        AVG(g.grade * g.coefficient) / AVG(g.coefficient),
        2
    ) AS average_grade
FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id,
    student_name
ORDER BY rank;
-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.enrollment_id
    JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1
ORDER BY c.course_name,
    g.evaluation_date;
-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
    COALESCE(SUM(c.credits), 0) AS total_credits
FROM professors p
    LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id,
    professor_name
ORDER BY total_credits DESC,
    professor_name;
-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    ROUND(
        (COUNT(e.enrollment_id) * 100.0) / c.max_capacity,
        2
    ) AS percentage_full
FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id,
    c.course_name,
    c.max_capacity
HAVING (COUNT(e.enrollment_id) * 100.0) / c.max_capacity > 80
ORDER BY percentage_full DESC;