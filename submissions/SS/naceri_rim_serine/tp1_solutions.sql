-- PART 1: the set up
-- 1. database creation
DROP DATABASE IF EXISTS university_db;
CREATE DATABASE university_db;
USE university_db;

-- 2. TABLE CREATION

-- 2.1 departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    building VARCHAR(50),
    budget DECIMAL(12, 2),
    department_head VARCHAR(100),
    creation_date DATE
);

-- 2.2 professors table
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
    CONSTRAINT fk_prof_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

-- 2.3 students table
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
    CONSTRAINT fk_student_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    CONSTRAINT chk_level CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2'))
);

-- 2.4 courses table
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
    CONSTRAINT fk_course_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_course_prof FOREIGN KEY (professor_id) 
        REFERENCES professors(professor_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    CONSTRAINT chk_credits CHECK (credits > 0),
    CONSTRAINT chk_semester CHECK (semester BETWEEN 1 AND 2)
);

-- 2.5 enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) 
        REFERENCES students(student_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT chk_status CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped'))
);

-- 2.6 grades table
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5, 2),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    CONSTRAINT fk_grade_enrollment FOREIGN KEY (enrollment_id) 
        REFERENCES enrollments(enrollment_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT chk_eval_type CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    CONSTRAINT chk_grade CHECK (grade BETWEEN 0 AND 20)
);

-- 3. indexes creation

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);

-- 4. data insertion

-- departments 
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES 
('Computer Science', 'Building A', 500000.00, 'Dr. Alan Turing', '2000-01-15'),
('Mathematics', 'Building B', 350000.00, 'Dr. Ada Lovelace', '1998-05-20'),
('Physics', 'Building C', 400000.00, 'Dr. Albert Einstein', '2005-09-01'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Isambard Brunel', '2010-03-12');

-- professors 
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES 
('Smith', 'John', 'j.smith@uni.edu', '555-0101', 1, '2015-08-20', 75000.00, 'Artificial Intelligence'),
('Doe', 'Jane', 'j.doe@uni.edu', '555-0102', 1, '2018-01-15', 72000.00, 'Cybersecurity'),
('Brown', 'Robert', 'r.brown@uni.edu', '555-0103', 1, '2012-11-05', 80000.00, 'Software Engineering'),
('Wilson', 'Emily', 'e.wilson@uni.edu', '555-0201', 2, '2016-09-01', 68000.00, 'Linear Algebra'),
('Taylor', 'David', 'd.taylor@uni.edu', '555-0301', 3, '2019-02-14', 71000.00, 'Quantum Physics'),
('Anderson', 'Sarah', 's.anderson@uni.edu', '555-0401', 4, '2014-06-23', 76000.00, 'Structural Engineering');

-- students 
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, department_id, level) VALUES 
('S2023001', 'Martin', 'Alice', '2002-04-15', 'alice.m@student.uni.edu', '555-1001', 1, 'L2'),
('S2023002', 'Garcia', 'Carlos', '2001-08-22', 'carlos.g@student.uni.edu', '555-1002', 1, 'L3'),
('S2023003', 'Lee', 'Min-Ji', '2003-12-05', 'minji.l@student.uni.edu', '555-1003', 2, 'L2'),
('S2023004', 'Dubois', 'Thomas', '2000-02-28', 'thomas.d@student.uni.edu', '555-1004', 3, 'M1'),
('S2023005', 'Khan', 'Fatima', '2001-11-12', 'fatima.k@student.uni.edu', '555-1005', 4, 'L3'),
('S2023006', 'Muller', 'Hans', '1999-07-30', 'hans.m@student.uni.edu', '555-1006', 1, 'M2'),
('S2023007', 'Rossi', 'Marco', '2002-09-19', 'marco.r@student.uni.edu', '555-1007', 2, 'L2'),
('S2023008', 'Tanaka', 'Ken', '2001-03-14', 'ken.t@student.uni.edu', '555-1008', 3, 'M1');

-- courses 
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id) VALUES 
('CS101', 'Intro to Programming', 'Python basics', 6, 1, 1, 1),
('CS202', 'Data Structures', 'Advanced algorithms', 6, 2, 1, 3),
('CS305', 'Network Security', 'Security protocols', 5, 1, 1, 2),
('MATH101', 'Calculus I', 'Derivatives and integrals', 6, 1, 2, 4),
('PHYS201', 'Mechanics', 'Newtonian physics', 5, 2, 3, 5),
('CIV301', 'Materials Science', 'Construction materials', 5, 1, 4, 6),
('MATH201', 'Linear Algebra', 'Matrices and vectors', 5, 2, 2, 4);

