-- DEPARTMENTS DATA
INSERT INTO departments (department_id, department_name, building, budget, department_head, creation_date)
VALUES 
(1,'Computer Science', 'Building A', 500000, 'Mr Nesraoui', '2010-09-01'),
(2,'Mathematics', 'Building B', 350000, 'Mr Ahmed', '2011-09-01'),
(3,'Physics', 'Building C', 400000, 'Mme Cheggou', '2012-09-01'),
(4,'Civil Engineering', 'Building D', 600000, 'Mr Benabdellah', '2013-09-01');

-- PROFESSORS DATA
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization)
VALUES
('Ghoumari', 'Leila', 'leila.ghoumari@ensta.edu.dz', '123456789', 1, '2010-09-01', 60000, 'Software Engineering'),
('Breidj', 'Yacine', 'breidj.yacine@ensta.edu.dz', '987654321', 2, '2011-09-01', 55000, 'Linear Algebra'),
('Lakhdari', 'Keira', 'lakhdari.keira@ensta.edu.dz', '234567890', 1, '2012-01-15', 55000, 'AI'),
('Bendouda', 'Djamila', 'bendouda.djamila@ensta.edu.dz', '345678901', 1, '2015-03-10', 50000, 'Databases'),
('Taflis', 'Mohammed', 'mohammed.taflis@ensta.edu.dz', '456789012', 2, '2011-07-20', 52000, 'Analysis'),
('Cheggou', 'Rabia', 'rabia.cheggou@ensta.edu.dz', '567890123', 3, '2013-05-05', 53000, 'Electronics'),
('Kherroubi', 'Souad', 'souad.kherroubi@ensta.edu.dz', '678901234', 4, '2014-08-12', 56000, 'Structural Engineering');

-- STUDENTS DATA
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date)
VALUES
('S1001', 'Allag', 'Abdelwadoud', '2007-01-25', 'ba.allag@ensta.edu.dz', '0559297089', 'Blida', 3, 'L2', '2025-09-01'),
('S1002', 'Hadj', 'Soundous', '2005-11-16', 'as.hadj@ensta.edu.dz', '0776090995', 'Batna', 1, 'L3', '2025-09-01'),
('S1003', 'Hammouti', 'Walid', '2005-05-05', 'aw.hammouti@ensta.edu.dz', '0562265767', 'Ain Temouchent', 1, 'L3', '2025-09-01'),
('S1004', 'Boucherit', 'Imene', '2003-10-06', 'bi.boucherit@ensta.edu.dz', '0554334230', 'Alger', 4, 'M1', '2025-09-01'),
('S1005','Harizi','Raounek','2005-02-19','ar.harizi@ensta.edu.dz','066335964','Annaba', 1,'L3','2025-09-01'),
('S1006','Berouakene','Hichem','2004-08-08','hb.berouakene@ensta.edu.dz','055382664','Alger', 3,'M2','2025-09-01'),
('S1007', 'Benloulou', 'Nadjah', '2006-11-24', 'nb.benloulou@ensta.edu.dz', '0557106142', 'Alger', 4, 'L2', '2025-09-01'),
('S1008', 'Naceri', 'Rim Serine', '2005-03-27', 'as.naceri@ensta.edu.dz', '0558841341', 'Biskra', 4, 'M1','2025-09-01');

-- COURSES DATA
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity)
VALUES
('CS101', 'Intro to Programming', 'Learn basics of programming', 6, 1, 1, 1, 30),
('CS201', 'Data Structures', 'Intermediate programming concepts', 5, 2, 1, 3, 30),
('CS301', 'Databases', 'Database design and SQL', 6, 1, 1, 4, 25),
('MATH101', 'Calculus I', 'Differential calculus', 5, 1, 2, 2, 40),
('PHYS101', 'Physics I', 'Mechanics', 5, 1, 3, 6, 35),
('CE101', 'Statics', 'Engineering statics', 6, 2, 4, 7, 30),
('AI401', 'AI Basics', 'Introduction to AI', 6, 2, 1, 3, 20);

-- ENROLLMENTS DATA
INSERT INTO enrollments (student_id, course_id, academic_year, status)
VALUES
(1, 1, '2025-2026', 'In Progress'),
(1, 2, '2025-2026', 'In Progress'),
(2, 1, '2025-2026', 'Passed'),
(2, 3, '2025-2026', 'In Progress'),
(3, 4, '2025-2026', 'Passed'),
(4, 4, '2025-2026', 'In Progress'),
(5, 5, '2025-2026', 'In Progress'),
(6, 5, '2025-2026', 'Passed'),
(7, 6, '2025-2026', 'In Progress'),
(8, 6, '2025-2026', 'In Progress'),
(3, 2, '2025-2026', 'In Progress'),
(4, 3, '2025-2026', 'In Progress'),
(5, 1, '2025-2026', 'In Progress'),
(6, 2, '2025-2026', 'In Progress'),
(7, 7, '2025-2026', 'In Progress');

-- GRADES DATA
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date)
VALUES
(1, 'Exam', 15, 1, '2026-01-15'),
(2, 'Project', 14, 1.5, '2026-01-20'),
(3, 'Exam', 18, 1, '2026-01-10'),
(4, 'Assignment', 16, 0.5, '2026-01-12'),
(5, 'Lab', 12, 1, '2026-01-18'),
(6, 'Exam', 17, 1, '2026-01-22'),
(7, 'Project', 11, 1, '2026-01-25'),
(8, 'Assignment', 13, 0.5, '2026-01-28'),
(9, 'Lab', 14, 1, '2026-01-30'),
(10, 'Exam', 15, 1, '2026-01-30'),
(11, 'Assignment', 16, 1, '2026-02-01'),
(12, 'Lab', 14, 1, '2026-02-02');
