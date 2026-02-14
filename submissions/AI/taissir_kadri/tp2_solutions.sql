
-- TP2 SOLUTION - Hospital Management System


DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;


-- 1) TABLES


CREATE TABLE specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
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

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    blood_type VARCHAR(5),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

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
    status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10,2),
    paid BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_consultation_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_consultation_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
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

CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    CONSTRAINT fk_prescription_consultation
        FOREIGN KEY (consultation_id)
        REFERENCES consultations(consultation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE prescription_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL,
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),
    CONSTRAINT chk_detail_quantity CHECK (quantity > 0),
    CONSTRAINT fk_detail_prescription
        FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_medication
        FOREIGN KEY (medication_id)
        REFERENCES medications(medication_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 2) INDEXES

CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);

-- 3) TEST DATA

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary care and general health follow-up', 2000.00),
('Cardiology', 'Heart and blood vessel diseases', 3500.00),
('Pediatrics', 'Child healthcare', 2500.00),
('Dermatology', 'Skin and hair conditions', 2800.00),
('Orthopedics', 'Bones and musculoskeletal system', 3200.00),
('Gynecology', 'Women reproductive health', 3000.00);

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Belaid', 'Karim', 'karim.belaid@hospital.dz', '0551-300001', 1, 'LIC-GM-001', '2018-02-14', 'A-101', TRUE),
('Hanafi', 'Imane', 'imane.hanafi@hospital.dz', '0551-300002', 2, 'LIC-CRD-002', '2016-09-10', 'B-204', TRUE),
('Mekki', 'Nabil', 'nabil.mekki@hospital.dz', '0551-300003', 3, 'LIC-PED-003', '2019-06-01', 'C-110', TRUE),
('Ramdani', 'Salma', 'salma.ramdani@hospital.dz', '0551-300004', 4, 'LIC-DER-004', '2020-01-20', 'D-305', TRUE),
('Benkhelifa', 'Omar', 'omar.benkhelifa@hospital.dz', '0551-300005', 5, 'LIC-ORT-005', '2015-11-03', 'E-212', TRUE),
('Aouar', 'Lina', 'lina.aouar@hospital.dz', '0551-300006', 6, 'LIC-GYN-006', '2017-04-18', 'F-120', FALSE);

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history) VALUES
('P2025001', 'Amrani', 'Yacine', '1988-05-11', 'M', 'O+', 'yacine.amrani@mail.dz', '0662-400001', '12 Rue Didouche', 'Algiers', 'Algiers', '2024-12-10', 'CNAS', 'CNAS-001', 'Penicillin', 'Hypertension'),
('P2025002', 'Bensalem', 'Meriem', '1995-10-02', 'F', 'A+', 'meriem.bensalem@mail.dz', '0662-400002', '45 Cite El Bahia', 'Oran', 'Oran', '2025-01-05', 'CASNOS', 'CAS-221', NULL, NULL),
('P2025003', 'Saidi', 'Nour', '2012-03-19', 'F', 'B+', 'nour.saidi@mail.dz', '0662-400003', '8 Rue Emir', 'Setif', 'Setif', '2025-01-12', 'CNAS', 'CNAS-154', 'Pollen', 'Asthma'),
('P2025004', 'Khellaf', 'Rachid', '1971-07-23', 'M', 'AB+', 'rachid.khellaf@mail.dz', '0662-400004', '17 Hai El Nour', 'Constantine', 'Constantine', '2024-11-22', NULL, NULL, NULL, 'Type 2 diabetes'),
('P2025005', 'Dahmani', 'Aya', '2006-09-30', 'F', 'O-', 'aya.dahmani@mail.dz', '0662-400005', '3 Rue Mokrani', 'Blida', 'Blida', '2025-02-01', 'CNAS', 'CNAS-909', 'Peanuts', NULL),
('P2025006', 'Touil', 'Hakim', '1958-01-14', 'M', 'A-', 'hakim.touil@mail.dz', '0662-400006', '21 Cite Djamel', 'Annaba', 'Annaba', '2024-10-15', 'Mutuelle', 'MUT-882', NULL, 'Cardiac surgery 2020'),
('P2025007', 'Mansour', 'Lina', '1982-12-05', 'F', 'B-', 'lina.mansour@mail.dz', '0662-400007', '90 Rue Colon', 'Tlemcen', 'Tlemcen', '2024-09-09', 'CNAS', 'CNAS-300', 'Latex', 'Migraine'),
('P2025008', 'Ferhat', 'Yanis', '2018-06-28', 'M', 'O+', 'yanis.ferhat@mail.dz', '0662-400008', '11 Hai El Wiam', 'Bejaia', 'Bejaia', '2025-01-18', NULL, NULL, NULL, NULL);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:30:00', 'Headache and fatigue', 'Viral syndrome', 'Rest and hydration', '12/8', 37.60, 78.50, 176.00, 'Completed', 2000.00, TRUE),
(2, 2, '2025-01-15 14:00:00', 'Chest pain on effort', 'Mild angina', 'ECG requested', '13/9', 36.90, 62.00, 165.00, 'Completed', 3500.00, FALSE),
(3, 3, '2025-01-22 10:15:00', 'Persistent cough', 'Bronchitis', 'Follow-up in 1 week', '10/6', 38.20, 35.00, 145.00, 'Completed', 2500.00, TRUE),
(4, 5, '2025-02-05 16:30:00', 'Knee pain', 'Osteoarthritis', 'Physiotherapy advised', '14/8', 36.70, 86.20, 172.00, 'Completed', 3200.00, FALSE),
(5, 4, '2025-03-03 11:00:00', 'Skin rash', 'Allergic dermatitis', 'Avoid irritants', '11/7', 37.10, 54.00, 161.00, 'Completed', 2800.00, TRUE),
(6, 2, '2025-04-12 08:45:00', 'Blood pressure follow-up', 'Hypertension', 'Medication adjusted', '15/9', 36.80, 81.00, 170.00, 'Completed', 3500.00, TRUE),
(7, 1, '2025-05-20 13:20:00', 'Annual check-up', 'Healthy', 'Continue exercise', '12/8', 36.60, 59.00, 163.00, 'Completed', 2000.00, TRUE),
(8, 3, '2025-07-08 09:00:00', 'Fever and sore throat', NULL, 'Pending lab results', '10/6', 38.70, 24.00, 118.00, 'Scheduled', 2500.00, FALSE);

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane 500', 'Paracetamol', 'Tablet', '500mg', 'Sanofi', 180.00, 120, 30, '2027-01-31', FALSE, TRUE),
('MED002', 'Amoxil', 'Amoxicillin', 'Capsule', '500mg', 'GSK', 420.00, 20, 25, '2026-05-20', TRUE, TRUE),
('MED003', 'Aerius Syrup', 'Desloratadine', 'Syrup', '2.5mg/5ml', 'MSD', 650.00, 15, 20, '2026-04-10', TRUE, FALSE),
('MED004', 'Coversyl', 'Perindopril', 'Tablet', '5mg', 'Servier', 980.00, 40, 20, '2028-02-28', TRUE, TRUE),
('MED005', 'Ventoline', 'Salbutamol', 'Inhaler', '100mcg', 'GSK', 750.00, 8, 15, '2026-07-01', TRUE, TRUE),
('MED006', 'Ibuprofen 400', 'Ibuprofen', 'Tablet', '400mg', 'Pfizer', 300.00, 50, 20, '2026-03-15', FALSE, TRUE),
('MED007', 'Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'Saidal', 260.00, 70, 25, '2027-09-30', TRUE, TRUE),
('MED008', 'Fucidin Cream', 'Fusidic acid', 'Cream', '2%', 'LEO', 540.00, 12, 18, '2026-06-05', TRUE, FALSE),
('MED009', 'Calcium D3', 'Calcium + Vit D', 'Tablet', '600mg', 'Bayer', 490.00, 35, 20, '2027-04-30', FALSE, FALSE),
('MED010', 'Insulin Rapid', 'Insulin Aspart', 'Injection', '100IU/ml', 'Novo Nordisk', 1450.00, 18, 12, '2026-08-25', TRUE, TRUE);

INSERT INTO prescriptions (consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1, '2025-01-10 10:00:00', 5, 'Hydration and rest'),
(2, '2025-01-15 14:25:00', 30, 'Low-salt diet and regular control'),
(3, '2025-01-22 10:40:00', 7, 'Complete full antibiotic course'),
(4, '2025-02-05 16:50:00', 20, 'Pain management and physiotherapy'),
(5, '2025-03-03 11:20:00', 10, 'Avoid allergen contact'),
(6, '2025-04-12 09:10:00', 60, 'Monitor blood pressure daily'),
(7, '2025-05-20 13:35:00', 14, 'Preventive supplementation');

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 2, '1 tablet every 8 hours', 5, 360.00),
(1, 6, 1, '1 tablet after meals if pain', 3, 300.00),
(2, 4, 1, '1 tablet every morning', 30, 980.00),
(2, 7, 1, '1 capsule before breakfast', 30, 260.00),
(3, 2, 2, '1 capsule every 12 hours', 7, 840.00),
(3, 5, 1, '2 puffs when needed', 7, 750.00),
(4, 6, 2, '1 tablet every 12 hours', 10, 600.00),
(4, 9, 1, '1 tablet per day', 20, 490.00),
(5, 3, 1, '10 ml once daily', 10, 650.00),
(5, 8, 1, 'Apply twice daily', 10, 540.00),
(6, 4, 2, '1 tablet every morning', 60, 1960.00),
(7, 9, 2, '1 tablet after lunch', 14, 980.00);

