-- University_management:

-- creation of databases: 
CREATE DATABASE university_db;
USE university_db;

-- creation and insertion of data test into each  of tables:
-- departments:

CREATE TABLE departments (
department_id INT PRIMARY KEY AUTO_INCREMENT ,
 department_name VARCHAR(100) NOT NULL ,
 building VARCHAR(50) ,
 budget DECIMAL (12, 2) , 
 department_head VARCHAR(100) ,
 creation_date DATE );
INSERT INTO departments (department_name,building,budget,department_head,creation_date)
VALUES
('Computer Science','Building A',500000,'ZEKRI Ahmed','2012-09-01'),
('Mathematics','Building B',350000,'ALI Fatima','2012-01-15'),
('Physics','Building C',400000,'KHLIF Mouhamed','2011-09-10'),
('Civil Engineering','Building D',600000,'YOUCEF Tarek','2013-05-20');

-- professors:
CREATE TABLE professors (
  professor_id INT AUTO_INCREMENT PRIMARY KEY,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  department_id INT,
  hire_date DATE,
  salary DECIMAL(10,2),
  specialization VARCHAR(100),
  FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
INSERT INTO professors ( last_name, first_name,email,phone,department_id,hire_date,salary,specialization)
VALUES	
('KETFI','Noura','nketfi@univ.com',	'0620657890',1,	'2011-09-01',50000,'Artificial Intelligence'),
('BEN FATEH','Salah','sbenfateh@univ.com','0787654321',1,'2012-01-15',52000,'Cyber security'),
('MEHDI','Nawel','nmehdi@univ.com','0556123789',1,'2012-06-01',51000,'Networks'),
('CHRIF','Linda','lcharif@univ.com','0621654987',2,	'2013-03-20',48000,'Algebra'),
('DELHAM','Mourad','mdelham@univ.com','0654987321',3,'2017-09-10',49000,'Quantum Physics'),
('AMMAR','Yousef','yammar@univ.com'	,'0789321654',4,'2014-01-05',47000,	'Structures');

-- students:
CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  student_number VARCHAR(20) UNIQUE NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  date_of_birth DATE,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  address TEXT,
  department_id INT,
  level VARCHAR(20) CHECK (level IN ('L1','L2','L3','M1','M2')),
  enrollment_date DATE ,
  FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email,phone,address, department_id, level , enrollment_date)
VALUES
('2024001','SAMI','Ali','2003-02-10','ali.sami@student.com','0555123456','Berraki-Alger',1,'L2',CURDATE()),
('2024002','BENSADEK','Bourhan','2002-05-15','bourhan.bensadek@student.com','0656784392','Babezzouar-Alger',1,'L3',CURDATE()),
('2024003','DERBALI','Chahra','2003-07-20','chahra.derbali@student.com','0544231687','Korso-Boumerdes',2,'L2',CURDATE()),
('2024004','AMMARI','Wafaa','2001-11-30','wafaa.ammari@student.com','0644568932','Ghassira-Batna',3,'M1',CURDATE()),
('2024005','TALBI','Anis','2002-03-22','anis.talbi@student.com','0567894312','Staouali-Alger',4,'L3',CURDATE()),
('2024006','ADDAS','Fares','2003-09-12','fares.addas@student.com','0786543210','Boudouaou-Boumerdes',1,'M1',CURDATE()),
('2024007','KHELFA','Loubna','2002-12-05','loubna.khelfa@student.com','0734256791','Merchi-Setif',2,'L2',CURDATE()),
('2024008','MERDASI','Hanaa','2003-06-18','hanaa.merdasi@student.com','0698124536','Birelater-Tibessa',3,'L3',CURDATE());

-- courses:
CREATE TABLE courses (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  course_code VARCHAR(10) UNIQUE NOT NULL,
  course_name VARCHAR(150) NOT NULL,
  description TEXT,
  credits INT NOT NULL CHECK (credits > 0),
  semester INT CHECK (semester BETWEEN 1 AND 2),
  department_id INT,
  professor_id INT,
  max_capacity INT DEFAULT 30,
  FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id)
VALUES
('CS101','Introduction to AI','AI Foundations',5,1,1,1),
('CS102','Introduction to Cyber Security','Cyber foundations',6,2,1,2),
('CS103','Networks','Network concepts',5,1,1,3),
('MATH101','Algebra I','Solving linear systems',5,1,2,4),
('PHYS101','Quantum Physics','Some deffinitions',6,2,3,5),
('CE101','Structures I','Structures foundations',5,1,4,6),
('CS104','Macine Learning','Supervised ML',5,2,1,1),
('CS105','ML Algorithms','Some Foundations',5,1,1,1);

