CREATE DATABASE hospitalmanagement;
USE hospitalmanagement;


CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
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

show TABLES ;
show create table doctors;
create table patients (
patient_id INT PRIMARY KEY auto_increment,
file_number VARCHAR(20) UNIQUE NOT null,
last_name VARCHAR(50) NOT null,
first_name VARCHAR(50) NOT null,
date_of_birth DATE NOT null,
gender ENUM('M', 'F') NOT null,
blood_type VARCHAR(5),
email VARCHAR(100),
phone VARCHAR(20) NOT null,
address TEXT,
city VARCHAR(50),
province VARCHAR(50),
registration_date DATE DEFAULT (CURRENT_DATE),
insurance VARCHAR(100),
insurance_number VARCHAR(50),
allergies TEXT,
medical_history TEXT
);

create table consultations (
consultation_id INT primary key auto_increment,
patient_id INT NOT null, 
doctor_id INT NOT null,
consultation_date DATETIME NOT null,
reason TEXT NOT null,
diagnosis TEXT,
observations TEXT,
blood_pressure VARCHAR(20),
temperature DECIMAL(4, 2),
weight DECIMAL(5, 2),
height DECIMAL(5, 2),
status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
amount DECIMAL(10, 2),
paid BOOLEAN DEFAULT false,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE RESTRICT ON UPDATE cascade,
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT ON UPDATE cascade
);

create table medications (
medication_id INT PRIMARY KEY auto_increment,
medication_code VARCHAR(20) UNIQUE NOT null,
commercial_name VARCHAR(150) NOT null,
generic_name VARCHAR(150),
form VARCHAR(50),
dosage VARCHAR(50),
manufacturer VARCHAR(100),
unit_price DECIMAL(10, 2) NOT null,
available_stock INT DEFAULT 0,
minimum_stock INT DEFAULT 10,
expiration_date DATE,
prescription_required BOOLEAN DEFAULT true,
reimbursable BOOLEAN DEFAULT false
);

create table prescriptions (
prescription_id INT PRIMARY KEY auto_increment,
consultation_id INT NOT null,
prescription_date DATETIME DEFAULT (CURRENT_TIMESTAMP),
treatment_duration INT,
general_instructions TEXT,
FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE RESTRICT ON UPDATE cascade
);

create table prescription_details (
detail_id INT PRIMARY KEY auto_increment,
prescription_id INT NOT null,
medication_id INT NOT null, 
quantity INT NOT NULL check (quantity > 0),
dosage_instructions VARCHAR(200) NOT null,
duration INT NOT null,
total_price DECIMAL(10, 2),
FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE RESTRICT ON UPDATE cascade,
FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT ON UPDATE cascade
);

CREATE INDEX idx_patients_name ON patients(last_name, first_name);
CREATE INDEX idx_consultations_date ON consultations(consultation_date);
CREATE INDEX idx_consultations_patient ON consultations(patient_id);
CREATE INDEX idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX idx_medications_name ON medications(commercial_name);
CREATE INDEX idx_prescriptions_consultation ON prescriptions(consultation_id);

INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary care and general health issues', 2500.00),
('Cardiology', 'Heart and cardiovascular diseases', 4000.00),
('Pediatrics', 'Medical care for children and infants', 3000.00),
('Dermatology', 'Skin, hair, and nail conditions', 3500.00),
('Orthopedics', 'Bones, joints, and muscle problems', 3800.00),
('Gynecology', 'Women\'s reproductive health', 4200.00);

INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Benali', 'Karim', 'karim.benali@hospital.dz', '0550-12-34-56', 1, 'LIC001-2020', '2020-03-15', 'Office 101', TRUE),
('Mansouri', 'Nadia', 'nadia.mansouri@hospital.dz', '0551-23-45-67', 2, 'LIC002-2019', '2019-06-20', 'Office 102', TRUE),
('Taleb', 'Redouane', 'redouane.taleb@hospital.dz', '0552-34-56-78', 3, 'LIC003-2021', '2021-01-10', 'Office 103', TRUE),
('Hamdi', 'Leila', 'leila.hamdi@hospital.dz', '0553-45-67-89', 4, 'LIC004-2018', '2018-11-05', 'Office 104', TRUE),
('Said', 'Amir', 'amir.said@hospital.dz', '0554-56-78-90', 5, 'LIC005-2020', '2020-09-12', 'Office 105', TRUE),
('Bouzid', 'Samira', 'samira.bouzid@hospital.dz', '0555-67-89-01', 6, 'LIC006-2022', '2022-02-28', 'Office 106', TRUE);


INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '500mg', 'Sanofi', 150.00, 500, 100, '2025-12-31', FALSE, TRUE),
('MED002', 'Ibuprofène', 'Ibuprofen', 'Tablet', '400mg', 'Biopharm', 200.00, 350, 50, '2025-06-30', FALSE, TRUE),
('MED003', 'Amoxicilline', 'Amoxicillin', 'Capsule', '500mg', 'Saïdal', 350.00, 200, 75, '2024-10-15', TRUE, TRUE),
('MED004', 'Ventoline', 'Salbutamol', 'Inhaler', '100mcg/dose', 'GSK', 1200.00, 80, 20, '2024-08-20', TRUE, TRUE),
('MED005', 'Insulatard', 'Insulin', 'Injection', '100IU/ml', 'Novo Nordisk', 2500.00, 40, 15, '2026-05-10', TRUE, TRUE),
('MED006', 'Omeprazole', 'Omeprazole', 'Capsule', '20mg', 'Merinal', 280.00, 300, 100, '2025-09-30', FALSE, TRUE),
('MED007', 'Augmentin', 'Amoxicillin/Clavulanic', 'Tablet', '1g', 'GlaxoSmithKline', 600.00, 150, 40, '2024-11-25', TRUE, TRUE),
('MED008', 'Voltarène', 'Diclofenac', 'Gel', '1%', 'Novartis', 450.00, 120, 30, '2025-03-15', FALSE, FALSE),
('MED009', 'Zyrtec', 'Cetirizine', 'Tablet', '10mg', 'UCB', 320.00, 200, 60, '2025-07-05', FALSE, TRUE),
('MED010', 'Crestor', 'Rosuvastatin', 'Tablet', '10mg', 'AstraZeneca', 850.00, 90, 25, '2024-12-12', TRUE, TRUE);

INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2024-01-15 09:30:00', 'Headache and fever', 'Viral infection', 'Rest and hydration recommended', '120/80', 38.5, 78.5, 175.0, 'Completed', 2500.00, TRUE),
(2, 2, '2024-01-20 10:15:00', 'Chest pain', 'Anxiety', 'ECG normal, stress-related', '135/85', 36.8, 65.0, 162.0, 'Completed', 4000.00, TRUE),
(3, 5, '2024-01-25 11:45:00', 'Knee pain', 'Arthritis', 'X-ray scheduled', '140/90', 37.2, 92.0, 180.0, 'Completed', 3800.00, FALSE),
(4, 3, '2024-02-01 14:30:00', 'Cough and wheezing', 'Asthma exacerbation', 'Inhaler prescribed', '110/70', 37.5, 18.5, 110.0, 'Completed', 3000.00, TRUE),
(5, 2, '2024-02-05 09:00:00', 'Shortness of breath', 'Heart failure monitoring', 'Medication adjustment needed', '150/95', 36.9, 75.0, 168.0, 'Completed', 4000.00, TRUE),
(6, 4, '2024-02-10 15:45:00', 'Skin rash', 'Allergic reaction', 'Prescribed antihistamine', '118/75', 37.0, 62.0, 165.0, 'Completed', 3500.00, FALSE),
(7, 3, '2024-02-15 16:30:00', 'Ear pain', 'Otitis media', 'Antibiotics prescribed', '105/65', 38.2, 30.5, 135.0, 'Completed', 3000.00, TRUE),
(8, 6, '2024-02-20 11:00:00', 'Pregnancy follow-up', 'Normal pregnancy', 'Routine checkup, all good', '115/75', 36.7, 68.0, 163.0, 'Scheduled', 4200.00, FALSE);

INSERT INTO prescriptions (consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1, '2024-01-15 10:00:00', 5, 'Take after meals with plenty of water'),
(2, '2024-01-20 11:00:00', 30, 'Take daily in the morning'),
(3, '2024-01-25 12:30:00', 15, 'Apply locally twice daily'),
(4, '2024-02-01 15:15:00', 7, 'Use as needed for shortness of breath'),
(5, '2024-02-05 10:00:00', 90, 'Take with food, avoid alcohol'),
(6, '2024-02-10 16:30:00', 10, 'Take once daily in the evening'),
(7, '2024-02-15 17:15:00', 7, 'Complete full course even if feeling better'),
(8, '2024-02-20 11:45:00', NULL, 'Follow-up in 1 month');

INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 10, 'Take 1 tablet every 6 hours if fever', 5, 1500.00),
(1, 2, 6, 'Take 1 tablet every 8 hours for pain', 3, 1200.00),
(2, 6, 30, 'Take 1 capsule daily before breakfast', 30, 8400.00),
(3, 8, 1, 'Apply thin layer to affected area twice daily', 15, 450.00),
(4, 4, 1, '2 puffs every 4 hours as needed', 30, 1200.00),
(5, 5, 3, 'Inject 10 units before meals', 90, 7500.00),
(5, 10, 30, 'Take 1 tablet daily in the evening', 30, 25500.00),
(6, 9, 10, 'Take 1 tablet daily', 10, 3200.00),
(7, 3, 14, 'Take 1 capsule every 12 hours', 7, 4900.00),
(7, 7, 14, 'Take 1 tablet every 12 hours', 7, 8400.00),
(7, 1, 8, 'Take 1 tablet every 8 hours for pain', 3, 1200.00),
(8, 9, 30, 'Take 1 tablet daily for allergies', 30, 9600.00);

-- queries :


-- List all patients with their main information 
select file_number, last_name, first_name, date_of_birth, phone, city
from patients;

-- Q2. Display all doctors with their specialty ( no join )
select 
   d.last_name,
   d.first_name,
   s.specialty_name,
   d.office, 
   d.active
from doctors d, specialties s
where d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA 
SELECT medication_code, commercial_name, unit_price, available_stock
FROM medications             
WHERE unit_price < 500            
ORDER by unit_price asc;

-- Q4 List consultations from January 2024 (since the data i entered starts before 2025)
select 
c.consultation_date, 
CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
c.status
from consultations c, patients p, doctors d
where p.patient_id = c.patient_id
and d.doctor_id = c.doctor_id
and c.consultation_date >= '2024-01-01';

-- Q5. Display medications where stock is below minimum stock
select commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
from medications 
where available_stock < minimum_stock;

-- Q6. Display all consultations with patient and doctor names
select 
c.consultation_date, 
CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
c.diagnosis,
c.amount
from consultations c
JOIN patients p ON p.patient_id = c.patient_id
JOIN doctors d ON d.doctor_id = c.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT 
    pr.prescription_date, 
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    m.commercial_name AS medication_name, 
    pd.quantity, 
    pd.dosage_instructions
FROM prescriptions pr
JOIN prescription_details pd ON pd.prescription_id = pr.prescription_id
JOIN medications m ON m.medication_id = pd.medication_id
JOIN consultations c ON c.consultation_id = pr.consultation_id
JOIN patients p ON p.patient_id = c.patient_id;

-- Q8. Display patients with their last consultation date
SELECT 
CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
MAX(c.consultation_date) AS last_consultation_date, 
CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients p
LEFT JOIN consultations c ON c.patient_id = p.patient_id
LEFT JOIN doctors d ON d.doctor_id = c.doctor_id
GROUP BY p.patient_id, p.first_name, p.last_name, d.first_name, d.last_name;

-- Q9. List doctors and the number of consultations performed
select  
CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
COUNT(c.consultation_id) as consultation_count
from doctors d
join consultations c on c.doctor_id = d.doctor_id
group by d.doctor_id, d.first_name, d.last_name;

-- Q10. Display revenue by medical specialty
select 
s.specialty_name, 
sum(c.amount) as total_revenue, 
COUNT(c.consultation_id) as consultation_count
from specialties s
joiN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

-- Q11. Calculate total prescription amount per patient
SELECT
CONCAT(pat.first_name, ' ', pat.last_name) AS patient_name, 
 SUM(pd.quantity * m.unit_price) AS total_prescription_cost
FROM patients pat
JOIN consultations c ON pat.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id
GROUP BY pat.patient_id, pat.first_name, pat.last_name;

-- Q12. Count the number of consultations per doctor
select 
concat(d.first_name, ' ', d.last_name) as doctor_name, 
COUNT(c.consultation_id) as consultation_count
from doctors d
join consultations c on c.doctor_id = d.doctor_id
group by d.first_name, d.last_name;


-- Q13. Calculate total stock value of pharmacy
select 
sum(available_stock) as total_stock_value,
count(medication_id) as total_medications
from medications ;

-- Q14. Find average consultation price per specialty
select 
specialty_name,
avg(consultation_fee)
from specialties
group by specialty_name;

-- Q15. Count number of patients by blood type
select 
blood_type,
count(*) as patient_count
from patients p
group by  p.blood_type;

