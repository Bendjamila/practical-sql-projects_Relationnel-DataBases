-- ============================================
-- TP2: Hospital Management System Solutions
-- ============================================

-- 1. Database creation
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- 2. Table creation with constraints

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
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Required Indexes
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);

-- 4. Complete test data (Using North African Names)

-- Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('Médecine Générale', 'Soins de santé primaires', 1500.00),
('Cardiologie', 'Cœur et vaisseaux sanguins', 3000.00),
('Pédiatrie', 'Soins médicaux pour enfants', 2000.00),
('Dermatologie', 'Peau, cheveux et ongles', 2500.00),
('Orthopédie', 'Système musculo-squelettique', 2800.00),
('Gynécologie', 'Système reproducteur féminin', 2500.00);

-- Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Abidi', 'Ahmed', 'ahmed.abidi@hopital.dz', '0550123456', 1, 'LIC001', '2015-01-10', 'Bureau 101', TRUE),
('Benali', 'Sara', 'sara.benali@hopital.tn', '0216123457', 2, 'LIC002', '2016-03-15', 'Bureau 202', TRUE),
('Cherif', 'Mohamed', 'mohamed.cherif@hopital.ma', '0661123458', 3, 'LIC003', '2017-06-20', 'Bureau 303', TRUE),
('Dahmani', 'Amel', 'amel.dahmani@hopital.dz', '0550123459', 4, 'LIC004', '2018-09-25', 'Bureau 404', TRUE),
('Ezzine', 'Karim', 'karim.ezzine@hopital.tn', '0216123460', 5, 'LIC005', '2019-12-30', 'Bureau 505', TRUE),
('Fekir', 'Leila', 'leila.fekir@hopital.ma', '0661123461', 6, 'LIC006', '2020-02-14', 'Bureau 606', TRUE);

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, insurance, allergies) VALUES
('PAT001', 'Gherbi', 'Yacine', '1985-05-15', 'M', 'A+', 'yacine.gherbi@email.dz', '0551112233', 'Alger', 'Alger', 'CNAS', 'Pollen'),
('PAT002', 'Hadj', 'Fatima', '1992-11-20', 'F', 'O-', 'fatima.hadj@email.tn', '0216112234', 'Tunis', 'Tunis', 'CASNOS', NULL),
('PAT003', 'Idris', 'Omar', '2015-03-10', 'M', 'B+', 'omar.idris@email.ma', '0661112235', 'Casablanca', 'Casablanca', 'CNAS', 'Arachides'),
('PAT004', 'Jebbar', 'Meriem', '1970-08-05', 'F', 'AB+', 'meriem.jebbar@email.dz', '0551112236', 'Oran', 'Oran', NULL, 'Pénicilline'),
('PAT005', 'Kaci', 'Rachid', '1955-12-25', 'M', 'O+', 'rachid.kaci@email.tn', '0216112237', 'Sousse', 'Sousse', 'CNAS', NULL),
('PAT006', 'Lalami', 'Zineb', '2000-06-12', 'F', 'A-', 'zineb.lalami@email.ma', '0661112238', 'Rabat', 'Rabat', 'CASNOS', 'Poussière'),
('PAT007', 'Mansouri', 'Sami', '1988-01-30', 'M', 'B-', 'sami.mansouri@email.dz', '0551112239', 'Constantine', 'Constantine', 'CNAS', NULL),
('PAT008', 'Nait', 'Khadidja', '1995-04-18', 'F', 'O+', 'khadidja.nait@email.tn', '0216112240', 'Sfax', 'Sfax', NULL, NULL);

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:00:00', 'Fièvre et toux', 'Rhume commun', 'Completed', 1500.00, TRUE),
(2, 2, '2025-01-12 10:30:00', 'Douleur thoracique', 'Angine de poitrine', 'Completed', 3000.00, TRUE),
(3, 3, '2025-01-15 14:00:00', 'Examen de routine', 'En bonne santé', 'Completed', 2000.00, TRUE),
(4, 4, '2025-01-18 11:00:00', 'Éruption cutanée', 'Eczéma', 'Completed', 2500.00, FALSE),
(5, 5, '2025-01-20 15:30:00', 'Douleur au genou', 'Arthrite', 'Completed', 2800.00, TRUE),
(6, 6, '2025-01-22 09:45:00', 'Suivi de grossesse', 'Grossesse normale', 'Completed', 2500.00, TRUE),
(7, 1, '2025-02-01 10:00:00', 'Maux de tête', 'Migraine', 'Scheduled', 1500.00, FALSE),
(8, 2, '2025-02-05 11:30:00', 'Palpitations cardiaques', 'Lié au stress', 'Scheduled', 3000.00, FALSE);

-- Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, unit_price, available_stock, minimum_stock, expiration_date) VALUES
('MED001', 'Doliprane', 'Paracétamol', 'Comprimé', '500mg', 250.00, 100, 20, '2026-12-31'),
('MED002', 'Amoxicilline', 'Amoxicilline', 'Gélule', '500mg', 450.00, 50, 15, '2025-06-30'),
('MED003', 'Ventoline', 'Salbutamol', 'Inhalateur', '100mcg', 800.00, 30, 10, '2026-03-15'),
('MED004', 'Voltarène', 'Diclofénac', 'Gel', '1%', 600.00, 40, 10, '2025-11-20'),
('MED005', 'Gaviscon', 'Alginate de Sodium', 'Sirop', '250ml', 550.00, 25, 5, '2026-01-10'),
('MED006', 'Augmentin', 'Amoxicilline/Acide Clavulanique', 'Comprimé', '1g', 1200.00, 20, 10, '2025-08-15'),
('MED007', 'Spasfon', 'Phloroglucinol', 'Comprimé', '80mg', 350.00, 60, 20, '2027-05-20'),
('MED008', 'Mopral', 'Oméprazole', 'Gélule', '20mg', 900.00, 15, 10, '2025-04-10'),
('MED009', 'Clamoxyl', 'Amoxicilline', 'Poudre', '500mg', 400.00, 5, 10, '2025-09-12'),
('MED010', 'Zyrtec', 'Cétirizine', 'Comprimé', '10mg', 700.00, 45, 15, '2026-07-01');

-- Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(1, 5, 'Prendre après les repas'),
(2, 30, 'Éviter les exercices intenses'),
(4, 10, 'Appliquer deux fois par jour'),
(5, 15, 'Reposer le genou'),
(6, 90, 'Vitamines prénatales'),
(1, 7, 'Boire beaucoup d''eau'),
(2, 14, 'Surveiller la tension artérielle');

-- Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 2, '1 comprimé 3 fois par jour', 5, 500.00),
(1, 2, 1, '1 gélule deux fois par jour', 5, 450.00),
(2, 8, 1, '1 gélule par jour', 30, 900.00),
(3, 4, 1, 'Appliquer sur la zone affectée', 10, 600.00),
(4, 7, 2, '2 comprimés si nécessaire', 15, 700.00),
(5, 10, 1, '1 comprimé le soir', 90, 700.00),
(6, 1, 3, '1 comprimé 3 fois par jour', 7, 750.00),
(7, 2, 2, '1 gélule deux fois par jour', 14, 900.00),
(1, 10, 1, '1 comprimé par jour', 5, 700.00),
(2, 5, 1, '1 cuillère après les repas', 30, 550.00),
(3, 1, 1, '1 comprimé pour la douleur', 10, 250.00),
(4, 2, 1, '1 gélule deux fois par jour', 15, 450.00);

-- 5. 30 SQL Queries

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

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

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
       (SELECT CONCAT(d.last_name, ' ', d.first_name) FROM doctors d JOIN consultations c2 ON d.doctor_id = c2.doctor_id WHERE c2.patient_id = p.patient_id ORDER BY c2.consultation_date DESC LIMIT 1) AS doctor_name
FROM patients p 
LEFT JOIN consultations c ON p.patient_id = c.patient_id 
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
SELECT COUNT(medication_id) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value 
FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name, AVG(c.amount) AS average_price 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(patient_id) AS patient_count FROM patients GROUP BY blood_type;

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

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find patients who consulted more than the average
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS consultation_count, 
       (SELECT COUNT(*) / COUNT(DISTINCT patient_id) FROM consultations) AS average_count 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
GROUP BY p.patient_id 
HAVING consultation_count > average_count;

-- Q22. List medications more expensive than average price
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) AS average_price 
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, 
       (SELECT COUNT(*) FROM consultations c2 JOIN doctors d2 ON c2.doctor_id = d2.doctor_id WHERE d2.specialty_id = s.specialty_id) AS specialty_consultation_count 
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
WHERE p.allergies IS NOT NULL AND p.allergies <> '' 
GROUP BY p.patient_id;

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total_consultations, 
       SUM(c.amount) AS total_revenue 
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
FROM (SELECT COUNT(medication_id) AS med_count FROM prescription_details GROUP BY prescription_id) AS sub;

-- Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients)) AS percentage 
FROM patients 
GROUP BY age_group;
