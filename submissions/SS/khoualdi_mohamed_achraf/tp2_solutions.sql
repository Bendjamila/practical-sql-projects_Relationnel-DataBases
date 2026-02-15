-- TP2: Hospital Management System Solutions
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

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
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id) ON DELETE RESTRICT ON UPDATE CASCADE
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
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
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
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

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

CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);

-- Inserting Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES ('General Medicine', 'Primary care', 1500);

INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES ('Cardiology', 'Heart health', 3000);

INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES ('Pediatrics', 'Children care', 2000);

INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES ('Dermatology', 'Skin care', 2500);

INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES ('Orthopedics', 'Bone health', 3000);

INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES ('Gynecology', 'Women health', 2500);

-- Inserting Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES ('Ziane', 'Hichem', 'hichem.ziane37@example.dz', '0550987650', 1, 'LIC100', '2018-01-01', 'Office 101');

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES ('Bensmail', 'Brahim', 'brahim.bensmail44@example.dz', '0550987651', 2, 'LIC101', '2018-01-01', 'Office 102');

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES ('Mebarki', 'Hichem', 'hichem.mebarki45@example.dz', '0550987652', 3, 'LIC102', '2018-01-01', 'Office 103');

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES ('Cherif', 'Amine', 'amine.cherif89@example.dz', '0550987653', 4, 'LIC103', '2018-01-01', 'Office 104');

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES ('Ouali', 'Abdelkader', 'abdelkader.ouali54@example.dz', '0550987654', 5, 'LIC104', '2018-01-01', 'Office 105');

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES ('Belkacem', 'Karim', 'karim.belkacem48@example.dz', '0550987655', 6, 'LIC105', '2018-01-01', 'Office 106');

-- Inserting Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1000', 'Bouaziz', 'Ahmed', '1980-01-01', 'M', 'O-', 'ahmed.bouaziz65@example.dz', '0770123450', 'Constantine', 'Constantine', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1001', 'Belkacem', 'Rania', '1980-01-01', 'F', 'AB+', 'rania.belkacem23@example.dz', '0770123451', 'Constantine', 'Constantine', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1002', 'Bouaziz', 'Sofiane', '1980-01-01', 'M', 'B+', 'sofiane.bouaziz36@example.dz', '0770123452', 'Setif', 'Setif', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1003', 'Dahmani', 'Sarah', '1980-01-01', 'F', 'AB-', 'sarah.dahmani20@example.dz', '0770123453', 'Algiers', 'Algiers', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1004', 'Saidi', 'Karim', '1980-01-01', 'M', 'O+', 'karim.saidi98@example.dz', '0770123454', 'Annaba', 'Annaba', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1005', 'Saidi', 'Lydia', '1980-01-01', 'F', 'AB-', 'lydia.saidi94@example.dz', '0770123455', 'Annaba', 'Annaba', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1006', 'Amrani', 'Faycal', '1980-01-01', 'M', 'AB-', 'faycal.amrani52@example.dz', '0770123456', 'Algiers', 'Algiers', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1007', 'Mansouri', 'Meriem', '1980-01-01', 'F', 'O-', 'meriem.mansouri17@example.dz', '0770123457', 'Algiers', 'Algiers', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1008', 'Ziane', 'Amine', '1980-01-01', 'M', 'B-', 'amine.ziane36@example.dz', '0770123458', 'Setif', 'Setif', '2024-01-01');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, registration_date)
VALUES ('FILE1009', 'Cherif', 'Hiba', '1980-01-01', 'F', 'B+', 'hiba.cherif12@example.dz', '0770123459', 'Algiers', 'Algiers', '2024-01-01');

-- Inserting Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (1, 1, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, True);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (2, 2, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, True);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (3, 3, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, True);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (4, 4, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, True);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (5, 5, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, True);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (6, 6, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, True);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (7, 1, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, False);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (8, 2, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Completed', 2000, False);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (9, 3, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Scheduled', 2000, False);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, status, amount, paid)
VALUES (10, 4, '2025-01-10 10:00:00', 'Checkup', 'Healthy', 'Scheduled', 2000, False);

