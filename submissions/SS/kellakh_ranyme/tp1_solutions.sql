-- ============================================
-- TP1: University Management System
-- ============================================


CREATE DATABASE university_db;
USE university_db;

-- ------------------------------------------------------------------
-- TABLE CREATION
-- ------------------------------------------------------------------

-- departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- professors table 
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

-- students table with level check constraint
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
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2'))
);

-- courses table - need to make sure credits > 0
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
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (credits > 0),
    CHECK (semester IN (1, 2))
);

-- enrollments junction table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE KEY unique_student_course_year (student_id, course_id, academic_year)
);

-- grades table - grades between 0 and 20 (french system)
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5, 2),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    CHECK (grade >= 0 AND grade <= 20)
);

-- ------------------------------------------------------------
-- INDEXES for better performance
-- ------------------------------------------------------------

CREATE INDEX idx_student_dept ON students(department_id);
CREATE INDEX idx_course_prof ON courses(professor_id);
CREATE INDEX idx_enroll_student ON enrollments(student_id);
CREATE INDEX idx_enroll_course ON enrollments(course_id);
CREATE INDEX idx_grades_enroll ON grades(enrollment_id);


CREATE INDEX idx_enroll_year ON enrollments(academic_year);

-- ------------------------------------------------------------
-- INSERT TEST DATA
-- ------------------------------------------------------------

-- first, add departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Alan Turing', '2000-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Ada Lovelace', '2000-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Marie Curie', '2001-09-01'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Gustave Eiffel', '2002-09-01');

-- now professors (6 total)
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Turing', 'Alan', 'alan.turing@university.edu', '123-456-7890', 1, '2010-08-15', 85000.00, 'Artificial Intelligence'),
('Knuth', 'Donald', 'donald.knuth@university.edu', '123-456-7891', 1, '2012-01-10', 90000.00, 'Algorithms'),
('Lovelace', 'Ada', 'ada.lovelace@university.edu', '123-456-7892', 1, '2015-03-20', 82000.00, 'Programming Languages'),
('Gauss', 'Carl', 'carl.gauss@university.edu', '123-456-7893', 2, '2011-11-05', 78000.00, 'Number Theory'),
('Curie', 'Marie', 'marie.curie@university.edu', '123-456-7894', 3, '2013-07-12', 81000.00, 'Quantum Physics'),
('Eiffel', 'Gustave', 'gustave.eiffel@university.edu', '123-456-7895', 4, '2014-09-30', 83000.00, 'Structural Engineering');

-- add students (8 students as required)
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('STU2024001', 'Smith', 'John', '2002-05-15', 'john.smith@student.edu', '987-654-3210', '123 Main St, City', 1, 'L3', '2024-09-01'),
('STU2024002', 'Johnson', 'Emma', '2003-08-22', 'emma.johnson@student.edu', '987-654-3211', '456 Oak Ave, Town', 1, 'L2', '2024-09-01'),
('STU2024003', 'Williams', 'Michael', '2001-11-10', 'michael.w@student.edu', '987-654-3212', '789 Pine Rd, Village', 1, 'M1', '2023-09-01'),
('STU2024004', 'Brown', 'Sophia', '2002-03-30', 'sophia.brown@student.edu', '987-654-3213', '321 Elm St, City', 2, 'L3', '2024-09-01'),
('STU2024005', 'Jones', 'David', '2003-07-18', 'david.jones@student.edu', '987-654-3214', '654 Maple Dr, Town', 2, 'L2', '2024-09-01'),
('STU2024006', 'Garcia', 'Maria', '2001-12-05', 'maria.garcia@student.edu', '987-654-3215', '987 Cedar Ln, Village', 3, 'M1', '2023-09-01'),
('STU2024007', 'Miller', 'James', '2002-09-12', 'james.miller@student.edu', '987-654-3216', '147 Birch St, City', 3, 'L3', '2024-09-01'),
('STU2024008', 'Davis', 'Sarah', '2003-01-25', 'sarah.davis@student.edu', '987-654-3217', '258 Spruce Ave, Town', 4, 'L2', '2024-09-01');

