
-- ======================================  DATA ENTRY ========================================


INSERT INTO specialities (speciality_name , description, consultation_fee) VALUES ('General Medicine' , 'entire consultation' ,2500.00),
																				  ('Cardiology' , 'Heart and blood vessel specialist' , 4000.00),
																				  ('Pediatrics' , 'Child health specialist' , 3000.00),
                                                                                  ('Dermatology' , 'Skin , Hair and nails specialist' , 3500.00),
																			      ('Orthopedics' , 'Bones and joints specialist' , 4000.00),
                                                                                  ('Genecology' , 'Woman reproductive health specialist' , 3500.00);



INSERT INTO doctors (last_name , first_name , email , phone, speciality_id , license_number , hire_date , office , active )
			        VALUES ( 'HASANI' , 'MOURAD' , 'hm.hasani@hosp.com', '0776096823', 1 , 'LIC234567' , '2021-01-15' , 'R10' , TRUE ),
                     ( 'DOULI' , 'WARDA' , 'dw.douali@hosp.com', '0557189461' , 2 , 'LIJ234867' , '2023-11-15' , 'R12' , TRUE ),
                     ( 'DJEMAA' , 'RAMI' , 'dr.djemaa@hosp.com', '0661936592' , 3 , 'LIC114567' , '2020-01-10' , 'R13' , TRUE ),
                     ( 'SLIMANI' , 'SOURAYA' , 'ss.slimani@hosp.com', '0551930640' ,4 , 'LOC034567' , '2011-01-05' , 'R14' , TRUE ),
                     ( 'SAAD' , 'MOUNDIR' , 'sd.saad@hosp.com', '0771962759' , 5 , 'TIC884567' , '2015-12-07' , 'R15' , TRUE ),
                     ( 'DJILALI' , 'CHAIMA' , 'dc.djilali@hosp.com', '0556937393', 6 , 'LICE36567' , '2014-11-15' , 'R16' , TRUE );
                     

  
 
 
INSERT INTO patients
(file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history)
VALUES
(201, 'AlHamadi', 'Ahmed', '1950-05-12', 'M', 'O+', 'ahmed.alhamadi@example.com', '0555123456',
'12 Didouche Mourad Street', 'Algiers', 'Algiers', '2025-01-10',
'CNAS', 'CNAS-2025-001', 'None', 'No chronic diseases'),

(202, 'BenAli', 'Leila', '1985-11-20', 'F', 'A+', 'leila.benali@example.com', '0555234567',
'45 Emir Abdelkader Boulevard', 'Oran', 'Oran', '2025-02-15',
NULL , NULL, 'Peanut allergy', 'No chronic diseases'),

(203, 'Cherif', 'Mohamed', '1992-07-08', 'M', 'B+', 'mohamed.cherif@example.com', '0555345678',
'18 Larbi Ben M’hidi Street', 'Constantine', 'Constantine', '2025-03-05',
'AXA', 'AXA-DZ-8891', 'None', 'Diabetes type 2'),

(204, 'Naemi', 'Sara', '2000-02-14', 'F', 'AB+', 'sara.naemi@example.com', '0555456789',
'22 Hassiba Ben Bouali Street', 'Algiers', 'Algiers', '2025-04-12',
'Allianz', 'ALL-DZ-3321', 'None', 'No chronic diseases'),

(205, 'Hassani', 'Khaled', '1978-09-22', 'M', 'O-', 'khaled.hassani@example.com', '0555567890',
'10 Ahmed Zabana Street', 'Oran', 'Oran', '2025-05-20',
'CNAS', 'CNAS-2025-078', 'None', 'Hypertension'),

(206, 'Mahdi', 'Fatima', '2020-12-05', 'F', 'A-', 'fatima.mahdi@example.com', '0555678901',
'30 1st November 1954 Street', 'Annaba', 'Annaba', '2025-06-18',
'CASNOS', 'CAS-2025-056', 'Dust allergy', 'No chronic diseases'),

(207, 'Arabi', 'Youssef', '2019-03-30', 'M', 'B-', 'youssef.arabi@example.com', '0555789012',
'15 El Moudjahid Street', 'Biskra', 'Biskra', '2025-07-22',
NULL, NULL, 'None', 'No chronic diseases'),

(208, 'Zaidi', 'Mona', '2002-08-11', 'F', 'AB-', 'mona.zaidi@example.com', '0555890123',
'8 Independence Avenue', 'Setif', 'Setif', '2025-08-10',
'Allianz', 'ALL-DZ-4419', 'None', 'No chronic diseases');


-- ====== Id begin from 18 : ID est incrémenté malgré qu'il y a une erreur lors de l'execution , pour cela j'ai utilisé des ID comme 18 , 8 ,9 .....
-- ===== mais j'ai respecté le nombre de data spécifié et tout les tables sont cohérnetes et les keys et queries aussi

INSERT INTO consultations
(patient_id, doctor_id, consultation_date, reason, diagnosis, observations,
blood_pressure, temperature, weight, height, status, amount, paid)
VALUES
-- Ahmed AlHamadi – General Medicine (elderly)
(1, 1, '2025-01-12 09:30:00', 'General fatigue', 'Age-related weakness', 'Needs rest',
'130/80', 36.8, 70.5, 170, 'Completed', 2500.00, TRUE),

