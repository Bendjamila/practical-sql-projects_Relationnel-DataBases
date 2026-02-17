-- TP2 hospital system - darine

-- create db
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

-- tables

CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10, 2) NOT NULL
);

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
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
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
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4, 2),
    weight DECIMAL(5, 2),
    height DECIMAL(5, 2),
    status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10, 2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_code VARCHAR(20) UNIQUE NOT NULL,
    commercial_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    form VARCHAR(50),
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10, 2) NOT NULL,
    available_stock INT DEFAULT 0,
    minimum_stock INT DEFAULT 10,
    expiration_date DATE,
    prescription_required BOOLEAN DEFAULT TRUE,
    reimbursable BOOLEAN DEFAULT FALSE
);

CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- indexes
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);

-- test data

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary care and general health', 2500.00),
('Cardiology', 'Heart and cardiovascular system', 4000.00),
('Pediatrics', 'Children health', 3000.00),
('Dermatology', 'Skin conditions', 3500.00),
('Orthopedics', 'Bones and joints', 4500.00),
('Gynecology', 'Women health', 3500.00);

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Alger', 'Amine', 'amine.alger@hospital.dz', '555-2001', 1, 'MED-2020-001', '2020-09-01', 'Room 101', TRUE),
('Benali', 'Karim', 'karim.benali@hospital.dz', '555-2002', 2, 'MED-2019-002', '2019-03-15', 'Room 102', TRUE),
('Chaoui', 'Nadia', 'nadia.chaoui@hospital.dz', '555-2003', 3, 'MED-2021-003', '2021-01-10', 'Room 103', TRUE),
('Dahmani', 'Omar', 'omar.dahmani@hospital.dz', '555-2004', 4, 'MED-2018-004', '2018-06-01', 'Room 104', TRUE),
('Essaid', 'Farida', 'farida.essaid@hospital.dz', '555-2005', 5, 'MED-2020-005', '2020-11-20', 'Room 105', TRUE),
('Ferhat', 'Samir', 'samir.ferhat@hospital.dz', '555-2006', 6, 'MED-2019-006', '2019-08-15', 'Room 106', TRUE);

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history) VALUES
('P2024001', 'Khelifi', 'Ahmed', '1990-03-15', 'M', 'O+', 'ahmed.khelifi@email.com', '555-3001', '10 Rue Alger', 'Algiers', 'Alger', '2024-01-15', 'CNAS', 'CN123456', NULL, NULL),
('P2024002', 'Mebarki', 'Fatima', '1985-07-22', 'F', 'A+', 'fatima.mebarki@email.com', '555-3002', '25 Bd Didouche', 'Oran', 'Oran', '2024-02-01', 'CASNOS', 'CS789012', 'Penicillin', NULL),
('P2024003', 'Ouali', 'Mohamed', '2015-11-10', 'M', 'B+', NULL, '555-3003', '5 Rue Constantine', 'Constantine', 'Constantine', '2024-02-15', NULL, NULL, NULL, NULL),
('P2024004', 'Rahmani', 'Samira', '1970-05-30', 'F', 'AB+', 'samira.rahmani@email.com', '555-3004', '15 Av Larbi', 'Annaba', 'Annaba', '2024-03-01', 'CNAS', 'CN654321', NULL, 'Hypertension'),
('P2024005', 'Salhi', 'Yacine', '2000-09-08', 'M', 'O-', 'yacine.salhi@email.com', '555-3005', '30 Rue Batna', 'Batna', 'Batna', '2024-03-15', NULL, NULL, 'Aspirin', NULL),
('P2024006', 'Taleb', 'Leila', '1995-12-20', 'F', 'A-', 'leila.taleb@email.com', '555-3006', '8 Place Benboulaid', 'Blida', 'Blida', '2024-04-01', 'CASNOS', 'CS456789', NULL, NULL),
('P2024007', 'Ziani', 'Hakim', '1960-01-25', 'M', 'O+', NULL, '555-3007', '12 Rue Tizi', 'Tizi Ouzou', 'Tizi Ouzou', '2024-04-15', 'CNAS', 'CN987654', NULL, 'Diabetes'),
('P2024008', 'Amrani', 'Djamila', '2010-04-12', 'F', 'B-', 'djamila.parent@email.com', '555-3008', '20 Av Setif', 'Setif', 'Setif', '2024-05-01', 'CASNOS', 'CS321654', 'Peanuts', NULL),
('P2024009', 'Bouzid', 'Rachid', '1988-08-03', 'M', 'A+', 'rachid.bouzid@email.com', '555-3009', '3 Rue Biskra', 'Biskra', 'Biskra', '2024-05-15', NULL, NULL, NULL, NULL);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2025-01-05 09:00:00', 'Flu symptoms', 'Seasonal flu', 'Rest and fluids', '120/80', 38.5, 75.0, 178.0, 'Completed', 2500.00, TRUE),
(2, 2, '2025-01-08 10:30:00', 'Chest pain', 'Anxiety', 'ECG normal', '130/85', 36.8, 68.0, 165.0, 'Completed', 4000.00, TRUE),
(3, 3, '2025-01-12 14:00:00', 'Fever', 'Viral infection', 'Prescribed paracetamol', '100/65', 38.2, 25.0, 120.0, 'Completed', 3000.00, TRUE),
(4, 1, '2025-01-15 11:00:00', 'Hypertension check', 'Controlled', 'Continue medication', '140/90', 36.5, 72.0, 162.0, 'Completed', 2500.00, FALSE),
(5, 4, '2025-01-18 15:30:00', 'Skin rash', 'Allergic dermatitis', 'Avoid trigger', '118/75', 36.7, 70.0, 175.0, 'Completed', 3500.00, TRUE),
(6, 5, '2025-01-20 09:30:00', 'Knee pain', 'Tendinitis', 'Physiotherapy recommended', '122/78', 36.6, 60.0, 168.0, 'Completed', 4500.00, FALSE),
(7, 6, '2025-01-22 10:00:00', 'Annual checkup', 'Stable', 'Monitor diabetes', '135/88', 36.5, 80.0, 170.0, 'Completed', 3500.00, TRUE),
(8, 3, '2025-01-25 16:00:00', 'Allergy reaction', 'Mild allergy', 'Epinephrine prescribed', '110/70', 37.0, 35.0, 140.0, 'Completed', 3000.00, TRUE),
(1, 1, '2025-02-01 09:00:00', 'Follow-up', 'Recovered', NULL, '118/76', 36.5, 75.0, 178.0, 'Scheduled', 2500.00, FALSE);

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '1000mg', 'Sanofi', 150.00, 500, 100, '2026-12-31', FALSE, TRUE),
('MED002', 'Augmentin', 'Amoxicillin-Clavulanate', 'Tablet', '1g', 'GSK', 450.00, 200, 50, '2026-06-30', TRUE, TRUE),
('MED003', 'Efferalgan', 'Paracetamol', 'Syrup', '150mg/5ml', 'Bristol', 280.00, 80, 20, '2025-12-31', FALSE, TRUE),
('MED004', 'Ibuprofene', 'Ibuprofen', 'Tablet', '400mg', 'Generic', 120.00, 300, 50, '2026-09-15', FALSE, FALSE),
('MED005', 'EpiPen', 'Epinephrine', 'Injection', '0.3mg', 'Pfizer', 8500.00, 15, 5, '2026-03-31', TRUE, TRUE),
('MED006', 'Lozan', 'Omeprazole', 'Capsule', '20mg', 'Generic', 250.00, 400, 100, '2026-08-20', FALSE, FALSE),
('MED007', 'Metformine', 'Metformin', 'Tablet', '850mg', 'Generic', 180.00, 350, 80, '2026-11-30', TRUE, TRUE),
('MED008', 'Voltaren', 'Diclofenac', 'Gel', '1%', 'Novartis', 420.00, 120, 30, '2026-04-15', FALSE, TRUE),
('MED009', 'Aerius', 'Desloratadine', 'Tablet', '5mg', 'MSD', 350.00, 250, 50, '2026-07-10', FALSE, TRUE),
('MED010', 'Humex', 'Chlorpheniramine', 'Syrup', '2mg/5ml', 'Generic', 380.00, 60, 15, '2025-10-31', FALSE, FALSE),
('MED011', 'Vitamin D', 'Cholecalciferol', 'Drops', '1000UI', 'Generic', 400.00, 90, 20, '2025-08-15', FALSE, FALSE);

