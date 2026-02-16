-- =============================================
-- TP1: University Management System - DATA
-- =============================================

USE university_db;

-- Departments
INSERT INTO departments (department_name, building, budget, department_head, creation_date) VALUES
('Computer Science', 'Building A', 500000.00, 'Dr. Mohammed Kara', '2010-09-01'),
('Mathematics', 'Building B', 350000.00, 'Dr. Fatima Snouci', '2009-09-01'),
('Physics', 'Building C', 400000.00, 'Dr. Hassan EL Arbi', '2010-09-01'),
('Civil Engineering', 'Building D', 600000.00, 'Dr. Nassima Tlemceni', '2011-09-01');

-- Professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
('Zeddoun', 'Aya', 'aya.zeddoun@univ.dz', '0661234567', 1, '2015-09-01', 15000.00, 'Artificial Intelligence'),
('El Hamri', 'Latifa', 'latifa.elhamri@univ.dz', '0794345678', 1, '2016-02-15', 14500.00, 'Database Systems'),
('Dollam', 'Raounak', 'raounak.dollam@univ.dz', '0663456789', 1, '2018-09-01', 13000.00, 'Web Development'),
('Asri', 'Youcef', 'youcef.asri@univ.dz', '0664567890', 2, '2014-09-01', 16000.00, 'Algebra'),
('Litir', 'Bahae', 'bahae.litir@univ.dz', '0765678901', 3, '2017-01-10', 14000.00, 'Quantum Physics'),
('Bendal', 'Yacine', 'yacine.bendal@univ.dz', '0566789012', 4, '2019-09-01', 15500.00, 'Structural Engineering');

-- Students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
('CS2023001', 'Zahraoui', 'Amine', '2003-05-12', 'amine.zahraoui@etu.univ.dz', '0671234567', 'Tlemcen', 1, 'L3', '2023-09-01'),
('CS2023002', 'Mansouri', 'Leila', '2004-03-08', 'leila.mansouri@etu.univ.dz', '0672345678', 'Oran', 1, 'L2', '2023-09-01'),
('MA2022001', 'Khalil', 'Sara', '2002-11-25', 'sara.khalil@etu.univ.dz', '0673456789', 'Ain Tmouchent', 2, 'M1', '2022-09-01'),
('PH2023001', 'Bennis', 'Mehdi', '2003-07-14', 'mehdi.bennis@etu.univ.dz', '0674567890', 'Alger', 3, 'L3', '2023-09-01'),
('CE2022001', 'Rachidi', 'Imane', '2002-01-30', 'imane.rachidi@etu.univ.dz', '0675678901', 'Tiaret', 4, 'M1', '2022-09-01'),
('CS2024001', 'Haddad', 'Yassine', '2004-09-22', 'yassine.haddad@etu.univ.dz', '0676789012', 'Oum Bouaki', 1, 'L2', '2024-09-01'),
('MA2023001', 'Lahlou', 'Nadia', '2003-12-05', 'nadia.lahlou@etu.univ.dz', '0677890123', 'Adrar', 2, 'L3', '2023-09-01'),
('PH2024001', 'Filali', 'Hamza', '2004-06-18', 'hamza.filali@etu.univ.dz', '0678901234', 'Remchi', 3, 'L2', '2024-09-01');

-- Courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
('CS301', 'Artificial Intelligence', 'Introduction to AI and Machine Learning', 6, 1, 1, 1, 40),
('CS302', 'Database Systems', 'Relational databases and SQL', 5, 1, 1, 2, 35),
('CS303', 'Web Development', 'HTML, CSS, JavaScript, PHP', 5, 2, 1, 3, 30),
('MA201', 'Linear Algebra', 'Matrices, vectors, and linear transformations', 6, 1, 2, 4, 40),
('PH301', 'Quantum Mechanics', 'Principles of quantum physics', 6, 1, 3, 5, 25),
('CE401', 'Structural Analysis', 'Analysis of building structures', 6, 2, 4, 6, 30),
('CS401', 'Advanced Algorithms', 'Algorithm design and optimization', 5, 2, 1, 1, 25);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
(1, 1, '2024-09-10', '2024-2025', 'In Progress'),
(1, 2, '2024-09-10', '2024-2025', 'In Progress'),
(1, 7, '2024-09-10', '2024-2025', 'In Progress'),
(2, 2, '2024-09-12', '2024-2025', 'In Progress'),
(2, 3, '2024-09-12', '2024-2025', 'In Progress'),
(3, 4, '2024-09-11', '2024-2025', 'Passed'),
(3, 1, '2023-09-15', '2023-2024', 'Passed'),
(4, 5, '2024-09-13', '2024-2025', 'In Progress'),
(4, 4, '2024-09-13', '2024-2025', 'In Progress'),
(5, 6, '2024-09-14', '2024-2025', 'In Progress'),
(6, 2, '2024-09-15', '2024-2025', 'In Progress'),
(6, 3, '2024-09-15', '2024-2025', 'Dropped'),
(7, 4, '2024-09-16', '2024-2025', 'In Progress'),
(8, 5, '2024-09-17', '2024-2025', 'In Progress'),
(8, 4, '2023-09-20', '2023-2024', 'Failed');

-- Grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Assignment', 15.50, 0.20, '2024-10-15', 'Good understanding of concepts'),
(1, 'Exam', 14.00, 0.60, '2024-12-20', 'Solid performance'),
(2, 'Lab', 16.00, 0.30, '2024-11-10', 'Excellent practical work'),
(2, 'Exam', 13.50, 0.50, '2024-12-18', 'Good theoretical knowledge'),
(4, 'Assignment', 12.00, 0.20, '2024-10-20', 'Needs improvement'),
(6, 'Exam', 17.00, 0.70, '2024-01-15', 'Outstanding'),
(7, 'Project', 18.00, 0.40, '2024-01-10', 'Excellent project'),
(8, 'Lab', 14.50, 0.30, '2024-11-25', 'Good lab skills'),
(10, 'Assignment', 15.00, 0.20, '2024-11-05', 'Very good work'),
(11, 'Lab', 13.00, 0.30, '2024-11-12', 'Average performance'),
(13, 'Exam', 16.50, 0.60, '2024-12-22', 'Very good understanding'),
(15, 'Exam', 8.00, 0.70, '2024-01-18', 'Needs to retake');

