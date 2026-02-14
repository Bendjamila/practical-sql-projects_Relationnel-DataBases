create database hospital_db;
use hospital_db;

-- table specialties
create table specialties (
    specialty_id int primary key auto_increment,
    specialty_name varchar(100) not null unique,
    description text,
    consultation_fee decimal(10,2) not null
);

-- table doctors
create table doctors (
    doctor_id int primary key auto_increment,
    last_name varchar(50) not null,
    first_name varchar(50) not null,
    email varchar(100) unique not null,
    phone varchar(20),
    specialty_id int not null,
    license_number varchar(20) unique not null,
    hire_date date,
    office varchar(100),
    active boolean default true,
    foreign key (specialty_id) references specialties(specialty_id)
        on delete restrict
        on update cascade
);

-- table patients
create table patients (
    patient_id int primary key auto_increment,
    file_number varchar(20) unique not null,
    last_name varchar(50) not null,
    first_name varchar(50) not null,
    date_of_birth date not null,
    gender enum('M','F') not null,
    blood_type varchar(5),
    email varchar(100),
    phone varchar(20) not null,
    address text,
    city varchar(50),
    province varchar(50),
    registration_date date default (current_date),
    insurance varchar(100),
    insurance_number varchar(50),
    allergies text,
    medical_history text
);

-- table consultations
create table consultations (
    consultation_id int primary key auto_increment,
    patient_id int not null,
    doctor_id int not null,
    consultation_date datetime not null,
    reason text not null,
    diagnosis text,
    observations text,
    blood_pressure varchar(20),
    temperature decimal(4,2),
    weight decimal(5,2),
    height decimal(5,2),
    status enum('Scheduled','In Progress','Completed','Cancelled') default 'Scheduled',
    amount decimal(10,2),
    paid boolean default false,
    foreign key (patient_id) references patients(patient_id) on delete cascade,
    foreign key (doctor_id) references doctors(doctor_id) on delete cascade
);

-- table medications
create table medications (
    medication_id int primary key auto_increment,
    medication_code varchar(20) unique not null,
    commercial_name varchar(150) not null,
    generic_name varchar(150),
    form varchar(50),
    dosage varchar(50),
    manufacturer varchar(100),
    unit_price decimal(10,2) not null,
    available_stock int default 0,
    minimum_stock int default 10,
    expiration_date date,
    prescription_required boolean default true,
    reimbursable boolean default false
);

-- table prescriptions
create table prescriptions (
    prescription_id int primary key auto_increment,
    consultation_id int not null,
    prescription_date datetime default current_timestamp,
    treatment_duration int,
    general_instructions text,
    foreign key (consultation_id) references consultations(consultation_id) on delete cascade
);

-- table prescription_details
create table prescription_details (
    detail_id int primary key auto_increment,
    prescription_id int not null,
    medication_id int not null,
    quantity int not null check (quantity > 0),
    dosage_instructions varchar(200) not null,
    duration int not null,
    total_price decimal(10,2),
    foreign key (prescription_id) references prescriptions(prescription_id) on delete cascade,
    foreign key (medication_id) references medications(medication_id) on delete cascade
);

-- indexes
create index idx_patient_name on patients(last_name, first_name);
create index idx_consultation_date on consultations(consultation_date);
create index idx_consultation_patient on consultations(patient_id);
create index idx_consultation_doctor on consultations(doctor_id);
create index idx_medication_name on medications(commercial_name);
create index idx_prescription_consultation on prescriptions(consultation_id);
-- insert specialties
insert into specialties (specialty_name, description, consultation_fee) values
('General Medicine', 'Primary healthcare and routine checkups', 1500.00),
('Cardiology', 'Heart and cardiovascular system disorders', 3000.00),
('Pediatrics', 'Medical care for infants and children', 2000.00),
('Dermatology', 'Skin, hair, and nail conditions', 2500.00),
('Orthopedics', 'Musculoskeletal system and bone health', 2800.00),
('Gynecology', 'Female reproductive health', 2500.00);

-- insert doctors
insert into doctors (last_name, first_name, email, specialty_id, license_number, office) values
('Abidi', 'Yasmine', 'y.abidi@hospital.dz', 1, 'LIC001', 'Room 101'),
('Mansouri', 'Karim', 'k.mansouri@hospital.dz', 2, 'LIC002', 'Room 202'),
('Brahimi', 'Amel', 'a.brahimi@hospital.dz', 3, 'LIC003', 'Room 105'),
('Zerrati', 'Omar', 'o.zerrati@hospital.dz', 4, 'LIC004', 'Room 301'),
('Haddad', 'Sami', 's.haddad@hospital.dz', 5, 'LIC005', 'Room 404'),
('Kaci', 'Nadia', 'n.kaci@hospital.dz', 6, 'LIC006', 'Room 205');

