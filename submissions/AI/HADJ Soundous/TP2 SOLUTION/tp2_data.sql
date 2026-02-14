-- SPECIALITIES DATA:
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'General health care and routine check-ups', 50.00),
('Cardiology', 'Heart-related treatments and diagnostics', 120.00),
('Pediatrics', 'Child health care and vaccinations', 60.00),
('Dermatology', 'Skin-related diseases and treatments', 80.00),
('Orthopedics', 'Bone, joint, and muscle treatments', 100.00),
('Gynecology', 'Female reproductive system treatments', 90.00);

-- DOCTORS DATA:
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Smith', 'John', 'john.smith@hospital.com', '055-1234567', 1, 'LIC1001', '2015-03-12', 'Room 101', 1),
('Brown', 'Emily', 'emily.brown@hospital.com', '055-2345678', 2, 'LIC1002', '2017-06-20', 'Room 202', 1),
('Lee', 'Michael', 'michael.lee@hospital.com', '055-3456789', 3, 'LIC1003', '2018-09-15', 'Room 303', 1),
('Garcia', 'Sophia', 'sophia.garcia@hospital.com', '055-4567890', 4, 'LIC1004', '2016-11-05', 'Room 404', 1),
('Patel', 'Raj', 'raj.patel@hospital.com', '055-5678901', 5, 'LIC1005', '2019-01-25', 'Room 505', 1),
('Kim', 'Hana', 'hana.kim@hospital.com', '055-6789012', 6, 'LIC1006', '2020-02-10', 'Room 606', 1);

-- PATIENTS DATA:
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, insurance, insurance_number, allergies, medical_history, registration_date) VALUES
('F001', 'Nguyen', 'Linh', '2010-05-14', 'F', 'O+', 'linh.nguyen@gmail.com', '055-1001001', '123 Maple St', 'Algiers', 'Algiers', 'None', NULL, 'Peanut allergy', 'No major illness', CAST(GETDATE() AS DATE)),
('F002', 'Omar', 'Ali', '1985-08-22', 'M', 'A+', 'ali.omar@gmail.com', '055-1001002', '456 Elm St', 'Oran', 'Oran', 'AXA', 'AX12345', NULL, 'Asthma', CAST(GETDATE() AS DATE)),
('F003', 'Hassan', 'Sara', '1970-03-10', 'F', 'B-', 'sara.hassan@gmail.com', '055-1001003', '789 Oak St', 'Constantine', 'Constantine', 'Daman', 'DM98765', 'Penicillin', 'Diabetes', CAST(GETDATE() AS DATE)),
('F004', 'Bensaid', 'Karim', '2005-12-05', 'M', 'AB+', 'karim.bensaid@gmail.com', '055-1001004', '321 Pine St', 'Algiers', 'Algiers', NULL, NULL, NULL, 'No chronic illnesses', CAST(GETDATE() AS DATE)),
('F005', 'Rached', 'Yasmine', '1995-07-18', 'F', 'O-', 'yasmine.rached@gmail.com', '055-1001005', '654 Cedar St', 'Annaba', 'Annaba', 'Saham', 'SH12345', 'Latex', 'Hypertension', CAST(GETDATE() AS DATE)),
('F006', 'Boualem', 'Ahmed', '1980-11-30', 'M', 'A-', 'ahmed.boualem@gmail.com', '055-1001006', '987 Birch St', 'Oran', 'Oran', 'CNAS', 'CN98765', NULL, 'High cholesterol', CAST(GETDATE() AS DATE)),
('F007', 'Mansouri', 'Leila', '2015-02-20', 'F', 'B+', 'leila.mansouri@gmail.com', '055-1001007', '111 Spruce St', 'Algiers', 'Algiers', NULL, NULL, 'Dust allergy', 'No prior illness', CAST(GETDATE() AS DATE)),
('F008', 'Khelifi', 'Samir', '1965-09-01', 'M', 'AB-', 'samir.khelifi@gmail.com', '055-1001008', '222 Walnut St', 'Blida', 'Blida', 'AXA', 'AX56789', 'Gluten', 'Heart surgery in 2010', CAST(GETDATE() AS DATE));

