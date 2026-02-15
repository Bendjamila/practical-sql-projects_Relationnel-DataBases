-- 1. Database creation
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

-- 2. Tables Creation

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
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT ON UPDATE CASCADE
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
('General Medicine', 'Primary care and general health', 2000.00),
('Cardiology', 'Heart and blood vessels', 5000.00),
('Pediatrics', 'Medical care for children', 2500.00),
('Dermatology', 'Skin, hair, and nails', 3000.00),
('Orthopedics', 'Musculoskeletal system', 4000.00),
('Gynecology', 'Female reproductive system', 3500.00);

-- Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Mebarki', 'Ahmed', 'ahmed.m@hospital.dz', '0550112233', 1, 'LIC001', '2010-05-15', 'Room 101', TRUE),
('Bensaid', 'Sarah', 'sarah.b@hospital.dz', '0550445566', 2, 'LIC002', '2012-08-20', 'Room 205', TRUE),
('Ziane', 'Omar', 'omar.z@hospital.dz', '0550778899', 3, 'LIC003', '2015-01-10', 'Room 302', TRUE),
('Kaci', 'Amel', 'amel.k@hospital.dz', '0550123456', 4, 'LIC004', '2018-03-25', 'Room 104', TRUE),
('Haddad', 'Karim', 'karim.h@hospital.dz', '0550987654', 5, 'LIC005', '2020-06-12', 'Room 401', TRUE),
('Rahmani', 'Lydia', 'lydia.r@hospital.dz', '0550111222', 6, 'LIC006', '2021-11-30', 'Room 208', TRUE);

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, phone, city, registration_date, allergies) VALUES
('P001', 'Belkacem', 'Yacine', '1985-04-12', 'M', 'A+', '0661001122', 'Algiers', '2024-10-01', 'Penicillin'),
('P002', 'Hamidi', 'Fatima', '1992-09-25', 'F', 'O-', '0661334455', 'Oran', '2024-11-15', NULL),
('P003', 'Mansouri', 'Ryad', '2015-02-10', 'M', 'B+', '0661667788', 'Constantine', '2025-01-05', 'Dust'),
('P004', 'Dahmani', 'Sonia', '1970-12-30', 'F', 'AB+', '0661990011', 'Annaba', '2024-05-20', 'Seafood'),
('P005', 'Ouali', 'Mohamed', '1955-07-08', 'M', 'O+', '0661223344', 'Setif', '2024-08-12', NULL),
('P006', 'Taleb', 'Ines', '2010-11-22', 'F', 'A-', '0661556677', 'Batna', '2025-01-20', NULL),
('P007', 'Bouzid', 'Walid', '1988-03-05', 'M', 'B-', '0661889900', 'Tlemcen', '2024-12-10', 'Pollen'),
('P008', 'Saidi', 'Nour', '1998-06-18', 'F', 'O+', '0661112233', 'Bejaia', '2025-02-01', NULL);

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:30:00', 'Fever and cough', 'Common Flu', 'Completed', 2000.00, TRUE),
(2, 2, '2025-01-12 11:00:00', 'Chest pain', 'Hypertension', 'Completed', 5000.00, TRUE),
(3, 3, '2025-01-15 14:00:00', 'Routine checkup', 'Healthy', 'Completed', 2500.00, TRUE),
(4, 4, '2025-01-18 10:00:00', 'Skin rash', 'Eczema', 'Completed', 3000.00, FALSE),
(5, 5, '2025-01-20 15:30:00', 'Knee pain', 'Arthritis', 'Completed', 4000.00, TRUE),
(6, 3, '2025-01-22 09:00:00', 'Sore throat', 'Tonsillitis', 'Completed', 2500.00, TRUE),
(1, 1, '2025-02-05 10:30:00', 'Follow up', 'Recovering', 'Completed', 2000.00, TRUE),
(8, 6, '2025-02-15 11:00:00', 'Checkup', 'Scheduled', 'Scheduled', 3500.00, FALSE);

-- Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, unit_price, available_stock, minimum_stock, expiration_date) VALUES
('M001', 'Doliprane', 'Paracetamol', 'Tablet', 250.00, 100, 20, '2026-12-31'),
('M002', 'Amoxicillin', 'Amoxicillin', 'Capsule', 450.00, 50, 15, '2025-08-30'),
('M003', 'Voltaren', 'Diclofenac', 'Gel', 600.00, 30, 10, '2026-05-20'),
('M004', 'Amlor', 'Amlodipine', 'Tablet', 850.00, 40, 10, '2027-01-15'),
('M005', 'Zyrtec', 'Cetirizine', 'Tablet', 400.00, 25, 10, '2026-10-10'),
('M006', 'Ventoline', 'Salbutamol', 'Inhaler', 1200.00, 15, 5, '2025-11-01'),
('M007', 'Augmentin', 'Amoxicillin/Clavulanic Acid', 'Tablet', 1500.00, 20, 10, '2025-06-15'),
('M008', 'Spasfon', 'Phloroglucinol', 'Tablet', 350.00, 60, 20, '2027-03-20'),
('M009', 'Gaviscon', 'Sodium Alginate', 'Syrup', 550.00, 8, 10, '2026-02-28'),
('M010', 'Betadine', 'Povidone-iodine', 'Solution', 480.00, 12, 5, '2025-09-12');

-- Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(1, 5, 'Rest and drink plenty of water'),
(2, 30, 'Take medication daily after breakfast'),
(4, 10, 'Apply gel twice a day'),
(5, 15, 'Avoid heavy lifting'),
(6, 7, 'Complete the full course of antibiotics'),
(7, 3, 'Continue current treatment'),
(1, 7, 'Additional antibiotics if needed');

-- Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 2, '1 tablet 3 times a day', 5, 500.00),
(2, 4, 1, '1 tablet every morning', 30, 850.00),
(3, 3, 1, 'Apply on affected area', 10, 600.00),
(4, 3, 2, 'Apply on joints', 15, 1200.00),
(5, 2, 3, '1 capsule 3 times a day', 7, 1350.00),
(1, 5, 1, '1 tablet at night', 5, 400.00),
(6, 1, 1, 'As needed for pain', 3, 250.00),
(2, 8, 2, 'When needed for pain', 30, 700.00),
(5, 7, 2, '1 tablet twice a day', 7, 3000.00),
(3, 10, 1, 'Clean wound twice daily', 10, 480.00),
(7, 2, 2, '1 capsule twice daily', 7, 900.00),
(1, 9, 1, '1 spoon after meals', 5, 550.00);

-- 5. SQL Queries (30)

-- Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;

-- Q2. Display all doctors with their specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4. List consultations from January 2025
SELECT consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, status 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';

-- Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions 
FROM prescription_details pd 
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id 
JOIN consultations c ON pr.consultation_id = c.consultation_id 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Display patients with their last consultation date
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, MAX(c.consultation_date) AS last_consultation_date, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
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
SELECT COUNT(medication_id) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name, ROUND(AVG(c.amount), 2) AS average_price 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(patient_id) AS patient_count FROM patients GROUP BY blood_type;

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
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.paid = FALSE;

-- Q20. List medications expiring in less than 6 months from today
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration 
FROM medications 
WHERE expiration_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);

-- Q21. Find patients who consulted more than the average
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS consultation_count, 
       (SELECT AVG(cnt) FROM (SELECT COUNT(consultation_id) as cnt FROM consultations GROUP BY patient_id) as sub) AS average_count 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
GROUP BY p.patient_id 
HAVING consultation_count > (SELECT AVG(cnt) FROM (SELECT COUNT(consultation_id) as cnt FROM consultations GROUP BY patient_id) as sub);

-- Q22. List medications more expensive than average price
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) AS average_price 
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, 
       (SELECT COUNT(c.consultation_id) FROM consultations c JOIN doctors d2 ON c.doctor_id = d2.doctor_id WHERE d2.specialty_id = s.specialty_id) AS specialty_consultation_count 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id 
WHERE s.specialty_id = (
    SELECT d3.specialty_id FROM consultations c3 JOIN doctors d3 ON c3.doctor_id = d3.doctor_id 
    GROUP BY d3.specialty_id ORDER BY COUNT(c3.consultation_id) DESC LIMIT 1
);

-- Q24. Find consultations with amount higher than average
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount, 
       (SELECT AVG(amount) FROM consultations) AS average_amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25. List allergic patients who received a prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS prescription_count 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
WHERE p.allergies IS NOT NULL 
GROUP BY p.patient_id;

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue 
FROM doctors d 
JOIN consultations c ON d.doctor_id = c.doctor_id 
WHERE c.paid = TRUE 
GROUP BY d.doctor_id;

-- Q27. Display top 3 most profitable specialties
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) AS `rank`, s.specialty_name, SUM(c.amount) AS total_revenue 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id 
LIMIT 3;

-- Q28. List medications to restock (stock < minimum)
SELECT commercial_name, available_stock AS current_stock, minimum_stock, (minimum_stock - available_stock) AS quantity_needed 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q29. Calculate average number of medications per prescription
SELECT AVG(med_count) AS average_medications_per_prescription 
FROM (SELECT COUNT(medication_id) as med_count FROM prescription_details GROUP BY prescription_id) as sub;

-- Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+' 
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND((COUNT(*) / (SELECT COUNT(*) FROM patients)) * 100, 2) AS percentage 
FROM patients 
GROUP BY age_group;