INSERT INTO prescriptions (consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1, '2025-01-05 09:30:00', 7, 'Take with meals'),
(2, '2025-01-08 11:00:00', 14, 'Avoid alcohol'),
(3, '2025-01-12 14:30:00', 5, 'Every 6 hours'),
(4, '2025-01-15 11:30:00', 30, 'Take in morning'),
(5, '2025-01-18 16:00:00', 10, 'Apply twice daily'),
(6, '2025-01-20 10:00:00', 7, 'With food'),
(8, '2025-01-25 16:30:00', 365, 'Carry at all times'),
(1, '2025-01-05 09:45:00', 5, 'If needed for fever');

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 21, '1 tablet 3x daily', 7, 3150.00),
(1, 4, 14, '1 tablet 2x daily', 7, 1680.00),
(2, 2, 14, '1 tablet 2x daily', 14, 6300.00),
(3, 3, 1, '5ml every 6 hours', 5, 280.00),
(4, 6, 30, '1 capsule daily', 30, 7500.00),
(5, 8, 1, 'Apply on affected area', 10, 420.00),
(5, 9, 10, '1 tablet daily', 10, 3500.00),
(6, 1, 14, '1 tablet 3x daily', 7, 2100.00),
(7, 5, 2, 'Use in emergency only', 365, 17000.00),
(8, 1, 15, '1 tablet if fever', 5, 2250.00),
(2, 6, 14, '1 capsule before meals', 14, 3500.00),
(4, 7, 60, '1 tablet 2x daily', 30, 10800.00);

