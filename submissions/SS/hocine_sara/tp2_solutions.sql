CREATE DATABASE hospital_management;
USE hospital_management;

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
    CONSTRAINT fk_doctor_specialty
	FOREIGN KEY (specialty_id)
    REFERENCES specialties(specialty_id)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
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
status ENUM ('Scheduled', 'In Progress', 'Completed', 'Cancelled') 
      DEFAULT 'Scheduled',
amount DECIMAL(10, 2),
paid BOOLEAN DEFAULT FALSE,

CONSTRAINT fk_consult_patient
FOREIGN KEY (patient_id)
REFERENCES patients(patient_id)
ON DELETE RESTRICT
 ON UPDATE CASCADE,

CONSTRAINT fk_consult_doctor
FOREIGN KEY (doctor_id)
REFERENCES doctors(doctor_id)
ON DELETE RESTRICT 
ON UPDATE CASCADE
);

CREATE TABLE medications(
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

CONSTRAINT fk_prescription_consult
FOREIGN KEY (consultation_id)
REFERENCES consultations(consultation_id)
ON DELETE CASCADE
);


CREATE TABLE prescription_details(
detail_id INT PRIMARY KEY AUTO_INCREMENT,
prescription_id INT NOT NULL, 
medication_id INT NOT NULL,
quantity INT NOT NULL CHECK (quantity > 0),
dosage_instructions VARCHAR(200) NOT NULL,
duration INT NOT NULL,
total_price DECIMAL(10, 2),

CONSTRAINT fk_details_prescription
FOREIGN KEY (prescription_id)
REFERENCES prescriptions(prescription_id)
ON DELETE CASCADE,

CONSTRAINT fk_details_medication
FOREIGN KEY (medication_id)
REFERENCES medications(medication_id)
ON DELETE RESTRICT
);

-- Indexes 
CREATE INDEX idx_patient_name
ON patients(last_name, first_name);

CREATE INDEX idx_consult_date
ON consultations(consultation_date);

CREATE INDEX idx_consultaion_patient
ON consultations(patient_id);

CREATE INDEX idx_consult_doctor
ON consultations(doctor_id);

CREATE INDEX idx_medication_name
ON medications(commercial_name);

CREATE INDEX idx_prescription_consult
ON prescriptions(consultation_id);

-- INSERT TEST DATA
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary healthcare and general diagnosis', 2000.00),
('Cardiology', 'Heart and cardiovascular system', 3500.00),
('Pediatrics', 'Medical care for infants and children', 2500.00),
('Dermatology', 'Skin related diseases and treatments', 2800.00),
('Orthopedics', 'Bone and joint treatment', 3200.00),
('Gynecology', 'Women reproductive health', 3000.00);

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active)
VALUES
('Benkacem','Amine','amine.benkacem@hospital.dz','0550123456',1,'DZ-GM-001','2018-03-12','Office A1',TRUE),
('Zeroual','Sofia','sofia.zeroual@hospital.dz','0550234567',2,'DZ-CD-002','2016-07-01','Office B2',TRUE),
('Meziane','Yacine','yacine.meziane@hospital.dz','0550345678',3,'DZ-PD-003','2019-09-15','Office C3',TRUE),
('Khellaf','Nadia','nadia.khellaf@hospital.dz','0550456789',4,'DZ-DM-004','2020-01-20','Office D4',TRUE),
('Touati','Karim','karim.touati@hospital.dz','0550567890',5,'DZ-OR-005','2017-11-10','Office E5',TRUE),
('Rahmani','Lina','lina.rahmani@hospital.dz','0550678901',6,'DZ-GY-006','2021-05-05','Office F6',TRUE);

