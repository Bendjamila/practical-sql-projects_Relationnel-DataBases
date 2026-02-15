-- UNIVERSITY DATABASE MANAGEMENT SYSTEM

create database university_db;
use university_db;

-- TABLE DEFINITIONS

create table departments (
    department_id int primary key auto_increment,
    department_name varchar(100) not null,
    building varchar(50),
    budget decimal(12, 2),
    department_head varchar(100),
    creation_date date
);

create table professors (
    professor_id int primary key auto_increment,
    last_name varchar(50) not null,
    first_name varchar(50) not null,
    email varchar(100) unique not null,
    phone varchar(20),
    department_id int,
    hire_date date,
    salary decimal(10, 2),
    specialization varchar(100),
    foreign key(department_id) references departments(department_id)
        on delete set null      -- Keep professor record even if department is deleted
        on update cascade       -- Auto-update if department_id changes
);

create table students (
    student_id int primary key auto_increment,
    student_number varchar(20) UNIQUE NOT NULL,
    last_name varchar(50) NOT NULL,
    first_name varchar(50) NOT NULL,
    date_of_birth DATE,
    email varchar(100) UNIQUE NOT NULL,
    phone varchar(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20) CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),  -- Academic year constraint
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    foreign key (department_id) references departments(department_id)
        on delete set null
        on update cascade
);

create table courses (
    course_id int primary key auto_increment,
    course_code varchar(10) UNIQUE NOT NULL,
    course_name varchar(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),  -- Must have at least 1 credit
    semester INT CHECK (semester BETWEEN 1 AND 2),
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,
    foreign key (department_id) references departments(department_id)
        on delete cascade,      -- Delete courses if department is deleted
    foreign key (professor_id) references professors(professor_id)
        on delete set null      -- Keep course even if professor leaves
);

create table enrollments (
    enrollment_id int primary key auto_increment,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    academic_year varchar(9) NOT NULL,
    status varchar(20) DEFAULT 'In Progress' 
        CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    foreign key (student_id) references students(student_id)
        on delete cascade,      -- Remove enrollments if student is deleted
    foreign key (course_id) references courses(course_id)
        on delete cascade,
    UNIQUE KEY unique_enrollment (student_id, course_id, academic_year)  -- Prevent duplicate enrollments in same year
);

create table grades (
    grade_id int primary key auto_increment,
    enrollment_id int not null,
    evaluation_type varchar(30) 
        CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade decimal(5, 2) check (grade BETWEEN 0 AND 20),  -- French grading system (0-20)
    coefficient decimal(3, 2) DEFAULT 1.00,  -- Weight of this evaluation
    evaluation_date DATE,
    comments TEXT,
    foreign key (enrollment_id) references enrollments(enrollment_id)
        on delete cascade
);

-- Performance indexes for frequently joined columns
create index idx_student_department on students(department_id);
create index idx_course_professor on courses(professor_id);
create index idx_enrollment_student on enrollments(student_id);
create index idx_enrollment_course on enrollments(course_id);
create index idx_grades_enrollment on grades(enrollment_id);

-- SAMPLE DATA

