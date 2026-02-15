-- ============================================
-- tp2_solutions.sql
-- TP2: Hospital Management System (MySQL 8+)
-- ============================================

/* ========== 0) DATABASE CREATION ========== */
DROP DATABASE IF EXISTS hospital_management_tp2;
CREATE DATABASE hospital_management_tp2
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE hospital_management_tp2;

/* ========== 1) TABLES ========== */

-- 1) specialties
CREATE TABLE specialties (
  specialty_id INT PRIMARY KEY AUTO_INCREMENT,
  specialty_name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  consultation_fee DECIMAL(10,2) NOT NULL
);

-- 2) doctors
CREATE TABLE doctors (
  doctor_id INT PRIMARY KEY AUTO_INCREMENT,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  phone VARCHAR(20),
  specialty_id INT NOT NULL,
  license_number VARCHAR(20) NOT NULL UNIQUE,
  hire_date DATE,
  office VARCHAR(100),
  active BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_doctors_specialty
    FOREIGN KEY (specialty_id)
    REFERENCES specialties(specialty_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- 3) patients
CREATE TABLE patients (
  patient_id INT PRIMARY KEY AUTO_INCREMENT,
  file_number VARCHAR(20) NOT NULL UNIQUE,
  last_name VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender ENUM('M','F') NOT NULL,
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

-- 4) consultations
CREATE TABLE consultations (
  consultation_id INT PRIMARY KEY AUTO_INCREMENT,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  consultation_date DATETIME NOT NULL,
  reason TEXT NOT NULL,
  diagnosis TEXT,
  observations TEXT,
  blood_pressure VARCHAR(20),
  temperature DECIMAL(4,2),
  weight DECIMAL(5,2),
  height DECIMAL(5,2),
  status ENUM('Scheduled','In Progress','Completed','Cancelled') DEFAULT 'Scheduled',
  amount DECIMAL(10,2),
  paid BOOLEAN DEFAULT FALSE,
  CONSTRAINT fk_consultations_patient
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_consultations_doctor
    FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- 5) medications
CREATE TABLE medications (
  medication_id INT PRIMARY KEY AUTO_INCREMENT,
  medication_code VARCHAR(20) NOT NULL UNIQUE,
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

-- 6) prescriptions
CREATE TABLE prescriptions (
  prescription_id INT PRIMARY KEY AUTO_INCREMENT,
  consultation_id INT NOT NULL,
  prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  treatment_duration INT, -- days
  general_instructions TEXT,
  CONSTRAINT fk_prescriptions_consultation
    FOREIGN KEY (consultation_id)
    REFERENCES consultations(consultation_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 7) prescription_details
CREATE TABLE prescription_details (
  detail_id INT PRIMARY KEY AUTO_INCREMENT,
  prescription_id INT NOT NULL,
  medication_id INT NOT NULL,
  quantity INT NOT NULL,
  dosage_instructions VARCHAR(200) NOT NULL,
  duration INT NOT NULL, -- days
  total_price DECIMAL(10,2),
  CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
  CONSTRAINT fk_details_prescription
    FOREIGN KEY (prescription_id)
    REFERENCES prescriptions(prescription_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_details_medication
    FOREIGN KEY (medication_id)
    REFERENCES medications(medication_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

/* ========== 2) REQUIRED INDEXES ========== */
CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_commercial_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);

/* ========== 3) TEST DATA INSERTS ========== */

-- Specialties (6)
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary care and general health assessment.', 2000.00),
('Cardiology', 'Heart and cardiovascular system care.', 3500.00),
('Pediatrics', 'Medical care for infants, children, and adolescents.', 2500.00),
('Dermatology', 'Skin, hair, and nail conditions.', 3000.00),
('Orthopedics', 'Bones, joints, ligaments, and muscles.', 3200.00),
('Gynecology', 'Women reproductive health and prenatal care.', 3300.00);

-- Doctors (6) one per specialty
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Benali',   'Sami',   'sami.benali@hospital.dz',   '0550-100-101', 1, 'LIC-GM-1001', '2021-03-15', 'Bldg A - Room 101', TRUE),
('Khelifi',  'Nadia',  'nadia.khelifi@hospital.dz','0550-100-102', 2, 'LIC-CAR-2001','2020-06-01', 'Bldg B - Room 210', TRUE),
('Mahmoudi', 'Yanis',  'yanis.mahmoudi@hospital.dz','0550-100-103',3, 'LIC-PED-3001','2022-01-10', 'Bldg C - Room 305', TRUE),
('Ait',      'Lina',   'lina.ait@hospital.dz',     '0550-100-104', 4, 'LIC-DER-4001','2019-09-20', 'Bldg D - Room 402', TRUE),
('Bouaziz',  'Karim',  'karim.bouaziz@hospital.dz','0550-100-105', 5, 'LIC-ORT-5001','2018-11-05', 'Bldg E - Room 115', TRUE),
('Saadi',    'Meriem', 'meriem.saadi@hospital.dz', '0550-100-106', 6, 'LIC-GYN-6001','2023-04-12', 'Bldg F - Room 220', TRUE);

-- Patients (8) various ages, blood types, allergies, insurance mix
INSERT INTO patients
(file_number,last_name,first_name,date_of_birth,gender,blood_type,email,phone,address,city,province,registration_date,insurance,insurance_number,allergies,medical_history)
VALUES
('FN-0001','Boukacem','Amine','2015-05-09','M','O+','amine.boukacem@mail.dz','0770-200-201','Cité 120 Logts','Algiers','Algiers','2024-12-10','CNAS','CNAS-778812','Peanuts','Asthma (mild)'),
('FN-0002','Haddad','Sara','1999-08-22','F','A+','sara.haddad@mail.dz','0770-200-202','Rue Didouche Mourad','Algiers','Algiers','2025-01-05',NULL,NULL,NULL,'No major history'),
('FN-0003','Ziani','Rachid','1978-02-14','M','B+','rachid.ziani@mail.dz','0770-200-203','Lotissement El Biar','Algiers','Algiers','2025-02-01','CNAS','CNAS-551100','Penicillin','Hypertension'),
('FN-0004','Toumi','Ines','2008-11-30','F','AB+','ines.toumi@mail.dz','0770-200-204','Hai 5 Juillet','Blida','Blida','2025-01-20','Private','PRV-204455','Dust','Eczema'),
('FN-0005','Bensaid','Kamel','1962-04-03','M','A-','kamel.bensaid@mail.dz','0770-200-205','Centre Ville','Oran','Oran','2024-10-18','CNAS','CNAS-900211',NULL,'Type 2 Diabetes'),
('FN-0006','Cherif','Aya','1987-07-17','F','O-','aya.cherif@mail.dz','0770-200-206','Nouvelle Ville','Constantine','Constantine','2025-01-11',NULL,NULL,'Latex','Migraine'),
('FN-0007','Mokhtar','Nour','1950-01-26','F','B-','nour.mokhtar@mail.dz','0770-200-207','Rue Emir Abdelkader','Setif','Setif','2024-09-02','Private','PRV-990012','Shellfish','Cardiac arrhythmia'),
('FN-0008','Larbi','Oussama','2003-03-02','M','O+','oussama.larbi@mail.dz','0770-200-208','Cité Universitaire','Tizi Ouzou','Tizi Ouzou','2025-02-10','CNAS','CNAS-112233',NULL,'Sports injury (knee, 2022)');

-- Consultations (8) mix completed/scheduled, dates, paid/unpaid, vitals
-- Note: amount set to match (or close to) specialty fee for realism
INSERT INTO consultations
(patient_id,doctor_id,consultation_date,reason,diagnosis,observations,blood_pressure,temperature,weight,height,status,amount,paid)
VALUES
(1,3,'2025-01-06 10:30:00','Fever and cough','Viral infection','Hydration advised','100/65',38.20,28.50,1.25,'Completed',2500.00,TRUE),
(2,1,'2025-01-18 09:00:00','General checkup',NULL,'Routine screening','110/70',36.70,58.00,1.64,'Completed',2000.00,FALSE),
(3,2,'2025-02-12 14:15:00','Chest discomfort','Possible angina','ECG recommended','145/90',37.10,82.30,1.72,'Completed',3500.00,TRUE),
(4,4,'2025-01-28 16:00:00','Skin rash','Dermatitis','Avoid allergens','105/68',36.90,44.20,1.50,'Completed',3000.00,FALSE),
(5,1,'2025-03-05 11:00:00','Fatigue and high glucose','Diabetes follow-up','Adjust diet','130/85',36.60,90.10,1.70,'Completed',2000.00,TRUE),
(6,6,'2025-02-20 13:30:00','Prenatal visit','Normal','Ultrasound scheduled','112/72',36.80,63.40,1.66,'Completed',3300.00,FALSE),
(7,2,'2025-04-10 08:45:00','Palpitations','Arrhythmia follow-up','Holter monitoring','150/95',36.90,70.00,1.60,'Scheduled',3500.00,FALSE),
(8,5,'2025-01-10 15:20:00','Knee pain','Ligament strain','Physiotherapy advised','120/75',36.70,75.50,1.78,'Completed',3200.00,TRUE);

-- Medications (10) prices/stock/forms/expirations
INSERT INTO medications
(medication_code,commercial_name,generic_name,form,dosage,manufacturer,unit_price,available_stock,minimum_stock,expiration_date,prescription_required,reimbursable)
VALUES
('MED-001','Paracetal 500','Paracetamol','Tablet','500mg','DZ Pharma',120.00,200,50,'2027-01-15',FALSE,TRUE),
('MED-002','AmoxiCaps','Amoxicillin','Capsule','500mg','MedAlger',380.00,25,40,'2026-07-01',TRUE,TRUE),
('MED-003','CoughStop','Dextromethorphan','Syrup','15mg/5ml','Saha Lab',450.00,12,20,'2026-05-20',FALSE,FALSE),
('MED-004','CardioPlus','Aspirin','Tablet','100mg','HeartCare',300.00,80,30,'2028-09-10',TRUE,TRUE),
('MED-005','Dermacort','Hydrocortisone','Cream','1%','DermaCo',600.00,8,15,'2026-04-30',TRUE,FALSE),
('MED-006','InsuControl','Metformin','Tablet','850mg','Glucare',520.00,60,40,'2027-11-05',TRUE,TRUE),
('MED-007','OrthoGel','Diclofenac','Gel','1%','OrthoMed',700.00,5,10,'2026-06-15',FALSE,FALSE),
('MED-008','PrenatalVit','Multivitamins','Tablet','Daily','VitaLab',480.00,100,30,'2027-03-01',FALSE,TRUE),
('MED-009','AntiAller','Cetirizine','Tablet','10mg','AllerFree',260.00,9,20,'2026-03-10',FALSE,TRUE),
('MED-010','ThermoScan','Ibuprofen','Tablet','400mg','DZ Pharma',220.00,150,40,'2027-08-18',FALSE,TRUE);

-- Prescriptions (7) linked to consultations
-- Linked to consultation_id: 1,2,3,4,5,6,8 (no prescription for con_

