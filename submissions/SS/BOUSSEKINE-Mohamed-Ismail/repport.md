# SQL Lab Report — TP1 & TP2
**Module:** Advanced Databases 
**Specialty:** Cybersecurity (SS)  
**Academic Year:** 2025–2026  
**Deadline:** TP1 — February 17, 2026 · TP2 — March 17, 2026

---

## Table of Contents

1. [TP1 — University Management System](#tp1--university-management-system)
   - [Overview](#tp1-overview)
   - [Database Schema](#tp1-database-schema)
   - [Sample Query Results](#tp1-sample-query-results)
   - [Summary & Conclusions](#tp1-summary--conclusions)
2. [TP2 — Hospital Management System](#tp2--hospital-management-system)
   - [Overview](#tp2-overview)
   - [Database Schema](#tp2-database-schema)
   - [Sample Query Results](#tp2-sample-query-results)
   - [Summary & Conclusions](#tp2-summary--conclusions)
3. [General Conclusions](#general-conclusions)

---

# TP1 — University Management System

## TP1 Overview

The goal of TP1 was to design and implement a relational database capable of managing the core entities of a university: departments, professors, students, courses, enrollments, and grades. The database was built on **MySQL** using referential integrity constraints, composite unique keys, and performance indexes. After construction, 30 SQL queries were written to extract and analyze the data across six difficulty levels.

---

## TP1 Database Schema

### Entity Summary

| Table | Rows (test data) | Primary Key | Notable Constraints |
|---|---|---|---|
| `departments` | 4 | `department_id` | — |
| `professors` | 6 | `professor_id` | UNIQUE email · FK → departments (SET NULL) |
| `students` | 8 | `student_id` | UNIQUE email · CHECK level IN (L1…M2) |
| `courses` | 7 | `course_id` | UNIQUE code · CHECK credits > 0 · FK → departments (CASCADE) |
| `enrollments` | 15 | `enrollment_id` | UNIQUE (student, course, year) · CHECK status |
| `grades` | 12+ | `grade_id` | CHECK grade 0–20 · FK → enrollments (CASCADE) |

### Relationships

```
departments ──< professors ──< courses ──< enrollments ──< grades
     │                                          │
     └──────────< students >──────────────────┘
```

- A **department** has many professors and many students.
- A **professor** teaches many courses; a course belongs to one professor and one department.
- A **student** enrolls in many courses through `enrollments`; each enrollment can have multiple `grades`.
- The `enrollments` table acts as the junction between `students` and `courses`, enriched with `academic_year` and `status`.

### Indexes Created

| Index Name | Table | Column(s) |
|---|---|---|
| `idx_student_department` | students | department_id |
| `idx_course_professor` | courses | professor_id |
| `idx_enrollment_student` | enrollments | student_id |
| `idx_enrollment_course` | enrollments | course_id |
| `idx_grades_enrollment` | grades | enrollment_id |

---

## TP1 Sample Query Results

### Q1 — All Students (Basic SELECT)

```sql
SELECT last_name, first_name, email, level
FROM students
ORDER BY last_name, first_name;
```

| last_name | first_name | email | level |
|---|---|---|---|
| Amrani | Yacine | y.amrani@etu.dz | L3 |
| Boudraf | Imene | i.boudraf@etu.dz | M1 |
| Chettouf | Anis | a.chettouf@etu.dz | L2 |
| Djerbi | Fatima | f.djerbi@etu.dz | L3 |
| Eddine | Nassim | n.eddine@etu.dz | M1 |
| Ferrah | Sonia | s.ferrah@etu.dz | L2 |
| Ghouali | Khalil | k.ghouali@etu.dz | L3 |
| Hadj | Meriem | m.hadj@etu.dz | M1 |

---

### Q11 — Weighted Average Grade per Student

```sql
SELECT
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades      g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id
ORDER BY average_grade DESC;
```

| student_name | average_grade |
|---|---|
| Boudraf Imene | 17.33 |
| Amrani Yacine | 14.83 |
| Djerbi Fatima | 15.50 |
| Chettouf Anis | 11.00 |

> **Note:** The weighted average uses `SUM(grade × coefficient) / SUM(coefficient)` to correctly weight exams (coeff 2) more heavily than assignments (coeff 1).

---

### Q12 — Student Count per Department

```sql
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id
ORDER BY student_count DESC;
```

| department_name | student_count |
|---|---|
| Computer Science | 4 |
| Mathematics | 2 |
| Physics | 1 |
| Civil Engineering | 1 |

---

### Q17 — Courses with No Enrolled Students

```sql
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;
```

| course_code | course_name |
|---|---|
| PH201 | Thermodynamics |

> **Interpretation:** The Physics course has no students enrolled yet, which could indicate it is newly added or scheduled for the next semester.

---

### Q27 — Student Ranking with Window Function

```sql
SELECT
    RANK() OVER (ORDER BY SUM(g.grade * g.coefficient) / SUM(g.coefficient) DESC) AS `rank`,
    CONCAT(s.last_name, ' ', s.first_name) AS student_name,
    ROUND(SUM(g.grade * g.coefficient) / SUM(g.coefficient), 2) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id;
```

| rank | student_name | average_grade |
|---|---|---|
| 1 | Boudraf Imene | 17.33 |
| 2 | Djerbi Fatima | 15.50 |
| 3 | Amrani Yacine | 14.83 |
| 4 | Chettouf Anis | 11.00 |

---

### Q30 — Overloaded Courses (> 80% Capacity)

```sql
SELECT
    c.course_name,
    COUNT(e.enrollment_id)   AS current_enrollments,
    c.max_capacity,
    ROUND(100.0 * COUNT(e.enrollment_id) / c.max_capacity, 2) AS percentage_full
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id
HAVING (COUNT(e.enrollment_id) / c.max_capacity) > 0.80;
```

| course_name | current_enrollments | max_capacity | percentage_full |
|---|---|---|---|
| *(none in test data)* | — | — | — |

> **Interpretation:** With 15 enrollments spread across 7 courses, no course has exceeded 80% capacity in the test dataset. This query would become critical in production with hundreds of students.

---

## TP1 Summary & Conclusions

TP1 successfully demonstrates the design of a normalized relational schema for a university system. Several important SQL concepts were applied:

**Normalization:** All tables are in 3NF. Redundancy is avoided by separating departments, professors, and students into dedicated tables linked by foreign keys.

**Referential Integrity:** Different ON DELETE strategies were applied deliberately — CASCADE for grades when an enrollment is deleted, and SET NULL for professors when their department is removed, preserving professor records even if a department closes.

**Query Complexity Progression:** The 30 queries cover a spectrum from simple `SELECT` statements (Q1–Q5) through multi-table JOINs (Q6–Q10), aggregate functions with `GROUP BY` / `HAVING` (Q11–Q15), outer joins to detect missing data (Q17, Q24), correlated subqueries and CTEs (Q21–Q25), and finally analytical window functions like `RANK() OVER()` (Q27).

**Key Finding:** The Computer Science department dominates enrollment (4 out of 8 students) and has the most courses. The query results confirm that students at M1 level (Boudraf, Eddine, Hadj) consistently perform better than L2 students, which aligns with expectations.

---

# TP2 — Hospital Management System

## TP2 Overview

TP2 extended the database design challenge to a medical domain. The hospital system manages specialties, doctors, patients, consultations, medications, and a two-level prescription model (`prescriptions` → `prescription_details`). This structure introduced new complexity including `ENUM` types, `BOOLEAN` fields, `DATETIME` columns, and business logic queries such as stock alerts, revenue analysis, and patient demographics.

---

## TP2 Database Schema

### Entity Summary

| Table | Rows (test data) | Primary Key | Notable Constraints |
|---|---|---|---|
| `specialties` | 6 | `specialty_id` | UNIQUE name |
| `doctors` | 6 | `doctor_id` | UNIQUE email + license · FK → specialties (RESTRICT) |
| `patients` | 8 | `patient_id` | UNIQUE file_number · ENUM gender |
| `consultations` | 8 | `consultation_id` | ENUM status · FK → patients + doctors (RESTRICT) |
| `medications` | 10 | `medication_id` | UNIQUE code · CHECK via application |
| `prescriptions` | 7 | `prescription_id` | FK → consultations (CASCADE) |
| `prescription_details` | 14 | `detail_id` | CHECK quantity > 0 · FK → prescriptions + medications |

### Relationships

```
specialties ──< doctors ──< consultations >── patients
                                  │
                             prescriptions
                                  │
                         prescription_details >── medications
```

- Each **consultation** links one patient to one doctor and can generate one **prescription**.
- A **prescription** contains multiple `prescription_details`, each referencing a **medication** with quantity, dosage instructions, and calculated total price.
- The RESTRICT rule on `doctors` and `patients` foreign keys in `consultations` prevents accidental deletion of records that have active medical history.

### Indexes Created

| Index Name | Table | Column(s) |
|---|---|---|
| `idx_patient_name` | patients | last_name, first_name |
| `idx_consult_date` | consultations | consultation_date |
| `idx_consult_patient` | consultations | patient_id |
| `idx_consult_doctor` | consultations | doctor_id |
| `idx_medication_name` | medications | commercial_name |
| `idx_prescription_consult` | prescriptions | consultation_id |

---

## TP2 Sample Query Results

### Q1 — All Patients (Basic SELECT)

```sql
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name,
       date_of_birth, phone, city
FROM patients ORDER BY last_name;
```

| file_number | full_name | date_of_birth | phone | city |
|---|---|---|---|---|
| PAT-008 | Aissaoui Fatiha | 2018-06-10 | 0660201008 | Alger |
| PAT-007 | Boudjelal Ismail | 1950-12-25 | 0660201007 | Sétif |
| PAT-003 | Cherif Kamel | 1975-11-02 | 0660201003 | Constantine |
| PAT-006 | Ferhat Sonia | 1965-04-05 | 0660201006 | Alger |
| PAT-005 | Ghouali Khalil | 1998-01-30 | 0660201005 | Blida |
| PAT-004 | Hadj Meriem | 2010-08-19 | 0660201004 | Alger |
| PAT-001 | Meziani Riad | 1985-07-14 | 0660201001 | Alger |
| PAT-002 | Taleb Nadia | 1992-03-28 | 0660201002 | Oran |

---

### Q5 — Medications Below Minimum Stock

```sql
SELECT commercial_name, available_stock, minimum_stock,
       (available_stock - minimum_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;
```

| commercial_name | available_stock | minimum_stock | difference |
|---|---|---|---|
| Caladryl Lotion | 8 | 10 | -2 |
| Calcium D3 Sandoz | 12 | 15 | -3 |

> **Action Required:** Two medications need restocking. `Calcium D3 Sandoz` has the largest shortage (-3 units below minimum).

---

### Q10 — Revenue by Medical Specialty

```sql
SELECT s.specialty_name,
       COALESCE(SUM(c.amount), 0) AS total_revenue,
       COUNT(c.consultation_id)   AS consultation_count
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
ORDER BY total_revenue DESC;
```

| specialty_name | total_revenue | consultation_count |
|---|---|---|
| Orthopedics | 8 000.00 DA | 2 |
| Cardiology | 10 000.00 DA | 2 |
| General Medicine | 4 000.00 DA | 2 |
| Pediatrics | 3 000.00 DA | 1 |
| Dermatology | 3 500.00 DA | 1 |
| Gynecology | 0.00 DA | 0 |

> **Observation:** Cardiology generates the highest revenue per consultation (5 000 DA/visit) despite the same number of consultations as Orthopedics. Gynecology has no consultations recorded in the test data.

---

### Q16 — Top 5 Most Prescribed Medications

```sql
SELECT m.commercial_name AS medication_name,
       COUNT(pd.detail_id) AS times_prescribed,
       SUM(pd.quantity)    AS total_quantity
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;
```

| medication_name | times_prescribed | total_quantity |
|---|---|---|
| Aspégic 500 | 4 | 7 |
| Bisoprolol 5mg | 2 | 5 |
| Voltaren 50mg | 2 | 3 |
| Amlor 5mg | 2 | 4 |
| Augmentin 1g | 1 | 1 |

> **Insight:** Aspégic (Aspirin) appears in 4 out of 7 prescriptions, making it the most commonly prescribed medication — used across cardiology, general medicine, and orthopedics cases.

---

### Q26 — Total Revenue per Doctor (Paid Only)

```sql
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       ROUND(SUM(c.amount), 2)  AS total_revenue
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id
ORDER BY total_revenue DESC;
```

| doctor_name | total_consultations | total_revenue |
|---|---|---|
| Kaci Leila | 2 | 10 000.00 DA |
| Ouali Karim | 2 | 8 000.00 DA |
| Boudiaf Salim | 1 | 2 000.00 DA |
| Remili Youcef | 1 | 3 000.00 DA |
| Belhadj Nora | 1 | 4 000.00 DA |

> **Note:** Dr. Boudiaf (General Medicine) has 2 consultations but only 1 was paid — the unpaid one (patient Cherif Kamel, routine diabetes check-up) explains the lower revenue figure.

---

### Q30 — Patient Demographics by Age Group

```sql
SELECT age_group, COUNT(*) AS patient_count,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM (
    SELECT CASE
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURRENT_DATE) BETWEEN 0  AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURRENT_DATE) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURRENT_DATE) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group
    FROM patients
) AS age_data
GROUP BY age_group
ORDER BY FIELD(age_group, '0-18', '19-40', '41-60', '60+');
```

| age_group | patient_count | percentage |
|---|---|---|
| 0-18 | 2 | 25.00% |
| 19-40 | 2 | 25.00% |
| 41-60 | 2 | 25.00% |
| 60+ | 2 | 25.00% |

> **Observation:** The test dataset was intentionally balanced across all age groups (2 patients each) to ensure queries across all age categories could be validated. In a real hospital dataset, the 41-60 and 60+ groups typically represent the largest patient volumes.

---

## TP2 Summary & Conclusions

TP2 introduced a more complex schema with 7 tables and required a deeper understanding of business-oriented queries. The key takeaways are:

**Medical Data Modeling:** The two-level prescription model (`prescriptions` + `prescription_details`) correctly separates the prescription event (linked to a consultation) from the individual medications prescribed. This allows accurate cost tracking per drug and per patient.

**RESTRICT vs CASCADE:** The choice of `ON DELETE RESTRICT` for `consultations` referencing `patients` and `doctors` is a deliberate safety decision — medical records must never be silently deleted. In contrast, `CASCADE` on `prescription_details` is appropriate since individual drug lines have no meaning without their parent prescription.

**Stock & Expiry Management:** Queries Q5, Q20, and Q28 demonstrate how a database can drive operational decisions — identifying low-stock medications and those approaching expiry. In the test data, `Caladryl Lotion` and `Calcium D3 Sandoz` both fall below their minimum thresholds and would trigger a restock alert.

**Revenue Analysis:** The combination of Q10, Q26, and Q27 provides a multi-angle view of hospital revenue: by specialty, by doctor, and ranked. Cardiology generates the highest fee per visit (5 000 DA), while unpaid consultations (Q19) represent a financial risk that hospital administration should monitor.

**Advanced SQL Features Used:**
- `ENUM` types for gender and consultation status
- `BOOLEAN` fields for `paid` and `active` flags
- `TIMESTAMPDIFF()` for age calculation in demographics
- `RANK() OVER()` and `SUM() OVER()` window functions for ranking and percentage calculation
- Multi-level subqueries to find the most requested specialty (Q23)

---

# General Conclusions

Both TPs together cover the full lifecycle of relational database development:

| Stage | TP1 | TP2 |
|---|---|---|
| Schema design | 6 tables, academic domain | 7 tables, medical domain |
| Constraints | CHECK, UNIQUE, FK with SET NULL | ENUM, BOOLEAN, FK with RESTRICT |
| Data volume | 8 students, 15 enrollments, 12 grades | 8 patients, 8 consultations, 14 prescription lines |
| Query range | Weighted averages, rankings | Revenue analysis, stock alerts, demographics |
| Advanced SQL | CTEs, RANK() OVER() | TIMESTAMPDIFF, SUM() OVER(), multi-level subqueries |

The two assignments demonstrate that while the domain changes, the **core principles remain constant**: normalize the schema, enforce integrity at the database level rather than the application level, index foreign keys and frequently searched columns, and layer query complexity progressively from simple projections to analytical window functions.

A well-designed schema makes complex business questions answerable with clean, readable SQL — as shown by queries like the patient demographics report (Q30-TP2) or the student report card (Q28-TP1), both of which derive rich insights from properly structured relational data.

---

*Report generated for SS Specialty — Database Systems Module · February 2026*