-- enrollments 
INSERT INTO enrollments (student_id, course_id, academic_year, status) VALUES 
(1, 1, '2024-2025', 'In Progress'), 
(1, 4, '2024-2025', 'In Progress'), 
(2, 2, '2024-2025', 'In Progress'), 
(2, 3, '2024-2025', 'In Progress'), 
(6, 3, '2023-2024', 'Passed'),      
(3, 4, '2024-2025', 'In Progress'), 
(3, 7, '2024-2025', 'In Progress'), 
(4, 5, '2024-2025', 'In Progress'), 
(5, 6, '2024-2025', 'In Progress'), 
(7, 4, '2024-2025', 'Failed'),      
(8, 5, '2023-2024', 'Passed'),      
(6, 2, '2024-2025', 'In Progress'), 
(2, 7, '2024-2025', 'Dropped'),     
(1, 7, '2024-2025', 'In Progress'), 
(5, 1, '2023-2024', 'Passed');      

-- grades 
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES 
(5, 'Exam', 16.50, 1.00, '2024-01-15', 'Excellent work'),
(5, 'Project', 18.00, 0.50, '2023-12-20', 'Good implementation'),
(11, 'Exam', 14.00, 1.00, '2024-01-10', 'Good'),
(15, 'Exam', 12.50, 1.00, '2024-01-12', 'Satisfactory'),
(1, 'Assignment', 15.00, 0.20, '2024-10-10', 'First assignment'),
(2, 'Exam', 11.00, 1.00, '2024-11-05', 'Needs improvement'),
(3, 'Lab', 17.00, 0.40, '2024-10-25', 'Perfect code'),
(10, 'Exam', 08.50, 1.00, '2024-11-05', 'Failed exam'),
(6, 'Assignment', 13.50, 0.20, '2024-10-15', 'Average'),
(4, 'Project', 19.00, 0.50, '2024-12-01', 'Outstanding'),
(7, 'Exam', 10.00, 1.00, '2024-11-20', 'Just passed'),
(12, 'Lab', 15.50, 0.40, '2024-10-20', 'Good participation');

-- PART 2: the queries

-- Q1: 
select s.last_name, s.first_name, s.email, s.level 
from students s;

-- Q2:
select p.last_name, p.first_name, p.email, p.specialization 
from professors p 
join departments d 
on p.department_id = d.department_id 
where d.department_name = "Computer Science"; 

-- Q3:
select c.course_code, c.course_name, c.credits 
from courses c 
where credits > 5;

-- Q4:
select s.student_number, s.last_name, s.first_name, s.email 
from students s
where s.level ="L3";

-- Q5:
select c.course_code, c.course_name, c.credits, c.semester 
from courses c
where c.semester = "1";

-- Q6:
select c.course_code, c.course_name, p.last_name, p.first_name 
from courses c 
join professors p 
on p.professor_id = c.professor_id;

-- Q7:
select s.first_name, s.last_name, c.course_name, e.enrollment_date, e.status 
from students s 
join enrollments e 
on e.student_id = s.student_id 
join courses c 
on c.course_id = e.course_id;

-- Q8:
select s.last_name, s.first_name, s.level, d.department_name 
from students s 
join departments d 
on s.department_id = d.department_id;

-- Q9:
select s.last_name, s.first_name, c.course_name, g.evaluation_type, g.grade 
from enrollments e 
join students s 
on e.student_id = s.student_id 
join grades g 
on g.enrollment_id = e.enrollment_id 
join courses c 
on c.course_id = e.course_id;

-- Q10:
select p.first_name, p.last_name, count(c.professor_id) as number_of_courses 
from professors p 
join courses c 
on c.professor_id = p.professor_id 
group by c.professor_id;

-- Q11:
select s.last_name, s.first_name, avg(g.grade) as average_grade 
from students s 
join enrollments e 
on e.student_id = s.student_id 
join grades g 
on g.enrollment_id = e.enrollment_id 
group by s.student_id;

-- Q12:
select d.department_name, count(s.student_id) as student_count 
from students s 
left join departments d 
on d.department_id = s.department_id 
group by d.department_id;

-- Q13:
select sum(budget) as total_budget from departments;

-- Q14:
select d.department_name, count(c.course_id) as course_count 
from courses c 
left join departments d 
on d.department_id = c.department_id 
group by c.department_id;

-- Q15:
select d.department_name, avg(p.salary) 
from professors p 
join departments d 
on d.department_id = p.department_id 
group by p.department_id; 
-- or 
-- select d.department_name, avg(p.salary) 
-- from professors p 
-- join departments d on d.department_id = p.department_id 
-- group by d.department_id;

-- Q16:
select s.first_name, s.last_name, avg(g.grade) as average_grade 
from grades g 
join enrollments e 
on e.enrollment_id = g.enrollment_id 
join students s 
on s.student_id = e.student_id 
group by s.student_id 
order by average_grade desc limit 3;