-- insert courses (7 courses)
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS101', 'Intro to Programming', 'Learn Python basics', 6, 1, 1, 3, 35),
('CS201', 'Data Structures', 'Stacks, queues, trees, etc', 5, 2, 1, 2, 30),
('CS301', 'AI Fundamentals', 'Intro to AI concepts', 6, 2, 1, 1, 25),
('MATH101', 'Calculus I', 'Differential calculus', 5, 1, 2, 4, 40),
('MATH201', 'Linear Algebra', 'Vectors and matrices', 5, 2, 2, 4, 35),
('PHY101', 'Physics I', 'Mechanics', 6, 1, 3, 5, 30),
('CE101', 'Structural Analysis', 'Building structures', 5, 1, 4, 6, 25);

-- enrollments (15 enrollments as required)
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2024-09-15', '2024-2025', 'In Progress'),
(1, 2, '2024-09-15', '2024-2025', 'In Progress'),
(1, 3, '2024-09-15', '2024-2025', 'In Progress'),
(2, 1, '2024-09-16', '2024-2025', 'In Progress'),
(2, 4, '2024-09-16', '2024-2025', 'In Progress'),
(3, 3, '2024-09-14', '2024-2025', 'In Progress'),
(3, 4, '2024-09-14', '2024-2025', 'In Progress'),
(4, 4, '2024-09-15', '2024-2025', 'In Progress'),
(4, 5, '2024-09-15', '2024-2025', 'In Progress'),
(5, 5, '2024-09-16', '2024-2025', 'In Progress'),
(6, 6, '2024-09-14', '2024-2025', 'In Progress'),
(7, 6, '2024-09-15', '2024-2025', 'In Progress'),
(8, 7, '2024-09-16', '2024-2025', 'In Progress'),
(1, 4, '2024-09-15', '2024-2025', 'In Progress'),
(2, 3, '2024-09-16', '2024-2025', 'In Progress');

-- grades (12 grades as required)
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Exam', 15.5, 2.0, '2024-10-20', 'Good work overall'),
(1, 'Assignment', 17.0, 1.0, '2024-10-05', 'Excellent work!'),
(2, 'Exam', 14.0, 2.0, '2024-10-22', 'Satisfactory performance'),
(3, 'Project', 16.5, 3.0, '2024-10-25', 'Very well done'),
(4, 'Exam', 12.0, 2.0, '2024-10-20', 'Could be better'),
(5, 'Assignment', 18.0, 1.0, '2024-10-07', 'Perfect score!'),
(6, 'Lab', 13.5, 1.5, '2024-10-15', 'Good lab work'),
(7, 'Exam', 10.5, 2.0, '2024-10-21', 'Barely passing'),
(8, 'Project', 14.5, 3.0, '2024-10-24', 'Good effort'),
(9, 'Assignment', 16.0, 1.0, '2024-10-06', 'Well written'),
(10, 'Exam', 11.0, 2.0, '2024-10-23', 'Below average'),
(11, 'Lab', 15.0, 1.5, '2024-10-16', 'Good report');

-- ------------------------------------------------------------
-- QUERIES
-- ------------------------------------------------------------

-- ========== PART 1: BASIC QUERIES ==========

-- Q1. List all students with basic info
SELECT 
    last_name, 
    first_name, 
    email, 
    level 
FROM students
ORDER BY last_name;

-- Q2. Show all CS professors
SELECT 
    p.last_name, 
    p.first_name, 
    p.email, 
    p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science'
ORDER BY p.last_name;

-- Q3. Find courses with more than 5 credits
SELECT 
    course_code, 
    course_name, 
    credits
FROM courses
WHERE credits > 5;

-- Q4. L3 students only
SELECT 
    student_number, 
    last_name, 
    first_name, 
    email
FROM students
WHERE level = 'L3'
ORDER BY last_name;

-- Q5. Semester 1 courses
SELECT 
    course_code, 
    course_name, 
    credits, 
    semester
FROM courses
WHERE semester = 1;

-- ========== PART 2: JOINS ==========

-- Q6. Courses with professor names
SELECT 
    c.course_code, 
    c.course_name,
    CONCAT(p.last_name, ', ', p.first_name) AS professor
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id
ORDER BY c.course_code;

-- Q7. All enrollments with student and course info
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    c.course_name,
    e.enrollment_date,
    e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY e.enrollment_date DESC;

-- Q8. Students with their department
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    d.department_name,
    s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
ORDER BY d.department_name, s.last_name;

-- Q9. Grades with all related info
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    c.course_name,
    g.evaluation_type,
    g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.last_name, c.course_name;

