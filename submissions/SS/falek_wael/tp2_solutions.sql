DROP DATABASE IF EXISTS hospital_management_system;
CREATE DATABASE hospital_management_system;
USE hospital_management_system;

CREATE TABLE med_specialties (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    info TEXT,
    fee DECIMAL(10, 2) NOT NULL
);

CREATE TABLE medical_doctors (
    doc_id INT PRIMARY KEY AUTO_INCREMENT,
    surname VARCHAR(50) NOT NULL,
    forename VARCHAR(50) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    spec_id INT NOT NULL,
    license_ref VARCHAR(20) UNIQUE NOT NULL,
    joining_date DATE,
    office_loc VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (spec_id) REFERENCES med_specialties(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE patient_records (
    pat_id INT PRIMARY KEY AUTO_INCREMENT,
    record_no VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    dob DATE NOT NULL,
    sex ENUM('M', 'F') NOT NULL,
    blood_grp VARCHAR(5),
    email VARCHAR(100),
    contact_no VARCHAR(20) NOT NULL,
    home_address TEXT,
    city_name VARCHAR(50),
    region VARCHAR(50),
    reg_date DATE DEFAULT (CURRENT_DATE),
    insurance_provider VARCHAR(100),
    policy_no VARCHAR(50),
    known_allergies TEXT,
    past_medical_history TEXT
);

CREATE TABLE medical_consultations (
    cons_id INT PRIMARY KEY AUTO_INCREMENT,
    p_id INT NOT NULL,
    d_id INT NOT NULL,
    cons_timestamp DATETIME NOT NULL,
    visit_reason TEXT NOT NULL,
    final_diagnosis TEXT,
    notes TEXT,
    bp_reading VARCHAR(20),
    temp_celsius DECIMAL(4, 2),
    weight_kg DECIMAL(5, 2),
    height_cm DECIMAL(5, 2),
    visit_status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    total_amount DECIMAL(10, 2),
    is_paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (p_id) REFERENCES patient_records(pat_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (d_id) REFERENCES medical_doctors(doc_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE pharmacy_inventory (
    med_id INT PRIMARY KEY AUTO_INCREMENT,
    med_ref_code VARCHAR(20) UNIQUE NOT NULL,
    brand_name VARCHAR(150) NOT NULL,
    chemical_name VARCHAR(150),
    med_form VARCHAR(50),
    strength VARCHAR(50),
    pharma_company VARCHAR(100),
    price_per_unit DECIMAL(10, 2) NOT NULL,
    stock_qty INT DEFAULT 0,
    min_stock_level INT DEFAULT 10,
    expiry DATE,
    needs_prescription BOOLEAN DEFAULT TRUE,
    is_reimbursable BOOLEAN DEFAULT FALSE
);

CREATE TABLE patient_prescriptions (
    rx_id INT PRIMARY KEY AUTO_INCREMENT,
    c_id INT NOT NULL,
    rx_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    days_duration INT,
    usage_guidelines TEXT,
    FOREIGN KEY (c_id) REFERENCES medical_consultations(cons_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE rx_line_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    rx_ref_id INT NOT NULL,
    medication_ref_id INT NOT NULL,
    qty_prescribed INT NOT NULL,
    usage_instructions VARCHAR(200) NOT NULL,
    days_to_take INT NOT NULL,
    line_total DECIMAL(10, 2),
    FOREIGN KEY (rx_ref_id) REFERENCES patient_prescriptions(rx_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_ref_id) REFERENCES pharmacy_inventory(med_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_qty_pos CHECK (qty_prescribed > 0)
);

CREATE INDEX idx_pat_names ON patient_records(last_name, first_name);
CREATE INDEX idx_cons_time ON medical_consultations(cons_timestamp);
CREATE INDEX idx_cons_pat ON medical_consultations(p_id);
CREATE INDEX idx_cons_doc ON medical_consultations(d_id);
CREATE INDEX idx_med_brands ON pharmacy_inventory(brand_name);
CREATE INDEX idx_rx_cons ON patient_prescriptions(c_id);

-- Insert medical specialties
INSERT INTO med_specialties (name, info, fee) VALUES
('Internal Medicine', 'Comprehensive adult healthcare', 1800.00),
('Neurology', 'Nervous system specialists', 3500.00),
('ENT', 'Ear, Nose, and Throat care', 2200.00),
('Ophthalmology', 'Eye care and surgery', 2600.00),
('Psychiatry', 'Mental health services', 3200.00),
('Urology', 'Urinary tract and male reproductive system', 2900.00);

-- Insert medical doctors (Arabic-style names)
INSERT INTO medical_doctors (surname, forename, email_address, phone_number, spec_id, license_ref, joining_date, office_loc, is_active) VALUES
('Falek', 'Wael', 'w.falek@med-center.dz', '0561223344', 1, 'DOC-2026-001', '2021-03-12', 'Wing A-10', 1),
('Kaddour', 'Abdelmalek', 'a.kaddour@med-center.dz', '0561334455', 2, 'DOC-2026-002', '2019-09-01', 'Wing B-05', 1),
('Benrahmoune', 'Anes', 'a.benrahmoune@med-center.dz', '0561445566', 3, 'DOC-2026-003', '2022-01-20', 'Wing C-12', 1),
('Ouerghi', 'Salma', 's.ouerghi@med-center.dz', '0561556677', 4, 'DOC-2026-004', '2020-06-15', 'Wing D-08', 1),
('Zouaoui', 'Tariq', 't.zouaoui@med-center.dz', '0561667788', 5, 'DOC-2026-005', '2018-11-10', 'Wing E-02', 1),
('Chebbi', 'Imene', 'i.chebbi@med-center.dz', '0561778899', 6, 'DOC-2026-006', '2023-04-05', 'Wing F-09', 1);

-- Insert patient records (Arabic-style names)
INSERT INTO patient_records (record_no, last_name, first_name, dob, sex, blood_grp, contact_no, city_name, reg_date, insurance_provider, known_allergies) VALUES
('FILE-001', 'Bouzar', 'Farid', '1988-04-15', 'M', 'O+', '0770123456', 'Algiers', '2024-02-01', 'MAIF', 'Peanuts'),
('FILE-002', 'Ait Lahcen', 'Rania', '2012-08-22', 'F', 'B+', '0770234567', 'Tipaza', '2024-03-10', 'CNAS', NULL),
('FILE-003', 'Mansouri', 'Said', '1962-12-05', 'M', 'A-', '0770345678', 'Boumerdes', '2023-11-15', 'CNAS', 'Latex'),
('FILE-004', 'Bendjaballah', 'Lydia', '1995-01-30', 'F', 'AB-', '0770456789', 'Tizi Ouzou', '2024-06-05', NULL, 'Aspirin'),
('FILE-005', 'Belkacem', 'Fouad', '1980-05-18', 'M', 'B-', '0770567890', 'Medea', '2024-04-22', 'CASNOS', NULL),
('FILE-006', 'Zemouri', 'Nadia', '2018-10-12', 'F', 'O-', '0770678901', 'Djelfa', '2024-07-01', 'CNAS', NULL),
('FILE-007', 'Bouzid', 'Youcef', '1970-03-25', 'M', 'A+', '0770789012', 'Chlef', '2024-02-28', 'MAIF', 'Shellfish'),
('FILE-008', 'Rahmani', 'Imene', '2000-07-08', 'F', 'AB+', '0770890123', 'Blida', '2024-05-12', 'CNAS', NULL);
-- Query 1
SELECT record_no, CONCAT(first_name, ' ', last_name) AS patient_full_name, dob, contact_no, city_name 
FROM patient_records;

-- Query 2
SELECT CONCAT('Dr. ', d.forename, ' ', d.surname) AS doctor_identity, s.name AS field_of_study, d.office_loc, d.is_active 
FROM medical_doctors d 
JOIN med_specialties s ON d.spec_id = s.id;

-- Query 3
SELECT med_ref_code, brand_name, price_per_unit, stock_qty 
FROM pharmacy_inventory 
WHERE price_per_unit < 500;

-- Query 4
SELECT c.cons_timestamp, CONCAT(p.first_name, ' ', p.last_name) AS patient, CONCAT(d.forename, ' ', d.surname) AS doctor, c.visit_status 
FROM medical_consultations c 
JOIN patient_records p ON c.p_id = p.pat_id 
JOIN medical_doctors d ON c.d_id = d.doc_id 
WHERE c.cons_timestamp BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';

-- Query 5
SELECT brand_name, stock_qty, min_stock_level, (min_stock_level - stock_qty) AS deficit 
FROM pharmacy_inventory 
WHERE stock_qty < min_stock_level;

-- Query 6
SELECT c.cons_timestamp, CONCAT(p.first_name, ' ', p.last_name) AS patient, CONCAT(d.forename, ' ', d.surname) AS physician, c.final_diagnosis, c.total_amount 
FROM medical_consultations c 
JOIN patient_records p ON c.p_id = p.pat_id 
JOIN medical_doctors d ON c.d_id = d.doc_id;

-- Query 7
SELECT p.first_name, p.last_name, m.brand_name, pd.qty_prescribed, pr.rx_timestamp
FROM rx_line_items pd 
JOIN patient_prescriptions pr ON pd.rx_ref_id = pr.rx_id 
JOIN medical_consultations c ON pr.c_id = c.cons_id 
JOIN patient_records p ON c.p_id = p.pat_id 
JOIN pharmacy_inventory m ON pd.medication_ref_id = m.med_id;

-- Query 8
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient, MAX(c.cons_timestamp) AS most_recent_visit
FROM patient_records p 
JOIN medical_consultations c ON p.pat_id = c.p_id 
GROUP BY p.pat_id;

-- Query 9
SELECT CONCAT(d.forename, ' ', d.surname) AS doctor, COUNT(c.cons_id) AS total_visits 
FROM medical_doctors d 
LEFT JOIN medical_consultations c ON d.doc_id = c.d_id 
GROUP BY d.doc_id;

-- Query 10
SELECT s.name AS department, SUM(c.total_amount) AS revenue_generated, COUNT(c.cons_id) AS visit_volume 
FROM med_specialties s 
JOIN medical_doctors d ON s.id = d.spec_id 
JOIN medical_consultations c ON d.doc_id = c.d_id 
GROUP BY s.id;

-- Query 11
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient, SUM(pd.line_total) AS total_rx_spend 
FROM patient_records p 
JOIN medical_consultations c ON p.pat_id = c.p_id 
JOIN patient_prescriptions pr ON c.cons_id = pr.c_id 
JOIN rx_line_items pd ON pr.rx_id = pd.rx_ref_id 
GROUP BY p.pat_id;

-- Query 12
SELECT CONCAT(d.forename, ' ', d.surname) AS physician, COUNT(c.cons_id) AS visit_count 
FROM medical_doctors d 
LEFT JOIN medical_consultations c ON d.doc_id = c.d_id 
GROUP BY d.doc_id;

-- Query 13
SELECT COUNT(*) AS unique_meds, SUM(price_per_unit * stock_qty) AS total_inventory_value 
FROM pharmacy_inventory;

-- Query 14
SELECT s.name AS specialty, ROUND(AVG(c.total_amount), 2) AS avg_fee 
FROM med_specialties s 
JOIN medical_doctors d ON s.id = d.spec_id 
JOIN medical_consultations c ON d.doc_id = c.d_id 
GROUP BY s.id;

-- Query 15
SELECT blood_grp, COUNT(*) AS frequency 
FROM patient_records 
GROUP BY blood_grp;

-- Query 16
SELECT m.brand_name AS drug, COUNT(pd.item_id) AS frequency_count, SUM(pd.qty_prescribed) AS units_issued 
FROM pharmacy_inventory m 
JOIN rx_line_items pd ON m.med_id = pd.medication_ref_id 
GROUP BY m.med_id 
ORDER BY frequency_count DESC 
LIMIT 5;

-- Query 17
SELECT CONCAT(first_name, ' ', last_name) AS patient, reg_date 
FROM patient_records 
WHERE pat_id NOT IN (SELECT DISTINCT p_id FROM medical_consultations);

-- Query 18
SELECT CONCAT(d.forename, ' ', d.surname) AS doctor, s.name AS field, COUNT(c.cons_id) AS visit_total 
FROM medical_doctors d 
JOIN med_specialties s ON d.spec_id = s.id 
JOIN medical_consultations c ON d.doc_id = c.d_id 
GROUP BY d.doc_id 
HAVING visit_total > 2;

-- Query 19
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient, c.cons_timestamp, c.total_amount, CONCAT(d.forename, ' ', d.surname) AS physician 
FROM medical_consultations c 
JOIN patient_records p ON c.p_id = p.pat_id 
JOIN medical_doctors d ON c.d_id = d.doc_id 
WHERE c.is_paid = 0;

-- Query 20
SELECT brand_name, expiry, DATEDIFF(expiry, CURDATE()) AS days_left 
FROM pharmacy_inventory 
WHERE expiry BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Query 21
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient, COUNT(c.cons_id) AS visit_count
FROM patient_records p 
JOIN medical_consultations c ON p.pat_id = c.p_id 
GROUP BY p.pat_id 
HAVING visit_count > (SELECT AVG(v_count) FROM (SELECT COUNT(*) as v_count FROM medical_consultations GROUP BY p_id) as stats);

-- Query 22
SELECT brand_name, price_per_unit
FROM pharmacy_inventory 
WHERE price_per_unit > (SELECT AVG(price_per_unit) FROM pharmacy_inventory);

-- Query 23
SELECT CONCAT(d.forename, ' ', d.surname) AS doctor, s.name AS specialty
FROM medical_doctors d 
JOIN med_specialties s ON d.spec_id = s.id 
WHERE s.id = (
    SELECT d_sub.spec_id 
    FROM medical_consultations c_sub 
    JOIN medical_doctors d_sub ON c_sub.d_id = d_sub.doc_id 
    GROUP BY d_sub.spec_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- Query 24
SELECT c.cons_timestamp, CONCAT(p.first_name, ' ', p.last_name) AS patient, c.total_amount
FROM medical_consultations c 
JOIN patient_records p ON c.p_id = p.pat_id 
WHERE c.total_amount > (SELECT AVG(total_amount) FROM medical_consultations);

-- Query 25
SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient, p.known_allergies, COUNT(pr.rx_id) AS rx_count 
FROM patient_records p 
JOIN medical_consultations c ON p.pat_id = c.p_id 
JOIN patient_prescriptions pr ON c.cons_id = pr.c_id 
WHERE p.known_allergies IS NOT NULL AND p.known_allergies != ''
GROUP BY p.pat_id;

-- Query 26
SELECT CONCAT(d.forename, ' ', d.surname) AS physician, COUNT(c.cons_id) AS settled_visits, SUM(c.total_amount) AS revenue_share 
FROM medical_doctors d 
JOIN medical_consultations c ON d.doc_id = c.d_id 
WHERE c.is_paid = 1 
GROUP BY d.doc_id;

-- Query 27
SELECT s.name AS specialty, SUM(c.total_amount) AS aggregate_revenue 
FROM med_specialties s 
JOIN medical_doctors d ON s.id = d.spec_id 
JOIN medical_consultations c ON d.doc_id = c.d_id 
GROUP BY s.id 
ORDER BY aggregate_revenue DESC
LIMIT 3;

-- Query 28
SELECT brand_name AS product, stock_qty AS current, min_stock_level AS threshold, (min_stock_level - stock_qty + 15) AS order_qty 
FROM pharmacy_inventory 
WHERE stock_qty < min_stock_level;

-- Query 29
SELECT ROUND(AVG(item_count), 2) AS avg_items_per_rx 
FROM (SELECT COUNT(*) as item_count FROM rx_line_items GROUP BY rx_ref_id) as rx_stats;

-- Query 30
SELECT 
    CASE 
        WHEN (YEAR(CURDATE()) - YEAR(dob)) <= 18 THEN 'Minor (0-18)'
        WHEN (YEAR(CURDATE()) - YEAR(dob)) <= 40 THEN 'Young Adult (19-40)'
        WHEN (YEAR(CURDATE()) - YEAR(dob)) <= 60 THEN 'Adult (41-60)'
        ELSE 'Senior (60+)'
    END AS demographic_group,
    COUNT(*) AS total_patients,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patient_records)), 2) AS pop_percentage
FROM patient_records 
GROUP BY demographic_group;
