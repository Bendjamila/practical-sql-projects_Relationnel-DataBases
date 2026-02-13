CREATE DATABASE hospital ;
USE hospital ;

# table creation 

CREATE TABLE specialities(
speciality_id INT PRIMARY KEY AUTO_INCREMENT,
speciality_name VARCHAR(100)  NOT NULL UNIQUE,
description TEXT,
consultation_fee DECIMAL(10, 2) NOT NULL
);

CREATE TABLE doctors(
doctor_id INT PRIMARY KEY AUTO_INCREMENT,
last_name VARCHAR(50) NOT NULL,
first_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phone VARCHAR (20),
speciality_id INT NOT NULL ,
license_number VARCHAR(20) UNIQUE NOT NULL,
hire_date DATE,
office VARCHAR(100),
active BOOLEAN DEFAULT TRUE,
FOREIGN KEY (speciality_id) REFERENCES specialities (speciality_id) ON DELETE RESTRICT ON UPDATE CASCADE 
# we can't delete the speciality of there is one docor related to it , so the data is safe
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
patient_id INT NOT NULL ,
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
FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE RESTRICT ON UPDATE CASCADE
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

CREATE TABLE prescriptions(
prescription_id INT PRIMARY KEY AUTO_INCREMENT,
consultation_id INT NOT NULL,
prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
treatment_duration INT,
general_instructions TEXT,
FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE prescription_details(
detail_id INT PRIMARY KEY AUTO_INCREMENT,
prescription_id INT NOT NULL,
medication_id INT NOT NULL,
quantity INT NOT NULL CHECK (quantity > 0),
dosage_instructions VARCHAR(200) NOT NULL,
duration INT NOT NULL,
total_price DECIMAL(10, 2),
FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT ON UPDATE CASCADE
);


#Create indexes 

CREATE INDEX idx_patient ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_patient_consultation ON consultations(patient_id);
CREATE INDEX idx_doctor_consultation ON consultations(doctor_id);
CREATE INDEX idx_med_comercial_name ON medications(commercial_name);
CREATE INDEX idx_presc_consul ON prescriptions(consultation_id);
