-- Disable foreign key checks temporarily to avoid import errors
SET FOREIGN_KEY_CHECKS=0;

-- SPECIALITIES TABLE:
CREATE TABLE specialties (
    specialty_id INT AUTO_INCREMENT PRIMARY KEY,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL
);

-- DOCTOR TABLE:
CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) NOT NULL UNIQUE,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_doctor_specialty FOREIGN KEY (specialty_id)
        REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- PATIENTS TABLE:
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
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
    registration_date DATE NOT NULL,
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

-- MEDICATIONS TABLE:
CREATE TABLE medications (
    medication_id INT AUTO_INCREMENT PRIMARY KEY,
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

-- CONSULTATION TABLE:
CREATE TABLE consultations (
    consultation_id INT AUTO_INCREMENT PRIMARY KEY,
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
    CONSTRAINT fk_consult_patient FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_consult_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- PRESCRIPTIONS TABLE:
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    CONSTRAINT fk_prescription_consult FOREIGN KEY (consultation_id)
        REFERENCES consultations(consultation_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- PRESCRIPTION DETAILS TABLE:
CREATE TABLE prescription_details (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10,2),
    CONSTRAINT fk_detail_prescription FOREIGN KEY (prescription_id)
        REFERENCES prescriptions(prescription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_medication FOREIGN KEY (medication_id)
        REFERENCES medications(medication_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- Indexes
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consult_patient ON consultations(patient_id);
CREATE INDEX idx_consult_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consult ON prescriptions(consultation_id);


SET FOREIGN_KEY_CHECKS=1;

