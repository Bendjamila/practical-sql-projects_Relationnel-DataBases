--solution tp1 dta base
CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;
-- -----------------------------
-- Schema: tables + indexes
-- -----------------------------

CREATE TABLE IF NOT EXISTS departments (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  department_name VARCHAR(100) NOT NULL,
  building VARCHAR(50),
  budget DECIMAL(12,2),
  department_head VARCHAR(100),
  creation_date DATE
);

CREATE TABLE IF NOT EXISTS professors (
  professor_id INT PRIMARY KEY AUTO_INCREMENT,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  department_id INT,
  hire_date DATE,
  salary DECIMAL(10,2),
  specialization VARCHAR(100),
  CONSTRAINT fk_prof_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS students (
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
  CONSTRAINT fk_stu_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS courses (
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
  CONSTRAINT chk_semester CHECK (semester IN (1,2)),
  CONSTRAINT fk_course_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_course_prof FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS enrollments (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE,
  academic_year VARCHAR(9) NOT NULL,
  status ENUM('In Progress','Passed','Failed','Dropped') DEFAULT 'In Progress',
  CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES students(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_enroll UNIQUE(student_id, course_id, academic_year)
);

CREATE TABLE IF NOT EXISTS grades (
  grade_id INT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id INT NOT NULL,
  evaluation_type ENUM('Assignment','Lab','Exam','Project'),
  grade DECIMAL(5,2),
  coefficient DECIMAL(3,2) DEFAULT 1.00,
  evaluation_date DATE,
  comments TEXT,
  CONSTRAINT fk_grade_enroll FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Indexes
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- -----------------------------
-- Sample test data (minimal set required)
-- -----------------------------

-- Departments
INSERT INTO departments (department_id, department_name, building, budget, department_head, creation_date) VALUES
(1,'Computer Science','Building A',500000.00,'Dr. Alan', '2010-09-01'),
(2,'Mathematics','Building B',350000.00,'Dr. Euler','2011-09-01'),
(3,'Physics','Building C',400000.00,'Dr. Curie','2012-09-01'),
(4,'Civil Engineering','Building D',600000.00,'Dr. Brunel','2009-09-01')
ON DUPLICATE KEY UPDATE department_name=VALUES(department_name);

-- Professors
INSERT INTO professors (professor_id,last_name,first_name,email,phone,department_id,hire_date,salary,specialization) VALUES
(1,'Smith','John','john.smith@uni.edu','+33100000001',1,'2015-08-01',60000.00,'AI'),
(2,'Doe','Jane','jane.doe@uni.edu','+33100000002',1,'2016-09-15',62000.00,'Systems'),
(3,'Brown','Alice','alice.brown@uni.edu','+33100000003',1,'2017-01-10',58000.00,'Security'),
(4,'Martin','Paul','paul.martin@uni.edu','+33100000004',2,'2013-03-05',55000.00,'Algebra'),
(5,'Novak','Eva','eva.novak@uni.edu','+33100000005',3,'2018-06-20',57000.00,'Quantum'),
(6,'King','Mark','mark.king@uni.edu','+33100000006',4,'2012-11-11',65000.00,'Structures')
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- Students
INSERT INTO students (student_id,student_number,last_name,first_name,date_of_birth,email,phone,address,department_id,level,enrollment_date) VALUES
(1,'S1001','Garcia','Luis','2001-02-03','luis.garcia@uni.edu','+33100000011','Addr 1',1,'L3','2022-09-01'),
(2,'S1002','Zhang','Li','2002-05-15','li.zhang@uni.edu','+33100000012','Addr 2',1,'L2','2023-09-01'),
(3,'S1003','Singh','Asha','2000-12-20','asha.singh@uni.edu','+33100000013','Addr 3',2,'L3','2021-09-01'),
(4,'S1004','Khan','Omar','1999-07-07','omar.khan@uni.edu','+33100000014','Addr 4',3,'M1','2020-09-01'),
(5,'S1005','Lopez','Maria','2001-11-11','maria.lopez@uni.edu','+33100000015','Addr 5',1,'L3','2022-09-01'),
(6,'S1006','Nguyen','Anh','2003-03-03','anh.nguyen@uni.edu','+33100000016','Addr 6',4,'L2','2024-09-01'),
(7,'S1007','Dubois','Claire','2000-08-08','claire.dubois@uni.edu','+33100000017','Addr 7',2,'M1','2021-09-01'),
(8,'S1008','Ivanov','Nikolai','2002-10-10','nikolai.ivanov@uni.edu','+33100000018','Addr 8',3,'L2','2023-09-01')
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- Courses
INSERT INTO courses (course_id,course_code,course_name,description,credits,semester,department_id,professor_id,max_capacity) VALUES
(1,'CS101','Intro to Programming','Basics of programming',6,1,1,1,40),
(2,'CS201','Data Structures','Arrays, lists, trees',6,2,1,2,35),
(3,'CS301','Operating Systems','Processes and threads',5,1,1,3,30),
(4,'MA101','Calculus I','Limits and derivatives',5,1,2,4,50),
(5,'PH101','Mechanics','Classical mechanics',6,2,3,5,45),
(6,'CE101','Statics','For civil engineering',5,1,4,6,40),
(7,'CS401','Security','Applied security topics',5,2,1,3,30)
ON DUPLICATE KEY UPDATE course_name=VALUES(course_name);

-- Enrollments (create at least 15)
INSERT INTO enrollments (enrollment_id,student_id,course_id,enrollment_date,academic_year,status) VALUES
(1,1,1,'2024-09-01','2024-2025','In Progress'),
(2,1,2,'2024-09-01','2024-2025','In Progress'),
(3,2,1,'2024-09-01','2024-2025','In Progress'),
(4,3,4,'2024-09-01','2024-2025','Passed'),
(5,4,5,'2024-09-01','2024-2025','Passed'),
(6,5,1,'2024-09-01','2024-2025','In Progress'),
(7,6,6,'2024-09-01','2024-2025','In Progress'),
(8,7,4,'2023-09-01','2023-2024','Passed'),
(9,8,5,'2023-09-01','2023-2024','Failed'),
(10,2,3,'2024-09-01','2024-2025','In Progress'),
(11,3,2,'2024-09-01','2024-2025','In Progress'),
(12,5,7,'2024-09-01','2024-2025','In Progress'),
(13,1,3,'2023-09-01','2023-2024','Passed'),
(14,4,2,'2024-09-01','2024-2025','In Progress'),
(15,6,2,'2024-09-01','2024-2025','In Progress')
ON DUPLICATE KEY UPDATE status=VALUES(status);

-- Grades (at least 12)
INSERT INTO grades (grade_id,enrollment_id,evaluation_type,grade,coefficient,evaluation_date,comments) VALUES
(1,4,'Exam',15.50,1.00,'2024-12-15','Good'),
(2,5,'Exam',12.00,1.00,'2024-12-16','Satisfactory'),
(3,8,'Project',17.00,1.50,'2023-11-20','Excellent'),
(4,13,'Exam',16.00,1.00,'2023-12-10','Very Good'),
(5,11,'Assignment',14.00,0.50,'2024-10-01','Ok'),
(6,1,'Lab',13.00,0.50,'2024-10-05','Lab work'),
(7,2,'Assignment',11.00,0.30,'2024-10-07','Needs improvement'),
(8,6,'Exam',18.00,1.00,'2024-12-18','Great'),
(9,3,'Exam',10.00,1.00,'2024-12-19','Pass'),
(10,9,'Exam',9.00,1.00,'2023-12-19','Fail'),
(11,12,'Lab',14.50,0.50,'2024-11-11','Nice'),
(12,10,'Exam',13.00,1.00,'2024-12-12','Good')
ON DUPLICATE KEY UPDATE grade=VALUES(grade);

-- -----------------------------
-- End of schema + sample data
-- -----------------------------

-- Q1. List all students with their main information (name, email, level)
SELECT last_name, first_name, email, level
FROM students;

-- Q2. Display all professors from the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3. Find all courses with more than 5 credits
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4. List students enrolled in L3 level
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5. Display courses from semester 1
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- Q6. Display all courses with the professor's name
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;

-- Q7. List all enrollments with student name and course name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.enrollment_date,
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8. Display students with their department name
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;

-- Q9. List grades with student name, course name, and grade obtained
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10. Display professors with the number of courses they teach
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q11. Calculate the overall average grade for each student
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(AVG(g.grade),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12. Count the number of students per department
SELECT d.department_name, COUNT(s.student_number) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;

-- Q15. Calculate the average salary of professors per department
SELECT d.department_name, ROUND(AVG(p.salary),2) AS average_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;

-- Q16. Find the top 3 students with the best averages
SELECT student_name, average_grade
FROM (
  SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
         AVG(g.grade) AS average_grade
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN grades g ON e.enrollment_id = g.enrollment_id
  GROUP BY s.student_id, s.last_name, s.first_name
) t
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING SUM(CASE WHEN e.status <> 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19. Find professors who teach more than 2 courses
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.course_id) > 2;

-- Q21. Find students with an average higher than their department's average
SELECT t.student_name, ROUND(t.student_avg,2) AS student_avg, ROUND(d.dept_avg,2) AS department_avg
FROM (
  SELECT s.student_id, CONCAT(s.last_name, ' ', s.first_name) AS student_name,
         AVG(g.grade) AS student_avg,
         s.department_id
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN grades g ON e.enrollment_id = g.enrollment_id
  GROUP BY s.student_id, s.last_name, s.first_name, s.department_id
) t
JOIN (
  SELECT s.department_id, AVG(g.grade) AS dept_avg
  FROM students s
  JOIN enrollments e ON s.student_id = e.student_id
  JOIN grades g ON e.enrollment_id = g.enrollment_id
  GROUP BY s.department_id
) d ON t.department_id = d.department_id
WHERE t.student_avg > d.dept_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
SELECT x.course_name, x.cnt AS enrollment_count
FROM (
  SELECT c.course_id, c.course_name, COUNT(e.enrollment_id) AS cnt
  FROM courses c
  LEFT JOIN enrollments e ON c.course_id = e.course_id
  GROUP BY c.course_id, c.course_name
) x
JOIN (
  SELECT AVG(cnt) AS avg_enroll
  FROM (
    SELECT COUNT(e.enrollment_id) AS cnt
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id
  ) y
) a ON x.cnt > a.avg_enroll;

-- Q23. Display professors from the department with the highest budget
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, s.email
FROM students s
WHERE NOT EXISTS (
  SELECT 1 FROM enrollments e JOIN grades g ON e.enrollment_id = g.enrollment_id WHERE e.student_id = s.student_id
);

-- Q25. List departments with more students than the average
SELECT d.department_name, COUNT(s.student_number) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_number) > (
  SELECT AVG(stu_count) FROM (
    SELECT COUNT(s2.student_number) AS stu_count
    FROM departments d2
    LEFT JOIN students s2 ON d2.department_id = s2.department_id
    GROUP BY d2.department_id
  ) z
);

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT c.course_name,
  COUNT(g.grade_id) AS total_grades,
  SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
  ROUND(100.0 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / NULLIF(COUNT(g.grade_id),0),2) AS pass_rate_percentage
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27. Display student ranking by descending average (MySQL-compatible)
-- Q27. Display student ranking by descending average (MySQL-compatible)
SELECT @r := @r + 1 AS row_rank, t.student_name, ROUND(t.average_grade,2) AS average_grade
FROM (SELECT @r := 0) vars,
     (
       SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, AVG(g.grade) AS average_grade
       FROM students s
       JOIN enrollments e ON s.student_id = e.student_id
       JOIN grades g ON e.enrollment_id = g.enrollment_id
       GROUP BY s.student_id, s.last_name, s.first_name
       ORDER BY average_grade DESC
     ) t;

-- Q28. Generate a report card for student with student_id = 1
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
       ROUND(g.grade * COALESCE(g.coefficient,1),2) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COALESCE(SUM(c.credits),0) AS total_credits
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT c.course_name,
       COALESCE(cnt.current_enrollments,0) AS current_enrollments,
       c.max_capacity,
       ROUND(100.0 * COALESCE(cnt.current_enrollments,0) / NULLIF(c.max_capacity,0),2) AS percentage_full
FROM courses c
LEFT JOIN (
  SELECT course_id, COUNT(enrollment_id) AS current_enrollments
  FROM enrollments
  GROUP BY course_id
) cnt ON c.course_id = cnt.course_id
WHERE COALESCE(cnt.current_enrollments,0) > 0.8 * COALESCE(c.max_capacity,0);
