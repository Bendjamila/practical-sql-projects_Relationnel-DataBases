CREATE DATABASE IF NOT EXISTS university_db;
USE university_db;

CREATE TABLE departement(
    departement_idINT INT PRIMARY KEY AUTO_INCREMENT,
    departement_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12,2),
    departement_head VARCHAR(100),
    creation_date DATE 
);

CREATE TABLE professor(
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    departement_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id) ON DELETE SET NULL ON UPDATE CASCADE

);
CREATE TABLE student(
    student_id  INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    departement_id INT,
    level VARCHAR(20) CHECK(level IN ("L1","L2","L3","M1","M2")),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id) ON DELETE SET NULL ON UPDATE CASCADE
); 
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK(credits>0),
    semester INT CHECK (semester IN (1,2)),
    departement_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    FOREIGN KEY (departement_id) REFERENCES departement(departement_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrollment(
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    academic_year VARCHAR(9) NOT NULL FORMAT "YYYY-YYYY",
    status VARCHAR(20) DEFAULT "In Progress" CHECK (status IN ("In Progress","Passed","Failed","Dropped")),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(student_id,course_id,academic_year)
    
);
CREATE TABLE grade (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(20) CHECK (evaluation_type IN ("Lab","Exam","Project","Assignment")),
    garde DECIMAL(5,2) CHECK(grade>=0,grade<=20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comment TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollment(enrollment_id) ON DELETE CASCADE ON UPDATE CASCADE

);
 
 CREATE INDEX idx_student_departement ON student(departement_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollment(student_id);
CREATE INDEX idx_enrollment_course ON enrollment(course_id);
CREATE INDEX idx_grade_enrollment ON grade(enrollment_id);



/* data  */

INSERT INTO departement
(departement_id, departement_name, building, budget, departement_head, creation_date)
VALUES
(1,"Computer Science","Building A",500000.00,"Ahmed Najjar","2000-09-01"),
(2,"Mathematics","Building B",350000.00,"Lina Hachemi","1995-08-15"),
(3,"Physics","Building C",400000.00,"Karim Abderrahmane","2005-01-10"),
(4,"Civil Engineering","Building D",600000.00,"Nour Bouali","2010-03-22");


INSERT INTO professor
(professor_id,last_name,first_name,email,phone,departement_id,hire_date,salary,specialization)
VALUES
(1,"Najjar","Ahmed","ahmed.najjar@univ.edu","0550-111-001",1,"2008-09-01",78000.00,"Artificial Intelligence"),
(2,"Khatib","Sara","sara.khatib@univ.edu","0550-111-002",1,"2010-03-15",75000.00,"Cyber Security"),
(3,"Ben Youssef","Mohamed","mohamed.ben@univ.edu","0550-111-003",1,"2015-01-10",72000.00,"Software Engineering"),
(4,"Hachemi","Lina","lina.hachemi@univ.edu","0550-111-004",2,"2012-09-20",69000.00,"Algebra"),
(5,"Abderrahmane","Karim","karim.abderrahmane@univ.edu","0550-111-005",3,"2016-11-05",66000.00,"Quantum Physics"),
(6,"Bouali","Nour","nour.bouali@univ.edu","0550-111-006",4,"2018-04-18",64000.00,"Structural Engineering");

INSERT INTO student
(student_id,student_number,last_name,first_name,date_of_birth,email,phone,address,departement_id,level,enrollment_date)
VALUES
(1,"S2001","Ali","Youssef","2003-05-12","youssef.ali@student.edu","0660-200-001","Algiers, Algeria",1,"L2","2023-09-01"),
(2,"S2002","Hassan","Meriem","2002-08-21","meriem.hassan@student.edu","0660-200-002","Oran, Algeria",1,"L3","2022-09-01"),
(3,"S2003","Abdallah","Khaled","2001-02-10","khaled.abdallah@student.edu","0660-200-003","Constantine, Algeria",2,"M1","2021-09-01"),
(4,"S2004","Said","Fatima","2003-11-30","fatima.said@student.edu","0660-200-004","Blida, Algeria",2,"L2","2023-09-01"),
(5,"S2005","Kacemi","Amine","2002-07-18","amine.kacemi@student.edu","0660-200-005","Annaba, Algeria",3,"L3","2022-09-01"),
(6,"S2006","Mourad","Huda","2001-12-05","huda.mourad@student.edu","0660-200-006","Setif, Algeria",3,"M1","2021-09-01"),
(7,"S2007","Cherif","Aya","2003-09-14","aya.cherif@student.edu","0660-200-007","Tlemcen, Algeria",4,"L2","2023-09-01"),
(8,"S2008","Mansour","Ibrahim","2002-04-25","ibrahim.mansour@student.edu","0660-200-008","Bejaia, Algeria",4,"L3","2022-09-01");

INSERT INTO courses
(course_id,course_code,course_name,description,credits,semester,departement_id,professor_id,max_capacity)
VALUES
(1,"CS201","Algorithms","Study of algorithms and complexity",6,1,1,1,30),
(2,"CS202","Databases","Relational database systems",5,2,1,2,25),
(3,"CS203","Web Development","Frontend and backend development",5,1,1,3,20),
(4,"MATH201","Advanced Algebra","Linear algebra and structures",6,2,2,4,30),
(5,"PHYS201","Modern Physics","Introduction to modern physics concepts",5,1,3,5,25),
(6,"CE201","Structural Analysis","Analysis of engineering structures",6,2,4,6,30),
(7,"CE202","Construction Materials","Properties of construction materials",5,1,4,6,20);

INSERT INTO enrollment
(enrollment_id,student_id,course_id,enrollment_date,academic_year,status)
VALUES
(1,1,1,"2024-09-01","2024-2025","In Progress"),
(2,1,2,"2024-09-01","2024-2025","In Progress"),
(3,2,1,"2023-09-01","2023-2024","Passed"),
(4,2,3,"2023-09-01","2023-2024","Passed"),
(5,3,4,"2022-09-01","2022-2023","Passed"),
(6,3,2,"2024-09-01","2024-2025","In Progress"),
(7,4,4,"2024-09-01","2024-2025","In Progress"),
(8,5,5,"2023-09-01","2023-2024","Passed"),
(9,5,1,"2023-09-01","2023-2024","Failed"),
(10,6,5,"2022-09-01","2022-2023","Passed"),
(11,6,6,"2024-09-01","2024-2025","In Progress"),
(12,7,6,"2024-09-01","2024-2025","In Progress"),
(13,7,7,"2023-09-01","2023-2024","Passed"),
(14,8,7,"2023-09-01","2023-2024","Passed"),
(15,8,3,"2024-09-01","2024-2025","In Progress"),
(16,4,2,"2023-09-01","2023-2024","Passed");



INSERT INTO grade
(grade_id,enrollment_id,evaluation_type,garde,coefficient,evaluation_date,comment)
VALUES
(1,3,"Exam",17.5,1.00,"2024-01-15","Very strong performance"),
(2,4,"Project",15.0,0.50,"2024-05-10","Good practical work"),
(3,5,"Exam",16.0,1.00,"2023-01-20","Excellent understanding"),
(4,8,"Lab",12.5,0.30,"2024-02-10","Satisfactory"),
(5,9,"Exam",10.0,1.00,"2024-01-18","Minimum passing level"),
(6,10,"Assignment",14.0,0.20,"2023-11-05","Good effort"),
(7,13,"Project",18.0,0.50,"2024-05-12","Outstanding project"),
(8,14,"Exam",16.5,1.00,"2024-01-22","Very good"),
(9,16,"Lab",13.0,0.30,"2024-03-01","Average work"),
(10,3,"Assignment",14.5,0.20,"2024-02-01","Well structured"),
(11,5,"Project",15.5,0.50,"2023-05-15","Solid project"),
(12,8,"Exam",11.0,1.00,"2024-01-30","Needs improvement");


/* QUESTIONS  */

-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level
SELECT last_name,first_name,email,level From student;

-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization

/* in case i know the departement id */
SELECT last_name,firstname,email,specialization From professor WHERE departement_id = 1;
/* in case i don't know  the departement id */
SELECT last_name,firstname,email,specialization From professor WHERE departement_id = (SELECT departement_id FROM departement WHERE departement_name = "Computer Science");

-- Q3. Find all courses with more than 5 credits
-- Expected columns: course_code, course_name, credits
SELECT course_code,course_name,credits FROM courses WHERE credits>5;


-- Q4. List students enrolled in L3 level
-- Expected columns: student_number, last_name, first_name, email
SELECT student_number,last_name,email FROM student WHERE level ="L3";


-- Q5. Display courses from semester 1
-- Expected columns: course_code, course_name, credits, semester
SELECT course_code,course_name,credits,semester FROM courses WHERE semester=1;


-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
-- Expected columns: course_code, course_name, professor_name (last + first)

SELECT course_code,course_name,CONCAT(professor.last_name," ",professor.first_name) AS professor_name FROM courses JOIN professor ON courses.professor_id=professor.professor_id;


-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT (student.last_name ," ",student.first_name) AS student_name,course.name,enrollment_date,status FROM enrolment JOIN student ON enrollment.student_id=student.student_id JOIN course ON enrollment.course_id =  course.course_id;


-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name , departement_name,level FROM departement JOIN student ON student.departement_id = departement.departement_id;
    

-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name , course_name,evaluation_type,grade FROM grade JOIN enrollment ON grade.enrollment_id=enrollment.enrollment_id JOIN course ON enrollment.course_id = course.course_id JOIN student ON enrollment.student_id = student.student_id;


-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses
SELECT CONCAT(professor.last_name," ",professor.first_name) AS professor_name,  COUNT (courses.course_id) AS number_of_courses FROM professor JOIN course ON course.professor_id = professor.professor_id  GROUP BY professor_name;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name , AVG(grade) as average_grade FROM grade JOIN enrollment ON grade.enrollment_id=enrollment.enrollment_id JOIN student ON enrollment.student_id = student.student_id GROUP BY student_name;


-- Q12. Count the number of students per department
-- Expected columns: department_name, student_count

SELECT departement_name , COUNT(student_id) AS student_count FROM departement JOIN student ON student.departement_id=departement.departement_id GROUP BY departement.departement_name;


-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
SELECT SUM(budget) AS total_budget FROM departement ;


-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count
SELECT departement_name , COUNT(course_id) AS course_count FROM departement JOIN course ON course.departement_id = departement.departement_id GROUP BY departement.departement_name;


-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary
SELECT departement_name , AVG(salary) AS average_salary FROM departement JOIN professor ON departement.departement_id = professor.departement_id GROUP BY departement.departement_name;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name , AVG(grade) as average_grade  FROM grade JOIN enrollment ON grade.enrollment_id=enrollment.enrollment_id JOIN student ON enrollment.student_id = student.student_id GROUP BY student.student_name ORDER BY average_grade DESC LIMIT 3;


-- Q17. List courses with no enrolled students
-- Expected columns: course_code, course_name
SELECT course_code , course_name FROM courses LEFT JOIN enrollment ON courses.course_id = enrollment.course_id WHERE enrollment.course_id IS NULL;


-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Expected columns: student_name, passed_courses_count
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name , COUNT(enrollment.course_id) AS passed_courses_count FROM student JOIN enrollment ON student.student_id = enrollment.student_id  WHERE enrollment.status = "Passed"  GROUPED BY student_name;


-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught
SELECT CONCAT(professor.last_name," ",professor.first_name) AS professor_name, COUNT(course_id) AS course_taught
 FROM professor JOIN course ON professor.professor_id=course.professor_id GROUP BY professor.professor_id HAVING course_taught > 2;

-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count
SELECT  CONCAT(student.last_name," ",student.first_name) AS student_name, COUNT (enrollment.course_id) AS enrolled_courses_count FROM student JOIN enrollment ON student.student_id = enrollment.student_id  GROUP BY student_name HAVING enrolled_courses_count > 2;




-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg 
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name , AVG(grade) AS student_avg, (SELECT AVG(grade) FROM grade JOIN enrollment ON grade.enrollment_id=enrollment.enrollment_id JOIN student ON enrollment.student_id = student.student_id WHERE student.departement_id = s.departement_id) AS department_avg FROM grade JOIN enrollment ON grade.enrollment_id=enrollment.enrollment_id JOIN student AS s ON enrollment.student_id = s.student_id GROUP BY student_name HAVING student_avg > department_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count
SELECT course_name, COUNT(enrollment_id) AS enrollment_count FROM courses JOIN enrollment ON courses.course_id = enrollment.course_id GROUP BY course_name HAVING enrollment_count > (SELECT AVG(enrollment_count) FROM (SELECT COUNT(enrollment_id) AS enrollment_count FROM courses JOIN enrollment ON courses.course_id = enrollment.course_id GROUP BY course_name) AS subquery);



-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget
SELECT CONCAT(professor.last_name," ",professor.first_name) AS professor_name, departement_name, budget FROM professor JOIN departement ON professor.departement_id = departement.departement_id WHERE departement.budget = (SELECT MAX(budget) FROM departement);


-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email
SELECT CONCAT(student.last_name," ",student.first_name) AS student_name, email FROM student LEFT JOIN enrollment ON student.student_id = enrollment.student_id LEFT JOIN grade ON enrollment.enrollment_id = grade.enrollment_id WHERE grade.grade_id IS NULL;


-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count
SELECT departement_name, COUNT(student_id) AS student_count FROM departement LEFT JOIN student ON departement.departement_id = student.departement_id GROUP BY departement_name HAVING student_count > (SELECT AVG(student_count) FROM (SELECT COUNT(student_id) AS student_count FROM departement LEFT JOIN student ON departement.departement_id = student.departement_id GROUP BY departement_name) AS subquery);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage
SELECT course_name, COUNT(grade_id) AS total_grades, SUM(CASE WHEN grade >= 10 THEN 1 ELSE 0 END) AS passed_grades, (SUM(CASE WHEN grade >= 10 THEN 1 ELSE 0 END) / COUNT(grade_id)) * 100 AS pass_rate_percentage FROM courses JOIN enrollment ON courses.course_id = enrollment.course_id JOIN grade ON enrollment.enrollment_id = grade.enrollment_id GROUP BY course_name;


-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade
SELECT RANK() OVER (ORDER BY AVG(grade) DESC) AS rank, CONCAT(student.last_name," ",student.first_name) AS student_name, AVG(grade) AS average_grade FROM student JOIN enrollment ON student.student_id = enrollment.student_id JOIN grade ON enrollment.enrollment_id = grade.enrollment_id GROUP BY student_name ORDER BY average_grade DESC;


-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade
SELECT course_name, evaluation_type, grade, coefficient, (grade * coefficient) AS weighted_grade FROM student JOIN enrollment ON student.student_id = enrollment.student_id JOIN grade ON enrollment.enrollment_id = grade.enrollment_id JOIN courses ON enrollment.course_id = courses.course_id WHERE student.student_id = 1;



-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits
SELECT CONCAT(professor.last_name," ",professor.first_name) AS professor_name, SUM(credits) AS total_credits FROM professor JOIN course ON professor.professor_id = course.professor_id GROUP BY professor_name;



-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full
SELECT course_name, COUNT(enrollment_id) AS current_enrollments, max_capacity, (COUNT(enrollment_id) / max_capacity) * 100 AS percentage_full FROM courses JOIN enrollment ON courses.course_id = enrollment.course_id GROUP BY course_name HAVING percentage_full > 80;