-- insert patients
insert into patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, phone, insurance, allergies) values
('P001', 'Belkacem', 'Adam', '2018-05-12', 'M', 'O+', '0550112233', 'CNAS', 'Peanuts'),
('P002', 'Merad', 'Lyna', '1995-10-20', 'F', 'A-', '0661445566', 'CASNOS', null),
('P003', 'Sifi', 'Ahmed', '1955-03-15', 'M', 'B+', '0770778899', 'CNAS', 'Penicillin'),
('P004', 'Ould', 'Sarah', '2010-12-01', 'F', 'O-', '0555990011', null, null),
('P005', 'Hamidi', 'Riad', '1988-07-25', 'M', 'AB+', '0662223344', 'CNAS', 'Dust'),
('P006', 'Lounis', 'Ines', '2002-01-30', 'F', 'A+', '0771334455', 'CASNOS', null),
('P007', 'Saidi', 'Malek', '1962-09-08', 'M', 'O+', '0558445566', null, 'Latex'),
('P008', 'Toumi', 'Keniza', '1990-11-14', 'F', 'B-', '0663556677', 'CNAS', null);

-- insert medications
insert into medications (medication_code, commercial_name, generic_name, form, unit_price, available_stock, minimum_stock, prescription_required) values
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', 250.00, 100, 20, false),
('MED002', 'Amoxil', 'Amoxicillin', 'Capsule', 650.00, 50, 15, true),
('MED003', 'Ventoline', 'Salbutamol', 'Spray', 450.00, 30, 10, true),
('MED004', 'Voltarene', 'Diclofenac', 'Gel', 380.00, 40, 5, false),
('MED005', 'Gaviscon', 'Sodium Alginate', 'Syrup', 550.00, 25, 8, false),
('MED006', 'Augmentin', 'Amoxicillin/Clavulanate', 'Tablet', 1200.00, 20, 10, true),
('MED007', 'Lasix', 'Furosemide', 'Tablet', 300.00, 15, 5, true),
('MED008', 'Advie', 'Ibuprofen', 'Tablet', 400.00, 12, 10, false),
('MED009', 'Clarityne', 'Loratadine', 'Tablet', 700.00, 5, 10, false),
('MED010', 'Lipitor', 'Atorvastatin', 'Tablet', 2200.00, 45, 10, true);

-- insert consultations
insert into consultations (patient_id, doctor_id, consultation_date, reason, status, amount, paid) values
(1, 3, '2025-01-10 09:00:00', 'Fever and cough', 'Completed', 2000.00, true),
(2, 4, '2025-01-12 11:30:00', 'Skin rash', 'Completed', 2500.00, true),
(3, 2, '2025-01-15 14:00:00', 'Chest pain', 'Completed', 3000.00, false),
(4, 3, '2025-01-20 10:00:00', 'Routine checkup', 'Scheduled', 2000.00, false),
(5, 5, '2024-12-05 08:30:00', 'Knee pain', 'Completed', 2800.00, true),
(6, 6, '2025-01-22 13:00:00', 'Prenatal visit', 'Completed', 2500.00, true),
(7, 1, '2025-01-25 15:30:00', 'General fatigue', 'In Progress', 1500.00, false),
(8, 2, '2025-01-28 09:30:00', 'High blood pressure', 'Completed', 3000.00, true);

-- insert prescriptions
insert into prescriptions (consultation_id, treatment_duration, general_instructions) values
(1, 7, 'Take after meals'),
(2, 10, 'Apply cream twice daily'),
(3, 30, 'Avoid heavy exercise'),
(5, 15, 'Rest the knee'),
(6, 90, 'Daily vitamins'),
(8, 60, 'Low salt diet'),
(1, 5, 'Keep hydrated');

-- insert prescription details
insert into prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) values
(1, 1, 2, '1 tablet 3x daily', 7, 500.00),
(1, 2, 1, '1 capsule 2x daily', 7, 650.00),
(2, 4, 1, 'Apply twice daily', 10, 380.00),
(3, 7, 3, '1 tablet morning', 30, 900.00),
(4, 4, 1, 'Apply night', 15, 380.00),
(5, 8, 2, 'As needed', 90, 800.00),
(6, 10, 2, '1 tablet night', 60, 4400.00),
(6, 7, 1, '1 tablet morning', 60, 300.00),
(7, 1, 1, '1 tablet 3x daily', 5, 250.00),
(1, 5, 1, '1 spoon night', 7, 550.00),
(2, 9, 2, '1 tablet daily', 10, 1400.00),
(3, 10, 1, '1 tablet daily', 30, 2200.00);
-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========
-- Q1. List all patients [4]
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;

-- Q2. Display all doctors with specialty [4]
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Medications < 500 DA [5]
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4. Consultations from January 2025 [5]
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status 
FROM consultations c JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.consultation_date LIKE '2025-01%';

-- Q5. Stock below minimum [5]
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
FROM medications WHERE available_stock < minimum_stock;