insert into departments (department_name, building, budget, department_head, creation_date) values
('Computer Science', 'Building A', 500000.00, 'Dr. Ahmed Benali', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Sarah Mansouri', '2012-01-15'),
('Physics', 'Building C', 400000.00, 'Dr. Mohamed Khelifi', '2011-06-20'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Fatima Zerrouki', '2009-03-10');

insert into professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) values
('Bouaziz', 'Karim', 'karim.bouaziz@univ.dz', '0555123456', 1, '2015-09-01', 85000.00, 'Artificial Intelligence'),
('Meziane', 'Amira', 'amira.meziane@univ.dz', '0555234567', 1, '2016-02-15', 78000.00, 'Database Systems'),
('Larbi', 'Rachid', 'rachid.larbi@univ.dz', '0555345678', 1, '2017-09-01', 82000.00, 'Software Engineering'),
('Hamadi', 'Leila', 'leila.hamadi@univ.dz', '0555456789', 2, '2014-09-01', 75000.00, 'Applied Mathematics'),
('Bendjebbar', 'Omar', 'omar.bendjebbar@univ.dz', '0555567890', 3, '2013-01-10', 80000.00, 'Quantum Physics'),
('Saadi', 'Nadia', 'nadia.saadi@univ.dz', '0555678901', 4, '2015-06-01', 88000.00, 'Structural Engineering');

insert into students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) values
('CS2024001', 'Belkacem', 'Yacine', '2003-05-12', 'yacine.belkacem@etu.univ.dz', '0660123456', '15 Rue Didouche Mourad, Alger', 1, 'L3', '2022-09-15'),
('CS2024002', 'Brahimi', 'Soundous', '2004-03-22', 'soundous.brahimi@etu.univ.dz', '0660234567', '28 Avenue Pasteur, Alger', 1, 'L2', '2023-09-10'),
('CS2024003', 'Cherif', 'Amine', '2002-11-08', 'amine.cherif@etu.univ.dz', '0660345678', '42 Rue Hassiba Ben Bouali, Alger', 1, 'M1', '2021-09-20'),
('MA2024001', 'Djamel', 'Lina', '2003-07-15', 'lina.djamel@etu.univ.dz', '0660456789', '7 Boulevard Zirout Youcef, Alger', 2, 'L3', '2022-09-15'),
('MA2024002', 'Ferhat', 'Mehdi', '2004-01-30', 'mehdi.ferhat@etu.univ.dz', '0660567890', '33 Rue Larbi Ben M\'Hidi, Alger', 2, 'L2', '2023-09-10'),
('PH2024001', 'Ghazi', 'Samia', '2003-09-18', 'samia.ghazi@etu.univ.dz', '0660678901', '19 Avenue Souidani Boudjemaa, Alger', 3, 'L3', '2022-09-15'),
('CE2024001', 'Hamza', 'Kamel', '2002-12-05', 'kamel.hamza@etu.univ.dz', '0660789012', '51 Rue Mohamed V, Alger', 4, 'M1', '2021-09-20'),
('CS2024004', 'Idir', 'Nawel', '2004-06-25', 'nawel.idir@etu.univ.dz', '0660890123', '8 Rue Ahmed Bouzrina, Alger', 1, 'L2', '2023-09-10');

insert into courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) values
('CS301', 'Database Management Systems', 'Introduction to relational databases, SQL, and database design', 6, 1, 1, 2, 35),
('CS302', 'Artificial Intelligence', 'Machine learning, neural networks, and AI algorithms', 6, 1, 1, 1, 30),
('CS303', 'Software Engineering', 'Software development lifecycle, design patterns, and testing', 5, 2, 1, 3, 40),
('MA201', 'Linear Algebra', 'Matrices, vector spaces, and eigenvalues', 5, 1, 2, 4, 45),
('PH301', 'Quantum Mechanics', 'Introduction to quantum physics and wave functions', 6, 1, 3, 5, 25),
('CE401', 'Structural Analysis', 'Analysis of structures and load calculations', 6, 2, 4, 6, 30),
('CS401', 'Advanced Algorithms', 'Algorithm design and complexity analysis', 5, 2, 1, 1, 30);

insert into enrollments (student_id, course_id, enrollment_date, academic_year, status) values
(1, 1, '2024-09-15', '2024-2025', 'In Progress'),
(1, 2, '2024-09-15', '2024-2025', 'In Progress'),
(1, 3, '2024-09-15', '2024-2025', 'Passed'),
(2, 1, '2024-09-16', '2024-2025', 'In Progress'),
(2, 4, '2024-09-16', '2024-2025', 'Passed'),
(3, 2, '2024-09-17', '2024-2025', 'Passed'),
(3, 3, '2024-09-17', '2024-2025', 'Passed'),
(3, 7, '2024-09-17', '2024-2025', 'In Progress'),
(4, 4, '2024-09-18', '2024-2025', 'Passed'),
(4, 1, '2024-09-18', '2024-2025', 'Failed'),
(5, 4, '2024-09-19', '2024-2025', 'In Progress'),
(6, 5, '2024-09-20', '2024-2025', 'Passed'),
(7, 6, '2024-09-21', '2024-2025', 'In Progress'),
(8, 1, '2024-09-22', '2024-2025', 'Dropped'),
(1, 1, '2023-09-15', '2023-2024', 'Passed');

