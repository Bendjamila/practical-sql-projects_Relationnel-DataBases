
-- TP2: Hospital Management System
-- please madame use  tp2_hospital.sql | sqlite3 database_two.db OR add "cat" at the beggining if you are using powershell to create tables for this exact script
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS prescription_details;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS consultations;
DROP TABLE IF EXISTS medications;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS specialties;

-- Tables
CREATE TABLE specialties (
    specialty_id INTEGER PRIMARY KEY AUTOINCREMENT,
    specialty_name TEXT UNIQUE NOT NULL,
    description TEXT,
    consultation_fee REAL NOT NULL
);

CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    specialty_id INTEGER NOT NULL,
    license_number TEXT UNIQUE NOT NULL,
    hire_date TEXT,
    office TEXT,
    active INTEGER DEFAULT 1,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    file_number TEXT UNIQUE NOT NULL,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    date_of_birth TEXT NOT NULL,
    gender TEXT CHECK(gender IN ('M', 'F')),
    blood_type TEXT,
    email TEXT,
    phone TEXT NOT NULL,
    address TEXT,
    city TEXT,
    province TEXT,
    registration_date TEXT DEFAULT CURRENT_DATE,
    insurance TEXT,
    insurance_number TEXT,
    allergies TEXT,
    medical_history TEXT
);

CREATE TABLE consultations (
    consultation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    consultation_date TEXT NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure TEXT,
    temperature REAL,
    weight REAL,
    height REAL,
    status TEXT DEFAULT 'Scheduled' CHECK(status IN ('Scheduled','In Progress','Completed','Cancelled')),
    amount REAL,
    paid INTEGER DEFAULT 0,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT
);

CREATE TABLE medications (
    medication_id INTEGER PRIMARY KEY AUTOINCREMENT,
    medication_code TEXT UNIQUE NOT NULL,
    commercial_name TEXT NOT NULL,
    generic_name TEXT,
    form TEXT,
    dosage TEXT,
    manufacturer TEXT,
    unit_price REAL NOT NULL,
    available_stock INTEGER DEFAULT 0,
    minimum_stock INTEGER DEFAULT 10,
    expiration_date TEXT,
    prescription_required INTEGER DEFAULT 1,
    reimbursable INTEGER DEFAULT 0
);

CREATE TABLE prescriptions (
    prescription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    consultation_id INTEGER NOT NULL,
    prescription_date TEXT DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INTEGER,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE
);

CREATE TABLE prescription_details (
    detail_id INTEGER PRIMARY KEY AUTOINCREMENT,
    prescription_id INTEGER NOT NULL,
    medication_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    dosage_instructions TEXT NOT NULL,
    duration INTEGER NOT NULL,
    total_price REAL,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT
);

-- Indexes
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consult_date ON consultations(consultation_date);
CREATE INDEX idx_consult_patient ON consultations(patient_id);
CREATE INDEX idx_consult_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consult ON prescriptions(consultation_id);

-- Test Data
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'routine checkups', 1500), ('pediatrics', 'kids doctor', 1200),
('Cardiology', 'heart stuff', 3000), ('Dermatology', 'skin and hair', 2000),
('orthopedics', 'bones', 2500), ('GYNECOLOGY', 'womens health', 2500);

INSERT INTO doctors (last_name, first_name, email, specialty_id, license_number, office) VALUES
('bensalem', 'Noureddine', 'nourredine.b@hosp.dz', 1, 'lic-001', 'Room A1'), ('Saidi', 'amina', 'a.saidi@hospital.dz', 2, 'lic-002', 'B202'),
('RAHMANI', 'Karim', 'k.rahmani@hosp.dz', 3, 'lic-003', 'off-303'), ('Belkacem', 'Lina', 'linabelk@gmail.com', 4, 'lic-004', 'D404'),
('zitouni', 'sofiane', 's.zitouni@hosp.dz', 5, 'lic-005', 'E-505'), ('moussa', 'NADIA', 'nadiam@hosp.dz', 6, 'lic-006', 'F606');

INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, phone, city, allergies) VALUES
('p_001', 'Meziane', 'yacine', '1988-05-12', 'M', '06612233', 'Algeirs', 'none'),
('p_002', 'kaci', 'Rania', '2012-11-30', 'F', '06614455', 'oran', 'Penicillin'),
('p_003', 'SAAD', 'Karim', '1975-02-20', 'M', '06616677', 'Setif', 'None'),
('p_004', 'Yahia', 'Lina', '1999-07-07', 'F', '06618899', 'Blida', 'sulfa meds'),
('p_005', 'Benali', 'Omar', '2016-01-15', 'M', '05501122', 'bejaia', 'None'),
('p_006', 'cherif', 'Meriem', '1995-04-22', 'F', '05503344', 'Algeirs', 'N/A'),
('p_007', 'Zouaoui', 'samir', '2010-12-01', 'M', '05505566', 'Annaba', 'none'),
('p_008', 'Djerbi', 'sofia', '1985-08-08', 'F', '05507788', 'Oran', 'aspirine');

