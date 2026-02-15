-- Question 1 --
select last_name, first_name, email, level
from STUDENTS;

-- Question 2 --
select last_name, first_name, email, specialization
from PROFESSORS
where department_id = 1;

-- Question 3 --
select course_code, course_name, credits
from COURSES
where credits > 5;

-- Question 4 --
select student_number, last_name, first_name, email, level
from STUDENTS
where level = 'L3';

-- Question 5 --
select course_code, course_name, credits, semester
from COURSES
where semester = 1;

-- Question 6 --
select c.course_code, c.course_name, concat(p.last_name, ' ', p.first_name) as professor_name
from COURSES c 
join PROFESSORS p on c.professor_id = p.professor_id;

-- Question 7 --
select concat(s.last_name, ' ', s.first_name) as student_name, c.course_name, e.enrollment_date, e.status
from ENROLLMENTS e 
join STUDENTS s on e.student_id = s.student_id
join COURSES c on e.course_id = c.course_id;

-- Question 8 --
select concat(s.last_name, ' ', s.first_name) as student_name, d.department_name, s.level
from STUDENTS s
join DEPARTMENTS d on s.department_id = d.department_id;

-- Question 9 --
select concat(s.last_name, ' ', s.first_name) as student_name, c.course_name, g.evaluation_type, g.grade
from GRADES g 
join ENROLLMENTS e on g.enrollment_id = e.enrollment_id
join STUDENTS s on e.student_id = s.student_id
join COURSES c on e.course_id = c.course_id;

-- Question 10 --
select concat(p.last_name, ' ', p.first_name) as professor_name, count(c.course_id) as nbr_courses
from PROFESSORS p
join COURSES c on p.professor_id = c.professor_id
group by p.professor_id;

-- Question 11 --
select concat(s.last_name, ' ', s.first_name) as student_name, avg(g.grade) as average_grade
from GRADES g
join ENROLLMENTS e on g.enrollment_id = e.enrollment_id
join STUDENTS s on e.student_id = s.student_id
group by s.student_id
order by average_grade desc;

-- Question 12 --
select d.department_name, count(s.student_id) as student_count
from DEPARTMENTS d 
join STUDENTS s on d.department_id = s.department_id
group by d.department_id
order by student_count desc;

-- Question 13 --
select sum(budget) as total_budget
from DEPARTMENTS;

-- Question 14 --
select d.department_name, count(c.course_id) as course_count
from DEPARTMENTS d
join COURSES c on c.department_id = d.department_id
group by d.department_id;

-- Question 15 --
select d.department_name, avg(p.salary) as average_salary
from DEPARTMENTS d
join PROFESSORS p on p.department_id = d.department_id
group by d.department_id
order by average_salary desc;

-- Question 16 --
select concat(s.last_name, ' ', s.first_name) as student_name, avg(g.grade) as average_grade
from GRADES g
join ENROLLMENTS e on g.enrollment_id = e.enrollment_id
join STUDENTS s on e.student_id = s.student_id
group by s.student_id
order by average_grade desc
limit 3;

-- Question 17 --
select c.course_code, c.course_name
from COURSES c
left join ENROLLMENTS e on c.course_id = e.course_id
where e.enrollment_id IS NULL;

-- Question 18 --
select concat(s.last_name, ' ', s.first_name) as student_name, count(e.enrollment_id) as passed_courses_count
from ENROLLMENTS e
join STUDENTS s on e.student_id = s.student_id
where e.status = 'PASSED' 
group by s.student_id;

-- Question 19 --
select concat(p.last_name, ' ', p.first_name) as professor_name, count(c.course_id) as courses_taught
from PROFESSORS p
join COURSES c on p.professor_id = c.professor_id  
group by p.professor_id
having count(c.course_id) > 2;

-- Question 20 --
select concat(s.last_name, ' ', s.first_name) as student_name, count(e.enrollment_id) as enrolled_courses_count
from ENROLLMENTS e
join STUDENTS s on e.student_id = s.student_id
group by s.student_id
having count(e.enrollment_id) > 2;

-- Question 21 --
select concat(s.last_name, ' ', s.first_name) as student_name, avg(g.grade) as student_average, d.department_average, d.department_id
from GRADES g
join ENROLLMENTS e on g.enrollment_id = e.enrollment_id 
join STUDENTS s on e.student_id = s.student_id
join ( select s.department_id, avg(g.grade) as department_average
    from STUDENTS s
    join ENROLLMENTS e ON s.student_id = e.student_id
    join GRADES g ON e.enrollment_id = g.enrollment_id
    group by s.department_id) d on s.department_id = d.department_id
group by s.student_id
having avg(g.grade) > d.department_average;

-- Question 22 --
select c.course_name, count(e.enrollment_id) as enrollment_count
from COURSES c
join ENROLLMENTS e on c.course_id = e.course_id
group by c.course_id
having count(e.enrollment_id) > (select avg(enrollment_count) from (
    select count(*) as enrollment_count
    from ENROLLMENTS
    group by course_id) as subquery);

-- Question 23 --
select concat(p.last_name, ' ', p.first_name) as professor_name, d.department_name, d.budget
from PROFESSORS p
join DEPARTMENTS d on p.department_id = d.department_id
where d.budget = ( select max(budget) from DEPARTMENTS);

-- Question 24 --
select concat(s.last_name, ' ', s.first_name) as student_name, s.email
from STUDENTS s
where s.student_id NOT IN ( select e.student_id from ENROLLMENTS e join grades g on e.enrollment_id = g.enrollment_id);

-- Question 25 --
select d.department_name, count(s.student_id) as student_count
from DEPARTMENTS d
join STUDENTS s on d.department_id = s.department_id
group by d.department_id
having count(s.student_id) > ( select avg(student_count) from (
    select count(*) as student_count
    from STUDENTS
    group by department_id) as subquery);

-- Question 26 --
select 
    c.course_name,
    count(g.grade_id) as total_grades,
    sum(case when g.grade >= 10 then 1 else 0 end) as passed_grades,
    sum(case when g.grade >= 10 then 1 else 0 end) / count(g.grade_id) * 100 as pass_rate_percentage
from COURSES c
join ENROLLMENTS e on c.course_id = e.course_id
join GRADES g on e.enrollment_id = g.enrollment_id
group by c.course_id;


-- Question 27--
select 
  rank() over (order by average_grade desc) as ranking,
  student_name, 
  average_grade
from (
  select 
    concat(s.last_name, ' ', s.first_name) as student_name, 
    avg(g.grade) as average_grade
  from GRADES g
  join ENROLLMENTS e on g.enrollment_id = e.enrollment_id
  join STUDENTS s on e.student_id = s.student_id
  group by s.student_id
) as student_averages;

-- Question 28 --
select
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    g.grade * g.coefficient as weighted_grade
from GRADES g
join ENROLLMENTS e on g.enrollment_id = e.enrollment_id
join COURSES c on e.course_id = c.course_id
where e.student_id = 1;

-- Question 29 --
select 
    concat(p.last_name, ' ', p.first_name) as professor_name,
    sum(c.credits) as total_credits
from PROFESSORS p
join COURSES c on p.professor_id = c.professor_id
group by p.professor_id;

-- Question 30 --
select 
    c.course_name,
    count(e.enrollment_id) as current_enrollment,
    c.max_capacity,
    count(e.enrollment_id)/c.max_capacity * 100 as enrollment_percentage
from COURSES c
left join ENROLLMENTS e on c.course_id = e.course_id
group by c.course_id
having enrollment_percentage > 80;