-- queries

-- Q1 patients info
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name,
       date_of_birth, phone, city FROM patients;

-- Q2 doctors + specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       s.specialty_name, d.office, d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3 meds < 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications WHERE unit_price < 500;

-- Q4 consultations jan 2025
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date >= '2025-01-01' AND c.consultation_date < '2025-02-01';

-- Q5 meds below min stock
SELECT commercial_name, available_stock, minimum_stock,
       (minimum_stock - available_stock) AS difference
FROM medications WHERE available_stock < minimum_stock;

-- Q6 consultations + patient + doctor
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       c.diagnosis, c.amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7 prescriptions + med details
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions
FROM prescriptions pr
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8 patients + last consultation
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       subq.last_consultation_date,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM patients p
JOIN (
    SELECT patient_id, MAX(consultation_date) AS last_consultation_date
    FROM consultations GROUP BY patient_id
) subq ON p.patient_id = subq.patient_id
JOIN consultations c ON subq.patient_id = c.patient_id AND subq.last_consultation_date = c.consultation_date
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q9 doctors + nb consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q10 revenue by specialty
SELECT s.specialty_name, SUM(c.amount) AS total_revenue,
       COUNT(c.consultation_id) AS consultation_count
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

-- Q11 total prescription cost per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       SUM(pd.total_price) AS total_prescription_cost
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id, p.last_name, p.first_name;

-- Q12 consultations per doctor
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q13 total stock value
SELECT COUNT(medication_id) AS total_medications,
       SUM(available_stock * unit_price) AS total_stock_value
FROM medications;