INSERT INTO medications (medication_code, commercial_name, unit_price, available_stock, minimum_stock) VALUES
('m-101', 'paracetamol 500', 450, 100, 20), ('m-102', 'Amoxicilline', 1200, 50, 10),
('m-103', 'ibuprofene', 300, 200, 30), ('m-104', 'Omeprazole', 2000, 5, 10),
('m-105', 'Aspirine', 250, 10, 20), ('m-106', 'salbutamol spray', 5000, 15, 5),
('m-107', 'Metformine', 800, 80, 20), ('m-108', 'Lisinopril', 1100, 25, 10),
('m-109', 'Cetirizine', 600, 40, 10), ('m-110', 'ventoline', 1500, 12, 5);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, status, amount, paid) VALUES
(1, 1, '2025-01-10', 'Monthly checkup', 'Completed', 1500, 1), (2, 2, '2025-01-15', 'flu and fever', 'Completed', 1200, 1),
(3, 3, '2025-01-20', 'chest pain', 'Completed', 3000, 1), (4, 4, '2025-01-25', 'skin rash', 'Completed', 2000, 1),
(5, 2, '2025-02-01', 'checkup', 'Scheduled', 1200, 0), (6, 6, '2025-02-05', 'consultation', 'Completed', 2500, 1),
(7, 5, '2025-02-10', 'broken arm', 'Completed', 2500, 1), (8, 1, '2025-02-12', 'stomach ache', 'Completed', 1500, 1);

INSERT INTO prescriptions (consultation_id, treatment_duration) VALUES
(1, 7), (2, 5), (3, 30), (4, 10), (6, 7), (7, 15), (8, 5);

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration) VALUES
(1, 1, 10, '1 pill twice a day', 5), (1, 9, 5, 'at night', 5), (2, 2, 14, '2 caps morning/night', 7),
(3, 8, 30, 'once daily', 30), (3, 7, 60, 'morning and evening', 30), (4, 3, 20, 'when needed', 10),
(5, 1, 10, 'twice a day', 5), (6, 5, 15, 'daily', 15), (7, 10, 1, '2 inhalations', 5),
(7, 6, 1, '1 puff', 5), (1, 3, 10, 'twice a day', 5), (2, 1, 10, 'twice a day', 5);