insert into grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) values
(1, 'Assignment', 15.50, 0.20, '2024-10-15', 'Good work on SQL queries'),
(1, 'Exam', 14.00, 0.60, '2024-12-10', 'Solid understanding of concepts'),
(2, 'Project', 16.50, 0.40, '2024-11-20', 'Excellent AI implementation'),
(3, 'Exam', 13.00, 0.70, '2024-12-15', 'Met all requirements'),
(5, 'Assignment', 17.00, 0.30, '2024-10-20', 'Outstanding work'),
(6, 'Exam', 15.00, 0.60, '2024-12-12', 'Very good performance'),
(7, 'Project', 18.00, 0.50, '2024-11-25', 'Exceptional software design'),
(9, 'Exam', 16.50, 0.60, '2024-12-08', 'Excellent mastery'),
(10, 'Exam', 12.50, 0.60, '2024-12-08', 'Satisfactory'),
(12, 'Lab', 14.50, 0.40, '2024-11-15', 'Good practical skills'),
(15, 'Exam', 12.00, 0.60, '2024-01-15', 'Satisfactory'),
(15, 'Assignment', 14.00, 0.40, '2023-11-10', 'Good progress');

-- Q1. List all students with their main information
-- Simple selection with ordering by name
select last_name, first_name, email, level 
from students 
order by last_name, first_name;

-- Q2. Display all professors from the Computer Science department
-- Uses subquery to find department_id, then filters professors
select last_name, first_name, email, specialization
from professors
where department_id = (
    select department_id 
    from departments 
    where department_name = 'Computer Science'
)
order by last_name;

-- Q3. Find all courses with more than 5 credits
-- Simple filtering with descending sort on credits
select course_code, course_name, credits 
from courses 
where credits > 5
order by credits DESC, course_name;

-- Q4. List students enrolled in L3 level
-- Direct filtering on level field
select student_number, last_name, first_name, email 
from students 
where level = 'L3'
order by last_name, first_name;

-- Q5. Display courses from semester 1
-- Filter by semester number
select course_code, course_name, credits, semester 
from courses
where semester = 1
order by course_name;

-- Q6. Display all courses with the professor's name
-- LEFT JOIN ensures courses without professors still appear
-- CONCAT combines first and last names into single field
select 
    C.course_code, 
    C.course_name, 
    concat(P.last_name, ' ', P.first_name) as professor_name
from courses C
left join professors P on C.professor_id = P.professor_id
order by C.course_name;

-- Q7. List all enrollments with student name and course name
-- Joins three tables to combine enrollment, student, and course data
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    C.course_name, 
    E.enrollment_date, 
    E.status
from enrollments E
join students S on E.student_id = S.student_id
join courses C on C.course_id = E.course_id
order by E.enrollment_date;

-- Q8. Display students with their department name
-- Simple join to show which department each student belongs to
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    D.department_name, 
    S.level
from students S
join departments D on S.department_id = D.department_id
order by student_name;

-- Q9. List grades with student name, course name, and grade obtained
-- Four-table join: grades -> enrollments -> students and courses
-- Shows complete picture of who got what grade in which course
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    C.course_name, 
    G.evaluation_type, 
    G.grade
from grades G 
join enrollments E on G.enrollment_id = E.enrollment_id
join students S on E.student_id = S.student_id
join courses C on E.course_id = C.course_id
order by G.grade desc, C.course_name;

-- Q10. Display professors with the number of courses they teach
-- LEFT JOIN ensures professors with no courses appear with count of 0
-- GROUP BY professor_name aggregates courses per professor
select 
    concat(P.last_name, ' ', P.first_name) as professor_name, 
    count(C.course_id) as number_of_courses
from professors P
left join courses C on P.professor_id = C.professor_id
group by professor_name
order by number_of_courses desc, professor_name;

-- Q11. Calculate the overall average grade for each student
-- Groups all grades by student and calculates their mean
-- ROUND() limits decimal places for readability
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    round(avg(G.grade), 2) as average_grade
from students S
join enrollments E on s.student_id = E.student_id
join grades g on E.enrollment_id = G.enrollment_id
group by S.student_id, S.last_name, S.first_name
order by average_grade desc;

