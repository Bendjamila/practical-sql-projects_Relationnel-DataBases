-- 1. DATABASE CREATION
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;
-- 2. TABLE CREATION WITH CONSTRAINTS
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
    status ENUM(
        'Scheduled',
        'In Progress',
        'Completed',
        'Cancelled'
    ) DEFAULT 'Scheduled',
    amount DECIMAL(10, 2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
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
-- 3. INDEX CREATION
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);
-- 4. TEST DATA INSERTION
-- Insert Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee)
VALUES (
        'General Medicine',
        'General health care and primary consultation',
        3000.00
    ),
    (
        'Cardiology',
        'Heart and cardiovascular system specialist',
        5000.00
    ),
    (
        'Pediatrics',
        'Medical care for infants, children and adolescents',
        3500.00
    ),
    (
        'Dermatology',
        'Skin, hair and nail conditions treatment',
        4000.00
    ),
    (
        'Orthopedics',
        'Musculoskeletal system and bone specialist',
        4500.00
    ),
    (
        'Gynecology',
        'Women reproductive health specialist',
        4000.00
    );
-- Insert Doctors
INSERT INTO doctors (
        last_name,
        first_name,
        email,
        phone,
        specialty_id,
        license_number,
        hire_date,
        office,
        active
    )
VALUES (
        'Benali',
        'Karim',
        'dr.benali@hospital.dz',
        '0555-100-200',
        1,
        'MED-2015-001',
        '2015-01-15',
        'Office 101',
        TRUE
    ),
    (
        'Lahlou',
        'Soraya',
        'dr.lahlou@hospital.dz',
        '0555-200-300',
        2,
        'CARD-2016-002',
        '2016-03-20',
        'Office 201',
        TRUE
    ),
    (
        'Amrani',
        'Nabil',
        'dr.amrani@hospital.dz',
        '0555-300-400',
        3,
        'PED-2017-003',
        '2017-05-10',
        'Office 102',
        TRUE
    ),
    (
        'Messaoudi',
        'Leila',
        'dr.messaoudi@hospital.dz',
        '0555-400-500',
        4,
        'DERM-2018-004',
        '2018-07-15',
        'Office 301',
        TRUE
    ),
    (
        'Khaled',
        'Rachid',
        'dr.khaled@hospital.dz',
        '0555-500-600',
        5,
        'ORTH-2019-005',
        '2019-09-01',
        'Office 401',
        TRUE
    ),
    (
        'Boumediene',
        'Amina',
        'dr.boumediene@hospital.dz',
        '0555-600-700',
        6,
        'GYN-2020-006',
        '2020-02-10',
        'Office 501',
        TRUE
    );
-- Insert Patients
INSERT INTO patients (
        file_number,
        last_name,
        first_name,
        date_of_birth,
        gender,
        blood_type,
        email,
        phone,
        address,
        city,
        province,
        registration_date,
        insurance,
        insurance_number,
        allergies,
        medical_history
    )
