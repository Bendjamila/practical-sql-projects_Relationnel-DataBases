use university_db;
-- Q1. List all students with their main information (name, email, level)
-- Expected columns: last_name, first_name, email, level

SELECT last_name, first_name, email, level
FROM students;

-- Q2
-- Q2. Display all professors from the Computer Science department
-- Expected columns: last_name, first_name, email, specialization

select last_name, first_name, email, specialization
from professors;

-- Q3. Find all courses with more than 5 credits
-- Expected columns: course_code, course_name, credits

select course_code, course_name, credits 
from courses
where credits>5;

-- Q4. List students enrolled in L3 level
-- Expected columns: student_number, last_name, first_name, email

select student_number, last_name, first_name, email
from students 
where level="l3";

-- Q5. Display courses from semester 1
-- Expected columns: course_code, course_name, credits, semester

select course_code, course_name, credits, semester
from courses
where semester=1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all courses with the professor's name
-- Expected columns: course_code, course_name, professor_name (last + first)

select  course_code, course_name, CONCAT(last_name, ' ', first_name) AS professor_name
from courses
join professors
on courses.professor_id = professors.professor_id;

-- Q7. List all enrollments with student name and course name
-- Expected columns: student_name, course_name, enrollment_date, status
SELECT CONCAT(students.last_name, ' ', students.first_name) AS student_name,
       courses.course_name,
       enrollments.created_at,
       enrollments.status
from enrollments 
join courses on courses.course_id = enrollments.course_id
join students on students.student_id = enrollments.student_id;

-- Q8. Display students with their department name
-- Expected columns: student_name, department_name, level

select CONCAT(students.last_name, ' ', students.first_name) AS student_name, department_name, level
from students
join departments on departments.department_id = students.department_id;

-- Q9. List grades with student name, course name, and grade obtained
-- Expected columns: student_name, course_name, evaluation_type, grade

select CONCAT(students.last_name, ' ', students.first_name) AS student_name, courses.course_name, evaluation_type, grade
from grades 
join enrollments on enrollments.enrollment_id = grades.enrollment_id
join students on students.student_id = enrollments.student_id
join courses on courses.course_id = enrollments.course_id;

-- Q10. Display professors with the number of courses they teach
-- Expected columns: professor_name, number_of_courses

select CONCAT(last_name, ' ', first_name) AS professor_name, COUNT(courses.course_id) AS number_of_courses
FROM professors
JOIN courses ON courses.professor_id = professors.professor_id
GROUP BY professors.professor_id, professors.first_name, professors.last_name;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate the overall average grade for each student
-- Expected columns: student_name, average_grade

select CONCAT(students.last_name, ' ', students.first_name) AS student_name, avg(grade) AS average_grade
from grades 
join enrollments on enrollments.enrollment_id = grades.enrollment_id
join students on students.student_id = enrollments.student_id
group by  students.student_id, students.first_name, students.last_name;

-- Q12. Count the number of students per department
-- Expected columns: department_name,student_count

select departments.department_name, COUNT(students.student_id) AS student_count
from students
join departments on departments.department_id = students.department_id
GROUP BY departments.department_id, departments.department_name;

-- Q13. Calculate the total budget of all departments
-- Expected result: One row with total_budget
select SUM(budget) as total_budget
from departments;

-- Q14. Find the total number of courses per department
-- Expected columns: department_name, course_count

select departments.department_name, COUNT(course_id) AS course_count
from courses
join departments on departments.department_id = courses.department_id
GROUP BY departments.department_id, departments.department_name;

-- Q15. Calculate the average salary of professors per department
-- Expected columns: department_name, average_salary

select departments.department_name,AVG(salary) AS average_salary
from professors
join departments on departments.department_id = professors.department_id
GROUP BY departments.department_id, departments.department_name;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 3 students with the best averages
-- Expected columns: student_name, average_grade
-- Order by average_grade DESC, limit 3

select CONCAT(students.last_name, ' ', students.first_name) AS student_name, avg(grade) AS average_grade
from students
join enrollments on enrollments.student_id = students.student_id
join grades on grades.enrollment_id = enrollments.enrollment_id
GROUP BY students.student_id, students.last_name, students.first_name
ORDER BY average_grade DESC
limit 3;

-- Q17. List courses with no enrolled students
-- Expected columns: course_code, course_name

select courses.course_code, courses.course_name
from courses 
LEFT JOIN enrollments  ON courses.course_id = enrollments.course_id
WHERE enrollments.course_id IS NULL;

-- Q18. Display students who have passed all their courses (status = 'Passed')
-- Expected columns: student_name, passed_courses_count

SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.enrollment_id) = 
       SUM(CASE WHEN e.status = 'Passed' THEN 1 ELSE 0 END);

-- Q19. Find professors who teach more than 2 courses
-- Expected columns: professor_name, courses_taught

SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name
HAVING COUNT(c.course_id) > 2;

-- Q20. List students enrolled in more than 2 courses
-- Expected columns: student_name, enrolled_courses_count

SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.last_name, s.first_name
HAVING COUNT(e.course_id) > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find students with an average higher than their department's average
-- Expected columns: student_name, student_avg, department_avg

SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       AVG(g.grade) AS student_avg,
       (
           SELECT AVG(g2.grade)
           FROM students s2
           JOIN enrollments e2 ON s2.student_id = e2.student_id
           JOIN grades g2 ON g2.enrollment_id = e2.enrollment_id
           WHERE s2.department_id = s.department_id
       ) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name, s.department_id
HAVING AVG(g.grade) > department_avg;

-- Q22. List courses with more enrollments than the average number of enrollments
-- Expected columns: course_name, enrollment_count

SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) >
       (
           SELECT AVG(enroll_count)
           FROM (
               SELECT COUNT(enrollment_id) AS enroll_count
               FROM enrollments
               GROUP BY course_id
           ) AS sub
       );

-- Q23. Display professors from the department with the highest budget
-- Expected columns: professor_name, department_name, budget

SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24. Find students with no grades recorded
-- Expected columns: student_name, email

SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name, s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade IS NULL;

-- Q25. List departments with more students than the average
-- Expected columns: department_name, student_count

SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
JOIN students s ON s.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(student_count) 
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM students
        GROUP BY department_id
    ) AS sub
);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
-- Expected columns: course_name, total_grades, passed_grades, pass_rate_percentage

SELECT c.course_name,
       COUNT(g.grade) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(g.grade), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;

-- Q27. Display student ranking by descending average
-- Expected columns: rank, student_name, average_grade

SELECT 
    RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name
ORDER BY average_grade DESC;

-- Q28. Generate a report card for student with student_id = 1
-- Expected columns: course_name, evaluation_type, grade, coefficient, weighted_grade

SELECT c.course_name, e.evaluation_type, g.grade, c.coefficient, ROUND(g.grade * c.coefficient, 2) AS weighted_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 1;

-- Q29. Calculate teaching load per professor (total credits taught)
-- Expected columns: professor_name, total_credits

SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON c.professor_id = p.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
-- Expected columns: course_name, current_enrollments, max_capacity, percentage_full

SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity,
       ROUND(COUNT(e.enrollment_id) * 100.0 / c.max_capacity, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING COUNT(e.enrollment_id) > 0.8 * c.max_capacity;
