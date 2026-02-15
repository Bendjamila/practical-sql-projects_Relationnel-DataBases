-- ============================================
-- TP2: Hospital Management System
-- Student: DJEDIDI Lina
-- ============================================

-- ============================================
-- Part I : DATABASE CREATION
-- ============================================
CREATE DATABASE hospital_db;

-- ============================================
-- TABLE 1: specialties
-- ============================================
CREATE TABLE specialties (
    specialty_id SERIAL PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

-- ============================================
-- TABLE 2: doctors
-- ============================================
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
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

-- ============================================
-- TABLE 3: patients
-- ============================================
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(1) NOT NULL
        CHECK (gender IN ('M','F')),
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

-- ============================================
-- TABLE 4: consultations
-- ============================================
CREATE TABLE consultations (
    consultation_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date TIMESTAMP NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,2),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    status VARCHAR(20) DEFAULT 'Scheduled'
        CHECK (status IN ('Scheduled','In Progress','Completed','Cancelled')),
    amount DECIMAL(10,2),
    paid BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_consult_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_consult_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- ============================================
-- TABLE 5: medications
-- ============================================
CREATE TABLE medications (
    medication_id SERIAL PRIMARY KEY,
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

-- ============================================
-- TABLE 6: prescriptions
-- ============================================
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    consultation_id INT NOT NULL,
    prescription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,

    CONSTRAINT fk_prescription_consultation
        FOREIGN KEY (consultation_id)
        REFERENCES consultations(consultation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================
-- TABLE 7: prescription_details
-- ============================================
CREATE TABLE prescription_details (
    detail_id SERIAL PRIMARY KEY,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),

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

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_patient_name
ON patients(last_name, first_name);

CREATE INDEX idx_consultation_date
ON consultations(consultation_date);

CREATE INDEX idx_consultation_patient
ON consultations(patient_id);

CREATE INDEX idx_consultation_doctor
ON consultations(doctor_id);

CREATE INDEX idx_medication_name
ON medications(commercial_name);

CREATE INDEX idx_prescription_consultation
ON prescriptions(consultation_id);

-- ============================================
-- Part II : DATA INSERTION
-- ============================================

-- ============================================
-- INSERT SPECIALTIES
-- ============================================

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('Cardiology', 'Heart and cardiovascular system specialist', 5000.00),
('Dermatology', 'Skin specialist', 3500.00),
('Pediatrics', 'Child healthcare specialist', 4000.00),
('General Medicine', 'Primary healthcare services', 3000.00),
('Neurology', 'Nervous system specialist', 6000.00);


-- ============================================
-- INSERT DOCTORS
-- ============================================

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office)
VALUES
('Benali', 'Karim', 'karim.benali@hospital.com', '0550000001', 1, 'LIC1001', '2018-03-15', 'A101'),
('Mansouri', 'Sofia', 'sofia.mansouri@hospital.com', '0550000002', 2, 'LIC1002', '2019-06-20', 'B201'),
('Rahmani', 'Yacine', 'yacine.rahmani@hospital.com', '0550000003', 3, 'LIC1003', '2020-01-10', 'C301'),
('Kaci', 'Nadia', 'nadia.kaci@hospital.com', '0550000004', 4, 'LIC1004', '2017-09-05', 'D401'),
('Haddad', 'Samir', 'samir.haddad@hospital.com', '0550000005', 5, 'LIC1005', '2016-11-12', 'E501');


-- ============================================
-- INSERT PATIENTS
-- ============================================

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, city, province, insurance)
VALUES
('P0001', 'Djedidi', 'Lina', '2002-05-14', 'F', 'A+', 'lina@email.com', '0661000001', 'Algiers', 'Algiers', 'CNAS'),
('P0002', 'Amrani', 'Youssef', '1998-08-22', 'M', 'O+', 'youssef@email.com', '0661000002', 'Oran', 'Oran', 'CASNOS'),
('P0003', 'Bouzid', 'Sara', '2010-03-10', 'F', 'B+', NULL, '0661000003', 'Constantine', 'Constantine', NULL),
('P0004', 'Khaled', 'Imane', '1985-12-01', 'F', 'AB+', 'imane@email.com', '0661000004', 'Blida', 'Blida', 'CNAS'),
('P0005', 'Hamzaoui', 'Adel', '1975-07-19', 'M', 'O-', 'adel@email.com', '0661000005', 'Setif', 'Setif', NULL);


-- ============================================
-- INSERT CONSULTATIONS
-- ============================================

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, temperature, weight, height, status, amount, paid)
VALUES
(1, 1, '2025-01-10 09:00:00', 'Chest pain', 'Mild arrhythmia', 37.2, 65.0, 165.0, 'Completed', 5000.00, TRUE),
(2, 2, '2025-01-11 11:30:00', 'Skin rash', 'Allergic reaction', 36.8, 70.0, 175.0, 'Completed', 3500.00, TRUE),
(3, 3, '2025-01-12 10:00:00', 'Fever', 'Viral infection', 38.5, 30.0, 120.0, 'Completed', 4000.00, FALSE),
(4, 4, '2025-01-13 14:00:00', 'Headache', 'Migraine', 36.9, 60.0, 160.0, 'Completed', 3000.00, TRUE),
(5, 5, '2025-01-14 15:30:00', 'Numbness', 'Nerve inflammation', 37.0, 80.0, 178.0, 'Scheduled', 6000.00, FALSE);


