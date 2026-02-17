
============================================-
TP2 – Hospital Management System
============================================
-- 1️⃣ DATABASE CREATION
-- ============================================

CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- ============================================
-- 2️⃣ TABLES CREATION
-- ============================================

-- Table 1: specialties
CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

-- Table 2: doctors
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) UNIQUE NOT NULL,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_doctor_specialty
        FOREIGN KEY (specialty_id)
        REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Table 3: patients
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M','F') NOT NULL,
    blood_type VARCHAR(5),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE DEFAULT CURRENT_DATE,
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

-- Table 4: consultations
CREATE TABLE consultations (
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,2),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    status ENUM('Scheduled','In Progress','Completed','Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10,2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table 5: medications
CREATE TABLE medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_code VARCHAR(20) UNIQUE NOT NULL,
    commercial_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    form VARCHAR(50),
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL,
    available_stock INT DEFAULT 0,
    minimum_stock INT DEFAULT 10,
    expiration_date DATE,
    prescription_required BOOLEAN DEFAULT TRUE,
    reimbursable BOOLEAN DEFAULT FALSE
);

-- Table 6: prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id)
        REFERENCES consultations(consultation_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 7: prescription_details
CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id)
        REFERENCES medications(medication_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================
-- 3️⃣ INDEXES
-- ============================================

CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);
============================================
4️⃣ TEST DATA INSERTION
============================================
-- ============================================
-- SPECIALTIES (6)
-- ============================================

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary healthcare services', 2000),
('Cardiology', 'Heart and cardiovascular diseases', 4000),
('Pediatrics', 'Child healthcare', 2500),
('Dermatology', 'Skin related treatments', 3000),
('Orthopedics', 'Bones and joints', 3500),
('Gynecology', 'Women reproductive health', 3200);

-- ============================================
-- DOCTORS (6)
-- ============================================

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES
('Benali','Ahmed','ahmed.benali@hospital.com','0550000001',1,'LIC1001','2018-03-10','Office 101'),
('Kaci','Sofia','sofia.kaci@hospital.com','0550000002',2,'LIC1002','2017-06-15','Office 201'),
('Moussa','Yasmine','yasmine.m@hospital.com','0550000003',3,'LIC1003','2019-09-01','Office 102'),
('Amrani','Karim','karim.a@hospital.com','0550000004',4,'LIC1004','2020-01-12','Office 103'),
('Rahmani','Nabil','nabil.r@hospital.com','0550000005',5,'LIC1005','2016-11-20','Office 301'),
('Cherif','Lina','lina.c@hospital.com','0550000006',6,'LIC1006','2021-04-05','Office 202');

-- ============================================
-- PATIENTS (8)
-- ============================================

INSERT INTO patients (file_number,last_name,first_name,date_of_birth,gender,blood_type,phone,city,province,allergies,insurance)
VALUES
('F001','Ziani','Sara','2010-05-12','F','A+','0661000001','Algiers','Algiers','Penicillin','CNAS'),
('F002','Brahimi','Omar','1985-03-22','M','O+','0661000002','Oran','Oran',NULL,NULL),
('F003','Haddad','Lina','1970-07-18','F','B+','0661000003','Constantine','Constantine','Aspirin','Private'),
('F004','Toumi','Adam','2015-01-05','M','AB+','0661000004','Blida','Blida',NULL,'CNAS'),
('F005','Saidi','Nour','1995-12-09','F','O-','0661000005','Setif','Setif',NULL,NULL),
('F006','Mekki','Yacine','1960-02-28','M','A-','0661000006','Annaba','Annaba','Dust','CNAS'),
('F007','Guerfi','Aya','2002-09-14','F','B-','0661000007','Tlemcen','Tlemcen',NULL,NULL),
('F008','Khaled','Rami','1948-11-30','M','O+','0661000008','Batna','Batna','Diabetes','Private');

-- ============================================
-- CONSULTATIONS (8)
-- ============================================