VALUES (
        'P2024-001',
        'Hamidi',
        'Mohamed',
        '1985-04-12',
        'M',
        'O+',
        'mohamed.hamidi@email.dz',
        '0666-111-001',
        '45 Rue Didouche Mourad',
        'Algiers',
        'Algiers',
        '2024-01-10',
        'CNAS',
        'CNAS-123456',
        'Penicillin',
        'Hypertension since 2020'
    ),
    (
        'P2024-002',
        'Cherif',
        'Fatima',
        '1990-08-25',
        'F',
        'A+',
        'fatima.cherif@email.dz',
        '0666-222-002',
        '78 Boulevard Mohamed V',
        'Oran',
        'Oran',
        '2024-02-15',
        'CASNOS',
        'CASNOS-789012',
        NULL,
        'None'
    ),
    (
        'P2024-003',
        'Bouazza',
        'Yacine',
        '2015-11-05',
        'M',
        'B+',
        'parent.bouazza@email.dz',
        '0666-333-003',
        '12 Rue de la Liberté',
        'Algiers',
        'Algiers',
        '2024-03-20',
        'CNAS',
        'CNAS-345678',
        'Peanuts',
        'Asthma'
    ),
    (
        'P2024-004',
        'Mansour',
        'Samira',
        '1978-02-18',
        'F',
        'AB+',
        'samira.mansour@email.dz',
        '0666-444-004',
        '33 Avenue Pasteur',
        'Constantine',
        'Constantine',
        '2024-04-05',
        NULL,
        NULL,
        'Sulfa drugs',
        'Diabetes Type 2'
    ),
    (
        'P2024-005',
        'Belkacem',
        'Ali',
        '1965-06-30',
        'M',
        'O-',
        'ali.belkacem@email.dz',
        '0666-555-005',
        '67 Rue des Martyrs',
        'Annaba',
        'Annaba',
        '2024-05-12',
        'CNAS',
        'CNAS-901234',
        NULL,
        'Cardiac arrhythmia'
    ),
    (
        'P2024-006',
        'Yahia',
        'Nadia',
        '1995-09-14',
        'F',
        'A-',
        'nadia.yahia@email.dz',
        '0666-666-006',
        '89 Rue Emir Abdelkader',
        'Algiers',
        'Algiers',
        '2024-06-18',
        'CASNOS',
        'CASNOS-567890',
        'Latex',
        'None'
    ),
    (
        'P2024-007',
        'Benamar',
        'Rachid',
        '2010-03-22',
        'M',
        'B-',
        'parent.benamar@email.dz',
        '0666-777-007',
        '56 Boulevard de la Victoire',
        'Blida',
        'Blida',
        '2024-07-25',
        'CNAS',
        'CNAS-234567',
        NULL,
        'Frequent ear infections'
    ),
    (
        'P2024-008',
        'Salmi',
        'Khadija',
        '1982-12-08',
        'F',
        'O+',
        'khadija.salmi@email.dz',
        '0666-888-008',
        '23 Rue Ben Boulaid',
        'Setif',
        'Setif',
        '2024-08-30',
        NULL,
        NULL,
        'Iodine',
        'Thyroid disorder'
    );
-- Insert Consultations
INSERT INTO consultations (
        patient_id,
        doctor_id,
        consultation_date,
        reason,
        diagnosis,
        observations,
        blood_pressure,
        temperature,
        weight,
        height,
        status,
        amount,
        paid
    )
VALUES (
        1,
        1,
        '2025-01-15 09:00:00',
        'Routine checkup and blood pressure monitoring',
        'Hypertension - well controlled with medication',
        'Patient reports feeling well. Continue current medication.',
        '130/85',
        36.6,
        78.5,
        175.0,
        'Completed',
        3000.00,
        TRUE
    ),
    (
        2,
        6,
        '2025-01-20 10:30:00',
        'Pregnancy consultation - first trimester',
        'Normal pregnancy progression',
        'Ultrasound scheduled for next visit. Prenatal vitamins prescribed.',
        '118/72',
        36.8,
        62.0,
        165.0,
        'Completed',
        4000.00,
        TRUE
    ),
    (
        3,
        3,
        '2025-01-25 14:00:00',
        'Asthma attack and difficulty breathing',
        'Acute asthma exacerbation',
        'Nebulizer treatment administered. Parent educated on inhaler use.',
        '110/70',
        37.2,
        35.0,
        145.0,
        'Completed',
        3500.00,
        TRUE
    ),
    (
        4,
        1,
        '2025-02-01 11:00:00',
        'Diabetes follow-up and medication adjustment',
        'Type 2 Diabetes - blood sugar not well controlled',
        'HbA1c elevated. Insulin dosage increased. Dietitian referral.',
        '145/90',
        36.5,
        82.0,
        160.0,
        'Completed',
        3000.00,
        FALSE
    ),
    (
        5,
        2,
        '2025-02-05 15:30:00',
        'Chest pain and irregular heartbeat',
        'Atrial fibrillation episode',
        'ECG performed. Medication adjusted. Follow-up in 2 weeks.',
        '150/95',
        36.9,
        85.0,
        172.0,
        'Completed',
        5000.00,
        TRUE
    ),
    (
        6,
        4,
        '2025-02-10 09:30:00',
        'Skin rash and itching on arms',
        'Contact dermatitis',
        'Likely allergic reaction. Avoid latex products. Topical treatment prescribed.',
        '120/75',
        36.7,
        58.0,
        168.0,
        'Completed',
        4000.00,
        FALSE
    ),
    (
        7,
        3,
        '2025-02-15 16:00:00',
        'Ear pain and fever',
        'Acute otitis media (ear infection)',
        'Right ear infected. Antibiotic prescribed. Return if no improvement in 3 days.',
        '105/65',
        38.1,
        32.0,
        138.0,
        'Completed',
        3500.00,
        TRUE
    ),
    (
        8,
        5,
        '2025-02-18 10:00:00',
        'Knee pain after fall',
        'Knee contusion - no fracture detected',
        'X-ray shows no fracture. RICE protocol. Pain management prescribed.',
        '128/82',
        36.6,
        68.0,
        158.0,
        'Scheduled',
        4500.00,
        FALSE
    );
