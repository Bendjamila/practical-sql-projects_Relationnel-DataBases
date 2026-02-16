-- TP2: Gestion Hospitaliere
-- by: BENRAHMOUNE Anes

-- Creation de la base de donnees
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- Creation des tables

-- 1. Table Specialites
CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10, 2) NOT NULL
);

-- 2. Table Medecins
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
    CONSTRAINT fk_doc_spec FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Table Patients
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

-- 4. Table Consultations
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
    CONSTRAINT fk_cons_pat FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    CONSTRAINT fk_cons_doc FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE
);

-- 5. Table Medicaments
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

-- 6. Table Ordonnances
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    CONSTRAINT fk_presc_cons FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE
);

-- 7. Table Details Ordonnance
CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL,
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    CONSTRAINT chk_qty CHECK (quantity > 0),
    CONSTRAINT fk_det_presc FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
    CONSTRAINT fk_det_med FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE CASCADE
);

-- Indexation
CREATE INDEX idx_pat_name ON patients(last_name, first_name);
CREATE INDEX idx_cons_date ON consultations(consultation_date);
CREATE INDEX idx_cons_pat ON consultations(patient_id);
CREATE INDEX idx_cons_doc ON consultations(doctor_id);
CREATE INDEX idx_med_name ON medications(commercial_name);
CREATE INDEX idx_presc_cons ON prescriptions(consultation_id);

-- Insertion des donnees (Contexte Algerien)

-- Specialites
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('Medecine Generale', 'Suivi general', 1500.00),
('Cardiologie', 'Maladies du coeur', 3500.00),
('Pediatrie', 'Sante des enfants', 2000.00),
('Dermatologie', 'Maladies de la peau', 2500.00),
('Orthopedie', 'Chirurgie des os', 3000.00),
('Gynecologie', 'Sante de la femme', 3000.00);

-- Medecins
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office) VALUES
('Bennabi', 'Malek', 'm.bennabi@sante.dz', '0550112233', 1, 'LIC-2010-001', '2010-05-10', 'Cabinet 101'),
('Haddad', 'Leila', 'l.haddad@sante.dz', '0661223344', 2, 'LIC-2012-045', '2012-09-15', 'Cabinet 205'),
('Khellaf', 'Yacine', 'y.khellaf@sante.dz', '0772334455', 3, 'LIC-2015-089', '2015-02-01', 'Cabinet 108'),
('Bouhired', 'Djamila', 'd.bouhired@sante.dz', '0553445566', 4, 'LIC-2008-012', '2008-11-20', 'Cabinet 302'),
('Amrouche', 'Slimane', 's.amrouche@sante.dz', '0664556677', 5, 'LIC-2018-110', '2018-06-30', 'Cabinet 401'),
('Zebiri', 'Fatiha', 'f.zebiri@sante.dz', '0775667788', 6, 'LIC-2020-033', '2020-01-15', 'Cabinet 202');

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, phone, city, province, insurance, allergies) VALUES
('P-2025-001', 'Rahmani', 'Ahmed', '1985-03-12', 'M', 'O+', '0555001122', 'Alger', 'Alger', 'CNAS', 'Penicilline'),
('P-2025-002', 'Mansouri', 'Zohra', '1960-11-25', 'F', 'A-', '0666112233', 'Blida', 'Blida', 'CNAS', NULL),
('P-2025-003', 'Belhadj', 'Samy', '2018-05-14', 'M', 'B+', '0777223344', 'Boumerdes', 'Boumerdes', 'Mutuelle', 'Pollen'),
('P-2025-004', 'Guerroudj', 'Nassima', '1992-08-30', 'F', 'AB+', '0555334455', 'Tipaza', 'Tipaza', NULL, 'Noix'),
('P-2025-005', 'Boudiaf', 'Mohamed', '1955-12-05', 'M', 'O-', '0666445566', 'Msila', 'Msila', 'CNAS', 'Poussiere'),
('P-2025-006', 'Taleb', 'Meriem', '2022-04-18', 'F', 'A+', '0777556677', 'Alger', 'Alger', 'CNAS', NULL),
('P-2025-007', 'Kaci', 'Youcef', '1978-07-22', 'M', 'O+', '0555667788', 'Tizi Ouzou', 'Tizi Ouzou', 'CASNOS', NULL),
('P-2025-008', 'Amrani', 'Lina', '2000-01-10', 'F', 'B-', '0666778899', 'Oran', 'Oran', 'CNAS', 'Aspirine');

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid) VALUES
(1, 2, '2025-01-10 09:30:00', 'Douleurs thoraciques', 'Angine de poitrine', 'Completed', 3500.00, TRUE),
(2, 1, '2025-01-12 10:00:00', 'Controle tension', 'HTA', 'Completed', 1500.00, TRUE),
(3, 3, '2025-01-15 14:00:00', 'Fievre', 'Grippe', 'Completed', 2000.00, TRUE),
(4, 4, '2025-01-20 11:30:00', 'Eruption cutanee', 'Eczema', 'Completed', 2500.00, FALSE),
(5, 5, '2025-02-05 09:00:00', 'Douleur genou', 'Arthrose', 'Completed', 3000.00, TRUE),
(6, 3, '2025-02-10 15:30:00', 'Vaccination', 'Suivi', 'Completed', 2000.00, TRUE),
(7, 1, '2025-02-15 11:00:00', 'Fatigue', 'Anemie', 'In Progress', 1500.00, FALSE),
(8, 6, '2025-02-20 10:00:00', 'Controle annuel', NULL, 'Scheduled', 3000.00, FALSE);

