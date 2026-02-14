create database university_management_system ;
use  university_management_system;

/* Table: departments*/
create table departments (
	department_id INT PRIMARY KEY AUTO_INCREMENT,
	department_name VARCHAR(100) NOT NULL,
	building VARCHAR(50),
	budget DECIMAL(12, 2),
	department_head VARCHAR(100),
	creation_date DATE
);

/*Table: professors*/
create table professors (
	professor_id INT PRIMARY KEY AUTO_INCREMENT,
	last_name VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	phone VARCHAR(20),
	department_id INT,
	hire_date DATE ,
	salary DECIMAL(10, 2),
	specialization VARCHAR(100),
		constraint fk_professors_departments
			foreign key (department_id)
			references departments (department_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
);

 /*Table: students*/
create table students(
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
	enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		constraint fk_students_departments
			foreign key (department_id)
			references departments (department_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE,
		CONSTRAINT chk_level
			CHECK ( `level` IN ('L1', 'L2', 'L3', 'M1', 'M2'))
 );
 
 /*4. Table: courses*/
create table courses (
	course_id INT PRIMARY KEY AUTO_INCREMENT,
	course_code VARCHAR(10) UNIQUE NOT NULL,
	course_name VARCHAR(150) NOT NULL,
	description TEXT,
	credits INT NOT NULL, --CHECK: must be > 0
	semester INT, --CHECK: must be between 1 and 2
	department_id INT, --FOREIGN KEY → departments
	professor_id INT, --FOREIGN KEY → professors
	max_capacity INT DEFAULT 30,
		constraint fk_courses_departments
			foreign key (department_id)
			references departments (department_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
		constraint fk_courses_professors
			foreign key (professor_id)
			references professors (professor_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE,
		constraint chk_semester check( semester between 1 and 2),
		constraint chk_credits check ( credits > 0)
);

/*Table: enrollments*/
create table enrollments (
	enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
	student_id INT NOT NULL, 
	course_id INT NOT NULL, 
	enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	academic_year VARCHAR(9) NOT NULL, 
	status VARCHAR(20) DEFAULT 'In Progress',
		constraint fk_enrollments_students
			foreign key (student_id)
			references students (student_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE,--FOREIGN KEY → students
		constraint fk_enrollements_courses
			foreign key (course_id)
			references courses (course_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE,--FOREIGN KEY → courses
		constraint chk_status
			check ( `status` IN ('In Progress','Passed','Failed','Dropped')),
			--CHECK: 'In Progress', 'Passed', 'Failed', 'Dropped'
		constraint chk_academic_year 
			check(academic_year regexp '^[0-9]{4}-[0-9]{4}$') --Format: '2024-2025'
);

/*Table: grades*/
create table  grades (
	grade_id INT PRIMARY KEY AUTO_INCREMENT,
	enrollment_id INT NOT NULL, 	
	evaluation_type VARCHAR(30), 
	grade DECIMAL(5, 2),
	coefficient DECIMAL(3, 2) DEFAULT 1.00,
	evaluation_date DATE,
	comments TEXT,
		constraint fk_grades_enrollements
			foreign key (enrollment_id)
			references enrollments (enrollment_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE, #FOREIGN KEY → enrollments
		constraint chk_grade check( grade between 0 and 20),--CHECK: between 0 and 20
		constraint chk_evaluation_type check( evaluation_type IN ('Assignement','Lab','Exam','Project'))
 --CHECK: 'Assignment', 'Lab', 'Exam', 'Project'
);

create index  idx_student_department on students(department_id);
create index idx_course_professor on courses(professor_id);
create index idx_enrollment_student on enrollments(student_id);
create index idx_enrollment_course on enrollments(course_id);
create index idx_grades_enrollment on grades(enrollment_id);


INSERT INTO departments(department_name,building,budget) values 
('Computer Science','A',500.000),
('Mathematics','B',350.000),
('Physics','C',400.000),
('Civil Engineering','D',600.000);


INSERT INTO professors(last_name,first_name,email,phone,department_id,hire_date,salary,specialization) VALUES 
('HELFUN','Amine','amine.helfun@univ.dz','0550123456',1,'2021-09-01',80000.00,'Artificial Intelligence'),
('HEDDAR','Nabila','nabila.heddar@univ.dz','0550654321',1,'2020-08-15',75000.00,'Software Engineering'),
('TOUFOUTI','Nabila','nabila.toufouti@univ.dz','0550987654',1,'2022-01-10',70000.00,'Cyber Security'),
('LAMAOUCHE','Malek', 'malek.lamouche@univ.dz', '0550765432', 2, '2019-07-20', 68000.00, 'Algebra'),       
('ACHEUK', 'Yasmine', 'yasmine.acheuk@univ.dz', '0550345678', 3, '2018-06-12', 72000.00, 'Quantum Physics'),
('HAMADOU', 'Kamal', 'kamal.hamadou@univ.dz', '0550432198', 4, '2021-03-05', 69000.00, 'Structural Engineering');

INSERT INTO students (student_number,last_name,first_name,date_of_birth,email,phone,address,department_id,level,enrollment_date)VALUES
('33068001','ACHEUK','Djida','2005-03-24','ad.acheuk@univ.edu.dz','07784125563','résidence 19 mai 1956',1,'L3','2023-09-20'),
('33068002','TAYEB CHERif','Yasmine','2006-06-24','ay.tayebcherif@univ.edu.dz','05784125563','résidence 19 mai 1956',1,'L2','2024-09-20'),
('33068003','TACHEKORT','Celine','2007-01-18','ac.tachekort@univ.edu.dz','06784125563','résidence RUB 5',1,'L1','2025-09-20'),
('33068004','HOCINE','Sara','2004-06-24','as.hocine@univ.edu.dz','07784125463','résidence 19 mai 1956',1,'M1','2022-09-20'),
('33068005','SANA','Yasmine','2003-05-03','ay.sana@univ.edu.dz','06784185563','résidence RUB 5',1,'M2','2021-09-20'),
('33068006','SAICH','Alicia','2006-07-24','aa.saich@univ.edu.dz','05784125573','résidence EL-DJORF',2,'L2','2024-09-20'),
('33068007','MIRI','Tahar','2005-04-16','at.miri@univ.edu.dz','05984125563','résidence CUB 3',3,'L3','2023-09-20'),
('33068008','ALMRINA','Hassina','2003-09-20','ah.almrina@univ.edu.dz','06784125523','résidence AL-ALIA',4,'M2','2021-09-20');

INSERT INTO courses (course_code,course_name,description,credits,semester,department_id,professor_id,max_capacity) VALUES
('A102','PM','project management',5,2,1,2,20),
('A103','ICS','introduction to cyber security',6,1,1,3,10),
('A104','IAI','introduction to artificial intelligence',6,1,1,1,15),
('A105','SEN','software engineering',5,1,1,2,30),
('B102','ALG','algebra',6,1,2,4,5),
('C102','PHY','physic basics',5,2,3,5,12),
('D102','Construction Management','project planning, cost estimation, scheduling',6,1,4,6,25);

INSERT INTO enrollments (student_id,course_id,enrollment_date,academic_year,status) VALUES
('33068001', 'A102', '2023-09-21', '2023-2024', 'In Progress'), 
('33068001', 'A103', '2023-09-21', '2023-2024', 'In Progress'),
('33068001', 'A104', '2023-09-22', '2023-2024', 'In Progress'), 
('33068002', 'A104', '2024-09-21', '2024-2025', 'In Progress'),
('33068002', 'A105', '2024-09-21', '2024-2025', 'In Progress'),
('33068002', 'A103', '2024-09-22', '2024-2025', 'In Progress'), 
('33068003', 'B102', '2025-09-21', '2025-2026', 'In Progress'),
('33068003', 'A105', '2025-09-22', '2025-2026', 'In Progress'),
('33068004', 'C102', '2022-09-21', '2022-2023', 'Passed'),
('33068004', 'C102', '2022-09-22', '2022-2023', 'Passed'),
('33068005', 'B102', '2021-09-21', '2021-2022', 'Failed'),
('33068005', 'B102', '2021-09-22', '2021-2022', 'Passed'),
('33068006', 'B102', '2024-09-21', '2024-2025', 'Dropped'),
('33068007', 'C102', '2023-09-21', '2023-2024', 'In Progress'),
('33068008', 'D102', '2021-09-21', '2021-2022', 'Passed');

INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient,evaluation_date) VALUES
-- Djida ACHEUK (Enrollment 1 & 2 & 3)
(1, 'Assignment', 15.50, 0.2, '2023-10-15'),
(1, 'Lab', 16.00, 0.3, '2023-11-01'),
(2, 'Exam', 14.50, 0.5, '2024-01-10'),
(2, 'Project', 16.00, 0.4, '2023-11-18'),
(3, 'Exam', 15.00, 0.6, '2024-01-12'),
(4, 'Assignment', 13.50, 0.2, '2024-10-10'),
(4, 'Lab', 14.50, 0.3, '2024-11-05'),
(5, 'Exam', 14.00, 0.5, '2025-01-08'),
(5, 'Project', 15.50, 0.4, '2024-11-10'),
(6, 'Exam', 14.50, 0.6, '2025-01-10'),
(7, 'Assignment', 12.00, 0.2, '2025-10-12'),
(7, 'Lab', 13.00, 0.3, '2025-11-12'),
(8, 'Exam', 13.50, 0.5, '2026-01-09'),
(9, 'Lab', 16.00, 0.3, '2022-11-15'),
(9, 'Project', 17.00, 0.3, '2023-01-05'),
(10, 'Exam', 17.50, 0.4, '2023-01-10'),
(11, 'Assignment', 10.50, 0.2, '2021-10-15'),
(11, 'Lab', 11.50, 0.3, '2021-11-10'),
(12, 'Exam', 12.00, 0.5, '2022-01-10');


/*-----------------------Queries----------------------------*/
--Question 1
select last_name, first_name, email, level
from students;

--Question 2

select last_name, first_name, email, specialization
from professors
where department_name = 'Computer Science';

--Question3
select course_code,course_name,credits
from courses
where credits > 5;

--Question 4
select student_number,last_name,first_name,email
from students
where level='L3';

--Question 5
select course_code,course_name,credits,semester
from courses
where semester=1;

--Question 6
select C.course_code,C.course_name,CONCAT(P.last_name,'  ',P.first_name) as professor_name
from courses C
left join professors P on C.professor_id = P.professor_id ;

--Question 7
select concat(S.last_name,' ',S.first_name) as student_name,
 C.course_name, E.enrollment_date,E.status
from  enrollments E
join students S on E.student_id = S.student_id
join courses C on E.course_id = C.course_id ;

--Question 8
select concat (S.last_name,S.first_name) as student_name, D.department_name,S.level
from students S
left join departments D on S.department_id = D.department_id ;

--Question 9
select concat(S.last_name ,' ', S.first_name) as student_name , 
C.course_name, G.evaluation_type, G.grade
from students S
join enrollments E on E.student_id = S.student_id 
join courses C on E.course_id = C.course_id
join grades G on E.enrollment_id = G.enrollment_id ;

--Question 10
select concat(P.last_name,' ',P.first_name) as professor_name,
count(C.course_id) as  number_of_courses
from professors P
left join courses C on P.professor_id = C.professor_id 
group by P.professor_id;

--Question 11
select concat(S.last_name,' ',S.first_name) as student_name,
 AVG(G.grade) as average_grade
from students S
join enrollment_id E on S.student_id = E.student_id
join grades G on E.enrollment_id = G.enrollment_id
group by S.student_id;

--Question  12 ;

select D.department_name, count(S.student_id) as student_count
from departments D
left join students S on D.department_id = S.department_id
group by D.department_id

--Question 13
select sum(budget) as total_budget
from departments ;

--Question 14
select D.department_name,count(C.course_id)as course_count
from departments D
left join courses C on D.department_id = C.department_id
group by D.department_id;

--Question 15
select D.department_name, avg(P.salary) as average_salary
from departments D
left join professors P on D.department_id = P.department_id
group by D.department_id ;

--Question 16
select concat( S.last_name,' ',S.first_name) as student_name,
 avg (G.grade) as average_grade
from students S
JOIN enrollments E on S.student_id = E.student_id
JOIN grades G on E.enrollment_id = G.enrollment_id
group by S.student_id
Order by average_grade DESC limit 3 ;

--Question 17
select C.course_code, C.course_name 
from courses C
left JOIN enrollments E on C.course_id = E.course_id
where E.enrollment_date is null ;

--Question 18
select concat (S.last_name,' ',S.first_name) as student_name ,
 count(*) as passed_courses_count
from students S
join enrollments E on S.student_id = E.student_id
Group by S.student_id
Having count(*) = sum(E.status = 'Passed') ;

--Question 19
select concat(P.last_name,' ',P.first_name) as professor_name,
count(C.course_id) as  courses_taught
from professors P
join courses C on P.professor_id = C.professor_id
group by P.professor_id
having count(C.course_id) > 2 ;

--Question 20

select concat(S.last_name,' ',S.first_name) as student_name,
count(E.course_id) as  enrolled_courses_count
from students S
join enrollments E on S.student_id = E.student_id
group by S.student_id
having count(E.course_id)  > 2;

--Question 21
SELECT student_name, student_avg, department_avg
FROM (
    SELECT CONCAT(S.last_name, ' ', S.first_name) AS student_name,
           AVG(G.grade) AS student_avg,
           (
               SELECT AVG(G2.grade)
               FROM students S2
               JOIN enrollments E2 ON S2.student_id = E2.student_id
               JOIN grades G2 ON E2.enrollment_id = G2.enrollment_id
               WHERE S2.department_id = S.department_id
           ) AS department_avg
    FROM students S
    JOIN enrollments E ON S.student_id = E.student_id
    JOIN grades G ON E.enrollment_id = G.enrollment_id
    GROUP BY S.student_id
) t
WHERE student_avg > department_avg;

--Question 22
SELECT C.course_name, COUNT(E.enrollment_id) AS enrollment_count
FROM courses C
JOIN enrollments E ON C.course_id = E.course_id
GROUP BY C.course_id
HAVING COUNT(E.enrollment_id) >
(SELECT AVG(cnt)FROM (SELECT COUNT(*) cnt FROM enrollments GROUP BY course_id) t);

--Question 23
select concat(p.last_name,' ',p.first_name) as professor_name, 
d.department_name, d.budget
from professors p
join departments d on p.department_id = d.department_id
where d.budget = (select max(budget) from departments);
 
--Question 24
select distinct concat(s.last_name,' ',s.first_name) as student_name, s.email
from students s
left join enrollments e on s.student_id = e.student_id
left join grades g on e.enrollment_id = g.enrollment_id
where g.grade_id is null

--Question 25
select department_name, student_count
from (
select d.department_name, count(s.student_id) as student_count
from departments d
left join students s on d.department_id = s.department_id
group by d.department_id
) t
where student_count >  (select avg(students_per_department) from 
 (select count (*) as students_per_department from students group by department_id) x);
 
--Question 26
select c.course_name, 
count(g.grade) as total_grades, 
sum(g.grade >= 10) as passed_grades, 
sum(g.grade >=10 )/count(g.grade) * 100,2 as pass_rate_percentage
from  courses c
join enrollments e on c.course_id = e.course_id
join grades g on e.enrollment_id = g.enrollment_id
group by c.course_id

--Question 27
select concat(s.last_name,' ',s.first_name) as student_name
avg(g.grade) as average_grade
from students s
join enrollments e on s.student_id = e.student_id
join grades g on e.enrollment_id = g.enrollment_id
group by s.student_id
order by average_grade DESC;

--Question 28
select c.course_name,
g.evaluation_type,
g.grade,
g.coefficient,
g.grade * g.coefficient as weighted_grade
from grades g
join enrollments e on g.enrollment_id = e.enrollment_id
join courses c on e.course_id =c.course_id
where e.student_id = 1,

--Question 29
select concat(p.last_name,' ',p.first_name) as professor_name,
sum(c.credits) as total_credits
from professors p
join courses c on p.professor_id = c.professor_id
group by p.professor_id;

--Question 30
select c.course_name,
count(e.enrollment_id) as current_enrollments,
c.max_capacity,
count(e.enrollment_id)/c.max_capacity*100 as percentage_full
from courses c
join enrollments e on c.course_id = e.course_id
group by c.course_id
having percentage_full > 80;