-- enrollments:
CREATE TABLE enrollments (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE ,
  academic_year VARCHAR(9) NOT NULL,
  status VARCHAR(20) DEFAULT 'In Progress' CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  UNIQUE (student_id, course_id, academic_year)
);
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status)
VALUES
(1,1,CURDATE(),'2024-2025','In Progress'),
(1,2,CURDATE(),'2024-2025','Dropped'),
(2,1,CURDATE(),'2024-2025','Failed'),
(2,2,CURDATE(),'2024-2025','In Progress'),
(3,3,CURDATE(),'2024-2025','In Progress'),
(3,7,CURDATE(),'2024-2025','In Progress'),
(4,4,CURDATE(),'2024-2025','In Progress'),
(5,5,CURDATE(),'2024-2025','Dropped'),
(6,1,CURDATE(),'2024-2025','In Progress'),
(6,6,CURDATE(),'2024-2025','Failed'),
(7,3,CURDATE(),'2024-2025','In Progress'),
(7,7,CURDATE(),'2024-2025','In Progress'),
(8,4,CURDATE(),'2024-2025','In Progress'),
(1,6,CURDATE(),'2023-2024','Passed'),
(2,6,CURDATE(),'2023-2024','Passed');

-- grades:
CREATE TABLE grades (
  grade_id INT AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT NOT NULL,
  evaluation_type VARCHAR(30) CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
  grade DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20),
  coefficient DECIMAL(3,2) DEFAULT 1.00,
  evaluation_date DATE,
  comments TEXT,
  FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date,comments)
VALUES
(1,'Exam',15.5,1.0,'2026-10-15','very good'),
(2,'Assignment',12.0,0.5,'2026-09-20','good'),
(3,'Lab',10.0,0.5,'2026-09-25','average'),
(4,'Project',16.0,1.0,'2026-10-10','well done'),
(5,'Exam',14.5,2.0,'2026-10-05','good'),
(6,'Assignment',18.0,0.5,'2026-09-18','excellent'),
(7,'Lab',13.5,3.0,'2026-09-22','good'),
(8,'Project',17.0,1.0,'2026-10-12','weel done'),
(9,'Exam',11.0,1.0,'2026-10-08','average'),
(10,'Assignment',15.0,0.5,'2026-09-19','very good'),
(11,'Lab',16.0,0.5,'2026-09-23','well done'),
(12,'Project',14.0,1.0,'2026-10-11','good');

-- ALL INDEXES:
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- Queries:
-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level
SELECT last_name,first_name,email,level
FROM students;

-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d
ON p.department_id=d.department_id
WHERE d.department_name='Computer Science';

-- Q3. Find all courses with more than 5 credits
-- Expected columns: course_code, course_name, credits
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4. List students enrolled in L3 level
-- Expected columns: student_number, last_name, first_name, email
SELECT student_number, last_name, first_name, email
FROM students
WHERE level='L3';

-- Q5. Display courses from semester 1
-- Expected columns: course_code, course_name, credits, semester
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester=1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
-- Expected columns: course_code, course_name, professor_name (last + first)
SELECT c.course_code, c.course_name,CONCAT(p.last_name,' ',p.first_name)AS professor_name
FROM courses c
JOIN professors p
ON c.professor_id=p.professor_id;

-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT(s.first_name ,' ',s.last_name) AS student_name, c.course_name, e.enrollment_date, e.status
FROM students s
JOIN enrollments e
ON s.student_id=e.student_id
JOIN courses c
ON c.course_id=e.course_id;

-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, d.department_name, s.level
FROM students s
JOIN departments d
ON s.department_id=d.department_id;

-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name,c.course_name,g.evaluation_type, g.grade
FROM grades g
JOIN enrollments e
ON e.enrollment_id=g.enrollment_id
JOIN students s
ON s.student_id=e.student_id
JOIN courses c
ON e.course_id=c.course_id;

-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT CONCAT(first_name,' ', last_name)AS professor_name,COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c
ON p.professor_id=c.professor_id
GROUP BY p.professor_id;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT CONCAT(first_name,' ', last_name) AS student_name,ROUND (AVG(g.grade),2) AS average_grade
FROM students s 
LEFT JOIN enrollments e
ON s.student_id=e.student_id 
LEFT JOIN grades g 
ON g.enrollment_id=e.enrollment_id
GROUP BY s.student_id;
-- Q12. Count the number of students per department
-- Expected columns: department_name, student_count
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s
ON d.department_id=s.department_id
GROUP BY d.department_id;

