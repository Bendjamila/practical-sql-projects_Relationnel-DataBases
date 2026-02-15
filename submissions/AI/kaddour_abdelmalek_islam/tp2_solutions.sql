
-- TP2: Système de Gestion Hospitalière


-- 1. Création de la base de données
CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- 2. Création des tables

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
    CONSTRAINT fk_doc_spec FOREIGN KEY (specialty_id) 
        REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
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
    status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10, 2),
    paid BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_cons_pat FOREIGN KEY (patient_id) 
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_cons_doc FOREIGN KEY (doctor_id) 
        REFERENCES doctors(doctor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
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
    CONSTRAINT fk_presc_cons FOREIGN KEY (consultation_id) 
        REFERENCES consultations(consultation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
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
    CONSTRAINT fk_det_presc FOREIGN KEY (prescription_id) 
        REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_det_med FOREIGN KEY (medication_id) 
        REFERENCES medications(medication_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 3. Création des index
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);

-- 4. Insertion des données de test

-- Spécialités
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('Médecine Générale', 'Services de santé primaires', 2000.00),
('Cardiologie', 'Système cardiovasculaire', 4500.00),
('Pédiatrie', 'Soins médicaux pour enfants', 2500.00),
('Dermatologie', 'Troubles de la peau, des cheveux et des ongles', 3000.00),
('Orthopédie', 'Système musculo-squelettique', 4000.00),
('Gynécologie', 'Système reproducteur féminin', 3500.00);

-- Médecins
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('Benali', 'Ahmed', 'a.benali@chu-alger.dz', '0550112233', 1, 'ORD001', '2015-06-01', 'Cabinet 101', TRUE),
('Mansouri', 'Sonia', 's.mansouri@chu-alger.dz', '0550445566', 2, 'ORD002', '2018-03-15', 'Cabinet 205', TRUE),
('Kacimi', 'Yacine', 'y.kacimi@chu-alger.dz', '0550778899', 3, 'ORD003', '2020-09-10', 'Cabinet 105', TRUE),
('Ziri', 'Lina', 'l.ziri@chu-alger.dz', '0550990011', 4, 'ORD004', '2017-11-20', 'Cabinet 302', TRUE),
('Haddad', 'Omar', 'o.haddad@chu-alger.dz', '0550223344', 5, 'ORD005', '2016-01-12', 'Cabinet 401', TRUE),
('Saidi', 'Meriem', 'm.saidi@chu-alger.dz', '0550556677', 6, 'ORD006', '2019-05-05', 'Cabinet 305', TRUE);

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history) VALUES
('DOS001', 'Brahimi', 'Mohamed', '1985-04-12', 'M', 'A+', 'm.brahimi@mail.dz', '0661112233', '12 Rue des Pins', 'Alger', 'Alger', '2024-10-01', 'CNAS', '123456789', 'Pollen', 'Hypertension'),
('DOS002', 'Lamine', 'Sara', '2015-08-20', 'F', 'O+', 's.lamine@mail.dz', '0661445566', '45 Cité El Hayat', 'Oran', 'Oran', '2024-11-15', 'Aucune', NULL, 'Pénicilline', 'Asthme'),
('DOS003', 'Belkacem', 'Ali', '1950-12-05', 'M', 'B-', 'a.belkacem@mail.dz', '0661778899', '5 Bis Avenue de la Gare', 'Constantine', 'Constantine', '2024-09-20', 'CASNOS', '987654321', 'Poussière', 'Diabète Type 2'),
('DOS004', 'Taleb', 'Amel', '1992-02-28', 'F', 'AB+', 'a.taleb@mail.dz', '0661001122', 'Lotissement 54', 'Annaba', 'Annaba', '2025-01-05', 'CNAS', '456789123', 'Aucune', 'Aucun'),
('DOS005', 'Ouali', 'Karim', '2010-06-14', 'M', 'A-', 'k.ouali@mail.dz', '0661334455', 'Rue de la Liberté', 'Béjaïa', 'Béjaïa', '2024-12-10', 'Aucune', NULL, 'Arachides', 'Aucun'),
('DOS006', 'Hamidi', 'Fatima', '1978-11-30', 'F', 'O-', 'f.hamidi@mail.dz', '0661667788', 'Cité 200 Logements', 'Sétif', 'Sétif', '2024-08-15', 'CNAS', '741852963', 'Aucune', 'Anémie'),
('DOS007', 'Bouzid', 'Rachid', '1965-03-25', 'M', 'B+', 'r.bouzid@mail.dz', '0661990011', 'Quartier Administratif', 'Tlemcen', 'Tlemcen', '2024-11-01', 'CASNOS', '369258147', 'Aucune', 'Arthrite'),
('DOS008', 'Derradji', 'Ines', '2000-09-18', 'F', 'A+', 'i.derradji@mail.dz', '0661223344', 'Résidence les Fleurs', 'Blida', 'Blida', '2025-01-20', 'CNAS', '159753486', 'Fraises', 'Aucun');

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:00:00', 'Contrôle de routine', 'Hypertension légère', 'Régime pauvre en sel conseillé', '140/90', 36.6, 85.0, 178.0, 'Completed', 2000.00, TRUE),
(2, 3, '2025-01-12 10:30:00', 'Fièvre et toux', 'Grippe saisonnière', 'Repos et hydratation prescrits', '110/70', 38.5, 30.0, 135.0, 'Completed', 2500.00, TRUE),
(3, 2, '2025-01-15 14:00:00', 'Douleur thoracique', 'Angine de poitrine', 'ECG urgent effectué', '150/95', 36.8, 78.0, 170.0, 'Completed', 4500.00, FALSE),
(4, 6, '2025-01-20 11:00:00', 'Suivi de grossesse', 'Progression normale', 'Battements cardiaques fœtaux sains', '120/80', 36.7, 65.0, 165.0, 'Completed', 3500.00, TRUE),
(5, 5, '2025-01-25 09:30:00', 'Douleur au genou', 'Entorse ligamentaire', 'Kinésithérapie recommandée', '120/75', 36.5, 45.0, 150.0, 'Completed', 4000.00, TRUE),
(6, 4, '2025-02-05 15:00:00', 'Éruption cutanée', 'Dermatite de contact', 'Éviter les allergènes suspectés', '115/75', 36.9, 60.0, 162.0, 'Completed', 3000.00, TRUE),
(7, 1, '2025-02-10 10:00:00', 'Mal de dos', 'Spasme musculaire', 'Analgésiques prescrits', '130/85', 36.6, 82.0, 175.0, 'Scheduled', 2000.00, FALSE),
(8, 3, '2025-02-15 11:30:00', 'Examen physique annuel', 'En bonne santé', 'Tous les systèmes sont normaux', '110/70', 36.7, 55.0, 168.0, 'Scheduled', 2500.00, FALSE);

-- Médicaments
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane', 'Paracétamol', 'Comprimé', '1000mg', 'Sanofi', 250.00, 100, 20, '2026-12-31', FALSE, TRUE),
('MED002', 'Amoxil', 'Amoxicilline', 'Gélule', '500mg', 'GSK', 450.00, 50, 15, '2025-08-30', TRUE, TRUE),
('MED003', 'Voltarène', 'Diclofénac', 'Gel', '1%', 'Novartis', 600.00, 30, 10, '2026-05-20', FALSE, TRUE),
('MED004', 'Ventoline', 'Salbutamol', 'Inhalateur', '100mcg', 'GSK', 800.00, 25, 5, '2025-11-15', TRUE, TRUE),
('MED005', 'Glucophage', 'Metformine', 'Comprimé', '850mg', 'Merck', 350.00, 80, 20, '2027-01-10', TRUE, TRUE),
('MED006', 'Amlor', 'Amlodipine', 'Comprimé', '5mg', 'Pfizer', 1200.00, 40, 10, '2026-03-15', TRUE, TRUE),
('MED007', 'Augmentin', 'Amoxicilline/Acide Clavulanique', 'Comprimé', '1g', 'GSK', 1500.00, 20, 10, '2025-07-01', TRUE, TRUE),
('MED008', 'Spasfon', 'Phloroglucinol', 'Comprimé', '80mg', 'Teva', 300.00, 60, 15, '2027-06-30', FALSE, TRUE),
('MED009', 'Gaviscon', 'Alginate de Sodium', 'Sirop', '250ml', 'Reckitt', 550.00, 15, 10, '2026-02-28', FALSE, FALSE),
('MED010', 'Zyrtec', 'Cétirizine', 'Comprimé', '10mg', 'UCB', 400.00, 5, 10, '2025-04-10', FALSE, TRUE);

-- Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(1, 30, 'Prendre le médicament quotidiennement après le petit-déjeuner'),
(2, 7, 'Repos et bonne hydratation'),
(3, 90, 'Éviter toute activité physique intense'),
(4, 30, 'Continuer les vitamines prénatales'),
(5, 15, 'Appliquer le gel deux fois par jour sur la zone affectée'),
(6, 10, 'Appliquer la crème matin et soir'),
(2, 5, 'Terminer tout le traitement antibiotique');

-- Détails des Prescriptions
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 6, 1, '1 comprimé par jour', 30, 1200.00),
(2, 1, 3, '1 comprimé toutes les 8 heures', 7, 750.00),
(2, 2, 2, '1 gélule deux fois par jour', 7, 900.00),
(3, 6, 1, '1 comprimé par jour', 90, 1200.00),
(4, 8, 2, 'Si besoin en cas de douleur', 30, 600.00),
(5, 3, 1, 'Appliquer deux fois par jour', 15, 600.00),
(6, 10, 1, '1 comprimé le soir', 10, 400.00),
(7, 7, 2, '1 comprimé deux fois par jour', 5, 3000.00),
(1, 1, 2, 'Si besoin pour les maux de tête', 30, 500.00),
(3, 5, 2, '1 comprimé pendant les repas', 90, 700.00),
(2, 8, 3, '1 comprimé pour la fièvre', 5, 900.00),
(5, 1, 2, 'Pour la douleur', 15, 500.00);

