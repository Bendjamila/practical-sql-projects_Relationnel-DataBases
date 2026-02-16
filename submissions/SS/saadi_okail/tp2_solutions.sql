-- ============================================
-- TP2 - Hospital Management System
-- ============================================

DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

-- =========================
-- Table: specialties
-- =========================
CREATE TABLE specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

-- =========================
-- Table: doctors
-- =========================
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) NOT NULL UNIQUE,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id)
        REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================
-- Table: patients
-- =========================
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    file_number VARCHAR(20) NOT NULL UNIQUE,
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

-- =========================
-- Table: consultations
-- =========================
CREATE TABLE consultations (
    consultation_id INT AUTO_INCREMENT PRIMARY KEY,
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
    CONSTRAINT fk_consult_patient FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_consult_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================
-- Table: medications
-- =========================
CREATE TABLE medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
    medication_code VARCHAR(20) NOT NULL UNIQUE,
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

-- =========================
-- Table: prescriptions
-- =========================
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT, -- days
    general_instructions TEXT,
    CONSTRAINT fk_prescription_consult FOREIGN KEY (consultation_id)
        REFERENCES consultations(consultation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- Table: prescription_details
-- =========================
CREATE TABLE prescription_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL,
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT fk_detail_prescription FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_med FOREIGN KEY (medication_id)
        REFERENCES medications(medication_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================
-- Indexes
-- =========================
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consult_date ON consultations(consultation_date);
CREATE INDEX idx_consult_patient ON consultations(patient_id);
CREATE INDEX idx_consult_doctor ON consultations(doctor_id);
CREATE INDEX idx_med_commercial ON medications(commercial_name);
CREATE INDEX idx_pres_consult ON prescriptions(consultation_id);

-- =========================
-- Test Data
-- =========================

-- Specialties (6)

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine','Primary care and internal medicine',1500.00),
('Cardiology','Heart and vascular specialty',3000.00),
('Pediatrics','Child health and pediatric care',1200.00),
('Dermatology','Skin health and treatments',2000.00),
('Orthopedics','Bones, joints and musculoskeletal',2500.00),
('Gynecology','Women''s reproductive health',2200.00);

-- Doctors (6) - one per specialty

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Smith','John','john.smith@hospital.uk','+44-20-7000-1101',1,'LIC-GB-1001','2012-04-01','Room 101',TRUE),
('Martin','Claire','claire.martin@hospital.fr','+33-1-4000-2101',2,'LIC-FR-2001','2010-06-15','Cardio 2',TRUE),
('Brown','Oliver','oliver.brown@hospital.uk','+44-20-7000-1102',3,'LIC-GB-1002','2018-11-20','Pediatrics 1',TRUE),
('Dubois','Pierre','pierre.dubois@hospital.fr','+33-1-4000-2102',4,'LIC-FR-2002','2015-03-12','Derm 5',TRUE),
('Taylor','Charlotte','charlotte.taylor@hospital.uk','+44-20-7000-1103',5,'LIC-GB-1003','2008-09-05','Ortho 3',TRUE),
('Moreau','Luc','luc.moreau@hospital.fr','+33-1-4000-2103',6,'LIC-FR-2003','2016-01-30','Gynae 1',TRUE);

-- Patients (8) - varied ages, blood types, some with allergies, some with insurance

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history) VALUES
('P2025001','Watson','Alice','2018-06-10','F','A+','alice.watson@example.com','+44-20-8000-3001','10 Downing St','London','Greater London','2025-01-10','HealthPlus','HP-1001','Peanuts','No chronic disease'),
('P2025002','Clark','Thomas','1985-02-14','M','O-','thomas.clark@example.com','+44-20-8000-3002','22 Baker St','London','Greater London','2024-11-20',NULL,NULL,NULL,'Hypertension'),
('P2025003','Leclerc','Sophie','1990-07-07','F','B+','sophie.leclerc@example.fr','+33-1-5000-4001','15 Rue Royale','Paris','Île-de-France','2024-12-05','MediCare','MC-2045','Penicillin','Asthma'),
('P2025004','Moreau','Lucas','1950-12-01','M','AB+','lucas.moreau@example.fr','+33-1-5000-4002','3 Rue Victor Hugo','Lyon','Auvergne-Rhône-Alpes','2023-10-01',NULL,NULL,'None','Type 2 Diabetes'),
('P2025005','Dupont','Camille','1975-09-10','F','O+','camille.dupont@example.fr','+33-1-5000-4003','8 Avenue des Arts','Marseille','Provence-Alpes-Côte d''Azur','2025-01-20','HealthPlus','HP-2003','Latex','Prior surgery 2015'),
('P2025006','King','Oliver','2000-03-03','M','A-','oliver.king@example.uk','+44-20-8000-3003','5 Abbey Rd','Manchester','Greater Manchester','2024-08-12',NULL,NULL,'None','No chronic disease'),
('P2025007','Mitchell','Ruby','2012-10-10','F','B-','ruby.mitchell@example.uk','+44-20-8000-3004','44 High St','Bristol','South West','2024-05-04','ChildCare','CC-301','Shellfish','Allergic rhinitis'),
('P2025008','Petit','Marc','1945-01-11','M','O+','marc.petit@example.fr','+33-1-5000-4005','60 Boulevard','Nice','Provence-Alpes-Côte d''Azur','2023-06-18',NULL,NULL,'Aspirin','Chronic heart disease');

-- Medications (10) - variety of forms, prices, stocks, some expiring soon

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED-001','Paracetamol 500mg','Paracetamol','Tablet','500mg','PharmaUK',20.00,200,50,'2026-12-31',FALSE,TRUE),
('MED-002','Amoxicillin 500mg','Amoxicillin','Capsule','500mg','PharmaFR',180.00,80,30,'2026-08-01',TRUE,FALSE),
('MED-003','Atorvastatin 20mg','Atorvastatin','Tablet','20mg','HealthLabs',650.00,40,20,'2027-05-10',TRUE,TRUE),
('MED-004','Ibuprofen 200mg','Ibuprofen','Tablet','200mg','PharmaUK',45.00,25,30,'2025-08-15',FALSE,TRUE),
('MED-005','Salbutamol 2mg/ml','Salbutamol','Inhalation','2mg/ml','Respira',350.00,15,20,'2026-03-20',TRUE,FALSE),
('MED-006','Cetirizine 10mg','Cetirizine','Tablet','10mg','AllergyCare',120.00,5,20,'2025-06-30',FALSE,TRUE),
('MED-007','Metformin 500mg','Metformin','Tablet','500mg','GlucoPharm',90.00,120,40,'2028-01-01',TRUE,FALSE),
('MED-008','Morphine 10mg/ml','Morphine','Injection','10mg/ml','PainRelief',1200.00,8,5,'2025-05-01',TRUE,FALSE),
('MED-009','Hydrocortisone 1%','Hydrocortisone','Cream','1%','DermaLab',250.00,60,20,'2026-11-11',FALSE,TRUE),
('MED-010','Vitamin D 1000IU','Cholecalciferol','Tablet','1000IU','NutriHealth',75.00,300,50,'2029-06-30',FALSE,TRUE);

-- Consultations (8) - mix of completed and scheduled, different dates, some paid

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1,3,'2025-01-05 09:30:00','Routine pediatric check','Well child','All normal','100/65','36.50',15.5,1.02,'Completed',1200.00,TRUE),
(2,1,'2025-01-12 11:00:00','Chest pain','Angina suspected','ECG done','130/85','37.00',82.0,1.78,'Completed',3000.00,TRUE),
(3,2,'2025-01-20 10:15:00','Follow-up high cholesterol','On statin','Lipid profile improved','120/80','36.80',62.0,1.65,'Completed',3000.00,FALSE),
(4,5,'2024-12-10 14:00:00','Knee pain','Osteoarthritis','Prescribed physio','140/90','36.60',87.0,1.80,'Completed',2500.00,TRUE),
(5,4,'2025-02-02 09:00:00','Rash','Contact dermatitis','Topical steroid advised','118/76','36.70',68.0,1.70,'Completed',2000.00,FALSE),
(6,1,'2025-03-15 16:30:00','General check','Healthy adult','No concerns','120/78','36.60',74.0,1.75,'Scheduled',1500.00,FALSE),
(7,3,'2025-01-25 13:45:00','Asthma exacerbation','Bronchospasm','Inhaler given','110/70','37.20',34.0,1.40,'Completed',1200.00,TRUE),
(8,6,'2025-04-10 10:00:00','Post-menopausal check','Routine','All OK','125/80','36.70',72.0,1.68,'Scheduled',2200.00,FALSE);

-- Prescriptions (7) - linked to consultations (use consultation ids 1..8 above)

INSERT INTO prescriptions (consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1,'2025-01-05 10:00:00',7,'Take as directed. Return if fever.'),
(2,'2025-01-12 11:30:00',14,'Rest and follow-up in 2 weeks.'),
(3,'2025-01-20 11:00:00',30,'Take once nightly.'),
(4,'2024-12-10 14:30:00',21,'Physio exercises & analgesics as needed.'),
(5,'2025-02-02 09:30:00',10,'Apply thin layer twice a day.'),
(7,'2025-01-25 14:15:00',5,'Use inhaler PRN.'),
(2,'2025-01-12 11:35:00',7,'Short course for pain management.');

-- Prescription Details (12) - multiple meds per prescription with computed total_price

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1,1,10,'1 tablet every 6 hours if needed',7,10 * 20.00),
(1,10,30,'1 tablet daily',7,30 * 75.00),
(2,2,20,'1 capsule every 8 hours',14,20 * 180.00),
(2,8,5,'Injection as prescribed in clinic',7,5 * 1200.00),
(3,3,30,'1 tablet at night',30,30 * 650.00),
(4,7,60,'500mg twice daily',21,60 * 90.00),
(4,1,20,'1 tablet every 6 hours',7,20 * 20.00),
(5,9,1,'Apply to affected area twice daily',10,1 * 250.00),
(6,5,2,'Inhale 2 puffs every 4-6 hours',5,2 * 350.00),
(6,6,10,'1 tablet daily for allergies',5,10 * 120.00),
(7,1,15,'1 tablet every 6 hours',7,15 * 20.00),
(7,4,10,'1 tablet every 8 hours',7,10 * 45.00);