-- Solutions Q1-Q30
-- Q1
SELECT file_number, last_name || ' ' || first_name AS full_name, date_of_birth, phone, city FROM patients;
-- Q2
SELECT d.last_name || ' ' || d.first_name AS doctor_name, s.specialty_name, d.office, d.active FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id;
-- Q3
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;
-- Q4
SELECT consultation_date, p.last_name || ' ' || p.first_name AS patient_name, d.last_name || ' ' || d.first_name AS doctor_name, status FROM consultations c JOIN patients p ON c.patient_id = p.patient_id JOIN doctors d ON c.doctor_id = d.doctor_id WHERE consultation_date LIKE '2025-01%';
-- Q5
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference FROM medications WHERE available_stock < minimum_stock;
-- Q6
SELECT consultation_date, p.last_name || ' ' || p.first_name AS patient_name, d.last_name || ' ' || d.first_name AS doctor_name, diagnosis, amount FROM consultations c JOIN patients p ON c.patient_id = p.patient_id JOIN doctors d ON c.doctor_id = d.doctor_id;
-- Q7
SELECT pr.prescription_date, p.last_name || ' ' || p.first_name AS patient_name, m.commercial_name, pd.quantity, pd.dosage_instructions FROM prescription_details pd JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id JOIN medications m ON pd.medication_id = m.medication_id JOIN consultations c ON pr.consultation_id = c.consultation_id JOIN patients p ON c.patient_id = p.patient_id;
-- Q8
SELECT p.last_name || ' ' || p.first_name AS patient_name, MAX(c.consultation_date) AS last_consultation_date, d.last_name || ' ' || d.first_name AS doctor_name FROM patients p JOIN consultations c ON p.patient_id = c.patient_id JOIN doctors d ON c.doctor_id = d.doctor_id GROUP BY p.patient_id;
-- Q9
SELECT d.last_name || ' ' || d.first_name AS doctor_name, COUNT(c.consultation_id) AS consult_count FROM doctors d LEFT JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY d.doctor_id;
-- Q10
SELECT s.specialty_name, SUM(c.amount) AS total_revenue FROM specialties s JOIN doctors d ON s.specialty_id = d.specialty_id JOIN consultations c ON d.doctor_id = c.doctor_id WHERE c.paid = 1 GROUP BY s.specialty_name;
-- Q11
SELECT AVG(amount) AS average_consultation_cost FROM consultations;
-- Q12
SELECT city, COUNT(*) AS patient_count FROM patients GROUP BY city;
-- Q13
SELECT m.commercial_name, COUNT(pd.detail_id) AS times_prescribed FROM medications m JOIN prescription_details pd ON m.medication_id = pd.medication_id GROUP BY m.medication_id;
-- Q14
SELECT COUNT(*) AS unpaid_consultations_count FROM consultations WHERE paid = 0;
-- Q15
SELECT p.last_name || ' ' || p.first_name AS patient_name, SUM(pd.quantity * m.unit_price) AS total_medication_cost FROM patients p JOIN consultations c ON p.patient_id = c.patient_id JOIN prescriptions pr ON c.consultation_id = pr.consultation_id JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id JOIN medications m ON pd.medication_id = m.medication_id GROUP BY p.patient_id;
-- Q16
SELECT d.last_name || ' ' || d.first_name AS doctor_name, s.specialty_name FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id WHERE d.active = 1;
-- Q17
SELECT * FROM consultations WHERE diagnosis IS NULL OR diagnosis = '';
-- Q18
SELECT p.last_name || ' ' || p.first_name AS patient_name, c.consultation_date, c.amount FROM patients p JOIN consultations c ON p.patient_id = c.patient_id WHERE c.amount > (SELECT AVG(amount) FROM consultations);
-- Q19
SELECT s.specialty_name, COUNT(d.doctor_id) AS doctor_count FROM specialties s LEFT JOIN doctors d ON s.specialty_id = d.specialty_id GROUP BY s.specialty_id;
-- Q20
SELECT commercial_name, expiration_date, (julianday(expiration_date) - julianday('now')) AS days_until_expiration FROM medications WHERE days_until_expiration < 180;
-- Q21
SELECT p.last_name || ' ' || p.first_name AS patient_name, COUNT(c.consultation_id) AS consultation_count FROM patients p JOIN consultations c ON p.patient_id = c.patient_id GROUP BY p.patient_id HAVING consultation_count > (SELECT AVG(cnt) FROM (SELECT COUNT(*) as cnt FROM consultations GROUP BY patient_id));
-- Q22
SELECT commercial_name, unit_price FROM medications WHERE unit_price > (SELECT AVG(unit_price) FROM medications);
-- Q23
SELECT d.last_name || ' ' || d.first_name AS doctor_name, s.specialty_name FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id WHERE s.specialty_id = (SELECT specialty_id FROM doctors JOIN consultations ON doctors.doctor_id = consultations.doctor_id GROUP BY specialty_id ORDER BY COUNT(*) DESC LIMIT 1);
-- Q24
SELECT consultation_date, p.last_name || ' ' || p.first_name AS patient_name, amount FROM consultations c JOIN patients p ON c.patient_id = p.patient_id WHERE amount > (SELECT AVG(amount) FROM consultations);
-- Q25
SELECT p.last_name || ' ' || p.first_name AS patient_name, p.allergies FROM patients p WHERE p.allergies IS NOT NULL AND p.patient_id IN (SELECT patient_id FROM consultations JOIN prescriptions ON consultations.consultation_id = prescriptions.consultation_id);
-- Q26
SELECT d.last_name || ' ' || d.first_name AS doctor_name, COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue FROM doctors d JOIN consultations c ON d.doctor_id = c.doctor_id WHERE c.paid = 1 GROUP BY d.doctor_id;
-- Q27
SELECT RANK() OVER(ORDER BY SUM(c.amount) DESC) as rank, s.specialty_name, SUM(c.amount) AS total_revenue FROM specialties s JOIN doctors d ON s.specialty_id = d.specialty_id JOIN consultations c ON d.doctor_id = c.doctor_id WHERE c.paid = 1 GROUP BY s.specialty_id LIMIT 3;
-- Q28
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS quantity_needed FROM medications WHERE available_stock < minimum_stock;
-- Q29
SELECT AVG(med_count) AS avg_meds_per_prescription FROM (SELECT COUNT(medication_id) as med_count FROM prescription_details GROUP BY prescription_id);
-- Q30
SELECT CASE WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) <= 18 THEN '0-18' WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) <= 40 THEN '19-40' WHEN (strftime('%Y', 'now') - strftime('%Y', date_of_birth)) <= 60 THEN '41-60' ELSE '60+' END AS age_group, COUNT(*) AS patient_count FROM patients GROUP BY age_group;