-- Insert Medications
INSERT INTO medications (
        medication_code,
        commercial_name,
        generic_name,
        form,
        dosage,
        manufacturer,
        unit_price,
        available_stock,
        minimum_stock,
        expiration_date,
        prescription_required,
        reimbursable
    )
VALUES (
        'MED-001',
        'Doliprane 1000',
        'Paracetamol',
        'Tablet',
        '1000mg',
        'Sanofi',
        45.00,
        500,
        50,
        '2026-12-31',
        FALSE,
        TRUE
    ),
    (
        'MED-002',
        'Amoxil 500',
        'Amoxicillin',
        'Capsule',
        '500mg',
        'GlaxoSmithKline',
        180.00,
        300,
        30,
        '2026-08-30',
        TRUE,
        TRUE
    ),
    (
        'MED-003',
        'Ventoline',
        'Salbutamol',
        'Inhaler',
        '100mcg',
        'GlaxoSmithKline',
        320.00,
        150,
        20,
        '2027-03-31',
        TRUE,
        TRUE
    ),
    (
        'MED-004',
        'Glucophage 850',
        'Metformin',
        'Tablet',
        '850mg',
        'Merck',
        95.00,
        400,
        40,
        '2026-11-30',
        TRUE,
        TRUE
    ),
    (
        'MED-005',
        'Coversyl 5',
        'Perindopril',
        'Tablet',
        '5mg',
        'Servier',
        280.00,
        250,
        30,
        '2026-10-31',
        TRUE,
        TRUE
    ),
    (
        'MED-006',
        'Cardioaspirin 100',
        'Aspirin',
        'Tablet',
        '100mg',
        'Bayer',
        85.00,
        350,
        40,
        '2027-06-30',
        TRUE,
        TRUE
    ),
    (
        'MED-007',
        'Diprosone',
        'Betamethasone',
        'Cream',
        '0.05%',
        'MSD',
        420.00,
        100,
        15,
        '2026-09-30',
        TRUE,
        FALSE
    ),
    (
        'MED-008',
        'Augmentin 1g',
        'Amoxicillin + Clavulanic Acid',
        'Tablet',
        '1g',
        'GlaxoSmithKline',
        380.00,
        200,
        25,
        '2026-07-31',
        TRUE,
        TRUE
    ),
    (
        'MED-009',
        'Elevit Pronatal',
        'Prenatal Multivitamin',
        'Tablet',
        'Multiple',
        'Bayer',
        650.00,
        180,
        20,
        '2027-04-30',
        FALSE,
        FALSE
    ),
    (
        'MED-010',
        'Voltaren Emulgel',
        'Diclofenac',
        'Gel',
        '1%',
        'Novartis',
        580.00,
        120,
        15,
        '2026-12-31',
        FALSE,
        FALSE
    );
