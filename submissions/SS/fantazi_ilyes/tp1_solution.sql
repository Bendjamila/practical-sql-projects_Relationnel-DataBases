-- univ Database chema and queries tp1 databose 

-- 1) Database creation
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- 2) Tables
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
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  department_id INT,
  hire_date DATE,
  salary DECIMAL(10,2),
  specialization VARCHAR(100),
  CONSTRAINT fk_prof_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_number VARCHAR(20) NOT NULL UNIQUE,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  date_of_birth DATE,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  address TEXT,
  department_id INT,
  level VARCHAR(20) CHECK (level IN ('L1','L2','L3','M1','M2')),
  enrollment_date DATE DEFAULT (CURRENT_DATE),
  CONSTRAINT fk_student_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_code VARCHAR(10) NOT NULL UNIQUE,
  course_name VARCHAR(150) NOT NULL,
  description TEXT,
  credits INT NOT NULL CHECK (credits > 0),
  semester INT CHECK (semester IN (1,2)),
  department_id INT,
  professor_id INT,
  max_capacity INT DEFAULT 30,
  CONSTRAINT fk_course_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_course_prof FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollments (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE DEFAULT (CURRENT_DATE),
  academic_year VARCHAR(9) NOT NULL,
  status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
  CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES students(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_student_course_year UNIQUE (student_id, course_id, academic_year)
);

CREATE TABLE grades (
  grade_id INT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id INT NOT NULL,
  evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
  grade DECIMAL(5,2) CHECK (grade >= 0 AND grade <= 20),
  coefficient DECIMAL(3,2) DEFAULT 1.00,
  evaluation_date DATE,
  comments TEXT,
  CONSTRAINT fk_grade_enroll FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3) Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4) Test data inserts
-- Departments (explicit ids to simplify inserts)
INSERT INTO departments (department_id, department_name, building, budget, department_head, creation_date) VALUES
(1,'Computer Science','Building A',500000.00,'Dr. Ada Lovelace','2010-09-01'),
(2,'Mathematics','Building B',350000.00,'Dr. Carl Gauss','2011-03-15'),
(3,'Physics','Building C',400000.00,'Dr. Marie Curie','2009-11-05'),
(4,'Civil Engineering','Building D',600000.00,'Dr. Isambard Kingdom','2008-06-20');

-- Professors (6)
INSERT INTO professors (professor_id,last_name,first_name,email,phone,department_id,hire_date,salary,specialization) VALUES
(1,'Turing','Alan','alan.turing@univ.edu','+33123456701',1,'2015-08-15',55000.00,'Algorithms'),
(2,'Knuth','Donald','donald.knuth@univ.edu','+33123456702',1,'2010-09-01',72000.00,'Computer Science Theory'),
(3,'Hopper','Grace','grace.hopper@univ.edu','+33123456703',1,'2012-01-20',61000.00,'Programming Languages'),
(4,'Noether','Emmy','emmy.noether@univ.edu','+33123456704',2,'2013-05-10',65000.00,'Algebra'),
(5,'Feynman','Richard','richard.feynman@univ.edu','+33123456705',3,'2009-09-23',80000.00,'Quantum Mechanics'),
(6,'Rossi','Luca','luca.rossi@univ.edu','+33123456706',4,'2018-02-01',53000.00,'Structural Engineering');

-- Students (8)
INSERT INTO students (student_id,student_number,last_name,first_name,date_of_birth,email,phone,address,department_id,level,enrollment_date) VALUES
(1,'S2024001','Martin','Sophie','2002-05-10','sophie.martin@student.univ.edu','+33611111111','12 Rue A, City',1,'L2','2023-09-01'),
(2,'S2024002','Dupont','Julien','2001-11-24','julien.dupont@student.univ.edu','+33622222222','34 Av B, City',1,'L3','2022-09-01'),
(3,'S2024003','Moreau','Camille','2003-02-14','camille.moreau@student.univ.edu','+33633333333','56 Bd C, City',2,'L2','2023-09-01'),
(4,'S2024004','Bernard','Lucas','2000-07-30','lucas.bernard@student.univ.edu','+33644444444','78 Pl D, City',3,'M1','2021-09-01'),
(5,'S2024005','Petit','Emma','2002-12-05','emma.petit@student.univ.edu','+33655555555','90 St E, City',1,'L3','2022-09-01'),
(6,'S2024006','Garcia','Carlos','1999-03-17','carlos.garcia@student.univ.edu','+33666666666','11 Ln F, City',4,'M1','2021-09-01'),
(7,'S2024007','Nguyen','Linh','2003-09-02','linh.nguyen@student.univ.edu','+33677777777','22 Way G, City',2,'L2','2023-09-01'),
(8,'S2024008','Rossi','Marco','2001-01-12','marco.rossi@student.univ.edu','+33688888888','33 Rd H, City',4,'L3','2022-09-01');