-- Medicaments
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, unit_price, available_stock, minimum_stock, expiration_date, reimbursable) VALUES
('MED-001', 'Doliprane', 'Paracetamol', 'Comprime', '1g', 250.00, 100, 20, '2026-12-31', TRUE),
('MED-002', 'Amoxicilline', 'Amoxicilline', 'Gelule', '500mg', 450.00, 50, 15, '2025-06-30', TRUE),
('MED-003', 'Kardegic', 'Aspirine', 'Sachet', '75mg', 300.00, 80, 10, '2027-01-15', TRUE),
('MED-004', 'Amlor', 'Amlodipine', 'Gelule', '5mg', 1200.00, 30, 5, '2026-05-20', TRUE),
('MED-005', 'Maxilase', 'Alpha-amylase', 'Sirop', '200ml', 350.00, 40, 10, '2025-10-10', FALSE),
('MED-006', 'Betadine', 'Povidone iodee', 'Solution', '125ml', 600.00, 25, 5, '2028-03-15', FALSE),
('MED-007', 'Ventoline', 'Salbutamol', 'Aerosol', '100µg', 550.00, 15, 10, '2026-08-22', TRUE),
('MED-008', 'Voltarene', 'Diclofenac', 'Gel', '50g', 400.00, 60, 15, '2025-11-30', TRUE),
('MED-009', 'Gaviscon', 'Alginate', 'Suspension', '250ml', 750.00, 5, 10, '2025-04-01', TRUE),
('MED-010', 'Spasfon', 'Phloroglucinol', 'Comprime', '80mg', 380.00, 45, 10, '2027-09-12', TRUE);

-- Ordonnances
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(1, 30, 'Repos strict'),
(2, 90, 'Chaque matin'),
(3, 7, 'Boire beaucoup'),
(4, 15, 'Matin et soir'),
(5, 21, 'Eviter les efforts'),
(6, 1, 'Surveiller temperature'),
(7, 60, 'Prendre avec jus');

-- Details Ordonnance
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 3, 1, '1/jour', 30, 300.00),
(2, 4, 3, '1/jour', 90, 3600.00),
(3, 1, 2, '3/jour', 7, 500.00),
(3, 2, 2, '2/jour', 7, 900.00),
(4, 8, 1, 'Application locale', 15, 400.00),
(5, 1, 1, 'Si douleur', 10, 250.00),
(7, 10, 2, '2 en cas de crise', 30, 760.00),
(1, 1, 1, 'Si besoin', 10, 250.00),
(3, 5, 1, '3/jour', 5, 350.00),
(7, 1, 2, 'Matin et soir', 30, 500.00),
(2, 1, 1, 'Si maux de tete', 10, 250.00),
(5, 8, 1, 'Masser', 21, 400.00);

-- Solutions des requetes

-- Q1
SELECT file_number, CONCAT(last_name, ' ', first_name) AS nom, date_of_birth, phone, city FROM patients;

-- Q2
SELECT CONCAT(d.last_name, ' ', d.first_name) AS medecin, s.specialty_name, d.office, d.active 
FROM doctors d, specialties s WHERE d.specialty_id = s.specialty_id;

-- Q3
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4
SELECT consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient, 
       CONCAT(d.last_name, ' ', d.first_name) AS medecin, c.status 
FROM consultations c, patients p, doctors d 
WHERE c.patient_id = p.patient_id AND c.doctor_id = d.doctor_id 
AND c.consultation_date LIKE '2025-01%';

-- Q5
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS diff 
FROM medications WHERE available_stock < minimum_stock;

-- Q6
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient, 
       CONCAT(d.last_name, ' ', d.first_name) AS medecin, c.diagnosis, c.amount 
FROM consultations c, patients p, doctors d 
WHERE c.patient_id = p.patient_id AND c.doctor_id = d.doctor_id;

-- Q7
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient, 
       m.commercial_name, pd.quantity, pd.dosage_instructions 