-- Q16. Find the top 5 most prescribed medications
select 
m.commercial_name as medication_name, 
count(p.medication_id) as times_prescribed, 
sum(m.available_stock) as total_quantity
from medications m
join prescription_details p On p.medication_id = m.medication_id
group by m.commercial_name, m.commercial_name
order by times_prescribed desc 
limit 5;

-- Q17. List patients who have never had a consultation
select 
CONCAT(pat.first_name, ' ', pat.last_name) AS patient_name, 
pat.registration_date
FROM patients pat
LEFT JOIN consultations c ON pat.patient_id = c.patient_id
WHERE c.consultation_id IS NULL;

-- Q18. Display doctors who performed more than 2 consultations
select 
concat(d.first_name, ' ', d.last_name) as doctor_name, 
count(c.doctor_id) as consultation_count
from doctors d
join consultations c On c.doctor_id = d.doctor_id
group by d.first_name, d.last_name
having count(c.consultation_id) > 2;

-- Q19. Find unpaid consultations with total amount
select 
CONCAT(pat.first_name, ' ', pat.last_name) AS patient_name,
c.consultation_date, 
c.amount as consultation_amount,
(SELECT SUM(amount) 
     FROM consultations c2 
     WHERE c2.patient_id = pat.patient_id 
     AND c2.paid = false) AS patient_total_unpaid,
concat(d.first_name, ' ', d.last_name) as doctor_name
from consultations c
join patients pat on pat.patient_id = c.patient_id
join doctors d on d.doctor_id = c.doctor_id
where c.paid = false;

-- Q20. List medications expiring in less than 6 months from today // WHEN THE NUMBER OD DAYS TILL EXPIRING IS NEGATIBE THEN ITS EXPIRED
select 
commercial_name as medication_name,
expiration_date, 
DATEDIFF(expiration_date, CURDATE()) as days_until_expiration,
CASE 
        WHEN DATEDIFF(expiration_date, CURDATE()) < 0 THEN 'EXPIRED'
        WHEN DATEDIFF(expiration_date, CURDATE()) < 30 THEN 'Expiring Soon'
        ELSE 'Valid'
    END AS status
from medications;

-- Q21. Find patients who consulted more than the average ?????
select 
CONCAT(pat.first_name, ' ', pat.last_name) AS patient_name,
count(c.patient_id) as consultation_count,
avg(consultation_count) as average_count
from patients pat
join consultations c on c.patient_id = pat.patient_id
group by pat.first_name, pat.last_name, consultation_count, average_count;

-- Q22. List medications more expensive than average price
SELECT 
    commercial_name AS medication_name,
    unit_price,
    ROUND((SELECT AVG(unit_price) FROM medications), 2) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications)
;

-- Q23. Display doctors from the most requested specialty
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE s.specialty_id = (
    SELECT d2.specialty_id
    FROM doctors d2
    JOIN consultations c2 ON d2.doctor_id = c2.doctor_id
    GROUP BY d2.specialty_id
    ORDER BY COUNT(c2.consultation_id) DESC
    LIMIT 1
)
GROUP BY d.doctor_id, d.first_name, d.last_name, s.specialty_name
ORDER BY specialty_consultation_count DESC;

-- Q25. List allergic patients who received a prescription
SELECT 
CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
  p.allergies,
 COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL 
 AND p.allergies != ''
GROUP BY p.patient_id, p.first_name, p.last_name, p.allergies
;

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT 
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(c.consultation_id) AS total_consultations,
    SUM(c.amount) AS total_revenue
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = true
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY total_revenue DESC;

-- Q27. Display top 3 most profitable specialties
SELECT 
    RANK() OVER (ORDER BY SUM(c.amount) DESC) AS ranking,
    s.specialty_name,
    SUM(c.amount) AS total_revenue,
    COUNT(c.consultation_id) AS total_consultations,
    ROUND(AVG(c.amount), 2) AS average_fee,
    COUNT(DISTINCT d.doctor_id) AS number_of_doctors,
    ROUND(SUM(c.amount) / COUNT(DISTINCT d.doctor_id), 2) AS revenue_per_doctor
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = true
GROUP BY s.specialty_id, s.specialty_name
ORDER BY total_revenue DESC
LIMIT 3;

-- Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) > 60 THEN '60+'
    END AS age_group,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS percentage_of_total,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())), 1) AS avg_age_in_group
FROM patients
GROUP BY age_group
ORDER BY 
    CASE age_group
        WHEN '0-18' THEN 1
        WHEN '19-40' THEN 2
        WHEN '41-60' THEN 3
        WHEN '60+' THEN 4
    END;