-- Q12. Count the number of students per department
-- LEFT JOIN ensures departments with no students still show count of 0
select 
    D.department_name, 
    count(S.student_id) as student_count
from departments D
left join students S on D.department_id = S.department_id
group by D.department_id, D.department_name
order by student_count desc;

-- Q13. Calculate the total budget of all departments
-- Simple aggregation across all rows
select sum(budget) as total_budget
from departments;

-- Q14. Find the total number of courses per department
-- Counts courses offered by each department
select 
    D.department_name, 
    count(C.course_id) as course_count
from departments D
left join courses C on D.department_id = C.department_id
group by D.department_id, D.department_name
order by course_count desc;

-- Q15. Calculate the average salary of professors per department
-- Groups professors by department and finds mean salary
select 
    D.department_name, 
    round(avg(P.salary), 2) as average_salary
from departments D
left join professors P on D.department_id = P.department_id
group by D.department_id, D.department_name
order by average_salary desc;

-- Q16. Find the top 3 students with the best averages
-- Same as Q11 but limited to top 3 performers
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    round(avg(G.grade), 2) as average_grade
from students S
join enrollments E on S.student_id = E.student_id
join grades G on E.enrollment_id = G.enrollment_id
group by S.student_id, S.last_name, S.first_name
order by average_grade desc
limit 3;

-- Q17. List courses with no enrolled students
-- LEFT JOIN creates NULL for courses without enrollments
-- WHERE filters to keep only those NULL rows
select 
    C.course_code, 
    C.course_name
from courses C
left join enrollments E on C.course_id = E.course_id
where E.enrollment_id is null
order by C.course_code;

-- Q18. Display students who have passed all their courses
-- Logic: Count passed courses = count of all courses for that student
-- HAVING clause filters groups after aggregation
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    count(E.course_id) as passed_courses_count
from students S
join enrollments E on S.student_id = E.student_id
where E.status = 'Passed'
group by S.student_id, S.last_name, S.first_name
having count(E.enrollment_id) = (
    select count(*) 
    from enrollments 
    where student_id = S.student_id
)
order by passed_courses_count desc;

-- Q19. Find professors who teach more than 2 courses
-- HAVING filters after grouping - only professors with >2 courses
select 
    concat(P.last_name, ' ', P.first_name) as professor_name, 
    count(C.course_id) as courses_taught
from professors P
join courses C on P.professor_id = C.professor_id
group by P.professor_id, P.last_name, P.first_name
having count(C.course_id) > 2
order by courses_taught desc;

-- Q20. List students enrolled in more than 2 courses
-- Similar logic to Q19 but for students
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    count(E.enrollment_id) as enrolled_courses_count
from students S
join enrollments E on S.student_id = E.student_id
group by S.student_id, S.first_name, S.last_name
having count(E.enrollment_id) > 2
order by enrolled_courses_count desc;

-- Q21. Find students with an average higher than their department's average
-- Complex logic: For each student, calculate their average and compare
-- to the average of all students in their department
-- Uses correlated subquery in both SELECT and HAVING
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    round(avg(G.grade), 2) as student_avg,
    (select round(avg(G2.grade), 2)
     from students S2
     join enrollments E2 on S2.student_id = E2.student_id
     join grades G2 on E2.enrollment_id = G2.enrollment_id
     where S2.department_id = S.department_id) as department_avg
from students S
join enrollments E on S.student_id = E.student_id
join grades G on E.enrollment_id = G.enrollment_id
group by S.student_id, S.last_name, S.first_name, S.department_id
having avg(G.grade) > (
    select avg(G2.grade)
    from students S2
    join enrollments E2 on S2.student_id = E2.student_id
    join grades G2 on E2.enrollment_id = G2.enrollment_id
    where S2.department_id = S.department_id
)
order by student_avg desc;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Logic: First calculate average enrollments per course (subquery)
-- Then filter courses that exceed this average
select 
    C.course_name, 
    count(E.enrollment_id) as enrollment_count