-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========
-- Q6. All consultations with names [5]
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount 
FROM consultations c JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. Prescriptions with medication details [6]
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       m.commercial_name, pd.quantity, pd.dosage_instructions 
FROM prescription_details pd JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id 
JOIN consultations c ON pr.consultation_id = c.consultation_id 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Display patients with their last consultation date and the doctor's name
SELECT 
    CONCAT(p.last_name, ' ', p.first_name) AS patient_name,
    c1.consultation_date AS last_consultation_date,
    CONCAT(d.last_name, ' ', d.first_name) AS doctor_name
FROM consultations c1
JOIN patients p ON c1.patient_id = p.patient_id
JOIN doctors d ON c1.doctor_id = d.doctor_id
WHERE c1.consultation_date = (
    SELECT MAX(c2.consultation_date)
    FROM consultations c2
    WHERE c2.patient_id = c1.patient_id
);

-- Q9. Doctors and consultation count [6]
SELECT CONCAT(last_name, ' ', first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d LEFT JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY d.doctor_id;

-- Q10. Revenue by specialty [6]
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count 
FROM specialties s JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY s.specialty_id;

-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========
-- Q11. Total prescription amount per patient [7]
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, SUM(pd.total_price) AS total_prescription_cost 
FROM patients p JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id GROUP BY p.patient_id;

-- Q12. Count consultations per doctor [7] (Already solved in Q9, repeating for structure)
SELECT CONCAT(last_name, ' ', first_name) AS doctor_name, COUNT(consultation_id) AS count FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY d.doctor_id;

-- Q13. Total stock value [7]
SELECT COUNT(*) AS total_medications, SUM(available_stock * unit_price) AS total_stock_value FROM medications;

-- Q14. Average price per specialty [7]
SELECT s.specialty_name, AVG(c.amount) AS average_price FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY s.specialty_id;

-- Q15. Count by blood type [8]
SELECT blood_type, COUNT(*) AS patient_count FROM patients GROUP BY blood_type;

-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========
-- Q16. Top 5 most prescribed medications [8]
SELECT m.commercial_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_qty 
FROM medications m JOIN prescription_details pd ON m.medication_id = pd.medication_id 
GROUP BY m.medication_id ORDER BY times_prescribed DESC LIMIT 5;

-- Q17. Patients never had consultation [8]
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date 
FROM patients WHERE patient_id NOT IN (SELECT patient_id FROM consultations);

-- Q18. Doctors with > 2 consultations [8]
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, COUNT(c.consultation_id) AS count 
FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY d.doctor_id HAVING count > 2;

-- Q19. Unpaid consultations [8]
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id WHERE c.paid = FALSE;

-- Q20. Expiring soon [9]
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURDATE()) AS days_until_expiration 
FROM medications WHERE expiration_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========
-- Q21. Consulted more than average [9]
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS count,
(SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM consultations GROUP BY patient_id) t) AS average 
FROM patients p JOIN consultations c ON p.patient_id = c.patient_id GROUP BY p.patient_id HAVING count > average;

-- Q22. Expensive medications [9]
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) AS avg_price 
FROM medications WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Doctors from most requested specialty [9]
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, 
(SELECT COUNT(*) FROM consultations c2 JOIN doctors d2 ON c2.doctor_id = d2.doctor_id WHERE d2.specialty_id = s.specialty_id) AS specialty_count 
FROM doctors d JOIN specialties s ON d.specialty_id = s.specialty_id 
WHERE s.specialty_id = (SELECT specialty_id FROM doctors d3 JOIN consultations c3 ON d3.doctor_id = c3.doctor_id GROUP BY specialty_id ORDER BY COUNT(*) DESC LIMIT 1);

-- Q24. High amount consultations [10]
SELECT consultation_date, amount, (SELECT AVG(amount) FROM consultations) AS avg_amount 
FROM consultations WHERE amount > (SELECT AVG(amount) FROM consultations);

-- Q25. Allergic patients with prescriptions [10]
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS count 
FROM patients p JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id WHERE p.allergies IS NOT NULL GROUP BY p.patient_id;

-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========
-- Q26. Revenue per doctor (Paid only) [10]
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total, SUM(c.amount) AS revenue 
FROM doctors d JOIN consultations c ON d.doctor_id = c.doctor_id WHERE c.paid = TRUE GROUP BY d.doctor_id;

-- Q27. Top 3 profitable specialties [11]
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) AS ranking, s.specialty_name, SUM(c.amount) AS revenue 
FROM specialties s JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id GROUP BY s.specialty_id LIMIT 3;

-- Q28. Restock list [11]
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS needed 
FROM medications WHERE available_stock < minimum_stock;

-- Q29. Avg meds per prescription [11]
SELECT AVG(med_count) AS avg_meds FROM (SELECT COUNT(detail_id) AS med_count FROM prescription_details GROUP BY prescription_id) t;

-- Q30. Demographics by age group [11]
SELECT CASE 
    WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
    WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
    WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
    ELSE '60+' END AS age_group, COUNT(*) AS patient_count FROM patients GROUP BY age_group;