INSERT INTO consultations (patient_id,doctor_id,consultation_date,reason,diagnosis,blood_pressure,temperature,weight,height,status,amount,paid)
VALUES
(1,3,'2025-01-10 10:00:00','Fever','Flu','110/70',38.5,40,140,'Completed',2500,TRUE),
(2,2,'2025-01-15 11:00:00','Chest pain','Hypertension','140/90',37,85,175,'Completed',4000,FALSE),
(3,1,'2025-02-01 09:30:00','Headache','Migraine','120/80',36.8,65,165,'Completed',2000,TRUE),
(4,3,'2025-03-05 14:00:00','Cough','Cold','100/70',37.5,30,120,'Completed',2500,TRUE),
(5,4,'2025-03-20 15:00:00','Skin rash','Allergy','115/75',36.7,55,160,'Completed',3000,FALSE),
(6,5,'2025-04-10 13:00:00','Knee pain','Arthritis','130/85',36.5,78,170,'Completed',3500,TRUE),
(7,6,'2025-05-02 10:30:00','Checkup','Routine','120/80',36.6,60,162,'Scheduled',3200,FALSE),
(8,2,'2025-01-25 16:00:00','Heart control','Arrhythmia','150/95',37.2,82,172,'Completed',4000,TRUE);

-- ============================================
-- MEDICATIONS (10)
-- ============================================

INSERT INTO medications (medication_code,commercial_name,form,dosage,manufacturer,unit_price,available_stock,minimum_stock,expiration_date)
VALUES
('M001','Paracetamol','Tablet','500mg','PharmaA',200,100,20,'2026-12-01'),
('M002','Amoxicillin','Capsule','500mg','PharmaB',450,50,15,'2026-08-01'),
('M003','Ibuprofen','Tablet','400mg','PharmaC',300,30,10,'2026-09-15'),
('M004','Insulin','Injection','10ml','PharmaD',1200,20,5,'2026-07-10'),
('M005','Cough Syrup','Syrup','100ml','PharmaE',350,15,20,'2026-06-01'),
('M006','Vitamin C','Tablet','1000mg','PharmaF',150,200,30,'2027-01-01'),
('M007','Skin Cream','Cream','50g','PharmaG',600,8,15,'2026-05-01'),
('M008','Antibiotic X','Injection','5ml','PharmaH',800,25,10,'2026-10-01'),
('M009','Pain Relief','Tablet','250mg','PharmaI',180,60,20,'2026-11-11'),
('M010','Heart Control','Tablet','50mg','PharmaJ',900,40,10,'2026-04-01');
============================================
5️⃣ 30 SQL QUERIES
============================================
-- Q1
SELECT file_number,
       CONCAT(first_name,' ',last_name) AS full_name,
       date_of_birth, phone, city
FROM patients;

-- Q2
SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       s.specialty_name, d.office, d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3
SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications
WHERE unit_price < 500;

-- Q4
SELECT c.consultation_date,
       CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       c.status
FROM consultations c
JOIN patients p ON c.patient_id=p.patient_id
JOIN doctors d ON c.doctor_id=d.doctor_id
WHERE MONTH(c.consultation_date)=1 AND YEAR(c.consultation_date)=2025;

