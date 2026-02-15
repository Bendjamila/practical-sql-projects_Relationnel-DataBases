-- NOTE : we worked with SQLite

CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name TEXT NOT NULL,
    building        TEXT,
    budget          NUMERIC,
    department_head TEXT,
    creation_date   DATETIME
);

CREATE TABLE professors (
    professor_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name       TEXT NOT NULL,
    first_name      TEXT NOT NULL,
    email           TEXT UNIQUE NOT NULL,
    phone           TEXT,
    department_id   INTEGER REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    hire_date       DATETIME,
    salary          NUMERIC,
    specialization  TEXT
);

CREATE TABLE students (
    student_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number    TEXT UNIQUE NOT NULL,
    last_name         TEXT NOT NULL,
    first_name        TEXT NOT NULL,
    date_of_birth     DATETIME,
    email             TEXT UNIQUE NOT NULL,
    phone             TEXT,
    address           TEXT,
    department_id     INTEGER REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    level             TEXT CHECK (level IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    enrollment_date  DATETIME DEFAULT CURRENT_DATE
);

CREATE TABLE courses (
    course_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code     TEXT UNIQUE NOT NULL,
    course_name     TEXT NOT NULL,
    description     TEXT,
    credits         INTEGER NOT NULL CHECK (credits > 0),
    semester        INTEGER CHECK (semester IN (1, 2)),
    department_id   REFERENCES departments(department_id) ON DELETE SET NULL ON UPDATE CASCADE,
    professor_id    INTEGER REFERENCES professors(professor_id) ON DELETE SET NULL ON UPDATE CASCADE,
    max_capacity    INTEGER DEFAULT 30
);

CREATE TABLE enrollments (
    enrollment_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id        INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    course_id         INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    enrollment_date   TEXT DEFAULT CURRENT_DATE,
    academic_year     TEXT NOT NULL CHECK (
        academic_year GLOB '2[0-9][0-9][0-9]-2[0-9][0-9][0-9]'
        AND CAST(SUBSTR(academic_year, 6, 4) AS INTEGER) = CAST(SUBSTR(academic_year, 1, 4) AS INTEGER) + 1
    ),
    status            TEXT DEFAULT 'In Progress' CHECK (status IN ('In Progress', 'Passed', 'Failed', 'Dropped')),
    UNIQUE(student_id, course_id, academic_year)
);

CREATE TABLE grades (
    grade_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id     INTEGER NOT NULL REFERENCES enrollments(enrollment_id) ON UPDATE CASCADE ON DELETE CASCADE,
    evaluation_type   TEXT CHECK (evaluation_type IN ('Assignment', 'Lab', 'Exam', 'Project')),
    grade             NUMERIC CHECK (grade >= 0 AND grade <= 20),
    coefficient       NUMERIC DEFAULT 1,
    evaluation_date   DATETIME,
    comments          TEXT

);



CREATE INDEX idx_student_departement ON students(departement_id);

CREATE INDEX idx_course_professor ON courses(professor_id);

CREATE INDEX idx_enrollement_student ON enrollements(student_id);

CREATE INDEX idx_enrollement_course ON enrollemnents(course_id);

CREATE INDEX idx_grades_enrollement ON grades(enrollement_id);