-- Q14 avg price per specialty
SELECT s.specialty_name, AVG(c.amount) AS average_price
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

-- Q15 patients by blood type
SELECT blood_type, COUNT(patient_id) AS patient_count
FROM patients WHERE blood_type IS NOT NULL
GROUP BY blood_type;

-- Q16 top 5 prescribed meds
SELECT m.commercial_name AS medication_name,
       COUNT(pd.detail_id) AS times_prescribed,
       SUM(pd.quantity) AS total_quantity
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id, m.commercial_name
ORDER BY times_prescribed DESC LIMIT 5;

-- Q17 patients with no consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date
FROM patients
WHERE patient_id NOT IN (SELECT patient_id FROM consultations);

-- Q18 doctors with >2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       s.specialty_name AS specialty,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, d.last_name, d.first_name, s.specialty_name
HAVING consultation_count > 2;

-- Q19 unpaid consultations
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       c.consultation_date, c.amount,
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE AND c.amount IS NOT NULL;

-- Q20 meds expiring in <6 months
SELECT commercial_name AS medication_name, expiration_date,
       DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration
FROM medications
WHERE expiration_date IS NOT NULL
  AND expiration_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Q21 patients above avg consultations
WITH avg_consult AS (
    SELECT AVG(cnt) AS avg_cnt FROM (
        SELECT COUNT(*) AS cnt FROM consultations GROUP BY patient_id
    ) t
)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       COUNT(c.consultation_id) AS consultation_count,
       (SELECT avg_cnt FROM avg_consult) AS average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id, p.last_name, p.first_name
HAVING consultation_count > (SELECT avg_cnt FROM avg_consult);

-- Q22 meds more expensive than avg
SELECT m.commercial_name AS medication_name, m.unit_price,
       (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications m
WHERE m.unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23 doctors from most requested specialty
WITH specialty_count AS (
    SELECT d.specialty_id, COUNT(c.consultation_id) AS cnt
    FROM doctors d JOIN consultations c ON d.doctor_id = c.doctor_id
    GROUP BY d.specialty_id
    ORDER BY cnt DESC LIMIT 1
)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       s.specialty_name, sc.cnt AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN specialty_count sc ON d.specialty_id = sc.specialty_id;

-- Q24 consultations above avg amount
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       c.amount, (SELECT AVG(amount) FROM consultations WHERE amount IS NOT NULL) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations WHERE amount IS NOT NULL);

-- Q25 allergic patients with prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
       p.allergies, COUNT(DISTINCT pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies != ''
GROUP BY p.patient_id, p.last_name, p.first_name, p.allergies;

-- Q26 revenue per doctor
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       SUM(c.amount) AS total_revenue
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q27 top 3 profitable specialties
SELECT ROW_NUMBER() OVER (ORDER BY SUM(c.amount) DESC) AS `rank`,
       s.specialty_name, SUM(c.amount) AS total_revenue
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY s.specialty_id, s.specialty_name
ORDER BY total_revenue DESC LIMIT 3;

-- Q28 meds to restock
SELECT commercial_name AS medication_name, available_stock AS current_stock,
       minimum_stock, (minimum_stock - available_stock) AS quantity_needed
FROM medications WHERE available_stock < minimum_stock;

-- Q29 avg meds per prescription
SELECT AVG(med_count) AS average_medications_per_prescription
FROM (SELECT prescription_id, COUNT(*) AS med_count
      FROM prescription_details GROUP BY prescription_id) t;

-- Q30 demographics by age group
WITH age_groups AS (
    SELECT patient_id,
           CASE
               WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
               WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 40 THEN '19-40'
               WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 60 THEN '41-60'
               ELSE '60+'
           END AS age_group
    FROM patients
)
SELECT age_group, COUNT(*) AS patient_count,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM patients), 2) AS percentage
FROM age_groups
GROUP BY age_group
ORDER BY age_group;