-- Q10. Count courses per professor
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor,
    COUNT(c.course_id) AS courses_taught
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
ORDER BY courses_taught DESC;

-- ========== PART 3: AGGREGATES ==========

-- Q11. Average grade per student
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    ROUND(AVG(g.grade), 2) AS average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average DESC;

-- Q12. Student count per department
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY student_count DESC;

-- Q13. Total budget all departments
SELECT 
    SUM(budget) AS total_budget
FROM departments;

-- Q14. Courses per department
SELECT 
    d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name
ORDER BY course_count DESC;

-- Q15. Average salary by department
SELECT 
    d.department_name,
    ROUND(AVG(p.salary), 2) AS avg_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name
ORDER BY avg_salary DESC;

-- ========== PART 4: ADVANCED ==========

-- Q16. Top 3 students by average
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    ROUND(AVG(g.grade), 2) AS avg_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY avg_grade DESC
LIMIT 3;

-- Q17. Courses with no students
SELECT 
    c.course_code, 
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Students who passed everything
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    COUNT(DISTINCT e.course_id) AS passed_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(DISTINCT e.course_id) = (
    SELECT COUNT(DISTINCT e2.course_id) 
    FROM enrollments e2 
    WHERE e2.student_id = s.student_id
);

-- Q19. Professors teaching > 2 courses
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor,
    COUNT(c.course_id) AS course_count
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;

-- Q20. Students in > 2 courses
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    COUNT(DISTINCT e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(DISTINCT e.course_id) > 2;

-- ========== PART 5: SUBQUERIES ==========

-- Q21. Students above dept average
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    ROUND(s_avg.student_avg, 2) AS student_avg,
    ROUND(d_avg.dept_avg, 2) AS dept_avg
FROM students s
JOIN (
    SELECT e.student_id, AVG(g.grade) AS student_avg
    FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY e.student_id
) s_avg ON s.student_id = s_avg.student_id
JOIN (
    SELECT s2.department_id, AVG(g2.grade) AS dept_avg
    FROM students s2
    JOIN enrollments e2 ON s2.student_id = e2.student_id
    JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
    GROUP BY s2.department_id
) d_avg ON s.department_id = d_avg.department_id
WHERE s_avg.student_avg > d_avg.dept_avg;

-- Q22. Courses above avg enrollment
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(enrollment_counts.cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM enrollments
        GROUP BY course_id
    ) AS enrollment_counts
);

-- Q23. Professors in highest budget dept
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Students with no grades
SELECT 
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    s.email
FROM students s
WHERE s.student_id NOT IN (
    SELECT DISTINCT e.student_id
    FROM enrollments e
    JOIN grades g ON e.enrollment_id = g.enrollment_id
);

-- Q25. Departments above avg students
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(student_counts.cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM students
        GROUP BY department_id
    ) AS student_counts
);

-- ========== PART 6: BUSINESS ANALYSIS ==========

-- Q26. Pass rate per course
SELECT 
    c.course_name,
    COUNT(g.grade_id) AS total_grades,
    SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed,
    ROUND(
        SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / 
        COUNT(g.grade_id), 
        2
    ) AS pass_rate
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name
ORDER BY pass_rate DESC;

-- Q27. Student ranking (with window function)
SELECT 
    ROW_NUMBER() OVER (ORDER BY AVG(g.grade) DESC) AS rank_no,
    CONCAT(s.last_name, ' ', s.first_name) AS student,
    ROUND(AVG(g.grade), 2) AS average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average DESC;

-- Q28. Report card for student ID 1
SELECT 
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    (g.grade * g.coefficient) AS weighted_score
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_id = 1
ORDER BY c.course_name, g.evaluation_date;

-- Q29. Teaching load (total credits)
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS professor,
    COALESCE(SUM(c.credits), 0) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
ORDER BY total_credits DESC;

-- Q30. Overloaded courses (>80% capacity)
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS enrolled,
    c.max_capacity,
    ROUND(COUNT(e.enrollment_id) * 100.0 / c.max_capacity, 2) AS percent_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING percent_full > 80
ORDER BY percent_full DESC;

-- Just to verify everything works, let's check some counts
SELECT 'Total Students' AS item, COUNT(*) AS count FROM students
UNION ALL
SELECT 'Total Professors', COUNT(*) FROM professors
UNION ALL
SELECT 'Total Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Total Enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'Total Grades', COUNT(*) FROM grades;