INSERT INTO patients (file_number,last_name,first_name,date_of_birth,gender,blood_type,email,phone,address,city,province,insurance,insurance_number,allergies,medical_history)
VALUES
('PAT001','Hamidi','Amina','2010-06-15','F','O+','amina.hamidi@email.dz','0661000001','Cite 120 Logements','Algiers','Algiers','CNAS','INS123',NULL,NULL),
('PAT002','Boulahbal','Rayan','1985-02-10','M','A+','rayan.b@email.dz','0661000002','Hai El Badr','Blida','Blida','CASNOS','INS124','Penicillin',NULL),
('PAT003','Cherif','Samira','1972-11-22','F','B+','samira.c@email.dz','0661000003','Centre Ville','Oran','Oran',NULL,NULL,NULL,'Diabetes'),
('PAT004','Saadi','Nabil','1958-04-05','M','AB+','nabil.saadi@email.dz','0661000004','Hai Salam','Constantine','Constantine','CNAS','INS125',NULL,'Hypertension'),
('PAT005','Mansouri','Yasmine','1999-09-18','F','O-','yasmine.m@email.dz','0661000005','El Khroub','Constantine','Constantine',NULL,NULL,'Aspirin',NULL),
('PAT006','Dahmani','Walid','2003-01-30','M','A-','walid.d@email.dz','0661000006','Bir Mourad Rais','Algiers','Algiers','CNAS','INS126',NULL,NULL),
('PAT007','Belkadi','Imene','1965-07-12','F','B-','imene.b@email.dz','0661000007','Akid Lotfi','Oran','Oran','CASNOS','INS127','Latex',NULL),
('PAT008','Kaci','Omar','2015-12-01','M','O+','omar.k@email.dz','0661000008','Bab Ezzouar','Algiers','Algiers',NULL,NULL,NULL,NULL);


INSERT INTO consultations
(patient_id,doctor_id,consultation_date,reason,diagnosis,observations,blood_pressure,temperature,weight,height,status,amount,paid)
VALUES
(1,3,'2025-01-05 09:00:00','Fever and cough','Flu','Rest required','110/70',38.5,30,130,'Completed',2500,TRUE),
(2,2,'2025-01-10 10:30:00','Chest pain','Mild arrhythmia','ECG done','130/85',37.0,82,175,'Completed',3500,FALSE),
(3,1,'2025-01-15 14:00:00','Routine checkup','Stable','Good condition','120/80',36.8,70,165,'Completed',2000,TRUE),
(4,5,'2025-02-01 11:00:00','Knee pain','Arthritis','Physiotherapy advised','140/90',36.7,85,170,'Completed',3200,TRUE),
(5,4,'2025-02-10 15:00:00','Skin rash','Allergic reaction','Avoid allergens','115/75',37.2,60,160,'Completed',2800,FALSE),
(6,1,'2025-03-05 09:30:00','Headache','Migraine','Prescribed medication','118/76',36.9,75,172,'Completed',2000,TRUE),
(7,2,'2025-03-12 13:00:00','Heart check','Stable','Monitoring','125/80',36.6,68,158,'Scheduled',3500,FALSE),
(8,3,'2025-03-20 08:30:00','Vaccination','Routine vaccine','No issues','100/65',36.5,20,110,'Completed',2500,TRUE);

INSERT INTO medications
(medication_code,commercial_name,generic_name,form,dosage,manufacturer,unit_price,available_stock,minimum_stock,expiration_date,prescription_required,reimbursable)
VALUES
('MED001','Doliprane','Paracetamol','Tablet','500mg','SAIDAL',150,200,20,'2026-05-01',FALSE,TRUE),
('MED002','Augmentin','Amoxicillin','Tablet','1g','Biopharm',450,50,15,'2025-12-01',TRUE,TRUE),
('MED003','Ventoline','Salbutamol','Inhaler','100mcg','GSK',1200,30,10,'2026-02-01',TRUE,TRUE),
('MED004','Spasfon','Phloroglucinol','Tablet','80mg','SAIDAL',300,80,20,'2025-10-10',FALSE,TRUE),
('MED005','Ibuprofen','Ibuprofen','Tablet','400mg','SAIDAL',200,100,25,'2026-08-01',FALSE,TRUE),
('MED006','Insulin','Insulin','Injection','10ml','NovoNordisk',2500,20,5,'2025-09-01',TRUE,TRUE),
('MED007','Aerius','Desloratadine','Tablet','5mg','MSD',600,40,10,'2025-11-15',TRUE,TRUE),
('MED008','Cough Syrup','Dextromethorphan','Syrup','150ml','Biocare',350,60,15,'2025-07-01',FALSE,FALSE),
('MED009','Vitamin C','Ascorbic Acid','Tablet','500mg','SAIDAL',100,300,50,'2026-01-01',FALSE,FALSE),
('MED010','Calcium','Calcium Carbonate','Tablet','600mg','SAIDAL',400,15,20,'2025-06-01',FALSE,TRUE);