-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d 
LEFT JOIN courses c 
ON c.department_id=d.department_id
GROUP BY d.department_id;
-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary
SELECT d.department_name,ROUND( AVG(p.salary),2 )AS average_salary
FROM departments d 
LEFT JOIN professors p
ON p.department_id=d.department_id
GROUP BY d.department_id;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3
SELECT CONCAT(first_name,' ', last_name) AS student_name,ROUND (AVG(g.grade),2) AS average_grade
FROM students s 
JOIN enrollments e
ON s.student_id=e.student_id 
JOIN grades g 
ON g.enrollment_id=e.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17. List courses with no enrolled students
-- Expected columns: course_code, course_name
SELECT c.course_code, c.course_name
FROM courses c 
LEFT JOIN enrollments e 
ON  c.course_id=e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Expected columns: student_name, passed_courses_count
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, COUNT(*) AS passed_courses_count
FROM students s 
JOIN enrollments e 
ON  s.student_id=e.student_id
WHERE e.status='Passed'
GROUP BY s.student_id;

-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught
SELECT CONCAT(p.last_name,' ',p.first_name) AS professor_name, COUNT(c.course_id) AS courses_taught
FROM professors p 
JOIN courses c
ON  p.professor_id=c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count
SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, COUNT(e.course_id) AS enrolled_courses_count
FROM students s 
JOIN enrollments e 
ON  s.student_id=e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;


-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg
SELECT sa.student_name, ROUND(sa.student_average, 2) AS student_average,
ROUND(d.department_average, 2) AS department_average
FROM ( SELECT s.student_id, CONCAT(s.first_name, ' ', s.last_name) AS student_name, s.department_id,
AVG(g.grade) AS student_average
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id) AS sa
JOIN ( SELECT s2.department_id, AVG(g2.grade) AS department_average
FROM students s2
JOIN enrollments e2 ON s2.student_id = e2.student_id
JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
GROUP BY s2.department_id) AS d
ON sa.department_id = d.department_id
WHERE sa.student_average > d.department_average;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT c.course_name,COUNT(e.student_id) AS enrollment_count
FROM courses c
JOIN enrollments e 
ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.student_id) > ( SELECT AVG(course_enroll_count) 
FROM ( SELECT COUNT(student_id) AS course_enroll_count
FROM enrollments
GROUP BY course_id ) AS avg_enrollments);

-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget
SELECT CONCAT(p.first_name, ' ', p.last_name) AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d 
ON p.department_id = d.department_id
WHERE d.budget = ( SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email
SELECT CONCAT(s.first_name,' ',s.last_name), s.email
FROM students s
LEFT JOIN enrollments e 
ON s.student_id=e.student_id
LEFT JOIN grades g 
ON e.enrollment_id=g.enrollment_id
WHERE g.grade_id IS NULL; 

-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT d.department_name,COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s 
ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > ( SELECT AVG(students_per_dept) 
FROM ( SELECT COUNT(student_id) AS students_per_dept FROM students GROUP BY department_id) AS avg_students
);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT c.course_name, COUNT(g.grade) AS total_grades,
SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
ROUND(100 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e 
ON c.course_id = e.course_id
JOIN grades g 
ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
SELECT ROW_NUMBER() OVER (ORDER BY AVG(g.grade) DESC) AS rankk,CONCAT(s.first_name, ' ', s.last_name) AS student_name,
ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e 
ON s.student_id = e.student_id
JOIN grades g 
ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY average_grade DESC;

-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade
SELECT c.course_name,g.evaluation_type,g.grade, g.coefficient, ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM students s
JOIN enrollments e 
ON s.student_id = e.student_id
JOIN grades g 
ON e.enrollment_id = g.enrollment_id
JOIN courses c 
ON e.course_id = c.course_id
WHERE s.student_id = 1;


-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT CONCAT(p.first_name,p.last_name) AS professor_name,SUM(c.credits) AS total_credits
FROM professors p 
JOIN courses c 
ON p.professor_id=c.professor_id
GROUP BY p.professor_id, p.first_name,p.last_name
ORDER BY total_credits DESC;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT c.course_name,COUNT(e.student_id) AS current_enrollment,c.max_capacity,
ROUND(100*COUNT(e.student_id)/c.max_capacity,2) AS percentage_full
FROM courses c 
LEFT JOIN enrollments e 
ON c.course_id=e.course_id
GROUP BY c.course_id,c.course_name,c.max_capacity
HAVING percentage_full >= 80
ORDER BY percentage_full DESC;
