INSERT INTO DEPARTMENTS (department_name, building, budget, department_head, creation_date)
VALUES
('Computer Science', 'Building A', 500000, 'Dr. Ahmed Benali', '2010-09-01'),
('Mathematics', 'Building B', 350000, 'Dr. Lina Kaci', '2011-09-01'),
('Physics', 'Building C', 400000, 'Dr. Omar Rahmani', '2012-09-01'),
('Civil Engineering', 'Building D', 600000, 'Dr. Sami Haddad', '2009-09-01');



INSERT INTO PROFESSORS (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES
('Benali', 'Ahmed', 'a.benali@uni.com', '0550000001', 1, '2015-09-01', 75000.00, 'Software Engineering'),
('Touati', 'Nadia', 'n.touati@uni.com', '0550000002', 1, '2016-09-01', 72500.50, 'Data Science'),
('Amrani', 'Youssef', 'y.amrani@uni.com', '0550000003', 1, '2017-09-01', 73899.75, 'Cybersecurity'),
('Kaci', 'Lina', 'l.kaci@uni.com', '0550000044', 2, '2014-09-30', 68999.25, 'Applied Mathematics'),
('Rahmani', 'Omar', 'o.rahmani@uni.com', '0550000005', 3, '2013-09-01', 70000.00, 'Quantum Physics'),
('Haddad', 'Sami', 's.haddad@uni.com', '0550000006', 4, '2012-09-01', 72555.55, 'Structural Engineering');


INSERT INTO STUDENTS (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date)
VALUES
('S001','Ali','Karim','2003-05-10','karim.ali@uni.com','0661000001','Algiers',1,'L2','2023-09-01'),
('S002','Sara','Nour','2002-07-15','sara.nour@uni.com','0661000002','Oran',1,'L3','2022-09-01'),
('S003','Yacine','Omar','2001-02-20','yacine.omar@uni.com','0661000003','Constantine',2,'M1','2021-09-01'),
('S004','Lina','Amina','2003-11-12','lina.amina@uni.com','0661000004','Blida',3,'L2','2023-09-01'),
('S005','Rami','Samir','2002-03-08','rami.samir@uni.com','0661000005','Setif',4,'L3','2022-09-01'),
('S006','Maya','Rania','2001-09-25','maya.rania@uni.com','0661000006','Annaba',1,'M1','2021-09-01'),
('S007','Ziad','Hassan','2002-12-30','ziad.hassan@uni.com','0661000007','Tlemcen',2,'L3','2022-09-01'),
('S008','Nina','Imane','2003-06-18','nina.imane@uni.com','0661000008','Bejaia',3,'L2','2023-09-01');



INSERT INTO COURSES (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity)
VALUES
('CS101','Programming I','Introduction to programming',6,1,1,1,40),
('CS201','Databases','Relational database systems',6,2,1,2,35),
('CS301','Algorithms','Algorithm design and analysis',5,1,1,3,30),
('MATH101','Linear Algebra','Matrices and vectors',5,1,2,4,30),
('PHY101','Mechanics','Classical mechanics basics',5,2,3,5,30),
('CE101','Statics','Engineering statics fundamentals',6,1,4,6,25),
('CS302','Operating Systems','Processes and memory management',6,2,1,1,30);

INSERT INTO ENROLLMENTS (student_id, course_id, enrollment_date, academic_year, status)
VALUES
(1,1,'2024-09-15','2024-2025','IN PROGRESS'),
(1,2,'2024-09-15','2024-2025','IN PROGRESS'),
(2,1,'2024-09-15','2024-2025','PASSED'),
(2,3,'2024-09-15','2024-2025','IN PROGRESS'),
(3,4,'2024-09-15','2024-2025','PASSED'),
(4,5,'2023-09-15','2023-2024','PASSED'),
(5,6,'2024-09-15','2024-2025','IN PROGRESS'),
(6,2,'2024-09-15','2024-2025','IN PROGRESS'),
(6,3,'2024-09-15','2024-2025','IN PROGRESS'),
(7,4,'2023-09-15','2023-2024','FAILED'),
(8,5,'2024-09-15','2024-2025','IN PROGRESS'),
(3,1,'2023-09-15','2023-2024','PASSED'),
(4,2,'2024-09-15','2024-2025','IN PROGRESS'),
(5,3,'2024-09-15','2024-2025','IN PROGRESS'),
(7,1,'2024-09-15','2024-2025','IN PROGRESS');


INSERT INTO GRADES (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments)
VALUES
(1,'EXAM',15,1.5,'2025-01-15','Good performance'),
(1,'ASSIGNMENT',14,1,'2024-12-20','Well done'),
(2,'PROJECT',16,2,'2025-01-20','Excellent project'),
(3,'EXAM',12,1.5,'2025-01-15','Satisfactory'),
(4,'LAB',13,1,'2025-01-10','Good lab work'),
(5,'EXAM',18,2,'2025-01-18','Outstanding'),
(6,'EXAM',11,1.5,'2024-06-15','Needs improvement'),
(7,'PROJECT',17,2,'2025-01-25','Very good'),
(8,'EXAM',14,1.5,'2025-01-18','Good'),
(9,'LAB',13,1,'2025-01-12','Acceptable'),
(10,'EXAM',10,1.5,'2024-06-20','Minimum pass'),
(11,'ASSIGNMENT',15,1,'2025-01-08','Nice work');