-- Q5
SELECT commercial_name,
       available_stock,
       minimum_stock,
       (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- Q6
SELECT c.consultation_date,
       CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       c.diagnosis, c.amount
FROM consultations c
JOIN patients p ON c.patient_id=p.patient_id
JOIN doctors d ON c.doctor_id=d.doctor_id;

-- Q9
SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id=c.doctor_id
GROUP BY d.doctor_id;

-- Q10
SELECT s.specialty_name,
       SUM(c.amount) AS total_revenue,
       COUNT(c.consultation_id) AS consultation_count
FROM consultations c
JOIN doctors d ON c.doctor_id=d.doctor_id
JOIN specialties s ON d.specialty_id=s.specialty_id
GROUP BY s.specialty_id;

-- Q11
SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       SUM(pd.total_price) AS total_prescription_cost
FROM patients p
JOIN consultations c ON p.patient_id=c.patient_id
JOIN prescriptions pr ON c.consultation_id=pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id=pd.prescription_id
GROUP BY p.patient_id;

-- Q12
SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id=c.doctor_id
GROUP BY d.doctor_id;

-- Q13
SELECT COUNT(*) AS total_medications,
       SUM(unit_price * available_stock) AS total_stock_value
FROM medications;

-- Q14
SELECT s.specialty_name,
       AVG(c.amount) AS average_price
FROM consultations c
JOIN doctors d ON c.doctor_id=d.doctor_id
JOIN specialties s ON d.specialty_id=s.specialty_id
GROUP BY s.specialty_id;

-- Q15
SELECT blood_type, COUNT(*) AS patient_count
FROM patients
GROUP BY blood_type;

-- Q16
SELECT m.commercial_name,
       COUNT(pd.medication_id) AS times_prescribed,
       SUM(pd.quantity) AS total_quantity
FROM prescription_details pd
JOIN medications m ON pd.medication_id=m.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17
SELECT CONCAT(first_name,' ',last_name) AS patient_name, registration_date
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18
SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       s.specialty_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id=s.specialty_id
JOIN consultations c ON d.doctor_id=c.doctor_id
GROUP BY d.doctor_id
HAVING consultation_count > 2;

-- Q19
SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       c.consultation_date, c.amount,
       CONCAT(d.first_name,' ',d.last_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id=p.patient_id
JOIN doctors d ON c.doctor_id=d.doctor_id
WHERE c.paid=FALSE;

-- Q20
SELECT commercial_name,
       expiration_date,
       DATEDIFF(expiration_date,CURDATE()) AS days_until_expiration
FROM medications
WHERE expiration_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH);
-- Q21
SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       COUNT(c.consultation_id) AS consultation_count,
       (SELECT AVG(cnt)
        FROM (SELECT COUNT(*) AS cnt
              FROM consultations
              GROUP BY patient_id) AS avg_table) AS average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
HAVING consultation_count >
       (SELECT AVG(cnt)
        FROM (SELECT COUNT(*) AS cnt
              FROM consultations
              GROUP BY patient_id) AS avg_table);

-- Q22
SELECT commercial_name,
       unit_price,
       (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price >
      (SELECT AVG(unit_price) FROM medications);

-- Q23
SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       s.specialty_name,
       COUNT(c.consultation_id) AS specialty_consultation_count
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, d.doctor_id
HAVING s.specialty_id =
       (SELECT specialty_id
        FROM (
            SELECT d.specialty_id,
                   COUNT(*) AS total_cons
            FROM consultations c
            JOIN doctors d ON c.doctor_id = d.doctor_id
            GROUP BY d.specialty_id
            ORDER BY total_cons DESC
            LIMIT 1
        ) AS top_specialty);

-- Q24
SELECT c.consultation_date,
       CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       c.amount,
       (SELECT AVG(amount) FROM consultations) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount >
      (SELECT AVG(amount) FROM consultations);

-- Q25
SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       p.allergies,
       COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL
GROUP BY p.patient_id;

-- Q26
SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       SUM(c.amount) AS total_revenue
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27
SELECT @rank := @rank + 1 AS rank,
       specialty_name,
       total_revenue
FROM (
    SELECT s.specialty_name,
           SUM(c.amount) AS total_revenue
    FROM consultations c
    JOIN doctors d ON c.doctor_id = d.doctor_id
    JOIN specialties s ON d.specialty_id = s.specialty_id
    GROUP BY s.specialty_id
    ORDER BY total_revenue DESC
    LIMIT 3
) ranked,
(SELECT @rank := 0) r;

-- Q28
SELECT commercial_name AS medication_name,
       available_stock AS current_stock,
       minimum_stock,
       (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock;

-- Q29
SELECT AVG(med_count) AS average_medications_per_prescription
FROM (
    SELECT COUNT(*) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) AS counts;

-- Q30
SELECT age_group,
       COUNT(*) AS patient_count,
       ROUND((COUNT(*) / (SELECT COUNT(*) FROM patients)) * 100,2) AS percentage
FROM (
    SELECT CASE
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group
    FROM patients
) AS age_groups
GROUP BY age_group;
