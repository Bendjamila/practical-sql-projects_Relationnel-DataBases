-- ============================================
-- TP2: Hospital Management System
-- ============================================

-- Create Database
DROP DATABASE IF EXISTS hospital_management;
CREATE DATABASE hospital_management;
USE hospital_management;

-- ============================================
-- PART 1: Creating Tables
-- ============================================

-- Table: specialties
CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10, 2) NOT NULL
);

-- Table: doctors
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

-- Table: patients
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

-- Table: consultations
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
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table: medications
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

-- Table: prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: prescription_details
CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================
-- Creating Indexes
-- ============================================
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);

-- ============================================
-- Inserting Test Data
-- ============================================

-- Insert Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary care and general health issues', 2500.00),
('Cardiology', 'Heart and cardiovascular system', 4500.00),
('Pediatrics', 'Medical care for children', 3000.00),
('Dermatology', 'Skin conditions and diseases', 3500.00),
('Orthopedics', 'Bones and musculoskeletal system', 4000.00),
('Gynecology', 'Women\'s reproductive health', 3800.00);

-- Insert Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Benali', 'Karim', 'k.benali@hospital.dz', '0555123456', 1, 'LIC001', '2020-01-15', 'Office 101', TRUE),
('Mansouri', 'Leila', 'l.mansouri@hospital.dz', '0555234567', 2, 'LIC002', '2019-03-20', 'Office 202', TRUE),
('Ziani', 'Nadia', 'n.ziani@hospital.dz', '0555345678', 3, 'LIC003', '2021-06-10', 'Office 103', TRUE),
('Bouaziz', 'Sofiane', 's.bouaziz@hospital.dz', '0555456789', 4, 'LIC004', '2018-09-05', 'Office 204', TRUE),
('Haddad', 'Amel', 'a.haddad@hospital.dz', '0555567890', 5, 'LIC005', '2020-11-12', 'Office 305', TRUE),
('Chenouf', 'Reda', 'r.chenouf@hospital.dz', '0555678901', 6, 'LIC006', '2022-02-28', 'Office 106', TRUE);

-- Insert Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, insurance, insurance_number, allergies, medical_history) VALUES
('PT001', 'Bouchareb', 'Ahmed', '1985-07-15', 'M', 'A+', 'a.bouchareb@email.com', '0777123456', '15 Rue Didouche', 'Algiers', 'Algiers', 'CASNOS', 'INS12345', 'Penicillin', 'Hypertension'),
('PT002', 'Khelifa', 'Fatima', '1992-03-22', 'F', 'O+', 'f.khelifa@email.com', '0777234567', '8 Rue Larbi', 'Oran', 'Oran', 'CNAS', 'INS12346', NULL, 'Asthma'),
('PT003', 'Toumi', 'Mohamed', '1978-11-08', 'M', 'B+', 'm.toumi@email.com', '0777345678', '22 Rue Khemisti', 'Constantine', 'Constantine', NULL, NULL, 'Sulfa', 'Diabetes Type 2'),
('PT004', 'Slimani', 'Nora', '2005-05-30', 'F', 'AB-', 'n.slimani@email.com', '0777456789', '5 Rue Aissat', 'Blida', 'Blida', 'CASNOS', 'INS12347', NULL, NULL),
('PT005', 'Amrani', 'Said', '1955-09-12', 'M', 'A-', 's.amrani@email.com', '0777567890', '17 Rue Bouzrina', 'Setif', 'Setif', 'CNAS', 'INS12348', 'Aspirin', 'Heart disease'),
('PT006', 'Yahiaoui', 'Lamia', '1998-12-03', 'F', 'O-', 'l.yahiaoui@email.com', '0777678901', '34 Rue Medjeber', 'Annaba', 'Annaba', NULL, NULL, 'Dust', NULL),
('PT007', 'Hamdi', 'Youcef', '2018-06-19', 'M', 'B-', 'y.hamdi@email.com', '0777789012', '12 Rue Saadi', 'Tizi Ouzou', 'Tizi Ouzou', 'CASNOS', 'INS12349', 'Eggs', 'None'),
('PT008', 'Messaoudi', 'Zineb', '1970-02-25', 'F', 'AB+', 'z.messaoudi@email.com', '0777890123', '45 Rue Amirouche', 'Bejaia', 'Bejaia', 'CNAS', 'INS12350', NULL, 'Arthritis');