-- 5. Requêtes SQL

-- Q1. Liste des patients (N° dossier, Nom complet, Date de naissance, Ville)
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city 
FROM patients;

-- Q2. Médecins et leurs spécialités
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Médicaments avec prix inférieur à 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock 
FROM medications 
WHERE unit_price < 500;

-- Q4. Consultations de Janvier 2025
SELECT consultation_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       status 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';

-- Q5. Médicaments en rupture de stock (stock < minimum)
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q6. Consultations avec noms des patients et médecins
SELECT c.consultation_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       c.diagnosis, c.amount 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. Prescriptions avec détails des médicaments
SELECT pr.prescription_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       m.commercial_name AS medication_name, 
       pd.quantity, pd.dosage_instructions 
FROM prescription_details pd
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients p ON c.patient_id = p.patient_id
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Patients avec leur dernière date de consultation
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       MAX(c.consultation_date) AS last_consultation_date,
       (SELECT CONCAT(d.last_name, ' ', d.first_name) 
        FROM consultations c2 
        JOIN doctors d ON c2.doctor_id = d.doctor_id 
        WHERE c2.patient_id = p.patient_id 
        ORDER BY c2.consultation_date DESC LIMIT 1) as doctor_name
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id;

-- Q9. Médecins et nombre de consultations effectuées
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       COUNT(c.consultation_id) AS consultation_count 
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q10. Revenu par spécialité médicale
SELECT s.specialty_name, 
       SUM(c.amount) AS total_revenue, 
       COUNT(c.consultation_id) AS consultation_count 
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q11. Montant total des prescriptions par patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       SUM(pd.total_price) AS total_prescription_cost 
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY p.patient_id;