FROM prescription_details pd, prescriptions pr, consultations c, patients p, medications m 
WHERE pd.prescription_id = pr.prescription_id AND pr.consultation_id = c.consultation_id 
AND c.patient_id = p.patient_id AND pd.medication_id = m.medication_id;

-- Q8
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient, MAX(c.consultation_date) AS derniere 
FROM patients p LEFT JOIN consultations c ON p.patient_id = c.patient_id 
GROUP BY p.patient_id;

-- Q9
SELECT CONCAT(d.last_name, ' ', d.first_name) AS medecin, COUNT(c.consultation_id) AS nb 
FROM doctors d LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id;

-- Q10
SELECT s.specialty_name, SUM(c.amount) AS revenu, COUNT(c.consultation_id) AS nb 
FROM specialties s, doctors d, consultations c 
WHERE s.specialty_id = d.specialty_id AND d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id;

-- Q11
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient, SUM(pd.total_price) AS total 
FROM patients p, consultations c, prescriptions pr, prescription_details pd 
WHERE p.patient_id = c.patient_id AND c.consultation_id = pr.consultation_id 
AND pr.prescription_id = pd.prescription_id 
GROUP BY p.patient_id;

-- Q12
SELECT CONCAT(d.last_name, ' ', d.first_name) AS medecin, COUNT(c.consultation_id) AS nb 
FROM doctors d LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id;

-- Q13
SELECT COUNT(*) AS nb_med, SUM(unit_price * available_stock) AS valeur_stock FROM medications;

-- Q14
SELECT s.specialty_name, AVG(c.amount) AS prix_moyen 
FROM specialties s, doctors d, consultations c 
WHERE s.specialty_id = d.specialty_id AND d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id;

-- Q15
SELECT blood_type, COUNT(*) AS nb FROM patients GROUP BY blood_type;

-- Q16
SELECT m.commercial_name, COUNT(pd.detail_id) AS nb, SUM(pd.quantity) AS total_qty 
FROM medications m, prescription_details pd 
WHERE m.medication_id = pd.medication_id 
GROUP BY m.medication_id ORDER BY nb DESC LIMIT 5;

-- Q17
SELECT CONCAT(last_name, ' ', first_name) AS patient, registration_date 
FROM patients WHERE patient_id NOT IN (SELECT patient_id FROM consultations);

-- Q18
SELECT CONCAT(d.last_name, ' ', d.first_name) AS medecin, COUNT(c.consultation_id) AS nb 
FROM doctors d, consultations c 
WHERE d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id HAVING nb > 2;

-- Q19
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient, c.consultation_date, c.amount 
FROM consultations c, patients p 
WHERE c.patient_id = p.patient_id AND c.paid = FALSE;

-- Q20
SELECT commercial_name, expiration_date 
FROM medications 
WHERE expiration_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);

-- Q21
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient, COUNT(c.consultation_id) AS nb 
FROM patients p, consultations c 
WHERE p.patient_id = c.patient_id 
GROUP BY p.patient_id 
HAVING nb > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM consultations GROUP BY patient_id) t);

-- Q22
SELECT commercial_name, unit_price FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23
SELECT CONCAT(d.last_name, ' ', d.first_name) AS medecin, s.specialty_name 
FROM doctors d, specialties s 
WHERE d.specialty_id = s.specialty_id AND s.specialty_id = (
    SELECT d2.specialty_id FROM consultations c2, doctors d2 
    WHERE c2.doctor_id = d2.doctor_id GROUP BY d2.specialty_id ORDER BY COUNT(*) DESC LIMIT 1
);

-- Q24
SELECT consultation_date, amount FROM consultations 
WHERE amount > (SELECT AVG(amount) FROM consultations);

-- Q25
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient, p.allergies, COUNT(pr.prescription_id) AS nb 
FROM patients p, consultations c, prescriptions pr 
WHERE p.patient_id = c.patient_id AND c.consultation_id = pr.consultation_id 
AND p.allergies IS NOT NULL GROUP BY p.patient_id;

-- Q26
SELECT CONCAT(d.last_name, ' ', d.first_name) AS medecin, SUM(c.amount) AS total 
FROM doctors d, consultations c 
WHERE d.doctor_id = c.doctor_id AND c.paid = TRUE 
GROUP BY d.doctor_id;

-- Q27
SELECT s.specialty_name, SUM(c.amount) AS total 
FROM specialties s, doctors d, consultations c 
WHERE s.specialty_id = d.specialty_id AND d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id ORDER BY total DESC LIMIT 3;

-- Q28
SELECT commercial_name, available_stock, minimum_stock 
FROM medications WHERE available_stock < minimum_stock;

-- Q29
SELECT AVG(nb) FROM (SELECT COUNT(*) as nb FROM prescription_details GROUP BY prescription_id) t;

-- Q30
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS nb
FROM patients GROUP BY age_group;