-- Insert Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:30:00', 'Chest pain', 'Gastric reflux', 'Prescribed antacids', '120/80', 36.6, 78.5, 175.0, 'Completed', 2500.00, TRUE),
(2, 3, '2025-01-12 10:00:00', 'Child fever', 'Viral infection', 'Rest and hydration', '110/70', 38.2, 45.0, 142.0, 'Completed', 3000.00, TRUE),
(3, 2, '2025-01-15 14:30:00', 'Heart palpitations', 'Arrhythmia', 'ECG scheduled', '145/95', 36.8, 82.0, 170.0, 'Completed', 4500.00, TRUE),
(4, 4, '2025-01-18 11:15:00', 'Skin rash', 'Contact dermatitis', 'Avoid allergen', '115/75', 36.5, 60.0, 165.0, 'Completed', 3500.00, FALSE),
(5, 2, '2025-01-20 09:45:00', 'Chest discomfort', 'Angina', 'Stress test required', '150/95', 36.7, 85.0, 172.0, 'Scheduled', 4500.00, FALSE),
(6, 5, '2025-01-22 16:00:00', 'Knee pain', 'Sprained ligament', 'Recommended physiotherapy', '118/78', 36.9, 65.0, 168.0, 'Completed', 4000.00, TRUE),
(7, 3, '2025-01-25 13:30:00', 'Cough and cold', 'Upper respiratory infection', 'Prescribed antibiotics', '105/65', 37.5, 22.0, 115.0, 'Completed', 3000.00, TRUE),
(8, 6, '2025-01-28 10:30:00', 'Pelvic pain', 'Ovarian cyst', 'Ultrasound needed', '122/82', 36.8, 72.0, 163.0, 'Scheduled', 3800.00, FALSE);

-- Insert Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '500mg', 'Sanofi', 350.00, 500, 100, '2025-12-31', FALSE, TRUE),
('MED002', 'Ibuprofen', 'Ibuprofene', 'Tablet', '400mg', 'Biopharm', 280.00, 300, 50, '2025-10-15', FALSE, TRUE),
('MED003', 'Amoxicillin', 'Amoxicilline', 'Capsule', '500mg', 'Saïdal', 450.00, 150, 30, '2025-08-20', TRUE, TRUE),
('MED004', 'Ventolin', 'Salbutamol', 'Inhaler', '100mcg', 'GSK', 1200.00, 45, 15, '2025-06-30', TRUE, TRUE),
('MED005', 'Augmentin', 'Amoxicilline/Ac clav', 'Tablet', '1g', 'Pfizer', 850.00, 80, 25, '2025-09-12', TRUE, FALSE),
('MED006', 'Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'Merinal', 420.00, 200, 40, '2026-01-15', FALSE, TRUE),
('MED007', 'Insulin', 'Insuline humaine', 'Injection', '100UI/ml', 'Novo Nordisk', 1500.00, 30, 15, '2025-05-20', TRUE, TRUE),
('MED008', 'Claritin', 'Loratadine', 'Tablet', '10mg', 'Schering', 380.00, 120, 30, '2025-11-05', FALSE, FALSE),
('MED009', 'Zantac', 'Ranitidine', 'Tablet', '150mg', 'Glaxo', 320.00, 60, 20, '2025-07-18', FALSE, TRUE),
('MED010', 'Morphine', 'Morphine', 'Injection', '10mg/ml', 'Roche', 2200.00, 15, 10, '2025-04-10', TRUE, TRUE);

-- Insert Prescriptions
INSERT INTO prescriptions (consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1, '2025-01-10 10:00:00', 7, 'Take after meals'),
(2, '2025-01-12 10:30:00', 5, 'Complete the course'),
(3, '2025-01-15 15:15:00', 30, 'Take in the morning'),
(4, '2025-01-18 11:45:00', 10, 'Apply twice daily'),
(6, '2025-01-22 16:30:00', 14, 'Rest the knee'),
(7, '2025-01-25 14:00:00', 7, 'Drink plenty of water'),
(5, '2025-01-20 10:15:00', 15, 'Take before bed');

-- Insert Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 14, 'Take 1 tablet 2 times daily', 7, 14 * 350.00),
(1, 6, 7, 'Take 1 capsule daily', 7, 7 * 420.00),
(2, 1, 10, 'Take 1 tablet when fever', 5, 10 * 350.00),
(3, 3, 20, 'Take 1 capsule every 8 hours', 10, 20 * 450.00),
(3, 7, 2, 'Inject daily', 30, 2 * 1500.00),
(4, 8, 10, 'Take 1 tablet daily', 10, 10 * 380.00),
(4, 2, 6, 'Take as needed for pain', 3, 6 * 280.00),
(5, 2, 20, 'Take 1 tablet every 6 hours', 5, 20 * 280.00),
(5, 9, 14, 'Take 1 tablet twice daily', 7, 14 * 320.00),
(6, 1, 14, 'Take 1 tablet 2 times daily', 7, 14 * 350.00),
(7, 3, 21, 'Take 1 capsule 3 times daily', 7, 21 * 450.00),
(7, 8, 7, 'Take 1 tablet daily', 7, 7 * 380.00);

-- ============================================
-- PART 2: SQL Queries Solutions
-- ============================================

-- Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, 
       date_of_birth, phone, city
FROM patients;

-- Q2. Display all doctors with their specialty
SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, 
       s.specialty_name, d.office, d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications
WHERE unit_price < 500;

-- Q4. List consultations from January 2025
SELECT c.consultation_date, 
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       c.status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';

-- Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock,
       (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, 
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       c.diagnosis, c.amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT pr.prescription_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       m.commercial_name AS medication_name,
       pd.quantity, pd.dosage_instructions
FROM prescriptions pr
JOIN consultation_details cd ON pr.consultation_id = cd.consultation_id
JOIN patients p ON cd.patient_id = p.patient_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Display patients with their last consultation date
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       MAX(c.consultation_date) AS last_consultation_date,
       CONCAT(d.first_name, ' ', d.last_name) AS last_doctor_name
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
GROUP BY p.patient_id;

-- Q9. List doctors and the number of consultations performed
SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q10. Display revenue by medical specialty
SELECT s.specialty_name,
       COALESCE(SUM(c.amount), 0) AS total_revenue,
       COUNT(c.consultation_id) AS consultation_count
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY s.specialty_id;

-- Q11. Calculate total prescription amount per patient
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       COALESCE(SUM(pd.total_price), 0) AS total_prescription_cost
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
LEFT JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id;

-- Q12. Count the number of consultations per doctor (including inactive ones)
SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
ORDER BY consultation_count DESC;

-- Q13. Calculate total stock value of pharmacy
SELECT COUNT(*) AS total_medications,
       SUM(unit_price * available_stock) AS total_stock_value
FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name,
       ROUND(AVG(c.amount), 2) AS average_price
FROM specialties s
LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
HAVING average_price IS NOT NULL;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(*) AS patient_count
FROM patients
WHERE blood_type IS NOT NULL
GROUP BY blood_type;

-- Q16. Find the top 5 most prescribed medications
SELECT m.commercial_name AS medication_name,
       COUNT(pd.detail_id) AS times_prescribed,
       SUM(pd.quantity) AS total_quantity
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17. List patients who have never had a consultation
SELECT CONCAT(first_name, ' ', last_name) AS patient_name,
       registration_date
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18. Display doctors who performed more than 2 consultations
SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       s.specialty_name,
       COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
HAVING consultation_count > 2;

-- Q19. Find unpaid consultations with total amount
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       c.consultation_date,
       c.amount,
       CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE;

-- Q20. List medications expiring in less than 6 months from today
SELECT commercial_name AS medication_name,
       expiration_date,
       DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration
FROM medications
WHERE expiration_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
ORDER BY expiration_date;

-- Q21. Find patients who consulted more than the average
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       COUNT(c.consultation_id) AS consultation_count,
       ROUND((SELECT AVG(consultation_count) FROM 
             (SELECT COUNT(*) AS consultation_count 
              FROM consultations GROUP BY patient_id) AS avg_table), 2) AS average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
HAVING consultation_count > (SELECT AVG(consultation_count) FROM 
                            (SELECT COUNT(*) AS consultation_count 
                             FROM consultations GROUP BY patient_id) AS avg_table);

-- Q22. List medications more expensive than average price
SELECT commercial_name AS medication_name,
       unit_price,
       (SELECT ROUND(AVG(unit_price), 2) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       s.specialty_name,
       specialty_consultations.total AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN (SELECT s2.specialty_id, COUNT(c.consultation_id) AS total
      FROM specialties s2
      LEFT JOIN doctors d2 ON s2.specialty_id = d2.specialty_id
      LEFT JOIN consultations c ON d2.doctor_id = c.doctor_id
      GROUP BY s2.specialty_id
      ORDER BY total DESC
      LIMIT 1) AS specialty_consultations ON s.specialty_id = specialty_consultations.specialty_id;

-- Q24. Find consultations with amount higher than average
SELECT c.consultation_date,
       CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       c.amount,
       ROUND((SELECT AVG(amount) FROM consultations WHERE amount IS NOT NULL), 2) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations WHERE amount IS NOT NULL);

-- Q25. List allergic patients who received a prescription
SELECT DISTINCT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
       p.allergies,
       COUNT(pr.prescription_id) OVER (PARTITION BY p.patient_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies != '';

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
       COUNT(c.consultation_id) AS total_consultations,
       COALESCE(SUM(c.amount), 0) AS total_revenue
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27. Display top 3 most profitable specialties
SELECT ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS rank,
       specialty_name,
       total_revenue
FROM (
    SELECT s.specialty_name,
           COALESCE(SUM(c.amount), 0) AS total_revenue
    FROM specialties s
    LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id AND c.paid = TRUE
    GROUP BY s.specialty_id
) AS specialty_revenue
ORDER BY total_revenue DESC
LIMIT 3;

-- Q28. List medications to restock (stock < minimum)
SELECT commercial_name AS medication_name,
       available_stock AS current_stock,
       minimum_stock,
       (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock;

-- Q29. Calculate average number of medications per prescription
SELECT ROUND(AVG(medication_count), 2) AS average_medications_per_prescription
FROM (
    SELECT pr.prescription_id, COUNT(pd.detail_id) AS medication_count
    FROM prescriptions pr
    JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
    GROUP BY pr.prescription_id
) AS prescription_meds;

-- Q30. Generate patient demographics report by age group
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
SELECT age_group,
       COUNT(*) AS patient_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS percentage
FROM age_groups
GROUP BY age_group
ORDER BY MIN(CASE age_group
                 WHEN '0-18' THEN 1
                 WHEN '19-40' THEN 2
                 WHEN '41-60' THEN 3
                 WHEN '60+' THEN 4
             END);
