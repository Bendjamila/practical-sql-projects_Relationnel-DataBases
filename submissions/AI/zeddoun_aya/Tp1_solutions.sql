=

USE university_db;

-- ========== PART 1 ==========

-- Q1. List all students with their main information (name, email, level)
SELECT last_name, first_name, email, level
FROM students;


-- Q2. Display all professors from the Computer Science department
SELECT p.last_name, p.first_name, p.email, p.specialization
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.department_name = 'Computer Science';


-- Q3. Find all courses with more than 5 credits
SELECT course_code, course_name, credits
FROM courses
WHERE credits > 5;


-- Q4. List students enrolled in L3 level
SELECT student_number, last_name, first_name, email
FROM students
WHERE level = 'L3';


-- Q5. Display courses from semester 1
SELECT course_code, course_name, credits, semester
FROM courses
WHERE semester = 1;


-- ========== PART 2 ==========

-- Q6. Display all courses with the professor's name
SELECT 
    c.course_code, 
    c.course_name, 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id;


-- Q7. List all enrollments with student name and course name
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name,
    e.enrollment_date,
    e.status
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Q8. Display students with their department name
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    d.department_name,
    s.level
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id;


-- Q9. List grades with student name, course name, and grade obtained
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name,
    g.evaluation_type,
    g.grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;


-- Q10. Display professors with the number of courses they teach
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    COUNT(c.course_id) AS number_of_courses
FROM professors p
LEFT JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, professor_name;


-- ========== PART 3==========

-- Q11. Calculate the overall average grade for each student
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, student_name;


-- Q12. Count the number of students per department
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;


-- Q13. Calculate the total budget of all departments
SELECT SUM(budget) AS total_budget
FROM departments;


-- Q14. Find the total number of courses per department
SELECT 
    d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;


-- Q15. Calculate the average salary of professors per department
SELECT 
    d.department_name,
    ROUND(AVG(p.salary), 2) AS average_salary
FROM departments d
LEFT JOIN professors p ON d.department_id = p.department_id
GROUP BY d.department_id, d.department_name;


-- ========== PART 4 ==========

-- Q16. Find the top 3 students with the best averages
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, student_name
ORDER BY average_grade DESC
LIMIT 3;


-- Q17. List courses with no enrolled students
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;


-- Q18. Display students who have passed all their courses (status = 'Passed')
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    COUNT(e.enrollment_id) AS passed_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.status = 'Passed'
GROUP BY s.student_id, student_name;


-- Q19. Find professors who teach more than 2 courses
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    COUNT(c.course_id) AS courses_taught
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, professor_name
HAVING COUNT(c.course_id) > 2;


-- Q20. List students enrolled in more than 2 courses
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    COUNT(e.enrollment_id) AS enrolled_courses_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, student_name
HAVING COUNT(e.enrollment_id) > 2;


-- ========== PART 5 ==========

-- Q21. Find students with an average higher than their department's average
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS student_avg,
    (
        SELECT ROUND(AVG(g2.grade), 2)
        FROM students s2
        JOIN enrollments e2 ON s2.student_id = e2.student_id
        JOIN grades g2 ON e2.enrollment_id = g2.enrollment_id
        WHERE s2.department_id = s.department_id
    ) AS department_avg
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.department_id, student_name
HAVING student_avg > department_avg;


-- Q22. List courses with more enrollments than the average number of enrollments
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(e.enrollment_id) > (
    SELECT AVG(enrollment_count)
    FROM (
        SELECT COUNT(e2.enrollment_id) AS enrollment_count
        FROM courses c2
        LEFT JOIN enrollments e2 ON c2.course_id = e2.course_id
        GROUP BY c2.course_id
    ) AS avg_enrollments
);


-- Q23. Display professors from the department with the highest budget
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    d.department_name,
    d.budget
FROM professors p
JOIN departments d ON p.department_id = d.department_id
WHERE d.budget = (SELECT MAX(budget) FROM departments);


-- Q24. Find students with no grades recorded
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;


-- Q25. List departments with more students than the average
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(s.student_id) > (
    SELECT AVG(student_count)
    FROM (
        SELECT COUNT(s2.student_id) AS student_count
        FROM departments d2
        LEFT JOIN students s2 ON d2.department_id = s2.department_id
        GROUP BY d2.department_id
    ) AS avg_students
);


-- ========== PART 6 ==========

-- Q26. Calculate the pass rate per course (grades >= 10/20)
SELECT 
    c.course_name,
    COUNT(g.grade_id) AS total_grades,
    SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) AS passed_grades,
    ROUND(
        (SUM(CASE WHEN g.grade >= 10 THEN 1 ELSE 0 END) * 100.0) / COUNT(g.grade_id), 
        2
    ) AS pass_rate_percentage
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_id, c.course_name;


-- Q27. Display student ranking by descending average
SELECT 
    RANK() OVER (ORDER BY AVG(g.grade) DESC) AS rank,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, student_name
ORDER BY average_grade DESC;


-- Q28. Generate a report card for student with student_id = 1
SELECT 
    c.course_name,
    g.evaluation_type,
    g.grade,
    g.coefficient,
    ROUND(g.grade * g.coefficient, 2) AS weighted_grade
FROM grades g
JOIN enrollments e ON g.enrollment_id = e.enrollment_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.student_id = 1
ORDER BY c.course_name, g.evaluation_type;


-- Q29. Calculate teaching load per professor (total credits taught)
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS professor_name,
    SUM(c.credits) AS total_credits
FROM professors p
JOIN courses c ON p.professor_id = c.professor_id
GROUP BY p.professor_id, professor_name;


-- Q30. Identify overloaded courses (enrollments > 80% of max capacity)
SELECT 
    c.course_name,
    COUNT(e.enrollment_id) AS current_enrollments,
    c.max_capacity,
    ROUND(
        (COUNT(e.enrollment_id) * 100.0) / c.max_capacity, 
        2
    ) AS percentage_full
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name, c.max_capacity
HAVING (COUNT(e.enrollment_id) * 100.0) / c.max_capacity > 80;