DESCRIBE departments;
DROP TABLE students;
show tables;
use university_db;
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization VARCHAR(100),

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    department_id INT,
    level VARCHAR(20),
   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    CHECK (level IN ('L1','L2','L3','M1','M2')),

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    semester INT,
    department_id INT,
    professor_id INT,
    max_capacity INT DEFAULT 30,

    CHECK (credits > 0),
    CHECK (semester BETWEEN 1 AND 2),

    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    academic_year VARCHAR(9) NOT NULL,
    status VARCHAR(20) DEFAULT 'In Progress',

    CHECK (status IN ('In Progress','Passed','Failed','Dropped')),

    UNIQUE (student_id, course_id, academic_year),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    evaluation_type VARCHAR(30),
    grade DECIMAL(5,2),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,

    CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    CHECK (grade BETWEEN 0 AND 20),

    FOREIGN KEY (enrollment_id)
        REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);
INSERT INTO departments (department_name, building, budget)
VALUES
('Computer Science', 'Building A', 500000),
('Mathematics', 'Building B', 350000),
('Physics', 'Building C', 400000),
('Civil Engineering', 'Building D', 600000);

INSERT INTO professors (last_name, first_name, email, department_id, salary)
VALUES
('Djamila', 'Bendouda', 'djamila.bendouda@ensta.edu.dz', 1, 60000),
('keira', 'lakhdari', 'keira.lakhdari@ensta.edu.dz', 1, 65000),
('abdelkader', 'belahcene', 'abdelkader.belahcene@ensta.edu.dz', 1, 70000),
('leila', 'ghomari', 'leila.ghomari@ensta.edu.dz', 4, 75000),
('mohammed', 'elaroussi', 'mohammed.elaroussi@ensta.edu.dz', 1, 60000),
('halim', 'chouabia', 'halim.chouabia@ensta.edu.dz', 1, 50000);

INSERT INTO students (student_number, last_name, first_name, email, department_id, level)
VALUES
('232334202915','Madjeda','BOUAKKAZ','am.bouakkaz@ensta.edu.dz',1,'L1'),
('232334251748','Manal','BOUTRIA','am.boutria@ensta.edu.dz',1,'L1'),
('202425146879','Zara','Lina','@ensta.edu.dz',2,'M1'),
('202451785995','Omar','Said','said@ensta.edu.dz',3,'M2'),
('202214569872','Amine','Rami','rami@ensta.edu.dz',4,'L2'),
('202334521547','Salma','Nour','nour@ensta.edu.dz',1,'L1'),
('202214536987','Yassine','Farid','farid@ensta.edu.dz',2,'L2'),
('202545369871','Hana','Imen','imen@ensta.edu.dz',3,'M1'),
('212120145786','Safa','Saida','sa.safa@ensta.edu.dz',2,'L3');

INSERT INTO courses 
(course_code, course_name, description, credits, semester, department_id, professor_id)
VALUES
('CS101', 'Advanced Databases', 
 'Study of advanced database concepts including optimization, transactions, and distributed databases', 
 6, 1, 1, 26),

('CS102', 'Data Analysis and Data Science', 
 'Introduction to data analysis techniques, statistics, and practical data science tools', 
 6, 2, 1, 27),

('CS103', 'Network Foundation 2', 
 'In-depth study of network protocols, routing, switching, and modern communication technologies', 
 5, 1, 1, 28),

('CS104', 'Graphs and Network Optimization', 
 'Mathematical modeling of networks and algorithms for optimization and graph theory applications', 
 5, 2, 1, 30),

('CS105', 'Network Foundation 2 Lab', 
 'Practical laboratory sessions applying network configuration and troubleshooting techniques', 
 6, 1, 1, 31),

('CE101', 'Industrial Engineering and Maintenance', 
 'Concepts of industrial systems, maintenance strategies, and engineering management', 
 6, 1, 4, 29),

('CS106', 'Project Management', 
 'Methods and tools for managing software and engineering projects effectively', 
 5, 2, 1, 27);
 
INSERT INTO enrollments (enrollment_id, student_id, course_id, created_at, academic_year, status) VALUES
(1, 25, 1, NOW(), 2025, 'Enrolled'),
(2, 25, 2, NOW(), 2025, 'Enrolled'),
(3, 26, 1, NOW(), 2024, 'Completed'),
(4, 26, 3, NOW(), 2025, 'Enrolled'),
(5, 27, 4, NOW(), 2025, 'Enrolled'),
(6, 28, 1, NOW(), 2025, 'Enrolled'),
(7, 28, 5, NOW(), 2024, 'Completed'),
(8, 29, 3, NOW(), 2025, 'Enrolled'),
(9, 30, 2, NOW(), 2024, 'Completed'),
(10, 31, 5, NOW(), 2025, 'Enrolled'),
(11, 31, 4, NOW(), 2025, 'Enrolled'),
(12, 30, 1, NOW(), 2025, 'Enrolled'),
(13, 32, 3, NOW(), 2024, 'Completed'),
(14, 32, 5, NOW(), 2025, 'Enrolled'),
(15, 26, 2, NOW(), 2025, 'Enrolled');

INSERT INTO grades (enrollment_id, evaluation_type, grade, coefficient, evaluation_date, comments) VALUES
(1, 'Assignment', 15.50, 1.00, '2025-02-01', 'Good work'),
(1, 'Lab', 16.00, 0.75, '2025-02-05', 'Well done'),
(2, 'Exam', 12.50, 2.00, '2025-03-01', 'Needs improvement'),
(2, 'Project', 17.00, 1.50, '2025-03-10', 'Excellent'),
(3, 'Assignment', 14.00, 1.00, '2024-11-15', 'Satisfactory'),
(3, 'Lab', 13.50, 0.50, '2024-11-20', 'Could do better'),
(4, 'Exam', 18.00, 2.00, '2025-01-30', 'Perfect score'),
(5, 'Project', 16.50, 1.25, '2025-02-12', 'Well executed'),
(6, 'Assignment', 10.50, 1.00, '2025-02-18', 'Barely passed'),
(7, 'Lab', 12.00, 0.75, '2025-02-22', 'Needs more practice'),
(8, 'Exam', 15.00, 2.00, '2024-12-05', 'Good effort'),
(9, 'Project', 17.50, 1.50, '2024-12-15', 'Very good project');

SHOW CREATE TABLE enrollments;
ALTER TABLE enrollments
DROP CHECK enrollments_chk_1;

ALTER TABLE enrollments
ADD CONSTRAINT enrollments_chk_1
CHECK (status IN ('Enrolled', 'Completed'));
ALTER TABLE enrollments
DROP CHECK enrollments_chk_1;
ALTER TABLE enrollments;

SELECT * FROM students;
SELECT * FROM professors;
SELECT * FROM enrollments;
SELECT * FROM grades;
SELECT * FROM courses;
SELECT * FROM departments;



