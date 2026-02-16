
-- use the command "cat AI/benchenina_souhaib/tp1_solution.sql | ./sqlite3 dbtp.db" in the terminal to creat the tables of the first exercice

-- making the skema first


CREATE TABLE Professors (
    professor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department TEXT
);


CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE,
    enrollment_date DATE DEFAULT CURRENT_DATE
);


CREATE TABLE Courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_name TEXT NOT NULL,
    credits INTEGER CHECK (credits > 0),
    professor_id INTEGER,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);


CREATE TABLE Enrollments (
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    course_id INTEGER,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);


CREATE TABLE Grades (
    grade_id INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER,
    score REAL CHECK (score >= 0 AND score <= 20),
    term TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);


-- putting in all the people now


-- insterting the 6 techers 
INSERT INTO Professors (first_name, last_name, department) VALUES 
('Ahmed', 'Mansour', 'Computer Science'), 
('Fatima', 'Zahra', 'Mathematics'), 
('Omar', 'Al-Fayed', 'Physics'), 
('Layla', 'Hassan', 'Computer Science'), 
('Youssef', 'Berrada', 'Engineering'), 
('Amira', 'Said', 'Mathematics');


-- adding the 8 stundents
INSERT INTO Students (first_name, last_name, email) VALUES 
('Yassine', 'Idrissi', 'yassine@univ.ma'), 
('Khadija', 'Amrani', 'khadija@univ.ma'), 
('Mustafa', 'Alami', 'mustafa@univ.ma'), 
('Sanaa', 'Tazi', 'sanaa@univ.ma'), 
('Hamza', 'Bennis', 'hamza@univ.ma'), 
('Zineb', 'Toumi', 'zineb@univ.ma'), 
('Walid', 'Kabbaj', 'walid@univ.ma'), 
('Meryem', 'Fassi', 'meryem@univ.ma');



-- the 7 lessons
INSERT INTO Courses (course_name, credits, professor_id) VALUES 
('Database Systems', 4, 1), 
('Calculus I', 3, 2), 
('Quantum Physics', 4, 3), 
('Software Engineering', 4, 4), 
('Data Structures', 4, 1), 
('Linear Algebra', 3, 6), 
('Thermodynamics', 3, 5);


-- the 15 signs ups
INSERT INTO Enrollments (student_id, course_id) VALUES 
(1,1), (1,2), (2,1), (2,4), (3,1), (3,5), (4,2), (4,3), (5,4), (5,5), (6,6), (6,7), (7,1), (8,2), (8,7);


-- lastly the 12 marks
INSERT INTO Grades (enrollment_id, score, term) VALUES 
(1, 18.5, 'Fall'), (2, 14.0, 'Fall'), (3, 16.0, 'Fall'), (4, 12.5, 'Fall'), 
(5, 19.0, 'Fall'), (6, 15.5, 'Fall'), (7, 13.0, 'Fall'), (8, 17.5, 'Fall'), 
(9, 11.0, 'Fall'), (10, 14.5, 'Fall'), (11, 16.5, 'Fall'), (12, 18.0, 'Fall');



-- here are the 30 quaries


-- just basic ones first
SELECT * FROM Students;

SELECT first_name, last_name FROM Professors;

SELECT course_name, credits FROM Courses WHERE credits > 3;

SELECT * FROM Students WHERE enrollment_date > '2024-01-01';

SELECT DISTINCT department FROM Professors;



-- joining tables together
SELECT s.first_name, c.course_name FROM Students s JOIN Enrollments e ON s.student_id = e.student_id JOIN Courses c ON e.course_id = c.course_id;

SELECT c.course_name, p.last_name FROM Courses c JOIN Professors p ON c.professor_id = p.professor_id;

SELECT s.first_name, g.score FROM Students s JOIN Enrollments e ON s.student_id = e.student_id JOIN Grades g ON e.enrollment_id = g.enrollment_id;

SELECT p.first_name, c.course_name FROM Professors p LEFT JOIN Courses c ON p.professor_id = c.professor_id;

SELECT s.first_name, s.last_name, c.course_name, g.score FROM Students s JOIN Enrollments e ON s.student_id = e.student_id JOIN Courses c ON e.course_id = c.course_id JOIN Grades g ON e.enrollment_id = g.enrollment_id;



-- maths and counting
SELECT AVG(score) FROM Grades;

SELECT COUNT(*) FROM Students;
SELECT department, COUNT(*) FROM Professors GROUP BY department;

SELECT course_id, COUNT(*) FROM Enrollments GROUP BY course_id;

SELECT MAX(score) FROM Grades;


-- sorting and filters
SELECT * FROM Students ORDER BY last_name ASC;

SELECT * FROM Courses WHERE credits BETWEEN 3 AND 4;

SELECT * FROM Students WHERE email LIKE '%@univ.ma';

SELECT * FROM Grades WHERE score >= 10;
SELECT student_id, COUNT(*) FROM Enrollments GROUP BY student_id HAVING COUNT(*) > 1;



-- fancy subquaries
SELECT * FROM Students WHERE student_id IN (SELECT student_id FROM Enrollments WHERE course_id = 1);

SELECT * FROM Courses WHERE professor_id = (SELECT professor_id FROM Professors WHERE last_name = 'Mansour');

SELECT first_name FROM Students WHERE student_id IN (SELECT student_id FROM Enrollments JOIN Grades USING(enrollment_id) WHERE score > 16);

SELECT * FROM Professors WHERE professor_id NOT IN (SELECT professor_id FROM Courses);

SELECT course_name FROM Courses WHERE credits = (SELECT MAX(credits) FROM Courses);


-- bits and bobs at the end
UPDATE Grades SET score = 20 WHERE score > 19;
SELECT s.first_name, AVG(g.score) FROM Students s JOIN Enrollments e ON s.student_id = e.student_id JOIN Grades g ON e.enrollment_id = g.enrollment_id GROUP BY s.student_id;

SELECT term, COUNT(*) FROM Grades GROUP BY term;

SELECT * FROM Students WHERE student_id NOT IN (SELECT student_id FROM Enrollments);

SELECT department FROM Professors GROUP BY department HAVING COUNT(*) > 1;