INSERT INTO prescriptions
(consultation_id,prescription_date,treatment_duration,general_instructions)
VALUES
(1,'2025-01-05 09:30:00',5,'Take medication after meals'),
(2,'2025-01-10 11:00:00',10,'Monitor heart rate'),
(4,'2025-02-01 11:30:00',30,'Physiotherapy and medication'),
(5,'2025-02-10 15:30:00',7,'Avoid allergens'),
(6,'2025-03-05 10:00:00',5,'Reduce screen time'),
(8,'2025-03-20 09:00:00',1,'Vaccine follow-up'),
(3,'2025-01-15 14:30:00',3,'Routine vitamins');

INSERT INTO prescription_details
(prescription_id,medication_id,quantity,dosage_instructions,duration,total_price)
VALUES
(1,1,10,'1 tablet 3 times per day',5,1500),
(1,8,1,'10ml twice daily',5,350),
(2,3,1,'2 inhalations daily',10,1200),
(3,5,20,'1 tablet twice daily',30,4000),
(3,10,15,'1 tablet daily',30,6000),
(4,7,10,'1 tablet daily',7,6000),
(5,1,5,'1 tablet when needed',5,750),
(6,9,10,'1 tablet daily',3,1000),
(7,9,5,'1 tablet daily',3,500),
(2,2,14,'1 tablet morning and night',10,6300),
(4,6,5,'Injection daily',30,12500),
(5,4,10,'1 tablet 3 times daily',7,3000);

-- queries
-- Q1
SELECT 
file_number,
CONCAT(last_name ,' ', first_name) AS full_name,
date_of_birth,
phone,
city
FROM patients;

-- Q2 
SELECT 
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
s.specialty_name,
d.office,
d.active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.speciality_id;

-- Q3 
SELECT 
medication_code,
commercial_name,
unit_price,
available_stock
FROM medications
WHERE unit_price < 500;

-- Q4
SELECT 
c.consultation_date,
CONCAT(p.last_name ,' ', p.first_name) AS patient_name,
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
c.status
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE YEAR(c.consultation_date) = 2025
AND MONTH(c.consultation_date) = 1;