-- Q12. Nombre de consultations par médecin
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       COUNT(c.consultation_id) AS consultation_count 
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id;

-- Q13. Valeur totale du stock de la pharmacie
SELECT COUNT(medication_id) AS total_medications, 
       SUM(unit_price * available_stock) AS total_stock_value 
FROM medications;

-- Q14. Prix moyen des consultations par spécialité
SELECT s.specialty_name, ROUND(AVG(c.amount), 2) AS average_price 
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id;

-- Q15. Nombre de patients par groupe sanguin
SELECT blood_type, COUNT(patient_id) AS patient_count 
FROM patients 
GROUP BY blood_type;

-- Q16. Top 5 des médicaments les plus prescrits
SELECT m.commercial_name AS medication_name, 
       COUNT(pd.detail_id) AS times_prescribed, 
       SUM(pd.quantity) AS total_quantity 
FROM medications m
JOIN prescription_details pd ON m.medication_id = pd.medication_id
GROUP BY m.medication_id
ORDER BY times_prescribed DESC
LIMIT 5;

-- Q17. Patients n'ayant jamais eu de consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date 
FROM patients 
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18. Médecins ayant effectué plus de 2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       s.specialty_name AS specialty, 
       COUNT(c.consultation_id) AS consultation_count 
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id
HAVING COUNT(c.consultation_id) >= 2;