from courses C
left join enrollments E on C.course_id = E.course_id
group by C.course_id, C.course_name
having count(E.enrollment_id) > (
    select avg(enrollment_count)
    from (
        select count(enrollment_id) as enrollment_count
        from enrollments
        group by course_id
    ) as avg_enrollments
)
order by enrollment_count desc;

-- Q23. Display professors from the department with the highest budget
-- Subquery finds max budget, outer query filters professors from that department
select 
    concat(P.last_name, ' ', P.first_name) as professor_name, 
    D.department_name, 
    D.budget
from professors P
join departments D on P.department_id = D.department_id
where D.budget = (select max(budget) from departments)
order by P.last_name;

-- Q24. Find students with no grades recorded
-- Uses NOT IN subquery to find students whose ID doesn't appear
-- in the list of student IDs that have grades
select 
    concat(S.last_name, ' ', S.first_name) as student_name, 
    S.email
from students S
where S.student_id not in (
    select distinct E.student_id
    from enrollments E
    join grades G on E.enrollment_id = G.enrollment_id
)
order by S.last_name;

-- Q25. List departments with more students than the average
-- Similar to Q22: calculate average students per department,
-- then show only departments exceeding that average
select 
    D.department_name, 
    count(S.student_id) as student_count
from departments D
left join students S on D.department_id = S.department_id
group by D.department_id, D.department_name
having count(S.student_id) > (
    select avg(student_count)
    from (
        select count(student_id) as student_count
        from students
        group by department_id
    ) as avg_students
)
order by student_count desc;

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Uses CASE statement to count passed grades (>=10)
-- Pass rate = (passed / total) * 100
select 
    C.course_name, 
    count(G.grade_id) as total_grades,
    sum(case when G.grade >= 10 then 1 else 0 end) as passed_grades,
    round((sum(case when G.grade >= 10 then 1 else 0 end) / count(G.grade_id)) * 100, 2) as pass_rate_percentage
from courses C
join enrollments E on C.course_id = E.course_id
join grades G on E.enrollment_id = G.enrollment_id
group by C.course_id, C.course_name
order by pass_rate_percentage desc;

-- Q27. Display student ranking by descending average
-- Uses window function RANK() to assign ranks based on average grade
-- Handles ties by giving same rank to students with identical averages
select 
    rank() over (order by avg(G.grade) desc) as `rank`,
    concat(S.last_name, ' ', S.first_name) as student_name,
    round(avg(G.grade), 2) as average_grade
from students S
join enrollments E on S.student_id = E.student_id
join grades G on E.enrollment_id = G.enrollment_id
group by S.student_id, S.last_name, S.first_name
order by `rank`;

-- Q28. Generate a report card for student with student_id = 1
-- Shows all evaluations with weighted grades for a specific student
-- weighted_grade = grade * coefficient (used to calculate final course grade)
select 
    C.course_name, 
    G.evaluation_type, 
    G.grade, 
    G.coefficient, 
    round(G.grade * G.coefficient, 2) as weighted_grade
from grades G
join enrollments E on G.enrollment_id = E.enrollment_id
join courses C on E.course_id = C.course_id
where E.student_id = 1
order by C.course_name, G.evaluation_date;

-- Q29. Calculate teaching load per professor (total credits taught)
-- Sums all credits from courses taught by each professor
-- COALESCE handles professors with no courses (returns 0 instead of NULL)
select 
    concat(P.last_name, ' ', P.first_name) as professor_name, 
    coalesce(sum(C.credits), 0) as total_credits
from professors P
left join courses C on P.professor_id = C.professor_id
group by P.professor_id, P.last_name, P.first_name
order by total_credits desc;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Calculates percentage full for each course
-- HAVING filters to show only courses over 80% capacity
select 
    C.course_name, 
    count(E.enrollment_id) as current_enrollments, 
    C.max_capacity,
    round((count(E.enrollment_id) / C.max_capacity) * 100, 2) as percentage_full
from courses C
left join enrollments E on C.course_id = E.course_id
group by C.course_id, C.course_name, C.max_capacity
having (count(E.enrollment_id) / C.max_capacity) > 0.80
order by percentage_full desc;