-- Insert Prescriptions
INSERT INTO prescriptions (
        consultation_id,
        prescription_date,
        treatment_duration,
        general_instructions
    )
VALUES (
        1,
        '2025-01-15 09:30:00',
        30,
        'Take medications with meals. Monitor blood pressure daily. Avoid high-salt foods.'
    ),
    (
        2,
        '2025-01-20 11:00:00',
        90,
        'Take prenatal vitamins daily. Maintain balanced diet. Schedule follow-up ultrasound.'
    ),
    (
        3,
        '2025-01-25 14:30:00',
        7,
        'Use inhaler as needed for breathing difficulty. Avoid cold air and exercise triggers.'
    ),
    (
        4,
        '2025-02-01 11:30:00',
        30,
        'Take diabetes medication before meals. Check blood sugar twice daily. Follow diet plan.'
    ),
    (
        5,
        '2025-02-05 16:00:00',
        30,
        'Take heart medication regularly. Avoid alcohol and caffeine. Rest adequately.'
    ),
    (
        6,
        '2025-02-10 10:00:00',
        14,
        'Apply cream to affected areas twice daily. Avoid latex products. Keep skin moisturized.'
    ),
    (
        7,
        '2025-02-15 16:30:00',
        7,
        'Complete full course of antibiotics. Apply warm compress to ear. Pain relief as needed.'
    );
-- Insert Prescription Details
INSERT INTO prescription_details (
        prescription_id,
        medication_id,
        quantity,
        dosage_instructions,
        duration,
        total_price
    )
VALUES -- Prescription 1: Hypertension follow-up
    (
        1,
        5,
        30,
        'Take 1 tablet once daily in the morning',
        30,
        8400.00
    ),
    (
        1,
        6,
        30,
        'Take 1 tablet once daily after dinner',
        30,
        2550.00
    ),
    -- Prescription 2: Pregnancy vitamins
    (
        2,
        9,
        90,
        'Take 1 tablet daily with breakfast',
        90,
        58500.00
    ),
    -- Prescription 3: Asthma treatment
    (
        3,
        3,
        1,
        'Use 2 puffs when needed, maximum 4 times daily',
        30,
        320.00
    ),
    (
        3,
        1,
        14,
        'Take 1 tablet every 6 hours if fever or pain',
        7,
        630.00
    ),
    -- Prescription 4: Diabetes management
    (
        4,
        4,
        60,
        'Take 1 tablet twice daily with meals',
        30,
        5700.00
    ),
    -- Prescription 5: Cardiac treatment
    (
        5,
        6,
        30,
        'Take 1 tablet daily after breakfast',
        30,
        2550.00
    ),
    (
        5,
        5,
        30,
        'Take 1 tablet daily in the morning',
        30,
        8400.00
    ),
    -- Prescription 6: Dermatitis treatment
    (
        6,
        7,
        1,
        'Apply thin layer to affected areas twice daily',
        14,
        420.00
    ),
    -- Prescription 7: Ear infection
    (
        7,
        8,
        14,
        'Take 1 tablet twice daily for 7 days',
        7,
        5320.00
    ),
    (
        7,
        1,
        20,
        'Take 1 tablet every 6 hours for pain or fever',
        7,
        900.00
    );
-- 5. SQL QUERIES (30 QUERIES)
-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========
-- Q1. List all patients with their basic information
SELECT file_number,
    last_name,
    first_name,
    date_of_birth,
    gender,
    phone,
    city
FROM patients
ORDER BY last_name,
    first_name;
-- Q2. Display all active doctors with their specialty
SELECT d.last_name,
    d.first_name,
    d.email,
    s.specialty_name,
    d.license_number
FROM doctors d
    JOIN specialties s ON d.specialty_id = s.specialty_id
WHERE d.active = TRUE
ORDER BY s.specialty_name,
    d.last_name;
-- Q3. Find all medications that require a prescription
SELECT medication_code,
    commercial_name,
    generic_name,
    unit_price,
    available_stock
FROM medications
WHERE prescription_required = TRUE
ORDER BY commercial_name;
-- Q4. List all completed consultations
SELECT consultation_id,
    consultation_date,
    reason,
    diagnosis,
    status
