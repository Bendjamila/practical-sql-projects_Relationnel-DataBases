--departements
INSERT INTO departments (department_name, building, budget, departmnt_head, creation_date) VALUES
  ('Computer Science', 'Building A', 500000, 'Mr. NESRAOUI', '15-06-2023'),
  ('Mathematics', 'Building B', 350000, 'Mrs. MEGUEDMI', '03-05-2013'),
  ('Physics', 'Building C', 400000, 'Mr. MOUGARI', '13-07-2010'),
  ('Civil Engineering', 'Building D', 600000, 'Mrs. FERHAH', '29-08-2011');



--professors
INSERT INTO professors (last_name, first_name, email, phone, department_id, hire_date, salary, specialization) VALUES
  ('Djamila', 'BENDOUDA', 'djamila.bendouda@ensta.edu.dz', '1234567890', 1,'12-10-2015', 120000, 'Database'),
  ('Kheira', 'LAKHDARI', 'kheira.lakhdari@ensta.edu.dz', '9012345678', 1,'03-05-2022', 100000, 'Data Sience'),
  ('Amina Fatima Zohra', 'MEDJAHED', 'amina.medjahed@ensta.edu.dz', '8901234567', 1,'25-08-2025', 80000, 'AI'),
  ('Yacine', 'BRIEDJ', 'yacine.briedj@ensta.edu.dz', '7890123456', 2,'14-09-2024', 90000, 'Algebra'),
  ('Meriem', 'MEZERDI', 'meriem.mezerdi@ensta.edu.dz', '6789012345', 3,'27-06-2016', 110000, 'Analysis'),
  ('Adel', 'BOUCETTA', 'adel.boucetta@ensta.edu.dz', '56789011234', 4,'07-10-2024', 80000, 'Statistics');



--students
INSERT INTO students (student_number, last_name, first_name, date_of_birth, email, phone, address, department_id, level, enrollment_date) VALUES
  ('232335678904', 'Zhour', 'SACI', '10-10-2004', 'az.saci@ensta.edu.dz', '0123456789', 'batna-algeria', 1, 'L3', '26-08-2023'),
  ('232367930261', 'Jazia', 'ABDELKRIM', '03-04-2005', 'aj.abdelkrim@ensta.edu.dz', '9012345678', 'bousaada-algeria', 1, 'L3', '06-08-2023'),
  ('222282905539', 'Aya', 'ZEDDOUN', '23-7-2002', 'aa.zeddouni@ensta.edu.dz', '8901234567', 'telemcen-algeria', 3, 'M1', '14-08-2022'),
  ('242489876324', 'Raounak', 'DJEBIR', '05-08-2005', 'ar.djebiri@ensta.edu.dz', '7890123456', 'oum elbouaghi-algeria', 2, 'L2', '10-08-2024'),
  ('252534261843', 'Sara', 'ARZIM', '17-10-2005', 'as.arzim@ensta.edu.dz', '6789012345', 'algiers-algeria', 2, 'L1', '24-08-2025'),
  ('242499226735', 'Rym', 'MALEK', '19-03-2006', 'ar.maleki@ensta.edu.dz', '5678901234', 'algiers-algeria', 4, 'L2', '03-08-2024'),
  ('212193683483', 'Amel', 'BOUTERBAG', '30-01-2005', 'aa.bouterbag@ensta.edu.dz', '4567890123', 'telemcen-algeria', 1, 'M2', '27-08-2021'),
  ('212112351731', 'Lina', 'DJEDAI', '03-05-2006', 'al.djedai@ensta.edu.dz', '3456789012', 'ouargla-algeria',1, 'M2', '18-08-2021');



--courses
INSERT INTO courses (course_code, course_name, description, credits, semester, department_id, professor_id, max_capacity) VALUES
  ('CS101', 'ADB', 'Advanced Databases', 5, 2, 1, 1, 70),
  ('CS102', 'DAS', 'Data Analysis & Data Scinece', 6, 1, 1, 2, 150),
  ('CS103', 'AI', 'Introduction to Artificial Intelligence', 5, 1, 1, 3, 85),
  ('M101', 'ALG1', 'Algebra', 6, 1, 2, 4, 120),
  ('M102', 'LOG', 'Mathematical Logic', 5, 2, 2, 4, 130),
  ('ST101', 'ANA', 'Mathematical Analysis', 6, 1, 3, 5, 50),
  ('ST102', 'PRST', 'Probabilities & Statistics', 5, 2, 2, 6, 100);



--enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, status) VALUES
  (1, 1, '13-01-2026', '2025-2026', 'In Progress'),
  (1, 2, '27-09-2025', '2025-2026', 'Passed'),
  (8, 3, '29-09-2025', '2024-2025', 'Passed'),
  (2, 4, '07-09-2025', '2025-2026', 'In Progress'),
  (2, 5, '13-01-2026', '2024-2025', 'Dropped'),
  (3, 6, '13-01-2026', '2021-2022', 'Failed'),
  (3, 7, '27-09-2025', '2025-2026', 'Passed'),
  (8, 6, '22-10-2025', '2024-2025', 'Passed'),
  (4, 4, '07-09-2025', '2025-2026', 'Failed'),
  (5, 5, '13-01-2026', '2022-2023', 'Dropped'),
  (5, 1, '13-01-2026', '2025-2026', 'In Progress'),
  (6, 2, '27-09-2025', '2025-2026', 'Passed'),
  (6, 6, '29-09-2025', '2021-2022', 'Passed'),
  (7, 7, '07-09-2025', '2025-2026', 'In Progress'),
  (7, 5, '13-01-2026', '2025-2026', 'Dropped');



--grades
INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date) VALUES
  (1, 'Assignment', 16, 4, '25-1-2026'),
  (2, 'Assignment', 13, 5, '17-1-2026'),
  (3, 'Assignment', 18, 6, '07-1-2026'),
  (4, 'Lab', 15, 4, '12-10-2025'),
  (5, 'Lab', 17, 4, '06-11-2025'),
  (6, 'Lab', 12, 6, '28-09-2026'),
  (7, 'Exam', 18, 5, '16-2-2026'),
  (8, 'Exam', 10, 3, '10-2-2026'),
  (9, 'Exam', 14, 4, '29-1-2026'),
  (10, 'Project', 16, 5, '31-1-2026'),
  (11, 'Project', 15, 6, '24-1-2026'),
  (12, 'Project', 17, 3, '18-12-2025');