-- CONSULTATIONS DATA:
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 3, '2026-02-10 09:00:00', 'Routine check-up', 'Healthy', 'No issues', '110/70', 36.5, 35.0, 140.0, 'Completed', 60.00, 1),
(2, 2, '2026-02-11 10:30:00', 'Chest pain', 'Mild angina', 'Follow-up in 2 weeks', '130/85', 37.0, 78.0, 175.0, 'Completed', 120.00, 1),
(3, 1, '2026-02-12 14:00:00', 'Flu symptoms', 'Influenza', 'Prescribed rest', '115/75', 38.2, 65.0, 160.0, 'Completed', 50.00, 1),
(4, 5, '2026-02-13 09:30:00', 'Knee pain', 'Minor sprain', 'Recommended physiotherapy', '120/80', 36.8, 70.0, 170.0, 'In Progress', 100.00, 0),
(5, 6, '2026-02-14 11:00:00', 'Gynecological check-up', 'Healthy', 'Routine exam', '110/70', 36.6, 60.0, 165.0, 'Scheduled', 90.00, 0),
(6, 2, '2026-02-15 15:00:00', 'High blood pressure', 'Hypertension', 'Monitor BP daily', '145/90', 36.9, 85.0, 180.0, 'Scheduled', 120.00, 0),
(7, 3, '2026-02-16 10:00:00', 'Cold symptoms', 'Common cold', 'Hydration recommended', '112/72', 37.1, 20.0, 110.0, 'Scheduled', 60.00, 0),
(8, 2, '2026-02-17 14:30:00', 'Heart palpitations', 'Arrhythmia', 'EKG performed', '135/88', 37.2, 78.0, 175.0, 'Scheduled', 120.00, 0);

-- MEDICATIONS DATA:
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Paracetamol 500mg', 'Paracetamol', 'Tablet', '500mg', 'PharmaPlus', 1.00, 200, 20, '2026-12-31', 1, 1),
('MED002', 'Amoxicillin 250mg', 'Amoxicillin', 'Capsule', '250mg', 'Medico', 2.50, 150, 15, '2026-10-15', 1, 1),
('MED003', 'Ibuprofen 200mg', 'Ibuprofen', 'Tablet', '200mg', 'HealthCorp', 1.20, 100, 10, '2026-08-30', 1, 1),
('MED004', 'Cough Syrup', 'Dextromethorphan', 'Syrup', '10ml', 'PharmaPlus', 3.00, 50, 5, '2025-12-31', 0, 0),
('MED005', 'Vitamin C 500mg', 'Ascorbic Acid', 'Tablet', '500mg', 'NutriHealth', 0.80, 300, 30, '2027-05-31', 0, 0),
('MED006', 'Insulin', 'Insulin', 'Injection', '10 units', 'BioPharm', 15.00, 30, 5, '2026-09-30', 1, 1),
('MED007', 'Omeprazole 20mg', 'Omeprazole', 'Capsule', '20mg', 'GastroMed', 2.00, 80, 10, '2026-11-15', 1, 1),
('MED008', 'Antihistamine', 'Loratadine', 'Tablet', '10mg', 'AllergyCare', 1.50, 120, 10, '2026-07-20', 1, 0),
('MED009', 'Hydrocortisone Cream', 'Hydrocortisone', 'Cream', 'Apply twice daily', 'Dermacare', 5.00, 60, 5, '2025-11-30', 1, 0),
('MED010', 'Paracetamol Syrup', 'Paracetamol', 'Syrup', '5ml', 'PharmaPlus', 1.80, 100, 10, '2026-12-31', 1, 1);

--PRESCRIPTIONS DATA:
INSERT INTO prescriptions (consultation_id, prescription_date, treatment_duration, general_instructions) VALUES
(1, '2026-02-10 09:15:00', 5, 'Take medications after meals'),
(2, '2026-02-11 10:45:00', 10, 'Monitor blood pressure daily'),
(3, '2026-02-12 14:15:00', 7, 'Rest and drink fluids'),
(4, '2026-02-13 09:45:00', 14, 'Apply cream twice a day'),
(5, '2026-02-14 11:15:00', 30, 'Monthly follow-up required'),
(6, '2026-02-15 15:15:00', 20, 'Reduce salt intake'),
(7, '2026-02-16 10:15:00', 5, 'Use syrup three times daily');

--PRESCRIPTION DETAILS DATA:
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 10, 'Take 1 tablet every 8 hours', 5, 10.00),
(1, 5, 5, 'Take 1 tablet daily', 5, 4.00),
(2, 2, 20, 'Take 1 capsule every 12 hours', 10, 50.00),
(3, 3, 14, 'Take 1 tablet every 8 hours', 7, 16.80),
(4, 9, 1, 'Apply cream to affected area', 14, 5.00),
(5, 6, 30, 'Inject 10 units daily', 30, 450.00),
(6, 7, 20, 'Take 1 capsule before breakfast', 20, 40.00),
(6, 8, 20, 'Take 1 tablet daily', 20, 30.00),
(7, 4, 15, 'Take 10ml three times daily', 5, 45.00),
(7, 1, 15, 'Take 1 tablet every 8 hours', 5, 15.00),
(2, 8, 10, 'Take 1 tablet daily', 10, 15.00),
(3, 5, 7, 'Take 1 tablet daily', 7, 5.60);