FROM consultations
WHERE status = 'Completed'
ORDER BY consultation_date DESC;
-- Q5. Display medications with low stock (below minimum)
SELECT commercial_name,
    available_stock,
    minimum_stock,
    (minimum_stock - available_stock) AS stock_deficit
FROM medications
WHERE available_stock < minimum_stock
ORDER BY stock_deficit DESC;
-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========
-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_id,
    CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    c.consultation_date,
    c.reason,
    c.status
FROM consultations c
    JOIN patients p ON c.patient_id = p.patient_id
    JOIN doctors d ON c.doctor_id = d.doctor_id
ORDER BY c.consultation_date DESC;
-- Q7. List all prescriptions with consultation details
SELECT pr.prescription_id,
    CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    pr.prescription_date,
    pr.treatment_duration
FROM prescriptions pr
    JOIN consultations c ON pr.consultation_id = c.consultation_id
    JOIN patients p ON c.patient_id = p.patient_id
    JOIN doctors d ON c.doctor_id = d.doctor_id
ORDER BY pr.prescription_date DESC;
-- Q8. Display prescription details with medication names
SELECT pd.detail_id,
    pr.prescription_id,
    m.commercial_name,
    pd.quantity,
    pd.dosage_instructions,
    pd.total_price
FROM prescription_details pd
    JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id
    JOIN medications m ON pd.medication_id = m.medication_id
ORDER BY pr.prescription_id,
    pd.detail_id;
-- Q9. List patients with their total consultation count
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    p.phone,
    COUNT(c.consultation_id) AS total_consultations
FROM patients p
    LEFT JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id,
    patient_name,
    p.phone
ORDER BY total_consultations DESC,
    patient_name;
-- Q10. Display doctors with their consultation count
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS consultations_count
FROM doctors d
    JOIN specialties s ON d.specialty_id = s.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id,
    doctor_name,
    s.specialty_name
ORDER BY consultations_count DESC;
-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========
-- Q11. Calculate total revenue from paid consultations
SELECT SUM(amount) AS total_revenue,
    COUNT(*) AS paid_consultations,
    ROUND(AVG(amount), 2) AS average_consultation_fee
FROM consultations
WHERE paid = TRUE;
-- Q12. Count patients by blood type
SELECT blood_type,
    COUNT(*) AS patient_count
FROM patients
WHERE blood_type IS NOT NULL
GROUP BY blood_type
ORDER BY patient_count DESC;
-- Q13. Calculate total value of medication inventory
SELECT SUM(unit_price * available_stock) AS total_inventory_value,
    COUNT(*) AS total_medications,
    ROUND(AVG(unit_price), 2) AS average_unit_price
FROM medications;
-- Q14. Find average consultation fee per specialty
SELECT s.specialty_name,
    s.consultation_fee,
    COUNT(c.consultation_id) AS consultations_performed,
    SUM(c.amount) AS total_earned
FROM specialties s
    LEFT JOIN doctors d ON s.specialty_id = d.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id,
    s.specialty_name,
    s.consultation_fee
ORDER BY total_earned DESC;
-- Q15. Calculate total prescription value per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    COUNT(DISTINCT pr.prescription_id) AS total_prescriptions,
    SUM(pd.total_price) AS total_medication_cost
FROM patients p
    JOIN consultations c ON p.patient_id = c.patient_id
    JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
    JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id,
    patient_name
ORDER BY total_medication_cost DESC;
-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========
-- Q16. Find top 3 most prescribed medications
SELECT m.commercial_name,
    m.generic_name,
    COUNT(pd.detail_id) AS times_prescribed,
    SUM(pd.quantity) AS total_quantity_prescribed
FROM medications m
    JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id,
    m.commercial_name,
    m.generic_name
ORDER BY times_prescribed DESC
LIMIT 3;
-- Q17. List patients with allergies
SELECT file_number,
    CONCAT(last_name, ' ', first_name) AS patient_name,
    allergies,
    phone
