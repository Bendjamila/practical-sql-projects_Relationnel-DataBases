PRAGMA foreign_keys = ON;


DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS departments
--------------------------------------------------
-- TABLE: departments
--------------------------------------------------
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name TEXT NOT NULL,
    building TEXT,
    budget DECIMAL(12,2),
    department_head TEXT,
    creation_date DATE
);


-- TABLE: professors
CREATE TABLE professors (
    professor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    department_id INTEGER,
    hire_date DATE,
    salary DECIMAL(10,2),
    specialization TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- TABLE: students

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    date_of_birth DATE,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    address TEXT,
    department_id INTEGER,
    level TEXT CHECK (level IN ('L1','L2','L3','M1','M2')),
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- TABLE: courses

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    course_name TEXT NOT NULL,
    description TEXT,
    credits INTEGER CHECK (credits > 0),
    semester INTEGER CHECK (semester BETWEEN 1 AND 2),
    department_id INTEGER,
    professor_id INTEGER,
    max_capacity INTEGER DEFAULT 30,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- TABLE: enrollments

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    academic_year TEXT NOT NULL,
    status TEXT DEFAULT 'In Progress' CHECK (status IN ('In Progress','Passed','Failed','Dropped')),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE (student_id, course_id, academic_year)
);


-- TABLE: grades

CREATE TABLE grades (
    grade_id INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER NOT NULL,
    evaluation_type TEXT CHECK (evaluation_type IN ('Assignment','Lab','Exam','Project')),
    grade DECIMAL(5,2) CHECK (grade BETWEEN 0 AND 20),
    coefficient DECIMAL(3,2) DEFAULT 1.00,
    evaluation_date DATE,
    comments TEXT,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- INDEXES

CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_professor ON courses(professor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grades_enrollment ON grades(enrollment_id);


-- INSERT DATA

-- Departments
INSERT INTO departments (department_name, building, budget) VALUES
('Computer Science','A',500000),
('Mathematics','B',350000),
('Physics','C',400000),
('Civil Engineering','D',600000);

-- Professors
INSERT INTO professors (last_name, first_name, email, department_id, salary, specialization) VALUES
('Smith','John','jsmith@uni.com',1,6000,'AI'),
('Brown','Alice','abrown@uni.com',1,5800,'Databases'),
('Taylor','Mark','mtaylor@uni.com',1,6200,'Networks'),
('Green','Laura','lgreen@uni.com',2,5500,'Algebra'),
('White','Tom','twhite@uni.com',3,5700,'Quantum Physics'),
('Black','Emma','eblack@uni.com',4,5900,'Structures');

-- Students
INSERT INTO students (student_number,last_name,first_name,email,department_id,level) VALUES
('S001','Doe','Anna','anna@uni.com',1,'L3'),
('S002','Lee','Paul','paul@uni.com',1,'L2'),
('S003','Kim','Sara','sara@uni.com',2,'M1'),
('S004','Ali','Omar','omar@uni.com',3,'L3'),
('S005','Ben','Lina','lina@uni.com',4,'M1'),
('S006','Ng','Eva','eva@uni.com',1,'L3'),
('S007','Zed','Yassine','yas@uni.com',2,'L2'),
('S008','Amr','Nour','nour@uni.com',3,'M1');

-- Courses
INSERT INTO courses (course_code,course_name,credits,semester,department_id,professor_id,max_capacity) VALUES
('CS101','Programming',6,1,1,1,40),
('CS102','Databases',6,2,1,2,30),
('CS103','Networks',5,1,1,3,25),
('MA101','Algebra',5,1,2,4,30),
('PH101','Physics I',6,2,3,5,35),
('CE101','Statics',6,1,4,6,30),
('CE102','Structures',5,2,4,6,25);

-- Enrollments 
INSERT INTO enrollments (student_id,course_id,academic_year,status) VALUES
(1,1,'2024-2025','Passed'),
(1,2,'2024-2025','Passed'),
(1,3,'2024-2025','Passed'),
(2,1,'2024-2025','In Progress'),
(2,2,'2024-2025','Passed'),
(3,4,'2024-2025','Passed'),
(3,1,'2024-2025','Passed'),
(4,5,'2024-2025','Failed'),
(4,1,'2024-2025','Passed'),
(5,6,'2024-2025','Passed'),
(5,7,'2024-2025','Passed'),
(6,1,'2024-2025','Passed'),
(6,2,'2024-2025','In Progress'),
(7,4,'2024-2025','Passed'),
(8,5,'2024-2025','Passed');

-- Grades 
INSERT INTO grades (enrollment_id,evaluation_type,grade,coefficient) VALUES
(1,'Exam',15,1),
(2,'Exam',14,1),
(3,'Exam',16,1),
(4,'Exam',12,1),
(5,'Exam',13,1),
(6,'Exam',17,1),
(7,'Exam',14,1),
(8,'Exam',9,1),
(9,'Exam',15,1),
(10,'Exam',16,1),
(11,'Exam',18,1),
(12,'Exam',14,1);
--
