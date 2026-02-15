/* TP1: Higher Education Management System - OULED DRISS Abdelmounaim */

DROP DATABASE IF EXISTS academic_management_sys;
CREATE DATABASE academic_management_sys;
USE academic_management_sys;

CREATE TABLE academic_units (
    unit_id INT PRIMARY KEY AUTO_INCREMENT,
    unit_title VARCHAR(100) NOT NULL,
    campus_block VARCHAR(50),
    annual_funding DECIMAL(12, 2),
    unit_director VARCHAR(100),
    established_on DATE
);

CREATE TABLE faculty_members (
    fac_id INT PRIMARY KEY AUTO_INCREMENT,
    family_name VARCHAR(50) NOT NULL,
    given_name VARCHAR(50) NOT NULL,
    official_email VARCHAR(100) UNIQUE NOT NULL,
    contact_phone VARCHAR(20),
    dept_ref_id INT,
    start_date DATE,
    monthly_pay DECIMAL(10, 2),
    expertise_area VARCHAR(100),
    FOREIGN KEY (dept_ref_id) REFERENCES academic_units(unit_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE enrolled_learners (
    learner_id INT PRIMARY KEY AUTO_INCREMENT,
    id_card_no VARCHAR(20) UNIQUE NOT NULL,
    surname VARCHAR(50) NOT NULL,
    forename VARCHAR(50) NOT NULL,
    birth_date DATE,
    personal_email VARCHAR(100) UNIQUE NOT NULL,
    mobile_no VARCHAR(20),
    residence_address TEXT,
    unit_link_id INT,
    study_stage VARCHAR(20) CHECK (study_stage IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    admission_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (unit_link_id) REFERENCES academic_units(unit_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE academic_modules (
    module_id INT PRIMARY KEY AUTO_INCREMENT,
    module_ref VARCHAR(10) UNIQUE NOT NULL,
    module_title VARCHAR(150) NOT NULL,
    module_info TEXT,
    credit_value INT NOT NULL CHECK (credit_value > 0),
    term_no INT CHECK (term_no BETWEEN 1 AND 2),
    unit_id_ref INT,
    instructor_id INT,
    seat_limit INT DEFAULT 30,
    FOREIGN KEY (unit_id_ref) REFERENCES academic_units(unit_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES faculty_members(fac_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE module_registrations (
    reg_id INT PRIMARY KEY AUTO_INCREMENT,
    learner_ref_id INT NOT NULL,
    module_ref_id INT NOT NULL,
    reg_timestamp DATE DEFAULT (CURRENT_DATE),
    session_year VARCHAR(9) NOT NULL,
    outcome_status VARCHAR(20) DEFAULT 'In Progress' CHECK (outcome_status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    FOREIGN KEY (learner_ref_id) REFERENCES enrolled_learners(learner_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (module_ref_id) REFERENCES academic_modules(module_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (learner_ref_id, module_ref_id, session_year)
);

CREATE TABLE performance_marks (
    mark_id INT PRIMARY KEY AUTO_INCREMENT,
    reg_ref_id INT NOT NULL,
    assessment_kind VARCHAR(30) CHECK (assessment_kind IN ('Assignment', 'Lab', 'Exam', 'Project')),
    score_val DECIMAL(5, 2) CHECK (score_val BETWEEN 0 AND 20),
    weight_factor DECIMAL(3, 2) DEFAULT 1.00,
    assessment_timestamp DATE,
    feedback_notes TEXT,
    FOREIGN KEY (reg_ref_id) REFERENCES module_registrations(reg_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX idx_learner_unit ON enrolled_learners(unit_link_id);
CREATE INDEX idx_module_instructor ON academic_modules(instructor_id);
CREATE INDEX idx_reg_learner ON module_registrations(learner_ref_id);
CREATE INDEX idx_reg_module ON module_registrations(module_ref_id);
CREATE INDEX idx_marks_reg ON performance_marks(reg_ref_id);

INSERT INTO academic_units (unit_title, campus_block, annual_funding, unit_director, established_on) VALUES
('Information Technology', 'North Wing', 450000.00, 'Prof. Linus Torvalds', '2015-01-10'),
('Applied Sciences', 'East Wing', 320000.00, 'Prof. Richard Feynman', '2015-01-10'),
('Biological Sciences', 'South Wing', 380000.00, 'Prof. Charles Darwin', '2016-03-22'),
('Architecture', 'West Wing', 550000.00, 'Prof. Zaha Hadid', '2017-08-15');

INSERT INTO faculty_members (family_name, given_name, official_email, contact_phone, dept_ref_id, start_date, monthly_pay, expertise_area) VALUES
('Khelifi', 'Yacine', 'y.khelifi@uni-tech.dz', '0661-001', 1, '2018-09-01', 8500.00, 'Machine Learning'),
('Brahimi', 'Nadia', 'n.brahimi@uni-tech.dz', '0661-002', 1, '2019-02-15', 8200.00, 'Cyber Security'),
('Mansouri', 'Karim', 'k.mansouri@uni-tech.dz', '0661-003', 1, '2020-10-10', 7800.00, 'Cloud Computing'),
('Saidi', 'Mounia', 'm.saidi@uni-tech.dz', '0661-004', 2, '2017-05-20', 9000.00, 'Mathematical Modeling'),
('Ouali', 'Reda', 'r.ouali@uni-tech.dz', '0661-005', 3, '2021-01-12', 7600.00, 'Genetics'),
('Haddad', 'Amel', 'a.haddad@uni-tech.dz', '0661-006', 4, '2022-04-01', 7900.00, 'Urban Design');

INSERT INTO enrolled_learners (id_card_no, surname, forename, birth_date, personal_email, mobile_no, residence_address, unit_link_id, study_stage, admission_date) VALUES
('L-2024-01', 'Belhadj', 'Omar', '2004-03-12', 'o.belhadj@email.com', '0770-111', 'Rue 1, Alger', 1, 'L3', '2023-09-15'),
('L-2024-02', 'Zemouri', 'Sonia', '2005-07-25', 's.zemouri@email.com', '0770-222', 'Rue 2, Blida', 1, 'L2', '2024-09-15'),
('L-2024-03', 'Ighil', 'Mehdi', '2002-11-05', 'm.ighil@email.com', '0770-333', 'Rue 3, Tipaza', 2, 'M1', '2023-09-15'),
('L-2024-04', 'Dahmani', 'Lydia', '2001-01-20', 'l.dahmani@email.com', '0770-444', 'Rue 4, Boumerdes', 3, 'M1', '2022-09-15'),
('L-2024-05', 'Amrani', 'Fouad', '2003-09-18', 'f.amrani@email.com', '0770-555', 'Rue 5, Medea', 4, 'L3', '2023-09-15'),
('L-2024-06', 'Bouzid', 'Ines', '2005-02-28', 'i.bouzid@email.com', '0770-666', 'Rue 6, Djelfa', 1, 'L2', '2024-09-15'),
('L-2024-07', 'Messaoudi', 'Adel', '2002-06-15', 'a.messaoudi@email.com', '0770-777', 'Rue 7, Chlef', 2, 'L3', '2023-09-15'),
('L-2024-08', 'Rahmani', 'Nadia', '2003-12-30', 'n.rahmani@email.com', '0770-888', 'Rue 8, Setif', 3, 'L3', '2023-09-15');

INSERT INTO academic_modules (module_ref, module_title, module_info, credit_value, term_no, unit_id_ref, instructor_id, seat_limit) VALUES
('IT101', 'Programming Basics', 'Python fundamentals', 6, 1, 1, 1, 60),
('IT202', 'Data Management', 'SQL and NoSQL systems', 5, 2, 1, 3, 45),
('SCI301', 'Complex Analysis', 'Mathematical theory', 6, 1, 2, 4, 25),
('BIO101', 'Cell Biology', 'Biological structures', 5, 1, 3, 5, 40),
('ARC201', 'History of Arch', 'Global architectures', 6, 2, 4, 6, 30),
('IT303', 'Deep Learning', 'Neural networks focus', 6, 1, 1, 1, 35),
('SCI101', 'Numerical Methods', 'Algorithmic math', 5, 2, 2, 4, 50);

INSERT INTO module_registrations (learner_ref_id, module_ref_id, session_year, outcome_status) VALUES
(1, 1, '2023-2024', 'Passed'),
(1, 2, '2024-2025', 'In Progress'),
(1, 6, '2024-2025', 'In Progress'),
(2, 1, '2024-2025', 'In Progress'),
(2, 2, '2024-2025', 'In Progress'),
(3, 3, '2023-2024', 'Passed'),
(3, 7, '2024-2025', 'In Progress'),
(4, 4, '2023-2024', 'Passed'),
(5, 5, '2023-2024', 'Passed'),
(6, 1, '2024-2025', 'In Progress'),
(7, 3, '2023-2024', 'Passed'),
(8, 4, '2023-2024', 'Passed'),
(1, 3, '2023-2024', 'Passed'),
(2, 7, '2024-2025', 'In Progress'),
(5, 2, '2024-2025', 'In Progress');

INSERT INTO performance_marks (reg_ref_id, assessment_kind, score_val, weight_factor, assessment_timestamp, feedback_notes) VALUES
(1, 'Exam', 16.25, 1.00, '2024-01-10', 'Very good'),
(6, 'Exam', 18.50, 1.00, '2024-01-10', 'Excellent work'),
(8, 'Exam', 13.75, 1.00, '2024-01-15', 'Above average'),
(9, 'Project', 15.00, 1.50, '2024-01-20', 'Solid design'),
(11, 'Lab', 17.50, 0.50, '2024-01-05', 'Precise results'),
(12, 'Exam', 10.50, 1.00, '2024-01-15', 'Barely passed'),
(13, 'Assignment', 19.00, 0.20, '2023-11-01', 'Top of class'),
(1, 'Lab', 15.00, 0.50, '2023-12-05', 'Consistent'),
(6, 'Project', 17.00, 1.00, '2023-12-10', 'Well presented'),
(8, 'Assignment', 14.50, 0.30, '2023-11-15', 'Good effort'),
(9, 'Exam', 16.00, 1.00, '2024-01-10', 'Strong results'),
(11, 'Exam', 15.25, 1.00, '2024-01-10', 'Well done');

-- Q1
SELECT surname, forename, personal_email, study_stage FROM enrolled_learners;

-- Q2
SELECT f.family_name, f.given_name, f.official_email, f.expertise_area 
FROM faculty_members f 
JOIN academic_units a ON f.dept_ref_id = a.unit_id 
WHERE a.unit_title = 'Information Technology';

-- Q3
SELECT module_ref, module_title, credit_value FROM academic_modules WHERE credit_value > 5;

-- Q4
SELECT id_card_no, surname, forename, personal_email FROM enrolled_learners WHERE study_stage = 'L3';

-- Q5
SELECT module_ref, module_title, credit_value, term_no FROM academic_modules WHERE term_no = 1;

-- Q6
SELECT m.module_ref, m.module_title, CONCAT(f.given_name, ' ', f.family_name) AS instructor 
FROM academic_modules m 
LEFT JOIN faculty_members f ON m.instructor_id = f.fac_id;

-- Q7
SELECT CONCAT(l.forename, ' ', l.surname) AS student, m.module_title, r.reg_timestamp, r.outcome_status 
FROM module_registrations r 
JOIN enrolled_learners l ON r.learner_ref_id = l.learner_id 
JOIN academic_modules m ON r.module_ref_id = m.module_id;

-- Q8
SELECT CONCAT(l.forename, ' ', l.surname) AS student, a.unit_title, l.study_stage 
FROM enrolled_learners l 
LEFT JOIN academic_units a ON l.unit_link_id = a.unit_id;

-- Q9
SELECT CONCAT(l.forename, ' ', l.surname) AS student, m.module_title, p.assessment_kind, p.score_val 
FROM performance_marks p 
JOIN module_registrations r ON p.reg_ref_id = r.reg_id 
JOIN enrolled_learners l ON r.learner_ref_id = l.learner_id 
JOIN academic_modules m ON r.module_ref_id = m.module_id;

-- Q10
SELECT CONCAT(f.given_name, ' ', f.family_name) AS faculty_name, COUNT(m.module_id) AS module_count 
FROM faculty_members f 
LEFT JOIN academic_modules m ON f.fac_id = m.instructor_id 
GROUP BY f.fac_id;

-- Q11
SELECT CONCAT(l.forename, ' ', l.surname) AS student, ROUND(AVG(p.score_val), 2) AS gpa 
FROM enrolled_learners l 
JOIN module_registrations r ON l.learner_id = r.learner_ref_id 
JOIN performance_marks p ON r.reg_id = p.reg_ref_id 
GROUP BY l.learner_id;

-- Q12
SELECT a.unit_title, COUNT(l.learner_id) AS enrollment_total 
FROM academic_units a 
LEFT JOIN enrolled_learners l ON a.unit_id = l.unit_link_id 
GROUP BY a.unit_id;

-- Q13
SELECT SUM(annual_funding) AS total_university_funding FROM academic_units;

-- Q14
SELECT a.unit_title, COUNT(m.module_id) AS total_modules 
FROM academic_units a 
LEFT JOIN academic_modules m ON a.unit_id = m.unit_id_ref 
GROUP BY a.unit_id;

-- Q15
SELECT a.unit_title, ROUND(AVG(f.monthly_pay), 2) AS mean_salary 
FROM academic_units a 
JOIN faculty_members f ON a.unit_id = f.dept_ref_id 
GROUP BY a.unit_id;

-- Q16
SELECT CONCAT(l.forename, ' ', l.surname) AS student, ROUND(AVG(p.score_val), 2) AS mean_score 
FROM enrolled_learners l 
JOIN module_registrations r ON l.learner_id = r.learner_ref_id 
JOIN performance_marks p ON r.reg_id = p.reg_ref_id 
GROUP BY l.learner_id 
ORDER BY mean_score DESC 
LIMIT 3;

-- Q17
SELECT module_ref, module_title 
FROM academic_modules 
WHERE module_id NOT IN (SELECT DISTINCT module_ref_id FROM module_registrations);

-- Q18
SELECT CONCAT(l.forename, ' ', l.surname) AS student, COUNT(r.reg_id) AS total_passed 
FROM enrolled_learners l 
JOIN module_registrations r ON l.learner_id = r.learner_ref_id 
WHERE l.learner_id NOT IN (SELECT learner_ref_id FROM module_registrations WHERE outcome_status != 'Passed')
GROUP BY l.learner_id;

-- Q19
SELECT CONCAT(f.given_name, ' ', f.family_name) AS instructor, COUNT(m.module_id) AS modules_assigned 
FROM faculty_members f 
JOIN academic_modules m ON f.fac_id = m.instructor_id 
GROUP BY f.fac_id 
HAVING modules_assigned > 2;

-- Q20
SELECT CONCAT(l.forename, ' ', l.surname) AS student, COUNT(r.reg_id) AS reg_count 
FROM enrolled_learners l 
JOIN module_registrations r ON l.learner_id = r.learner_ref_id 
GROUP BY l.learner_id 
HAVING reg_count > 2;

-- Q21
WITH LearnerStats AS (
    SELECT l.learner_id, l.unit_link_id, CONCAT(l.forename, ' ', l.surname) AS name, AVG(p.score_val) as personal_avg
    FROM enrolled_learners l
    JOIN module_registrations r ON l.learner_id = r.learner_ref_id
    JOIN performance_marks p ON r.reg_id = p.reg_ref_id
    GROUP BY l.learner_id
),
UnitStats AS (
    SELECT unit_link_id, AVG(score_val) as unit_avg
    FROM enrolled_learners l
    JOIN module_registrations r ON l.learner_id = r.learner_ref_id
    JOIN performance_marks p ON r.reg_id = p.reg_ref_id
    GROUP BY unit_link_id
)
SELECT ls.name, ROUND(ls.personal_avg, 2) AS personal_score, ROUND(us.unit_avg, 2) AS dept_benchmark
FROM LearnerStats ls
JOIN UnitStats us ON ls.unit_link_id = us.unit_link_id
WHERE ls.personal_avg > us.unit_avg;

-- Q22
SELECT m.module_title, COUNT(r.reg_id) AS current_regs 
FROM academic_modules m 
LEFT JOIN module_registrations r ON m.module_id = r.module_ref_id 
GROUP BY m.module_id 
HAVING current_regs > (
    SELECT AVG(counts) FROM (SELECT COUNT(reg_id) as counts FROM module_registrations GROUP BY module_ref_id) as stats
);

-- Q23
SELECT CONCAT(f.given_name, ' ', f.family_name) AS faculty, a.unit_title, a.annual_funding 
FROM faculty_members f 
JOIN academic_units a ON f.dept_ref_id = a.unit_id 
WHERE a.annual_funding = (SELECT MAX(annual_funding) FROM academic_units);

-- Q24
SELECT CONCAT(forename, ' ', surname) AS student, personal_email 
FROM enrolled_learners 
WHERE learner_id NOT IN (
    SELECT DISTINCT r.learner_ref_id 
    FROM module_registrations r 
    JOIN performance_marks p ON r.reg_id = p.reg_ref_id
);

-- Q25
SELECT a.unit_title, COUNT(l.learner_id) AS pop_count 
FROM academic_units a 
JOIN enrolled_learners l ON a.unit_id = l.unit_link_id 
GROUP BY a.unit_id 
HAVING pop_count > (
    SELECT AVG(counts) FROM (SELECT COUNT(learner_id) as counts FROM enrolled_learners GROUP BY unit_link_id) as stats
);

-- Q26
SELECT 
    m.module_title, 
    COUNT(p.mark_id) AS evaluations_total,
    SUM(CASE WHEN p.score_val >= 10 THEN 1 ELSE 0 END) AS successes,
    ROUND((SUM(CASE WHEN p.score_val >= 10 THEN 1 ELSE 0 END) / COUNT(p.mark_id)) * 100, 2) AS success_percentage
FROM academic_modules m
JOIN module_registrations r ON m.module_id = r.module_ref_id
JOIN performance_marks p ON r.reg_id = p.reg_ref_id
GROUP BY m.module_id;

-- Q27
SELECT 
    RANK() OVER (ORDER BY AVG(p.score_val) DESC) AS pos,
    CONCAT(l.forename, ' ', l.surname) AS student_name,
    ROUND(AVG(p.score_val), 2) AS cumulative_gpa
FROM enrolled_learners l
JOIN module_registrations r ON l.learner_id = r.learner_ref_id
JOIN performance_marks p ON r.reg_id = p.reg_ref_id
GROUP BY l.learner_id;

-- Q28
SELECT 
    m.module_title, 
    p.assessment_kind, 
    p.score_val, 
    p.weight_factor, 
    ROUND(p.score_val * p.weight_factor, 2) AS weighted_score
FROM performance_marks p
JOIN module_registrations r ON p.reg_ref_id = r.reg_id
JOIN academic_modules m ON r.module_ref_id = m.module_id
WHERE r.learner_ref_id = 1;

-- Q29
SELECT 
    CONCAT(f.given_name, ' ', f.family_name) AS instructor, 
    SUM(m.credit_value) AS credit_load
FROM faculty_members f
JOIN academic_modules m ON f.fac_id = m.instructor_id
GROUP BY f.fac_id;

-- Q30
SELECT 
    m.module_title, 
    COUNT(r.reg_id) AS enrolled, 
    m.seat_limit, 
    ROUND((COUNT(r.reg_id) / m.seat_limit) * 100, 2) AS occupancy_rate
FROM academic_modules m
LEFT JOIN module_registrations r ON m.module_id = r.module_ref_id
GROUP BY m.module_id
HAVING occupancy_rate > 80;
