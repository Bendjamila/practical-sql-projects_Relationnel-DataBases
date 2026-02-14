-- ======================================================
-- TP2: Hospital Management System
-- Student: TIFOUR Ahmed Yassine
-- ======================================================

-- 1. Database creation
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

-- 2. Tables creation
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
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id) ON DELETE RESTRICT ON UPDATE CASCADE
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
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
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
    quantity INT NOT NULL,
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_quantity CHECK (quantity > 0)
);

-- 3. Indexes
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);

-- 4. Test Data Insertion
-- Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary care and general health', 1500.00),
('Cardiology', 'Heart and vascular system', 3000.00),
('Pediatrics', 'Medical care for children', 2000.00),
('Dermatology', 'Skin, hair, and nail disorders', 2500.00),
('Orthopedics', 'Musculoskeletal system', 2800.00),
('Gynecology', 'Female reproductive health', 2500.00);

-- Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Mebarki', 'Amine', 'amine.mebarki@hospital.dz', '0550123456', 1, 'LIC001', '2020-01-15', 'Room 101', 1),
('Brahimi', 'Sarah', 'sarah.brahimi@hospital.dz', '0550234567', 2, 'LIC002', '2018-05-20', 'Room 202', 1),
('Kaci', 'Omar', 'omar.kaci@hospital.dz', '0550345678', 3, 'LIC003', '2021-03-10', 'Room 303', 1),
('Ziri', 'Lina', 'lina.ziri@hospital.dz', '0550456789', 4, 'LIC004', '2019-11-05', 'Room 404', 1),
('Haddad', 'Yacine', 'yacine.haddad@hospital.dz', '0550567890', 5, 'LIC005', '2017-08-12', 'Room 505', 1),
('Mansouri', 'Meriem', 'meriem.mansouri@hospital.dz', '0550678901', 6, 'LIC006', '2022-02-28', 'Room 606', 1);

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, phone, city, registration_date, insurance, allergies) VALUES
('PAT001', 'Benali', 'Ahmed', '1985-06-12', 'M', 'A+', '0660112233', 'Algiers', '2024-01-10', 'CNAS', 'Penicillin'),
('PAT002', 'Saidi', 'Fatima', '2015-03-25', 'F', 'O-', '0660223344', 'Oran', '2024-02-15', 'CASNOS', NULL),
('PAT003', 'Laribi', 'Mohamed', '1950-11-05', 'M', 'B+', '0660334455', 'Constantine', '2023-12-01', 'CNAS', 'Dust'),
('PAT004', 'Belkacem', 'Sonia', '1992-09-18', 'F', 'AB+', '0660445566', 'Annaba', '2024-05-20', NULL, 'Pollen'),
('PAT005', 'Cherif', 'Kamel', '1978-12-30', 'M', 'A-', '0660556677', 'Setif', '2024-03-05', 'CNAS', NULL),
('PAT006', 'Ouali', 'Zahra', '2020-07-14', 'F', 'O+', '0660667788', 'Bejaia', '2024-06-12', 'CNAS', NULL),
('PAT007', 'Amrani', 'Rachid', '1965-02-22', 'M', 'B-', '0660778899', 'Tlemcen', '2024-01-20', 'CASNOS', 'Seafood'),
('PAT008', 'Hamidi', 'Yasmine', '2005-10-10', 'F', 'A+', '0660889900', 'Blida', '2024-04-18', 'CNAS', NULL);

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid) VALUES
(1, 1, '2025-01-15 09:00:00', 'Persistent cough', 'Common cold', 'Completed', 1500.00, 1),
(2, 3, '2025-01-16 10:30:00', 'Fever', 'Influenza', 'Completed', 2000.00, 1),
(3, 2, '2025-01-17 14:00:00', 'Chest pain', 'Hypertension', 'Completed', 3000.00, 0),
(4, 4, '2025-01-18 11:15:00', 'Skin rash', 'Eczema', 'Completed', 2500.00, 1),
(5, 5, '2025-01-20 08:45:00', 'Back pain', 'Muscle strain', 'Completed', 2800.00, 1),
(6, 3, '2025-02-10 16:00:00', 'Routine checkup', 'Healthy', 'Scheduled', 2000.00, 0),
(7, 1, '2025-01-22 13:30:00', 'Headache', 'Migraine', 'Completed', 1500.00, 1),
(8, 6, '2025-01-25 15:20:00', 'Abdominal pain', 'Gastritis', 'Completed', 2500.00, 1);

-- Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, unit_price, available_stock, minimum_stock, expiration_date) VALUES
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '500mg', 250.00, 100, 20, '2026-12-31'),
('MED002', 'Amoxil', 'Amoxicillin', 'Capsule', '500mg', 450.00, 50, 15, '2025-08-30'),
('MED003', 'Voltaren', 'Diclofenac', 'Gel', '1%', 600.00, 30, 10, '2026-05-15'),
('MED004', 'Ventoline', 'Salbutamol', 'Inhaler', '100mcg', 850.00, 25, 5, '2027-01-20'),
('MED005', 'Gaviscon', 'Sodium Alginate', 'Syrup', '250ml', 550.00, 40, 10, '2026-03-10'),
('MED006', 'Zyrtec', 'Cetirizine', 'Tablet', '10mg', 350.00, 60, 15, '2026-09-25'),
('MED007', 'Lasilix', 'Furosemide', 'Tablet', '40mg', 400.00, 45, 10, '2025-11-12'),
('MED008', 'Augmentin', 'Amoxicillin/Clavulanic Acid', 'Tablet', '1g', 1200.00, 20, 10, '2025-07-05'),
('MED009', 'Spasfon', 'Phloroglucinol', 'Tablet', '80mg', 300.00, 80, 20, '2026-02-18'),
('MED010', 'Advantan', 'Methylprednisolone', 'Cream', '0.1%', 750.00, 15, 5, '2026-06-30');

-- Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(1, 5, 'Take after meals'),
(2, 7, 'Rest and drink plenty of fluids'),
(3, 30, 'Daily blood pressure monitoring'),
(4, 10, 'Apply cream twice daily'),
(5, 15, 'Avoid heavy lifting'),
(7, 3, 'Take when pain starts'),
(8, 7, 'Avoid spicy food');

-- Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 2, '1 tablet 3 times a day', 5, 500.00),
(1, 2, 1, '1 capsule 2 times a day', 7, 450.00),
(2, 1, 1, '1 tablet as needed', 5, 250.00),
(3, 7, 1, '1 tablet every morning', 30, 400.00),
(4, 10, 1, 'Apply to affected area', 10, 750.00),
(5, 3, 1, 'Apply to back', 15, 600.00),
(6, 1, 1, '1 tablet if headache persists', 3, 250.00),
(7, 5, 1, '1 spoon after meals', 7, 550.00),
(7, 9, 2, '2 tablets when pain occurs', 7, 600.00),
(1, 6, 1, '1 tablet at night', 10, 350.00),
(2, 8, 1, '1 tablet twice a day', 7, 1200.00),
(4, 6, 1, '1 tablet for itching', 5, 350.00);

-- 5. SQL Queries (Q1-Q30)

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;

-- Q2. Display all doctors with their specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4. List consultations from January 2025
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.consultation_date >= '2025-01-01' AND c.consultation_date < '2025-02-01';

-- Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference FROM medications WHERE available_stock < minimum_stock;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions 
FROM prescription_details pd 
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id 
JOIN consultations c ON pr.consultation_id = c.consultation_id 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Display patients with their last consultation date
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, MAX(c.consultation_date) AS last_consultation_date
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
GROUP BY p.patient_id;

-- Q9. List doctors and the number of consultations performed
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id;

-- Q10. Display revenue by medical specialty
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate total prescription amount per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, SUM(pd.total_price) AS total_prescription_cost 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id 
GROUP BY p.patient_id;

-- Q12. Count the number of consultations per doctor
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id;

-- Q13. Calculate total stock value of pharmacy
SELECT COUNT(*) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name, ROUND(AVG(c.amount), 2) AS average_price 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(*) AS patient_count FROM patients GROUP BY blood_type;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 5 most prescribed medications
SELECT m.commercial_name AS medication_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_quantity 
FROM medications m 
JOIN prescription_details pd ON m.medication_id = pd.medication_id 
GROUP BY m.medication_id 
ORDER BY times_prescribed DESC 
LIMIT 5;

-- Q17. List patients who have never had a consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date 
FROM patients 
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18. Display doctors who performed more than 2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name AS specialty, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id 
HAVING consultation_count > 2;

-- Q19. Find unpaid consultations with total amount
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.paid = 0;

-- Q20. List medications expiring in less than 6 months from today
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration 
FROM medications 
WHERE expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find patients who consulted more than the average
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS consultation_count
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
GROUP BY p.patient_id 
HAVING consultation_count > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM consultations GROUP BY patient_id) as sub);

-- Q22. List medications more expensive than average price
SELECT commercial_name, unit_price
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id 
WHERE s.specialty_id = (
    SELECT d3.specialty_id 
    FROM consultations c3 
    JOIN doctors d3 ON c3.doctor_id = d3.doctor_id 
    GROUP BY d3.specialty_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- Q24. Find consultations with amount higher than average
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25. List allergic patients who received a prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS prescription_count 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
WHERE p.allergies IS NOT NULL AND p.allergies != ''
GROUP BY p.patient_id;

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue 
FROM doctors d 
JOIN consultations c ON d.doctor_id = c.doctor_id 
WHERE c.paid = 1 
GROUP BY d.doctor_id;

-- Q27. Display top 3 most profitable specialties
SELECT s.specialty_name, SUM(c.amount) AS total_revenue 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id 
ORDER BY total_revenue DESC
LIMIT 3;

-- Q28. List medications to restock (stock < minimum)
SELECT commercial_name AS medication_name, available_stock AS current_stock, minimum_stock, (minimum_stock - available_stock + 10) AS quantity_needed 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q29. Calculate average number of medications per prescription
SELECT ROUND(AVG(med_count), 2) AS average_medications_per_prescription 
FROM (SELECT COUNT(*) as med_count FROM prescription_details GROUP BY prescription_id) as sub;

-- Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN (YEAR(CURDATE()) - YEAR(date_of_birth)) <= 18 THEN '0-18'
        WHEN (YEAR(CURDATE()) - YEAR(date_of_birth)) <= 40 THEN '19-40'
        WHEN (YEAR(CURDATE()) - YEAR(date_of_birth)) <= 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients)), 2) AS percentage
FROM patients 
GROUP BY age_group;