-- Courses (7)
INSERT INTO courses (course_id,course_code,course_name,description,credits,semester,department_id,professor_id,max_capacity) VALUES
(1,'CS101','Introduction to Programming','Basics of programming in Python',6,1,1,3,40),
(2,'CS201','Algorithms','Design and analysis of algorithms',6,2,1,1,35),
(3,'CS301','Operating Systems','Concepts of OS design',5,2,1,2,30),
(4,'MATH101','Calculus I','Differential calculus',6,1,2,4,50),
(5,'PHYS201','Mechanics','Classical mechanics',6,2,3,5,40),
(6,'CE201','Statics','Statics for civil engineering',5,1,4,6,45),
(7,'CS150','Data Structures','Linear and non-linear data structures',5,1,1,1,30);

-- Enrollments (15) spanning 2023-2024 and 2022-2023
INSERT INTO enrollments (enrollment_id,student_id,course_id,enrollment_date,academic_year,status) VALUES
(1,1,1,'2023-09-03','2023-2024','In Progress'),
(2,1,2,'2023-09-05','2023-2024','In Progress'),
(3,2,1,'2022-09-02','2022-2023','Passed'),
(4,2,3,'2023-09-04','2023-2024','In Progress'),
(5,3,4,'2023-09-03','2023-2024','In Progress'),
(6,4,5,'2022-09-10','2022-2023','Passed'),
(7,5,1,'2022-09-05','2022-2023','Failed'),
(8,5,7,'2023-09-06','2023-2024','In Progress'),
(9,6,6,'2021-09-12','2021-2022','Passed'),
(10,7,4,'2023-09-07','2023-2024','In Progress'),
(11,8,6,'2022-09-08','2022-2023','Passed'),
(12,3,2,'2023-09-09','2023-2024','In Progress'),
(13,4,2,'2023-09-10','2023-2024','In Progress'),
(14,2,7,'2023-09-11','2023-2024','In Progress'),
(15,1,7,'2023-09-12','2023-2024','In Progress');

-- Grades (12) — various evaluation types and coefficients
INSERT INTO grades (grade_id,enrollment_id,evaluation_type,grade,coefficient,evaluation_date,comments) VALUES
(1,3,'Exam',15.50,1.50,'2023-01-15','Good work'),
(2,6,'Exam',17.00,2.00,'2022-12-10','Excellent'),
(3,9,'Project',16.75,1.20,'2021-11-05','Well executed'),
(4,11,'Exam',14.00,2.00,'2022-12-02','Satisfactory'),
(5,7,'Assignment',10.50,0.80,'2022-10-10','Needs improvement'),
(6,1,'Lab',13.25,0.50,'2023-10-05','Acceptable'),
(7,2,'Exam',12.00,2.00,'2023-12-12','Below average'),
(8,5,'Assignment',18.00,1.00,'2023-11-01','Very good'),
(9,8,'Exam',14.50,2.00,'2023-12-20','OK'),
(10,12,'Lab',15.00,0.75,'2023-11-25','Good lab'),
(11,13,'Project',16.00,1.50,'2023-12-05','Solid'),
(12,14,'Assignment',11.50,1.00,'2023-10-20','Fair');

-- 5) 30 SQL queries (examples required by assignment)
-- 1
SELECT * FROM departments;

-- 2: List professors with their department names
SELECT p.professor_id,p.first_name,p.last_name,d.department_name
FROM professors p
LEFT JOIN departments d ON p.department_id = d.department_id;

-- 3: Students in Computer Science
SELECT s.student_number,s.first_name,s.last_name
FROM students s JOIN departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- 4: Courses with assigned professor
SELECT c.course_code,c.course_name,p.first_name,p.last_name
FROM courses c LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- 5: Enrollment counts per course (current academic year 2023-2024)
SELECT c.course_code,c.course_name,COUNT(e.enrollment_id) AS enrolled
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.academic_year = '2023-2024'
GROUP BY c.course_id;