-- Q5 
SELECT 
commercial_name,
available_stock,
(minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;

-- Q6
SELECT 
c.consultation_date,
CONCAT(p.last_name ,' ', p.first_name) AS patient_name,
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
c.diagnosis,
c.amount
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7
SELECT 
pr.prescription_date,
CONCAT(p.last_name ,' ', p.first_name) AS patient_name,
m.commercial_name As medication_name,
pd.quantity,
pd.dosage_instructions
FROM prescriptions pr 
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id =m.medication_id;

-- Q8
SELECT 
CONCAT(p.last_name ,' ', p.first_name) AS patient_name,
MAX(c.consultaion_date) AS last_consultation_date,
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id
GROUP BY p.patient_id;

-- Q9
SELECT 
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
COUNT(c.consultation_id) AS consultation_count 
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q10
SELECT 
s.specialty_name,
SUM(c.amount) AS total_revenue,
COUNT(c.consultation_id) AS consultation_count
FROM consultations c
JOIN doctors d ON c.doctor_id = d.doctor_id
JOIN specialties s ON d.specialty_id = s.specialty_id
GROUP BY s.specialty_id;

-- Q11
SELECT 
CONCAT(p.last_name ,' ', p.first_name) AS patient_name,
SUM(pd.total_price) AS total_prescription_cost
FROM prescription_details pd 
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id 
GROUP BY p.patient_id;

-- Q12
SELECT 
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
COUNT(*) AS consultation_count
FROM consultations c 
JOIN doctors d ON c.doctor_id = d.doctor_id 
GROUP BY d.doctor_id;

-- Q13
SELECT 
COUNT(*) AS total_medications,
SUM(unit_price * available_stock) AS total_stock_value
FROM medications;

-- Q14
SELECT 
s.specialty_name,
AVG(c.amount) AS average_price
FROM consultations c
JOIN doctors d ON c.doctor_id = d.doctor_id
JOIN specialties s ON d.specialty_id = s.specialty_id
GROUP BY s.specialty_id;

-- Q15
SELECT 
blood_type,
COUNT(*) AS patient_count 
FROM patients 
GROUP BY blood_type;

-- Q16
SELECT  
m.commercial_name AS medication_name,
COUNT(pd.medication_id) AS times_prescribed,
SUM(pd.quantity) AS total_quantity
FROM prescription_details pd
JOIN medications m ON pd.medication_id = m.medication_id
GROUP BY m.medication_id 
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17
SELECT 
CONCAT(p.last_name ,' ', p.first_name) AS patient_name,
p.registration_date
FROM patients p 
LEFT JOIN consultations c ON p.patient_id = c.patient_id
WHERE c.consultation_id IS NULL;

-- Q18
SELECT 
CONCAT(d.last_name, ' ', d.first_name) AS doctor_name,
s.specialty_name,
COUNT(c.consultation_id) AS consultation_count
FROM consultations c 
JOIN doctors d ON c.doctor_id = d.doctor_id 
JOIN specialties s ON d.specialty_id = s.specialty_id
GROUP BY d.doctor_id 
HAVING consultation_count > 2;

-- Q19
SELECT 
CONCAT(p.last_name,' ',p.first_name) AS patient_name,
c.consultation_date,
c.amount,
CONCAT(d.last_name,' ',d.first_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE;

-- Q20
SELECT 
commercial_name AS medication_name,
expiration_date,
DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration
FROM medications
WHERE expiration_date <= DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Q21
SELECT 
CONCAT(p.last_name,' ',p.first_name) AS patient_name,
COUNT(c.consultation_id) AS consultation_count,
    (SELECT AVG(cnt)
     FROM (SELECT COUNT(*) AS cnt
           FROM consultations
           GROUP BY patient_id) AS avg_table) AS average_count
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
GROUP BY p.patient_id
HAVING consultation_count > average_count;

-- Q22
SELECT 
    commercial_name AS medication_name,
    unit_price,
    (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23
SELECT 
    CONCAT(d.last_name,' ',d.first_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
HAVING specialty_consultation_count = (
    SELECT MAX(total)
    FROM (
        SELECT COUNT(*) AS total
        FROM consultations c2
        JOIN doctors d2 ON c2.doctor_id = d2.doctor_id
        GROUP BY d2.specialty_id
    ) AS sub
);

-- Q24
SELECT 
    c.consultation_date,
    CONCAT(p.last_name,' ',p.first_name) AS patient_name,
    c.amount,
    (SELECT AVG(amount) FROM consultations) AS average_amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25
SELECT 
    CONCAT(p.last_name,' ',p.first_name) AS patient_name,
    p.allergies,
    COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL
GROUP BY p.patient_id;

-- Q26
SELECT 
    CONCAT(d.last_name,' ',d.first_name) AS doctor_name,
    COUNT(c.consultation_id) AS total_consultations,
    SUM(c.amount) AS total_revenue
FROM consultations c
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27
SELECT 
    RANK() OVER (ORDER BY SUM(c.amount) DESC) AS rank_position,
    s.specialty_name,
    SUM(c.amount) AS total_revenue
FROM consultations c
JOIN doctors d ON c.doctor_id = d.doctor_id
JOIN specialties s ON d.specialty_id = s.specialty_id
GROUP BY s.specialty_id
LIMIT 3;

-- Q28
SELECT 
    commercial_name AS medication_name,
    available_stock AS current_stock,
    minimum_stock,
    (minimum_stock - available_stock) AS quantity_needed
FROM medications
WHERE available_stock < minimum_stock;

-- Q29
SELECT 
    AVG(med_count) AS average_medications_per_prescription
FROM (
    SELECT COUNT(*) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) AS sub;

-- Q30
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients),2) AS percentage
FROM patients
GROUP BY age_group;