-- ========== 30 SQL Queries to Solution ==========

USE hospital_db;

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1

SELECT file_number,
       CONCAT(first_name, ' ', last_name) AS full_name,
       date_of_birth,
       phone,
       city
FROM patients;

-- Q2

SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       s.specialty_name,
       d.office,
       d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3

SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications
WHERE unit_price < 500.00
ORDER BY unit_price ASC;

-- Q4

SELECT c.consultation_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       c.status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59'
ORDER BY c.consultation_date;

-- Q5

SELECT commercial_name, available_stock, minimum_stock,
       (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6

SELECT c.consultation_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       c.diagnosis,
       c.amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
ORDER BY c.consultation_date DESC;

-- Q7

SELECT pr.prescription_date,
       CONCAT(pt.first_name, ' ', pt.last_name) AS patient_name,
       m.commercial_name AS medication_name,
       pd.quantity,
       pd.dosage_instructions
FROM prescriptions pr
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients pt ON c.patient_id = pt.patient_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id
ORDER BY pr.prescription_date DESC;

-- Q8

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       MAX(c.consultation_date) AS last_consultation_date,
       CONCAT(d2.first_name, ' ', d2.last_name) AS doctor_name
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN doctors d2 ON c.doctor_id = d2.doctor_id
GROUP BY p.patient_id
ORDER BY last_consultation_date DESC;

-- Q9

SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
ORDER BY consultation_count DESC;

-- Q10

SELECT s.specialty_name,
       COALESCE(SUM(c.amount),0) AS total_revenue,
       COUNT(c.consultation_id) AS consultation_count
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY s.specialty_id
ORDER BY total_revenue DESC;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11

SELECT CONCAT(pt.first_name,' ',pt.last_name) AS patient_name,
       ROUND(COALESCE(SUM(pd.total_price),0),2) AS total_prescription_cost
FROM patients pt
LEFT JOIN consultations c ON pt.patient_id = c.patient_id
LEFT JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
LEFT JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY pt.patient_id
ORDER BY total_prescription_cost DESC;

-- Q12

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
ORDER BY consultation_count DESC;

-- Q13

SELECT COUNT(*) AS total_medications,
       ROUND(SUM(unit_price * available_stock),2) AS total_stock_value
FROM medications;

-- Q14

SELECT s.specialty_name,
       ROUND(AVG(c.amount),2) AS average_price
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
ORDER BY average_price DESC;

-- Q15

SELECT COALESCE(blood_type,'Unknown') AS blood_type,
       COUNT(*) AS patient_count
FROM patients
GROUP BY blood_type
ORDER BY patient_count DESC;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16

SELECT m.commercial_name AS medication_name,
       COUNT(pd.detail_id) AS times_prescribed,
       SUM(pd.quantity) AS total_quantity
FROM prescription_details pd
JOIN medications m ON pd.medication_id = m.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC, total_quantity DESC
LIMIT 5;

-- Q17

SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       p.registration_date
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
WHERE c.consultation_id IS NULL
ORDER BY p.registration_date;

-- Q18

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       s.specialty_name AS specialty,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
HAVING COUNT(c.consultation_id) > 2
ORDER BY consultation_count DESC;

-- Q19

SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       c.consultation_date,
       c.amount,
       CONCAT(d.first_name,' ',d.last_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE
ORDER BY c.consultation_date;

-- Q20

SELECT commercial_name AS medication_name,
       expiration_date,
       DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration
FROM medications
WHERE expiration_date IS NOT NULL
  AND DATEDIFF(expiration_date, CURRENT_DATE) < 180
  AND DATEDIFF(expiration_date, CURRENT_DATE) >= 0
ORDER BY days_until_expiration ASC;

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21

SELECT t.patient_name, t.consultation_count, avg_stats.avg_count AS average_count
FROM (
    SELECT p.patient_id, CONCAT(p.first_name,' ',p.last_name) AS patient_name,
           COUNT(c.consultation_id) AS consultation_count
    FROM patients p
    LEFT JOIN consultations c ON p.patient_id = c.patient_id
    GROUP BY p.patient_id
) t
CROSS JOIN (
    SELECT AVG(cnt) AS avg_count FROM (
        SELECT COUNT(consultation_id) AS cnt
        FROM consultations
        GROUP BY patient_id
    ) sub
) avg_stats
WHERE t.consultation_count > avg_stats.avg_count
ORDER BY t.consultation_count DESC;

-- Q22

SELECT m.commercial_name AS medication_name,
       m.unit_price,
       ROUND((SELECT AVG(unit_price) FROM medications),2) AS average_price
FROM medications m
WHERE m.unit_price > (SELECT AVG(unit_price) FROM medications)
ORDER BY m.unit_price DESC;

-- Q23

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       s.specialty_name,
       spec_counts.total_consultations AS specialty_consultation_count
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN (
    SELECT s2.specialty_id, COUNT(c2.consultation_id) AS total_consultations
    FROM specialties s2
    JOIN doctors dd ON s2.specialty_id = dd.specialty_id
    JOIN consultations c2 ON dd.doctor_id = c2.doctor_id
    GROUP BY s2.specialty_id
    ORDER BY total_consultations DESC
    LIMIT 1
) spec_counts ON s.specialty_id = spec_counts.specialty_id
ORDER BY doctor_name;

-- Q24

SELECT c.consultation_date,
       CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       c.amount,
       (SELECT ROUND(AVG(amount),2) FROM consultations) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations)
ORDER BY c.amount DESC;

-- Q25

SELECT CONCAT(p.first_name,' ',p.last_name) AS patient_name,
       p.allergies,
       COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies <> ''
GROUP BY p.patient_id
ORDER BY prescription_count DESC;

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       ROUND(SUM(c.amount),2) AS total_revenue
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY d.doctor_id
ORDER BY total_revenue DESC;

-- Q27

SELECT ROW_NUMBER() OVER (ORDER BY spec_revenue.total_revenue DESC) AS rank,
       spec_revenue.specialty_name,
       spec_revenue.total_revenue
FROM (
    SELECT s.specialty_name, ROUND(COALESCE(SUM(c.amount),0),2) AS total_revenue
    FROM specialties s
    JOIN doctors d ON s.specialty_id = d.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
    GROUP BY s.specialty_id
) spec_revenue
ORDER BY total_revenue DESC
LIMIT 3;

-- Q28

SELECT commercial_name AS medication_name,
       available_stock AS current_stock,
       minimum_stock,
       (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock
ORDER BY quantity_needed DESC;

-- Q29

SELECT ROUND(AVG(meds_count),2) AS average_medications_per_prescription
FROM (
    SELECT prescription_id, COUNT(detail_id) AS meds_count
    FROM prescription_details
    GROUP BY prescription_id
) t;

-- Q30

SELECT age_group,
       COUNT(*) AS patient_count,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM patients),2) AS percentage
FROM (
    SELECT *,
        CASE
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURRENT_DATE) BETWEEN 0 AND 18 THEN '0-18'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURRENT_DATE) BETWEEN 19 AND 40 THEN '19-40'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURRENT_DATE) BETWEEN 41 AND 60 THEN '41-60'
            ELSE '60+'
        END AS age_group
    FROM patients
) sub
GROUP BY age_group
ORDER BY FIELD(age_group,'0-18','19-40','41-60','60+');
