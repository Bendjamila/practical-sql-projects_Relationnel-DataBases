-- use the command "cat AI/benchenina_souhaib/tp2_solution.sql | ./sqlite3 dbtp.db" in the terminal to creat the tables of the first exercice
-- making the hospital tables now

CREATE TABLE Doctors (
    doctor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    specialization TEXT,
    department TEXT,
    phone TEXT
);


CREATE TABLE Patients (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE,
    gender TEXT,
    address TEXT,
    phone TEXT
);


CREATE TABLE Appointments (
    appointment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    doctor_id INTEGER,
    appointment_date DATETIME NOT NULL,
    reason TEXT,
    status TEXT DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);


CREATE TABLE Medications (
    medication_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    dosage TEXT,
    description TEXT
);


CREATE TABLE Prescriptions (
    prescription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER,
    medication_id INTEGER,
    instructions TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);


-- putting in the data... hope I didnt miss anyone


-- adding the 6 docctors
INSERT INTO Doctors (first_name, last_name, specialization, department, phone) VALUES 
('Hicham', 'El-Guerrouj', 'Cardiology', 'Internal Medicine', '0611223344'),
('Nawal', 'El-Moutawakel', 'Pediatrics', 'Children Unit', '0622334455'),
('Said', 'Aouita', 'Neurology', 'Neurological Sciences', '0633445566'),
('Nesrine', 'Slama', 'General Medicine', 'Emergency', '0644556677'),
('Mehdi', 'Benatia', 'Orthopedics', 'Surgery', '0655667788'),
('Hakim', 'Ziyech', 'Dermatology', 'Outpatient', '0666778899');



-- adding the 8 patiennts
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, address, phone) VALUES 
('Soufiane', 'Rahimi', '1996-06-02', 'Male', 'Casablanca', '0701020304'),

('Brahim', 'Diaz', '1999-08-03', 'Male', 'Tangier', '0702030405'),
('Salma', 'Amani', '1992-04-15', 'Female', 'Rabat', '0703040506'),
('Fatima', 'Tagnaout', '1999-01-20', 'Female', 'Agadir', '0704050607'),
('Achraf', 'Hakimi', '1998-11-04', 'Male', 'Madrid', '0705060708'),

('Youssef', 'En-Nesyri', '1997-06-01', 'Male', 'Fes', '0706070809'),

('Sofyan', 'Amrabat', '1996-08-21', 'Male', 'Florence', '0707080910'),
('Romain', 'Saïss', '1990-03-26', 'Male', 'Istanbul', '0708091011');


-- setting up the 15 meets
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason, status) VALUES 
(1, 1, '2026-02-20 09:00:00', 'Chest pain', 'Completed'),
(2, 4, '2026-02-21 10:30:00', 'Flu symptoms', 'Scheduled'),
(3, 2, '2026-02-21 14:00:00', 'Child checkup', 'Scheduled'),
(4, 6, '2026-02-22 11:00:00', 'Skin rash', 'Scheduled'),
(5, 1, '2026-02-23 08:45:00', 'Heart follow-up', 'Scheduled'),
(6, 5, '2026-02-24 13:00:00', 'Knee injury', 'Completed'),
(7, 3, '2026-02-25 15:30:00', 'Headache', 'Scheduled'),
(8, 5, '2026-02-26 10:00:00', 'Back pain', 'Scheduled'),
(1, 4, '2026-02-27 09:15:00', 'General fatigue', 'Scheduled'),
(2, 1, '2026-02-28 11:30:00', 'Artery check', 'Scheduled'),

(3, 2, '2026-03-01 14:45:00', 'Fever', 'Scheduled'),
(5, 5, '2026-03-02 16:00:00', 'Ankle sprain', 'Scheduled'),
(6, 6, '2026-03-03 09:00:00', 'Acne treatment', 'Scheduled'),
(7, 3, '2026-03-04 11:00:00', 'Nerve test', 'Scheduled'),
(8, 1, '2026-03-05 10:30:00', 'Blood pressure', 'Scheduled');