-- ============================================
-- INSERT MEDICATIONS
-- ============================================

INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, expiration_date)
VALUES
('MED001', 'CardioPlus', 'Atenolol', 'Tablet', '50mg', 'PharmaLab', 200.00, 100, '2026-12-31'),
('MED002', 'Dermacure', 'Hydrocortisone', 'Cream', '1%', 'SkinCare Inc', 150.00, 200, '2026-06-30'),
('MED003', 'Pediadol', 'Paracetamol', 'Syrup', '250mg', 'HealthPharm', 100.00, 150, '2027-01-15'),
('MED004', 'Neurovit', 'Vitamin B Complex', 'Capsule', '100mg', 'NeuroPharma', 180.00, 120, '2026-08-20');


-- ============================================
-- INSERT PRESCRIPTIONS
-- ============================================

INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions)
VALUES
(1, 30, 'Take medication daily after meals'),
(2, 7, 'Apply cream twice daily'),
(3, 5, 'Take syrup three times daily');


-- ============================================
-- INSERT PRESCRIPTION DETAILS
-- ============================================

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES
(1, 1, 30, '1 tablet per day', 30, 6000.00),
(2, 2, 1, 'Apply on affected area', 7, 150.00),
(3, 3, 2, '10ml three times daily', 5, 200.00);

-- ============================================
--  PART III : 30 SQL Queries Solution
-- ============================================


-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all patients with their main information
SELECT 
    file_number,
    last_name || ' ' || first_name AS full_name,
    date_of_birth,
    phone,
    city
FROM patients;


-- Q2. Display all doctors with their specialty
SELECT 
    d.last_name || ' ' || d.first_name AS doctor_name,
    s.specialty_name,
    d.office,
    d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;


-- Q3. Find all medications with price less than 500 DA
SELECT 
    medication_code,
    commercial_name,
    unit_price,
    available_stock
FROM medications
WHERE unit_price < 500;


-- Q4. List consultations from January 2025
SELECT 
    c.consultation_date,
    p.last_name || ' ' || p.first_name AS patient_name,
    d.last_name || ' ' || d.first_name AS doctor_name,
    c.status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.consultation_date 
BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';