-- Q19. Consultations non payées avec montant total
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       c.consultation_date, c.amount, 
       CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE c.paid = FALSE;

-- Q20. Médicaments expirant dans moins de 6 mois
SELECT commercial_name, expiration_date, 
       DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration 
FROM medications 
WHERE expiration_date <= DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);

-- Q21. Patients ayant consulté plus que la moyenne
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       COUNT(c.consultation_id) AS consultation_count,
       (SELECT AVG(cnt) FROM (SELECT COUNT(consultation_id) as cnt FROM consultations GROUP BY patient_id) as sub) as average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id
HAVING COUNT(c.consultation_id) > (
    SELECT AVG(cnt) FROM (SELECT COUNT(consultation_id) as cnt FROM consultations GROUP BY patient_id) as sub
);

-- Q22. Médicaments plus chers que le prix moyen
SELECT commercial_name, unit_price, 
       (SELECT AVG(unit_price) FROM medications) AS average_price 
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Médecins de la spécialité la plus demandée
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       s.specialty_name, 
       (SELECT COUNT(*) FROM consultations c2 JOIN doctors d2 ON c2.doctor_id = d2.doctor_id WHERE d2.specialty_id = s.specialty_id) as specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
WHERE s.specialty_id = (
    SELECT d3.specialty_id 
    FROM consultations c3 
    JOIN doctors d3 ON c3.doctor_id = d3.doctor_id 
    GROUP BY d3.specialty_id 
    ORDER BY COUNT(*) DESC LIMIT 1
);

-- Q24. Consultations avec un montant supérieur à la moyenne
SELECT consultation_date, 
       CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       amount, 
       (SELECT AVG(amount) FROM consultations) AS average_amount 
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
WHERE amount > (SELECT AVG(amount) FROM consultations);

-- Q25. Patients allergiques ayant reçu une prescription
SELECT DISTINCT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, 
       p.allergies, 
       COUNT(pr.prescription_id) AS prescription_count 
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE p.allergies IS NOT NULL AND p.allergies <> 'Aucune'
GROUP BY p.patient_id;

-- Q26. Revenu total par médecin (consultations payées uniquement)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, 
       COUNT(c.consultation_id) AS total_consultations, 
       SUM(c.amount) AS total_revenue 
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = TRUE
GROUP BY d.doctor_id;

-- Q27. Top 3 des spécialités les plus rentables
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) as `rank`, 
       s.specialty_name, 
       SUM(c.amount) AS total_revenue 
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id
LIMIT 3;

-- Q28. Médicaments à réapprovisionner (stock < minimum)
SELECT commercial_name, available_stock AS current_stock, 
       minimum_stock, (minimum_stock - available_stock + 10) AS quantity_needed 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q29. Nombre moyen de médicaments par prescription
SELECT ROUND(AVG(med_count), 2) AS average_medications_per_prescription
FROM (
    SELECT COUNT(detail_id) as med_count 
    FROM prescription_details 
    GROUP BY prescription_id
) as sub;

-- Q30. Rapport démographique des patients par groupe d'âge
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS percentage
FROM patients
GROUP BY age_group;