-- Leila BenAli – Dermatology (skin allergy)
(2, 4, '2025-02-18 10:00:00', 'Skin rash', 'Allergic dermatitis', 'Avoid allergens',
'120/75', 36.6, 62.0, 165, 'Completed', 3500.00, TRUE),

-- Mohamed Cherif – Endocrine via General Medicine (Diabetes)
(3, 1, '2025-03-06 11:15:00', 'High blood sugar', 'Type 2 Diabetes', 'Diet required',
'140/90', 37.0, 85.0, 172, 'Completed', 1400.00, FALSE),

-- Sara Naemi – Gynecology
(4, 6, '2025-04-15 14:00:00', 'Menstrual pain', 'Hormonal imbalance', 'Follow-up needed',
'110/70', 36.7, 58.0, 168, 'Completed', 3500.00, TRUE),

-- Khaled Hassani – Cardiology (hypertension)
(5, 2, '2025-05-22 09:00:00', 'Chest discomfort', 'Hypertension', 'Monitor BP',
'150/95', 36.9, 90.0, 175, 'Completed', 4000.00, TRUE),

-- Fatima Mahdi – Pediatrics
(6, 3, '2025-06-20 10:30:00', 'Cough and fever', 'Viral infection', 'Hydration advised',
'100/65', 38.5, 14.0, 95, 'Completed', 3000.00, FALSE),

-- Youssef Arabi – Pediatrics (scheduled)
(7, 3, '2025-07-25 11:00:00', 'Routine checkup', NULL, NULL,
NULL, NULL, 16.5, 102, 'Scheduled', 3000.00, FALSE),

-- Mona Zaidi – General Medicine
(8, 1, '2025-08-12 15:30:00', 'Headache', 'Tension headache', 'Reduce stress',
'115/75', 36.5, 60.0, 166, 'Completed', 2500.00, TRUE);


INSERT INTO medications
(medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable)
VALUES
('MED-001', 'Doliprane', 'Paracetamol', 'Tablet', '500 mg', 'Sanofi', 100.00, 10, 20, '2027-05-31', FALSE, TRUE),
('MED-002', 'Augmentin', 'Amoxicillin + Clavulanic Acid', 'Tablet', '1 g', 'GSK', 390.00, 60, 15, '2026-11-30', TRUE, TRUE),
('MED-003', 'Ventolin', 'Salbutamol', 'Inhaler', '100 mcg', 'GSK', 650.00, 35, 10, '2026-08-15', TRUE, TRUE),
('MED-004', 'Spasfon', 'Phloroglucinol', 'Tablet', '80 mg', 'Teva', 420.00, 90, 20, '2027-01-20', FALSE, FALSE),
('MED-005', 'Lantus', 'Insulin Glargine', 'Injection', '100 IU/ml', 'Sanofi', 250.00, 18, 5, '2026-04-10', TRUE, TRUE),
('MED-006', 'Nurofen', 'Ibuprofen', 'Capsule', '400 mg', 'Reckitt', 380.00, 150, 30, '2027-09-01', FALSE, FALSE),
('MED-007', 'Zyrtec', 'Cetirizine', 'Tablet', '10 mg', 'UCB', 510.00, 75, 15, '2027-03-18', FALSE, TRUE),
('MED-008', 'Glucophage', 'Metformin', 'Tablet', '850 mg', 'Merck', 730.00, 55, 10, '2026-12-05', TRUE, TRUE),
('MED-009', 'Dafalgan', 'Paracetamol', 'Syrup', '250 mg/5ml', 'UPS A', 320.00, 40, 10, '2026-10-22', FALSE, TRUE),
('MED-010', 'Ciproflox', 'Ciprofloxacin', 'Tablet', '500 mg', 'Bayer', 1200.00, 25, 10, '2026-06-30', TRUE, TRUE);


-- ====== id begin from 8 ======
INSERT INTO prescriptions
(consultation_id, treatment_duration, general_instructions)
VALUES
(18, 5, 'Rest and hydration'),
(19, 7, 'Apply medication twice daily'),
(20, 30, 'Strict diet and daily medication'),
(21, 10, 'Hormonal treatment, follow instructions'),
(22, 30, 'Daily blood pressure monitoring'),
(23, 5, 'Complete full course'),
(25, 3, 'Take medication when needed');


-- ======= Id start from 25 =======
INSERT INTO prescription_details
(prescription_id, medication_id, quantity, dosage_instructions, duration, total_price)
VALUES
-- Ahmed
(8, 1, 10, '1 tablet twice daily', 5, 1000.00),
-- Leila
(9, 4, 4, '1 tablet morning and evening', 7, 1680.00),

-- Mohamed (Diabetes)
(10, 8, 9, '1 tablet twice daily', 30, 6570.00),

-- Sara (Gynecology)
(11, 4, 2, '1 tablet twice daily', 10, 840.00),

-- Khaled (Hypertension)
(12, 6, 3, '1 capsule daily', 30, 1140.00),

-- Fatima (Pediatrics – fever)
(13, 9, 1, '5 ml every 8 hours', 5, 320.00),
(13, 1, 6, 'Half tablet if fever persists', 3, 600.00),

-- Mona (Headache)
(14, 1, 6, '1 tablet when needed', 3, 600.00),
(14, 6, 4, '1 capsule daily', 3, 1520.00),
(14, 7, 5, '1 tablet at night', 5, 2550.00),
(14, 4, 4, '1 tablet if pain continues', 2, 1680.00),
(14, 9, 1, '10 ml if severe headache', 2, 320.00);