-- Q17:
select c.course_code, c.course_name 
from courses c 
left join enrollments e 
on e.course_id = c.course_id 
where student_id is null;

-- Q18:
select s.first_name, s.last_name, count(*) as passed_courses 
from students s 
join enrollments e 
on e.student_id = s.student_id group by s.student_id 
having count(*) = sum(e.status = "Passed");

-- Q19:
select p.last_name, p.first_name, count(c.course_id) as courses_taught 
from professors p 
join courses c 
on c.professor_id = p.professor_id 
group by p.professor_id 
having count(c.course_id);

-- Q20:
select s.first_name, s.last_name, count(c.course_id) as enrolled_courses_count 
from students s 
join enrollments e 
on e.student_id = s.student_id 
join courses c 
on c.course_id = e.course_id 
group by s.student_id 
having count(c.course_id) > 2;

-- Q21:
select s.last_name, s.first_name, avg(g.grade) as student_average, (
    select avg(g2.grade) as department_average 
    from grades g2 
    join enrollments e2 
    on e2.enrollment_id = g2.enrollment_id 
    join students s2 
    on s2.student_id = e2.student_id 
    where s2.department_id = s.department_id) as department_avg 
from students s 
join enrollments e 
on s.student_id = e.student_id 
join grades g 
on g.enrollment_id = e.enrollment_id 
group by s.student_id, s.first_name, s.last_name, s.department_id 
having avg(g.grade) > (
    select avg(g2.grade) as department_average 
    from grades g2 
    join enrollments e2 
    on e2.enrollment_id = g2.enrollment_id 
    join students s2 
    on s2.student_id = e2.student_id 
    where s2.department_id = s.department_id);

-- Q22:
select c.course_name, count(e.enrollment_id) as enrollment_count
from courses c
left join enrollments e 
on e.course_id = c.course_id
group by c.course_id, c.course_name
having count(e.enrollment_id) > (
    select avg(course_count)
    from (
        select count(e2.enrollment_id) as course_count
        from courses c2
        left join enrollments e2 
        on e2.course_id = c2.course_id
        group by c2.course_id
    ) as sub
);

-- Q23:
select p.first_name,  p.last_name, d.department_name, d.budget
from professors p
join departments d 
on p.department_id = d.department_id
where d.budget = (
    select max(budget) 
    from departments);

-- Q24: 
select s.first_name, s.last_name, s.email
from students s
left join enrollments e 
on s.student_id = e.student_id
left join grades g 
on e.enrollment_id = g.enrollment_id
where g.grade is null;

-- Q25:
select d.department_name, count(s.student_id) as student_count
from departments d
left join  students s 
on s.department_id = d.department_id
group by d.department_id, d.department_name
having count(s.student_id) > (
    select avg(student_count) 
    from (
        select count(s2.student_id) as student_count
        from departments d2
        left join  students s2 
        on s2.department_id = d2.department_id
        group by d2.department_id
    ) as sub
);

-- Q26:
select c.course_name, 
    count(g.grade_id) as total_grades, 
    sum(case when g.grade >= 10 then 1 else 0 end) as passed_grades,
    round(100 * sum(case when g.grade >= 10 then 1 else 0 end)/count(g.grade_id), 2) as pass_rate_percentage
from courses c
join enrollments e 
on e.course_id = c.course_id
join grades g 
on g.enrollment_id = e.enrollment_id
group by c.course_id, c.course_name;

-- Q27:
select
    rank() over (order by avg(g.grade) desc) as rank,
    s.first_name,  s.last_name,
    round(avg(g.grade), 2) as average_grade
from students s
join enrollments e 
on e.student_id = s.student_id
join grades g 
on g.enrollment_id = e.enrollment_id
group by s.student_id, s.first_name, s.last_name
order by average_grade desc;

-- Q28:
select
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    round(g.grade * g.coefficient, 2) as weighted_grade
from grades g
join enrollments e 
on g.enrollment_id = e.enrollment_id
join courses c 
on e.course_id = c.course_id
where e.student_id = 1;

-- Q29:
select p.first_name,  p.last_name, sum(c.credits) as total_credits
from professors p
join courses c 
on c.professor_id = p.professor_id
group by p.professor_id, p.first_name, p.last_name;

-- Q30:
select 
    c.course_name,
    count(e.enrollment_id) as current_enrollments,
    c.max_capacity,
    round(100 * count(e.enrollment_id)/c.max_capacity, 2) as percentage_full
from courses c
left join enrollments e 
on e.course_id = c.course_id
group by c.course_id, c.course_name, c.max_capacity
having percentage_full > 80;
