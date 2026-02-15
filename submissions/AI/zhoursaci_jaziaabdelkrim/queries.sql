-- University Management System

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1
SELECT last_name, first_name, email, level FROM students;

-- Q2
SELECT last_name, first_name, email, specialization 
FROM professors p 
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = "Computer Science";

-- Q3
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;

-- Q4
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = "L3";

-- Q5
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6
SELECT c.course_code, c.course_name, p.last_name, p.first_name
FROM courses c
JOIN professors p ON c.professor_id = s.professor_id;

-- Q7
SELECT s.last_name, s.first_name, c.course_name, e.enrollment_date, e.status
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses c ON c.course_id = e.course_id;

-- Q8
SELECT s.last_name, s.first_name, d.department_name, s.level
FROM students s
JOIN departments d ON d.department_id = s.department_id;

-- Q9
SELECT s.last_name, s.first_name, c.course_name, g.evaluation_type, g.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
JOIN courses c ON c.course_id = e.course_id;

-- Q10
SELECT p.professor_id, p.last_name, p.first_name, COUNT(c.professor_id) AS number_of_courses
FROM courses c
JOIN professors p ON p.professor_id = c.professor_id
GROUP BY p.professor_id, p.last_name, p.first_name;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11
SELECT s.student_id, s.last_name, s.first_name, AVG(g.grade) AS average_grade
FROM students s
JOIN enrollments e ON e.student_id = s.student_id
JOIN grades g ON g.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.last_name, s.first_name;

-- Q12
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q13
SELECT SUM(budget) AS total_budget
FROM departments;

-- Q14
SELECT d.department_id, d.department_name, COUNT(c.course_id)
FROM departments d
LEFT JOIN courses c ON c.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- Q15
SELECT d.department_id, d.department_name, AVG(p.salary) AS average_salary
FROM professors p
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16
SELECT s.first_name || ' ' || s.last_name AS student_name, ROUND(AVG(g.grade),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Q17
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Q18
SELECT s.first_name || ' ' || s.last_name AS student_name, COUNT(*) AS curses_passed
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.status != 'Passed' THEN 1 ELSE 0 END) = 0;

-- Q19
SELECT p.first_name || ' ' || p.last_name AS professor_name, COUNT(c.course_id) AS prof_courses
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id
HAVING COUNT(c.course_id) > 2;

-- Q20
SELECT s.first_name || ' ' || s.last_name AS student_name, COUNT(e.course_id) AS nb_enrollments
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 2;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21
SELECT student_name, student_avg, department_avg
FROM (
    SELECT s.student_id, s.department_id, s.first_name || ' ' || s.last_name AS student_name,
        AVG(g.grade) AS student_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.student_id
) student_data
JOIN (
    SELECT s.department_id, AVG(g.grade) AS department_avg
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY s.department_id
) department_data
ON student_data.department_id = department_data.department_id
WHERE student_avg > department_avg;

-- Q22
SELECT course_name, enrollment_nb
FROM(
    SELECT c.course_name, COUNT(e.enrollment_id) AS enrollment_nb
    FROM courses c
    LEFT JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id
) subq
WHERE enrollment_nb > ( 
    SELECT AVG(enrollments_count)
    FROM (
        SELECT COUNT(enrollment_id) AS enrollments_count
        FROM enrollments
        GROUP BY course_id
    )
);

-- Q23
SELECT p.first_name || ' ' || p.last_name AS professor_name, d.department_name, d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (
    SELECT MAX(budget) FROM departments
);

-- Q24
SELECT s.first_name || ' ' || s.last_name AS student_name, e.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- Q25
SELECT department_name, students_nb
FROM (
    SELECT d.department_name, COUNT(s.student_id) AS students_nb
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id
) subqr
WHERE students_nb > (
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM students
        GROUP BY department_id 
    )
);

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26
SELECT c.course_name, COUNT(g.grade_id) AS total_grades,
			SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
			ROUND( 100.0 * SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) / COUNT(g.grade_id), 2) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollments ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id;

-- Q27
SELECT RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
			s.first_name || ' ' || s.last_name AS student_name,
			ROUND(AVG(g.grade),2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;

-- Q28
SELECT c.course_name, g.evaluation_type, g.grade, g.coefficient,
			(g.grade * g.coefficient) AS weighted_grade
FROM enrollment e
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE e.student_id = 1;

-- Q29
SELECT p.first_name || ' ' || p.last_name AS professor_name, SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id;

-- Q30
SELECT c.course_name, COUNT(e.enrollment_id) AS current_enrollments, c.max_capacity,
			ROUND(100.0 * COUNT(e.enrollment_id) / c.max_capacity,2) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING percentage_full > 80;
