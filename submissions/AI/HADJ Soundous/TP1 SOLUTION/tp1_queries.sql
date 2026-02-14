-- Q1
SELECT last_name, first_name, email, level
FROM students;

-- Q2
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- Q3
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';

-- Q5
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- Q6
SELECT c.course_code, c.course_name, CONCAT(p.last_name, ' ', p.first_name) AS professor_name
FROM courses c
JOIN professors p ON c.professor_id = p.professor_id;

-- Q7
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       c.course_name,
       e.academic_year,
       e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q8
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       d.department_name,
       s.level
FROM students s
JOIN departments d ON s.department_id = d.department_id;

-- Q9
SELECT CONCAT(st.last_name, ' ', st.first_name) AS student_name,
       c.course_name,
       g.evaluation_type,
       g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students st ON e.student_id = st.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q10
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q11
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q12
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id;

-- Q13
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14
SELECT d.department_name, COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id;

-- Q15
SELECT d.department_name, ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id;

-- Q16
SELECT TOP 3 CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.status <> 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       COUNT(e.course_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- Q21
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS student_avg,
       d.dept_avg AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
JOIN (
    SELECT s.department_id, 
           ROUND(AVG(g.grade * g.coefficient / g.coefficient), 2) AS dept_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) d ON s.department_id = d.department_id
GROUP BY s.student_id
HAVING student_avg > department_avg;

-- Q22
SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING COUNT(e.enrollment_id) > (SELECT AVG(course_count) 
                                 FROM (SELECT COUNT(*) AS course_count
                                       FROM enrollments
                                       GROUP BY course_id) AS sub);

-- Q23
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       d.department_name,
       d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);

-- Q24
SELECT CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade IS NULL;

-- Q25
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
HAVING COUNT(s.student_id) > (SELECT AVG(student_count)
                              FROM (SELECT COUNT(*) AS student_count
                                    FROM students
                                    GROUP BY department_id) AS sub);

-- Q26
SELECT c.course_name,
       COUNT(g.grade) AS total_grades,
       SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
       ROUND(SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade) * 100, 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27
SELECT RANK() OVER (ORDER BY AVG(g.grade * g.coefficient / g.coefficient) DESC) AS rank,
       CONCAT(s.last_name, ' ', s.first_name) AS student_name,
       ROUND(AVG(g.grade * g.coefficient / g.coefficient), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;

-- Q28
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
       ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM enrollments e
JOIN grades g ON e.enrollment_id = g.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;

-- Q29
SELECT CONCAT(p.last_name, ' ', p.first_name) AS professor_name,
       SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30
SELECT c.course_name,
       COUNT(e.enrollment_id) AS current_enrollments,
       c.max_capacity,
       ROUND(COUNT(e.enrollment_id) / c.max_capacity * 100, 2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;