-- Inserting Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '500mg', 'Sanofi', 250, 100, 20, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED002', 'Amoxicilline', 'Amoxicillin', 'Capsule', '500mg', 'Saidal', 450, 50, 15, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED003', 'Spasfon', 'Phloroglucinol', 'Tablet', '80mg', 'Teva', 350, 80, 10, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED004', 'Voltarene', 'Diclofenac', 'Gel', '1%', 'Novartis', 600, 30, 5, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED005', 'Gaviscon', 'Sodium Alginate', 'Syrup', '250ml', 'Reckitt', 800, 40, 10, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED006', 'Ventoline', 'Salbutamol', 'Inhaler', '100mcg', 'GSK', 1200, 20, 5, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED007', 'Augmentin', 'Amoxicillin/Clavulanic', 'Tablet', '1g', 'GSK', 1500, 25, 10, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED008', 'Magne B6', 'Magnesium', 'Tablet', '50mg', 'Sanofi', 900, 60, 15, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED009', 'Clamoxyl', 'Amoxicillin', 'Syrup', '250mg', 'GSK', 550, 45, 10, '2026-12-31');

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date)
VALUES ('MED010', 'Zyrtec', 'Cetirizine', 'Tablet', '10mg', 'UCB', 700, 35, 5, '2026-12-31');

-- Inserting Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (1, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (2, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (3, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (4, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (5, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (6, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (7, 7, 'Take after meals');

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES (8, 7, 'Take after meals');

-- Inserting Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (1, 1, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 1));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (2, 2, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 2));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (3, 3, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 3));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (4, 4, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 4));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (5, 5, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 5));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (6, 6, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 6));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (7, 7, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 7));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (8, 8, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 8));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (1, 9, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 9));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (2, 10, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 10));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (3, 1, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 1));

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES (4, 2, 1, '1 tablet daily', 7, (SELECT unit_price FROM medications WHERE medication_id = 2));

-- ========== TP2 QUERIES SOLUTIONS ==========

-- Q1.
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city
FROM patients;

-- Q2.
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3.
SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications
WHERE unit_price < 500;

-- Q4.
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31';

-- Q5.
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- Q6.
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7.
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions
FROM prescription_details pd
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    MAX(c.consultation_date) AS last_consultation_date,
    (SELECT CONCAT(d.last_name, ' ', d.first_name)
     FROM doctors d
     JOIN consultations c2 ON d.doctor_id = c2.doctor_id
     WHERE c2.patient_id = p.patient_id
     ORDER BY c2.consultation_date DESC
     LIMIT 1) AS doctor_name
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id;

-- Q9.
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q10.
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q11.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, SUM(pd.total_price) AS total_prescription_cost
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id;

-- Q12.
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q13.
SELECT COUNT(*) AS total_medications, SUM(available_stock * unit_price) AS total_stock_value
FROM medications;

-- Q14.
SELECT s.specialty_name, AVG(c.amount) AS average_price
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q15.
SELECT blood_type, COUNT(*) AS patient_count
FROM patients
GROUP BY blood_type;

-- Q16.
SELECT m.commercial_name AS medication_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_quantity
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17.
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18.
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name AS specialty,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
HAVING consultation_count > 2;

-- Q19.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount,
    CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE;

-- Q20.
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration
FROM medications
WHERE expiration_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);

-- Q21.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    COUNT(c.consultation_id) AS consultation_count,
    (SELECT COUNT(*) / COUNT(DISTINCT patient_id) FROM consultations) AS average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
HAVING consultation_count > average_count;

-- Q22.
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23.
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name,
    (SELECT COUNT(*)
     FROM consultations c2
     JOIN doctors d2 ON c2.doctor_id = d2.doctor_id
     WHERE d2.specialty_id = s.specialty_id) AS specialty_consultation_count
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

-- Q24.
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount,
    (SELECT AVG(amount) FROM consultations) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25.
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies,
    COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies <> ''
GROUP BY p.patient_id;

-- Q26.
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27.
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) AS `rank`, s.specialty_name, SUM(c.amount) AS total_revenue
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
LIMIT 3;

-- Q28.
SELECT commercial_name, available_stock AS current_stock, minimum_stock,
    (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock;

-- Q29.
SELECT AVG(med_count) AS average_medications_per_prescription
FROM (
    SELECT COUNT(medication_id) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) AS subquery;

-- Q30.
SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    (COUNT(*) / (SELECT COUNT(*) FROM patients)) * 100 AS percentage
FROM patients
GROUP BY age_group;