FROM patients
WHERE allergies IS NOT NULL
    AND allergies != ''
ORDER BY last_name;
-- Q18. Find unpaid consultations with patient contact info
SELECT c.consultation_id,
    c.consultation_date,
    CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    p.phone,
    p.email,
    c.amount AS amount_due
FROM consultations c
    JOIN patients p ON c.patient_id = p.patient_id
WHERE c.paid = FALSE
    AND c.status = 'Completed'
ORDER BY c.consultation_date;
-- Q19. Identify medications expiring within 6 months
SELECT commercial_name,
    expiration_date,
    available_stock,
    DATEDIFF(expiration_date, CURDATE()) AS days_until_expiry
FROM medications
WHERE expiration_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
ORDER BY days_until_expiry;
-- Q20. List doctors who haven't had consultations recently (last 30 days)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    s.specialty_name,
    d.email,
    MAX(c.consultation_date) AS last_consultation_date
FROM doctors d
    JOIN specialties s ON d.specialty_id = s.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE d.active = TRUE
GROUP BY d.doctor_id,
    doctor_name,
    s.specialty_name,
    d.email
HAVING last_consultation_date IS NULL
    OR last_consultation_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY)
ORDER BY last_consultation_date;
-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========
-- Q21. Find patients who spent more than average on consultations
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    SUM(c.amount) AS total_spent
FROM patients p
    JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id,
    patient_name
HAVING SUM(c.amount) > (
        SELECT AVG(total_per_patient)
        FROM (
                SELECT SUM(amount) AS total_per_patient
                FROM consultations
                GROUP BY patient_id
            ) AS patient_totals
    )
ORDER BY total_spent DESC;
-- Q22. List specialties with above-average consultation fees
SELECT specialty_name,
    consultation_fee,
    description
FROM specialties
WHERE consultation_fee > (
        SELECT AVG(consultation_fee)
        FROM specialties
    )
ORDER BY consultation_fee DESC;
-- Q23. Find medications more expensive than average in their form
SELECT m1.commercial_name,
    m1.form,
    m1.unit_price,
    (
        SELECT ROUND(AVG(m2.unit_price), 2)
        FROM medications m2
        WHERE m2.form = m1.form
    ) AS avg_price_for_form
FROM medications m1
WHERE m1.unit_price > (
        SELECT AVG(m2.unit_price)
        FROM medications m2
        WHERE m2.form = m1.form
    )
ORDER BY m1.form,
    m1.unit_price DESC;
-- Q24. Identify patients with no prescriptions
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    p.file_number,
    p.phone,
    COUNT(c.consultation_id) AS consultations_count
FROM patients p
    LEFT JOIN consultations c ON p.patient_id = c.patient_id
WHERE p.patient_id NOT IN (
        SELECT DISTINCT c2.patient_id
        FROM consultations c2
            JOIN prescriptions pr ON c2.consultation_id = pr.consultation_id
    )
GROUP BY p.patient_id,
    patient_name,
    p.file_number,
    p.phone
ORDER BY patient_name;
-- Q25. Find doctors with more consultations than their specialty average
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS consultation_count,
    (
        SELECT ROUND(AVG(consultation_count), 2)
        FROM (
                SELECT COUNT(c2.consultation_id) AS consultation_count
                FROM doctors d2
                    LEFT JOIN consultations c2 ON d2.doctor_id = c2.doctor_id
                WHERE d2.specialty_id = d.specialty_id
                GROUP BY d2.doctor_id
            ) AS specialty_avg
    ) AS specialty_average
FROM doctors d
    JOIN specialties s ON d.specialty_id = s.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id,
    doctor_name,
    s.specialty_name,
    d.specialty_id
HAVING consultation_count > (
        SELECT AVG(consultation_count)
        FROM (
                SELECT COUNT(c2.consultation_id) AS consultation_count
                FROM doctors d2
                    LEFT JOIN consultations c2 ON d2.doctor_id = c2.doctor_id
                WHERE d2.specialty_id = d.specialty_id
                GROUP BY d2.doctor_id
            ) AS specialty_avg
    )