-- some pills and stuff
INSERT INTO Medications (name, dosage, description) VALUES 
('Aspirin', '100mg', 'Blood thinner'),
('Paracetamol', '500mg', 'Pain reliever'),
('Amoxicillin', '250mg', 'Antibiotic'),
('Loratadine', '10mg', 'Antihistamine');


INSERT INTO Prescriptions (appointment_id, medication_id, instructions) VALUES 
(1, 1, 'Once daily after breakfast'),
(2, 2, 'Every 6 hours if fever'),
(6, 2, 'Twice daily for pain'),
(4, 4, 'Before bed');



-- the big list of quaries for the hospital


-- easy ones to start with
SELECT * FROM Patients;

SELECT first_name, last_name FROM Doctors WHERE specialization = 'Cardiology';

SELECT * FROM Appointments WHERE status = 'Scheduled';

SELECT name FROM Medications ORDER BY name ASC;

SELECT DISTINCT department FROM Doctors;



-- looking across different tables
SELECT p.first_name, d.last_name, a.appointment_date FROM Patients p JOIN Appointments a ON p.patient_id = a.patient_id JOIN Doctors d ON a.doctor_id = d.doctor_id;

SELECT a.appointment_id, m.name, pr.instructions FROM Appointments a JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id JOIN Medications m ON pr.medication_id = m.medication_id;

SELECT d.first_name, a.reason FROM Doctors d LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id;

SELECT p.first_name, a.status FROM Patients p JOIN Appointments a ON p.patient_id = a.patient_id WHERE a.doctor_id = 5;

SELECT d.last_name, p.last_name FROM Doctors d JOIN Appointments a ON d.doctor_id = a.doctor_id JOIN Patients p ON a.patient_id = p.patient_id WHERE a.status = 'Completed';



-- counting and stuff
SELECT COUNT(*) FROM Patients;

SELECT department, COUNT(*) FROM Doctors GROUP BY department;

SELECT status, COUNT(*) FROM Appointments GROUP BY status;

SELECT doctor_id, COUNT(*) FROM Appointments GROUP BY doctor_id HAVING COUNT(*) > 2;

SELECT patient_id, COUNT(*) FROM Appointments GROUP BY patient_id;
SELECT AVG(strftime('%Y', 'now') - strftime('%Y', date_of_birth)) AS avg_age FROM Patients;

SELECT MAX(appointment_date) FROM Appointments;

SELECT specialization, COUNT(*) FROM Doctors GROUP BY specialization;

SELECT COUNT(DISTINCT patient_id) FROM Appointments;
SELECT MIN(appointment_date) FROM Appointments WHERE status = 'Scheduled';



-- bit more complext ones
SELECT * FROM Patients WHERE patient_id IN (SELECT patient_id FROM Appointments WHERE doctor_id = 1);

SELECT * FROM Doctors WHERE doctor_id NOT IN (SELECT doctor_id FROM Appointments);

SELECT first_name FROM Patients WHERE patient_id IN (SELECT patient_id FROM Appointments WHERE reason LIKE '%pain%');

SELECT * FROM Medications WHERE medication_id IN (SELECT medication_id FROM Prescriptions);
SELECT * FROM Patients WHERE strftime('%Y', date_of_birth) > '1995';



-- final lot of quaries


SELECT * FROM Appointments WHERE appointment_date BETWEEN '2026-02-20' AND '2026-02-25';

UPDATE Appointments SET status = 'Completed' WHERE appointment_id = 2;
SELECT p.first_name, d.first_name, a.appointment_date FROM Patients p JOIN Appointments a ON p.patient_id = a.patient_id JOIN Doctors d ON a.doctor_id = d.doctor_id WHERE d.department = 'Internal Medicine';

SELECT * FROM Patients WHERE address = 'Casablanca' OR address = 'Tangier';


SELECT d.first_name, COUNT(a.appointment_id) AS total FROM Doctors d JOIN Appointments a ON d.doctor_id = a.doctor_id GROUP BY d.doctor_id ORDER BY total DESC;