-- 4) 30 SQL QUERIES ANSWERS


-- Q1
SELECT file_number,
       CONCAT(last_name, ' ', first_name) AS full_name,
       date_of_birth,
       phone,
       city
FROM patients;

-- Q2
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       s.specialty_name,
       d.office,
       d.active
FROM doctors d
JOIN specialties s ON s.specialty_id = d.specialty_id;

-- Q3
SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications
WHERE unit_price < 500;

-- Q4
SELECT c.consultation_date,
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       c.status
FROM consultations c
JOIN patients p ON p.patient_id = c.patient_id
JOIN doctors d ON d.doctor_id = c.doctor_id
WHERE c.consultation_date >= '2025-01-01'
  AND c.consultation_date < '2025-02-01';

-- Q5
SELECT commercial_name,
       available_stock,
       minimum_stock,
       (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- Q6
SELECT c.consultation_date,
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       c.diagnosis,
       c.amount
FROM consultations c
JOIN patients p ON p.patient_id = c.patient_id
JOIN doctors d ON d.doctor_id = c.doctor_id;

-- Q7
SELECT pr.prescription_date,
       CONCAT(pa.last_name, ' ', pa.first_name) AS patient_name,
       m.commercial_name AS medication_name,
       pd.quantity,
       pd.dosage_instructions
FROM prescriptions pr
JOIN consultations c ON c.consultation_id = pr.consultation_id
JOIN patients pa ON pa.patient_id = c.patient_id
JOIN prescription_details pd ON pd.prescription_id = pr.prescription_id
JOIN medications m ON m.medication_id = pd.medication_id;

-- Q8
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       MAX(c.consultation_date) AS last_consultation_date,
       SUBSTRING_INDEX(
           GROUP_CONCAT(CONCAT(d.last_name, ' ', d.first_name) ORDER BY c.consultation_date DESC),
           ',',
           1
       ) AS doctor_name
FROM patients p
LEFT JOIN consultations c ON c.patient_id = p.patient_id
LEFT JOIN doctors d ON d.doctor_id = c.doctor_id
GROUP BY p.patient_id, p.last_name, p.first_name;

-- Q9
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON c.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q10
SELECT s.specialty_name,
       ROUND(SUM(c.amount), 2) AS total_revenue,
       COUNT(c.consultation_id) AS consultation_count
FROM specialties s
LEFT JOIN doctors d ON d.specialty_id = s.specialty_id
LEFT JOIN consultations c ON c.doctor_id = d.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

-- Q11
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       ROUND(COALESCE(SUM(pd.total_price), 0), 2) AS total_prescription_cost
FROM patients p
LEFT JOIN consultations c ON c.patient_id = p.patient_id
LEFT JOIN prescriptions pr ON pr.consultation_id = c.consultation_id
LEFT JOIN prescription_details pd ON pd.prescription_id = pr.prescription_id
GROUP BY p.patient_id, p.last_name, p.first_name;

-- Q12
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON c.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q13
SELECT COUNT(*) AS total_medications,
       ROUND(SUM(unit_price * available_stock), 2) AS total_stock_value
FROM medications;

-- Q14
SELECT s.specialty_name,
       ROUND(AVG(c.amount), 2) AS average_price
FROM specialties s
LEFT JOIN doctors d ON d.specialty_id = s.specialty_id
LEFT JOIN consultations c ON c.doctor_id = d.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

-- Q15
SELECT blood_type,
       COUNT(*) AS patient_count
FROM patients
GROUP BY blood_type;

-- Q16
SELECT m.commercial_name AS medication_name,
       COUNT(pd.detail_id) AS times_prescribed,
       SUM(pd.quantity) AS total_quantity
FROM medications m
JOIN prescription_details pd ON pd.medication_id = m.medication_id
GROUP BY m.medication_id, m.commercial_name
ORDER BY times_prescribed DESC, total_quantity DESC
LIMIT 5;

-- Q17
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       p.registration_date
FROM patients p
LEFT JOIN consultations c ON c.patient_id = p.patient_id
WHERE c.consultation_id IS NULL;

-- Q18
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       s.specialty_name AS specialty,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON s.specialty_id = d.specialty_id
JOIN consultations c ON c.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.last_name, d.first_name, s.specialty_name
HAVING COUNT(c.consultation_id) > 2;

-- Q19
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       c.consultation_date,
       c.amount,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM consultations c
JOIN patients p ON p.patient_id = c.patient_id
JOIN doctors d ON d.doctor_id = c.doctor_id
WHERE c.paid = FALSE;

-- Q20
SELECT commercial_name AS medication_name,
       expiration_date,
       DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration
FROM medications
WHERE expiration_date >= CURDATE()
  AND expiration_date < DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Q21
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       COUNT(c.consultation_id) AS consultation_count,
       avg_t.average_count
FROM patients p
JOIN consultations c ON c.patient_id = p.patient_id
CROSS JOIN (
    SELECT AVG(cnt) AS average_count
    FROM (
        SELECT COUNT(*) AS cnt
        FROM consultations
        GROUP BY patient_id
    ) z
) avg_t
GROUP BY p.patient_id, p.last_name, p.first_name, avg_t.average_count
HAVING COUNT(c.consultation_id) > avg_t.average_count;

-- Q22
SELECT commercial_name AS medication_name,
       unit_price,
       (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       s.specialty_name,
       t.specialty_consultation_count
FROM doctors d
JOIN specialties s ON s.specialty_id = d.specialty_id
JOIN (
    SELECT d2.specialty_id,
           COUNT(c2.consultation_id) AS specialty_consultation_count
    FROM doctors d2
    JOIN consultations c2 ON c2.doctor_id = d2.doctor_id
    GROUP BY d2.specialty_id
    ORDER BY specialty_consultation_count DESC
    LIMIT 1
) t ON t.specialty_id = d.specialty_id;

-- Q24
SELECT c.consultation_date,
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       c.amount,
       avg_c.average_amount
FROM consultations c
JOIN patients p ON p.patient_id = c.patient_id
CROSS JOIN (SELECT AVG(amount) AS average_amount FROM consultations) avg_c
WHERE c.amount > avg_c.average_amount;

-- Q25
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       p.allergies,
       COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON c.patient_id = p.patient_id
JOIN prescriptions pr ON pr.consultation_id = c.consultation_id
WHERE p.allergies IS NOT NULL
  AND TRIM(p.allergies) <> ''
GROUP BY p.patient_id, p.last_name, p.first_name, p.allergies;

-- Q26
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       ROUND(SUM(c.amount), 2) AS total_revenue
FROM doctors d
JOIN consultations c ON c.doctor_id = d.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q27
SELECT DENSE_RANK() OVER (ORDER BY SUM(c.amount) DESC) AS rank,
       s.specialty_name,
       ROUND(SUM(c.amount), 2) AS total_revenue
FROM specialties s
JOIN doctors d ON d.specialty_id = s.specialty_id
JOIN consultations c ON c.doctor_id = d.doctor_id
WHERE c.paid = TRUE
GROUP BY s.specialty_id, s.specialty_name
ORDER BY rank
LIMIT 3;

-- Q28
SELECT commercial_name AS medication_name,
       available_stock AS current_stock,
       minimum_stock,
       (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock;

-- Q29
SELECT ROUND(AVG(med_count), 2) AS average_medications_per_prescription
FROM (
    SELECT prescription_id, COUNT(*) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) x;

-- Q30
SELECT age_group,
       patient_count,
       ROUND((patient_count * 100.0) / SUM(patient_count) OVER (), 2) AS percentage
FROM (
    SELECT
        CASE
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
            ELSE '60+'
        END AS age_group,
        COUNT(*) AS patient_count
    FROM patients
    GROUP BY
        CASE
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
            ELSE '60+'
        END
) groups;