-- 6: Students with average grade (weighted by coefficient)
SELECT s.student_id,s.first_name,s.last_name,
  ROUND(SUM(g.grade * g.coefficient) / NULLIF(SUM(g.coefficient),0),2) AS weighted_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY weighted_avg DESC;

-- 7: Courses with average grade
SELECT c.course_code,c.course_name,ROUND(AVG(g.grade),2) AS avg_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id
HAVING COUNT(g.grade) > 0;

-- 8: Top 5 students by average
SELECT s.student_number,s.first_name,s.last_name,
  ROUND(AVG(g.grade),2) AS avg_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY avg_grade DESC
LIMIT 5;

-- 9: Professors with number of courses they teach
SELECT p.professor_id,p.first_name,p.last_name,COUNT(c.course_id) AS courses_taught
FROM professors p LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- 10: Departments budget summary
SELECT department_name,SUM(budget) AS total_budget FROM departments GROUP BY department_name;

-- 11: Students enrolled in more than 2 courses in 2023-2024
SELECT s.student_number,s.first_name,s.last_name,COUNT(e.course_id) AS cnt
FROM students s JOIN enrollments e ON s.student_id = e.student_id
WHERE e.academic_year = '2023-2024'
GROUP BY s.student_id HAVING cnt > 2;

-- 12: Courses at or over capacity
SELECT c.course_code,c.course_name,c.max_capacity,COUNT(e.enrollment_id) AS enrolled
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id HAVING enrolled >= c.max_capacity;

-- 13: Grades distribution for a specific course (CS101)
SELECT g.evaluation_type,COUNT(*) AS count,ROUND(AVG(g.grade),2) AS avg_grade
FROM grades g JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_code = 'CS101'
GROUP BY g.evaluation_type;

-- 14: Students without any enrollments
SELECT s.student_id,s.first_name,s.last_name FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- 15: Average salary by department
SELECT d.department_name,ROUND(AVG(p.salary),2) AS avg_salary
FROM professors p JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_id;

-- 16: Recent hires (last 5 years)
SELECT * FROM professors WHERE hire_date >= DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR);

-- 17: Students per level
SELECT level,COUNT(*) AS students_count FROM students GROUP BY level;

-- 18: Enrollment status counts
SELECT status,COUNT(*) AS count FROM enrollments GROUP BY status;

-- 19: Courses offered by department
SELECT d.department_name,c.course_code,c.course_name FROM courses c JOIN departments d ON c.department_id = d.department_id ORDER BY d.department_name;

-- 20: Find students with avg grade below 12
SELECT s.student_number,s.first_name,s.last_name,ROUND(AVG(g.grade),2) AS avg_grade
FROM students s JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id HAVING avg_grade < 12;

-- 21: Yearly enrollments count
SELECT academic_year,COUNT(*) AS enroll_count FROM enrollments GROUP BY academic_year ORDER BY academic_year DESC;

-- 22: All grades for a student (S2024001)
SELECT s.student_number,g.* FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
WHERE s.student_number = 'S2024001';

-- 23: Students and their departments (including those with NULL)
SELECT s.student_number,s.first_name,s.last_name,d.department_name FROM students s LEFT JOIN departments d ON s.department_id = d.department_id;

-- 24: Courses without assigned professor
SELECT course_code,course_name FROM courses WHERE professor_id IS NULL;

-- 25: Highest grade per course
SELECT c.course_code,c.course_name,MAX(g.grade) AS max_grade
FROM courses c JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- 26: Students who dropped a course
SELECT s.student_number,s.first_name,s.last_name,c.course_code,c.course_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Dropped'
JOIN courses c ON e.course_id = c.course_id;

-- 27: Department heads and department budgets
SELECT department_name,department_head,budget FROM departments;

-- 28: Courses and enrollment percentage of capacity
SELECT c.course_code,c.course_name,COUNT(e.enrollment_id) AS enrolled,c.max_capacity,
  ROUND(100.0 * COUNT(e.enrollment_id) / NULLIF(c.max_capacity,0),2) AS pct_capacity
FROM courses c LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- 29: Students who passed at least one course
SELECT DISTINCT s.student_number,s.first_name,s.last_name
FROM students s JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed';

-- 30: Weighted average grade per course
SELECT c.course_code,c.course_name,
  ROUND(SUM(g.grade * g.coefficient) / NULLIF(SUM(g.coefficient),0),2) AS weighted_avg
FROM courses c JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- End of file