ORDER BY consultation_count DESC;
-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========
-- Q26. Generate monthly revenue report
SELECT DATE_FORMAT(consultation_date, '%Y-%m') AS month,
    COUNT(consultation_id) AS total_consultations,
    SUM(
        CASE
            WHEN paid = TRUE THEN 1
            ELSE 0
        END
    ) AS paid_consultations,
    SUM(
        CASE
            WHEN paid = FALSE THEN 1
            ELSE 0
        END
    ) AS unpaid_consultations,
    SUM(amount) AS total_revenue,
    SUM(
        CASE
            WHEN paid = TRUE THEN amount
            ELSE 0
        END
    ) AS collected_revenue,
    SUM(
        CASE
            WHEN paid = FALSE THEN amount
            ELSE 0
        END
    ) AS pending_revenue
FROM consultations
WHERE status = 'Completed'
GROUP BY month
ORDER BY month DESC;
-- Q27. Patient demographics analysis
SELECT gender,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 18 THEN 'Child (0-17)'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 18 AND 35 THEN 'Young Adult (18-35)'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 36 AND 60 THEN 'Adult (36-60)'
        ELSE 'Senior (60+)'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(
        AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())),
        1
    ) AS average_age
FROM patients
GROUP BY gender,
    age_group
ORDER BY gender,
    age_group;
-- Q28. Doctor performance report
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS total_consultations,
    SUM(
        CASE
            WHEN c.status = 'Completed' THEN 1
            ELSE 0
        END
    ) AS completed,
    SUM(
        CASE
            WHEN c.status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS cancelled,
    SUM(
        CASE
            WHEN c.paid = TRUE THEN c.amount
            ELSE 0
        END
    ) AS revenue_generated,
    COUNT(DISTINCT pr.prescription_id) AS prescriptions_written
FROM doctors d
    JOIN specialties s ON d.specialty_id = s.specialty_id
    LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
    LEFT JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
GROUP BY d.doctor_id,
    doctor_name,
    s.specialty_name
ORDER BY total_consultations DESC;
-- Q29. Medication inventory alert report
SELECT commercial_name,
    form,
    available_stock,
    minimum_stock,
    CASE
        WHEN available_stock = 0 THEN 'OUT OF STOCK - CRITICAL'
        WHEN available_stock < minimum_stock * 0.5 THEN 'VERY LOW - ORDER URGENTLY'
        WHEN available_stock < minimum_stock THEN 'LOW - REORDER NEEDED'
        ELSE 'ADEQUATE'
    END AS stock_status,
    (minimum_stock * 2 - available_stock) AS suggested_order_quantity,
    unit_price * (minimum_stock * 2 - available_stock) AS estimated_order_cost
FROM medications
ORDER BY available_stock,
    commercial_name;
-- Q30. Complete patient medical summary (patient_id = 1)
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    p.date_of_birth,
    TIMESTAMPDIFF(YEAR, p.date_of_birth, CURDATE()) AS age,
    p.blood_type,
    p.allergies,
    COUNT(DISTINCT c.consultation_id) AS total_consultations,
    COUNT(DISTINCT pr.prescription_id) AS total_prescriptions,
    SUM(c.amount) AS total_medical_expenses,
    SUM(
        CASE
            WHEN c.paid = TRUE THEN c.amount
            ELSE 0
        END
    ) AS amount_paid,
    SUM(
        CASE
            WHEN c.paid = FALSE THEN c.amount
            ELSE 0
        END
    ) AS balance_due,
    GROUP_CONCAT(
        DISTINCT CONCAT(d.last_name, ' ', d.first_name) SEPARATOR ', '
    ) AS doctors_consulted
FROM patients p
    LEFT JOIN consultations c ON p.patient_id = c.patient_id
    LEFT JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
    LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE p.patient_id = 1
GROUP BY p.patient_id,
    patient_name,
    p.date_of_birth,
    p.blood_type,
    p.allergies;