-- Q5. Display medications where stock is below minimum stock
SELECT 
    commercial_name,
    available_stock,
    minimum_stock,
    (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;



-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all consultations with patient and doctor names
SELECT 
    c.consultation_date,
    p.last_name || ' ' || p.first_name AS patient_name,
    d.last_name || ' ' || d.first_name AS doctor_name,
    c.diagnosis,
    c.amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;


-- Q7. List all prescriptions with medication details
SELECT 
    pr.prescription_date,
    pa.last_name || ' ' || pa.first_name AS patient_name,
    m.commercial_name AS medication_name,
    pd.quantity,
    pd.dosage_instructions
FROM prescriptions pr
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients pa ON c.patient_id = pa.patient_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id;


-- Q8. Display patients with their last consultation date
SELECT 
    p.last_name || ' ' || p.first_name AS patient_name,
    MAX(c.consultation_date) AS last_consultation_date
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id, patient_name;


-- Q9. List doctors and the number of consultations performed
SELECT 
    d.last_name || ' ' || d.first_name AS doctor_name,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, doctor_name
ORDER BY consultation_count DESC;


-- Q10. Display revenue by medical specialty
SELECT 
    s.specialty_name,
    SUM(c.amount) AS total_revenue,
    COUNT(c.consultation_id) AS consultation_count
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.status = 'Completed'
GROUP BY s.specialty_name
ORDER BY total_revenue DESC;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate total prescription amount per patient
SELECT 
    p.last_name || ' ' || p.first_name AS patient_name,
    COALESCE(SUM(pd.total_price), 0) AS total_prescription_cost
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
LEFT JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id, patient_name
ORDER BY total_prescription_cost DESC;


-- Q12. Count the number of consultations per doctor
SELECT 
    d.last_name || ' ' || d.first_name AS doctor_name,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, doctor_name
ORDER BY consultation_count DESC;


-- Q13. Calculate total stock value of pharmacy
SELECT 
    COUNT(*) AS total_medications,
    SUM(unit_price * available_stock) AS total_stock_value
FROM medications;


-- Q14. Find average consultation price per specialty
SELECT 
    s.specialty_name,
    AVG(c.amount) AS average_price
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.status = 'Completed'
GROUP BY s.specialty_name
ORDER BY average_price DESC;


-- Q15. Count number of patients by blood type
SELECT 
    blood_type,
    COUNT(*) AS patient_count
FROM patients
GROUP BY blood_type
ORDER BY patient_count DESC;



-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 5 most prescribed medications
SELECT 
    m.commercial_name AS medication_name,
    COUNT(pd.prescription_id) AS times_prescribed,
    SUM(pd.quantity) AS total_quantity
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id, medication_name
ORDER BY total_quantity DESC
LIMIT 5;


-- Q17. List patients who have never had a consultation
SELECT 
    p.last_name || ' ' || p.first_name AS patient_name,
    p.registration_date
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
WHERE c.consultation_id IS NULL;


-- Q18. Display doctors who performed more than 2 consultations
SELECT 
    d.last_name || ' ' || d.first_name AS doctor_name,
    s.specialty_name AS specialty,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, doctor_name, specialty
HAVING COUNT(c.consultation_id) > 2
ORDER BY consultation_count DESC;


-- Q19. Find unpaid consultations with total amount
SELECT 
    p.last_name || ' ' || p.first_name AS patient_name,
    c.consultation_date,
    c.amount,
    d.last_name || ' ' || d.first_name AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE
ORDER BY c.consultation_date;


-- Q20. List medications expiring in less than 6 months from today
SELECT 
    commercial_name AS medication_name,
    expiration_date,
    (expiration_date - CURRENT_DATE) AS days_until_expiration
FROM medications
WHERE expiration_date <= CURRENT_DATE + INTERVAL '6 months'
ORDER BY expiration_date;


-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find patients who consulted more than the average
SELECT 
    p.last_name || ' ' || p.first_name AS patient_name,
    COUNT(c.consultation_id) AS consultation_count,
    (
        SELECT AVG(consult_count)
        FROM (
            SELECT COUNT(*) AS consult_count
            FROM consultations
            GROUP BY patient_id
        ) sub
    ) AS average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id, patient_name
HAVING COUNT(c.consultation_id) >
(
    SELECT AVG(consult_count)
    FROM (
        SELECT COUNT(*) AS consult_count
        FROM consultations
        GROUP BY patient_id
    ) sub
);


-- Q22. List medications more expensive than average price
SELECT 
    commercial_name AS medication_name,
    unit_price,
    (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);


-- Q23. Display doctors from the most requested specialty
SELECT 
    d.last_name || ' ' || d.first_name AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS specialty_consultation_count
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, specialty_name, d.doctor_id, doctor_name
HAVING COUNT(c.consultation_id) =
(
    SELECT MAX(spec_count)
    FROM (
        SELECT COUNT(*) AS spec_count
        FROM consultations c2
        JOIN doctors d2 ON c2.doctor_id = d2.doctor_id
        GROUP BY d2.specialty_id
    ) sub
);


-- Q24. Find consultations with amount higher than average
SELECT 
    c.consultation_date,
    p.last_name || ' ' || p.first_name AS patient_name,
    c.amount,
    (SELECT AVG(amount) FROM consultations) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations);


-- Q25. List allergic patients who received a prescription
SELECT 
    p.last_name || ' ' || p.first_name AS patient_name,
    p.allergies,
    COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL
GROUP BY p.patient_id, patient_name, p.allergies;



-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT 
    d.last_name || ' ' || d.first_name AS doctor_name,
    COUNT(c.consultation_id) AS total_consultations,
    SUM(c.amount) AS total_revenue
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id, doctor_name
ORDER BY total_revenue DESC;


-- Q27. Display top 3 most profitable specialties
SELECT 
    RANK() OVER (ORDER BY SUM(c.amount) DESC) AS rank,
    s.specialty_name,
    SUM(c.amount) AS total_revenue
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY s.specialty_name
ORDER BY total_revenue DESC
LIMIT 3;


-- Q28. List medications to restock (stock < minimum)
SELECT 
    commercial_name AS medication_name,
    available_stock AS current_stock,
    minimum_stock,
    (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock
ORDER BY quantity_needed DESC;


-- Q29. Calculate average number of medications per prescription
SELECT 
    AVG(med_count) AS average_medications_per_prescription
FROM (
    SELECT COUNT(*) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) sub;


-- Q30. Generate patient demographics report by age group
SELECT 
    age_group,
    COUNT(*) AS patient_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM (
    SELECT 
        CASE 
            WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 0 AND 18 THEN '0-18'
            WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 19 AND 40 THEN '19-40'
            WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 41 AND 60 THEN '41-60'
            ELSE '60+'
        END AS age_group
    FROM patients
) sub
GROUP BY age_group
ORDER BY age_group;
