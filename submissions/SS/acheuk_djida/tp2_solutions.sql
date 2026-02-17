create database Hospital_Management_System;
use Hospital_Management_System ;

create table specialties (
	specialty_id INT PRIMARY KEY AUTO_INCREMENT,
	specialty_name VARCHAR(100) NOT NULL UNIQUE,
	description TEXT ,
	consultation_fee DECIMAL(10, 2) NOT NULL
	);
	
create table doctors (
	doctor_id INT PRIMARY KEY AUTO_INCREMENT,
	last_name VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	phone VARCHAR(20),
	specialty_id INT NOT NULL, /*FOREIGN KEY → specialties*/
	license_number VARCHAR(20) UNIQUE NOT NULL,
	hire_date DATE ,
	office VARCHAR(100),
	active BOOLEAN DEFAULT TRUE ,
		constraint fk_doctors_specialities
		foreign key (specialty_id)
		references specialties (specialty_id)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
	);

create table patients (
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
	registration_date DATE DEFAULT CURRENT_DATE,
	insurance VARCHAR(100),
	insurance_number VARCHAR(50),
	allergies TEXT,
	medical_history TEXT
);

create table consultations (
	consultation_id INT PRIMARY KEY AUTO_INCREMENT,
	patient_id INT NOT NULL, /*FOREIGN KEY → patients*/
	doctor_id INT NOT NULL, /*FOREIGN KEY → doctors*/
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
		constraint fk_consultations_patients
			foreign key (patient_id)
			references patients (patient_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE,
		constraint fk_consultations_doctors
			foreign key (doctor_id)
			references doctors (doctor_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE
);

create table medications (
	medication_id INT  PRIMARY KEY  AUTO_INCREMENT,
	medication_code VARCHAR(20)  UNIQUE  NOT NULL,
	commercial_name VARCHAR(150)  NOT NULL,
	generic_name VARCHAR(150),
	form VARCHAR(50),/* - Tablet, Syrup, Injection, etc.*/
	dosage VARCHAR(50),
	manufacturer VARCHAR(100),
	unit_price DECIMAL(10, 2)  NOT NULL,
	available_stock INT DEFAULT 0,
	minimum_stock INT DEFAULT 10,
	expiration_date DATE,
	prescription_required BOOLEAN DEFAULT TRUE,
	reimbursable BOOLEAN DEFAULT FALSE
);

create table prescriptions (
	prescription_id INT  PRIMARY KEY  AUTO_INCREMENT,
	consultation_id INT NOT NULL, /*FOREIGN KEY → consultations*/
	prescription_date DATETIME  DEFAULT CURRENT_TIMESTAMP,
	treatment_duration INT, /*- Duration in days*/
	general_instructions TEXT,
		constraint fk_prescriptions_consultations
			foreign key (consultation_id)
			references consultations (consultation_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);

Create table prescription_details (
	detail_id INT, PRIMARY KEY, AUTO_INCREMENT,
	prescription_id INT  NOT NULL, /*FOREIGN KEY → prescriptions*/
	medication_id INT  NOT NULL, /*FOREIGN KEY → medications*/
	quantity INT  NOT NULL CHECK(quantity > 0),
	dosage_instructions VARCHAR(200)  NOT NULL,
	duration INT  NOT NULL,
	total_price DECIMAL(10, 2),
		constraint fk_prescriptiondetails_prescriptions
			foreign key (prescription_id)
			references prescriptions (prescription_id)
			ON DELETE CASCADE 
			ON UPDATE CASCADE,
		constraint fk_prescriptiondetails_medications
			foreign key (medication_id)
			references medications (medication_id)
			ON DELETE RESTRICT
			ON UPDATE CASCADE
);

create index idx_patients_name on patients(last_name, first_name);
create index idx_consultations_date on consultations(consultation_date);
create index idx_consultations_patient on consultations(patient_id);
create index idx_consultations_doctor on consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
create index idx_prescriptions_consultation on prescriptions(consultation_id);

INSERT INTO specialties (specialty_name,description,consultation_fee) values
('General Medicine','primary health care',3000),
('Cardiology', 'heart disease',5000),
('Pediatrics','child healthcare',3500),
('Dermatology','skin diseases',4000),
('Orthopedics', 'bone & joint care',4500),
('Gynecology','women health',4000);

insert into doctors (last_name,first_name,email,phone ,specialty_id,license_number,hire_date,office,active) values
('Benali','Ahmed','a.benali@hospital.com','055000001',1,'LIC001','2018-03-10','A101',TRUE),
('Kaci','Nadia','n.kaci@hospital.com','055000002',2,'LIC002','2017-06-15','B201',TRUE),
('Saidi','Yacine','y.saidi@hospital.com','055000003',3,'LIC003','2019-01-20','C301',TRUE),
('Toumi','Salma','s.toumi@hospital.com','055000004',4,'LIC004','2020-09-01','D401',TRUE),
('Haddad','Karim','k.haddad@hospital.com','055000005',5,'LIC005','2016-11-11','E501',TRUE),
('Bensalem','Amina','a.bensalem@hospital.com','055000006',6,'LIC006','2015-02-25','F601',TRUE);

insert into patients(file_number,last_name,first_name,date_of_birth,gender,blood_type,email,phone,address,city,province,
registration_date,insurance,insurance_number,allergies,medical_history)
values
('F001','Ali','Omar','1985-04-10','M','A+','omar@mail.com','066100001','Street 1','Algiers','Algiers','2024-01-10','CNAS','CN001','Penicillin','Hypertension'),
('F002','Zahra','Lina','2015-06-12','F','O+','lina@mail.com','066100002','Street 2','Blida','Blida','2024-02-01',NULL,NULL,NULL,NULL),
('F003','Hamdi','Samir','1970-08-20','M','B+','samir@mail.com','066100003','Street 3','Oran','Oran','2024-02-10','CNAS','CN003','Dust','Diabetes'),
('F004','Ait','Nour','1992-01-05','F','AB+','nour@mail.com','066100004','Street 4','Setif','Setif','2024-03-01',NULL,NULL,NULL,NULL),
('F005','Moussa','Yasmine','2000-11-30','F','A-','yas@mail.com','066100005','Street 5','Batna','Batna','2024-03-15','CASNOS','CS005','Seafood',NULL),
('F006','Rahmani','Adel','1960-02-14','M','O-','adel@mail.com','066100006','Street 6','Annaba','Annaba','2024-04-01','CNAS','CN006',NULL,'Heart disease'),
('F007','Cherif','Sara','2018-09-22','F','B-','sara@mail.com','066100007','Street 7','Tlemcen','Tlemcen','2024-04-10',NULL,NULL,NULL,NULL),
('F008','Boualem','Khaled','1998-07-18','M','A+','khaled@mail.com','066100008','Street 8','Constantine','Constantine','2024-04-20','CNAS','CN008',NULL,NULL);
	

insert into consultations (patient_id,doctor_id,consultation_date,reason,diagnosis,observations,blood_pressure,temperature,
weight,height,status,amount,paid)
values
(1,1,'2025-01-10 09:00','Checkup','Normal',NULL,'120/80',36.7,75,175,'Completed',3000,TRUE),
(2,3,'2025-01-11 10:00','Flu','Viral infection',NULL,NULL,38.5,20,110,'Completed',3500,FALSE),
(3,2,'2025-01-12 11:00','Chest pain','Angina',NULL,'140/90',37,80,170,'Completed',5000,TRUE),
(4,4,'2025-01-13 12:00','Skin rash','Allergy',NULL,NULL,36.8,60,165,'Completed',4000,FALSE),
(5,6,'2025-01-14 13:00','Routine exam',NULL,NULL,NULL,NULL,NULL,NULL,'Scheduled',4800,FALSE),
(6,2,'2025-01-15 14:00','Follow-up','Stable',NULL,'130/85',36.6,85,172,'Completed',5000,TRUE),
(7,3,'2025-01-16 15:00','Cough','Bronchitis',NULL,NULL,37.9,18,105,'Completed',3500,FALSE),
(8,5,'2025-01-17 16:00','Back pain','Muscle strain',NULL,NULL,36.5,78,178,'Scheduled',4500,FALSE);

insert into medications(medication_code,commercial_name,generic_name,form,dosage,manufacturer,unit_price,available_stock,minimum_stock,
expiration_date,prescription_required,reimbursable) values 
('MED001','Doliprane','Paracetamol','Tablet','500mg','Sanofi',50,200,20,'2026-12-31',FALSE,TRUE),
('MED002','Augmentin','Amoxicillin','Tablet','1g','GSK',120,100,10,'2026-10-30',TRUE,TRUE),
('MED003','Ventoline','Salbutamol','Inhaler','100mcg','GSK',800,50,5,'2027-01-01',TRUE,FALSE),
('MED004','Ibuprofen','Ibuprofen','Tablet','400mg','Pfizer',70,150,15,'2026-11-20',FALSE,TRUE),
('MED005','Insulin','Insulin','Injection','10ml','Novo',1500,40,5,'2025-12-31',TRUE,TRUE),
('MED006','Aspirin','Acetylsalicylic','Tablet','500mg','Bayer',60,300,30,'2027-05-15',FALSE,TRUE),
('MED007','Zyrtec','Cetirizine','Tablet','10mg','UCB',90,120,10,'2026-08-01',FALSE,TRUE),
('MED008','Bisolvon','Bromhexine','Syrup','4mg/5ml','Boehringer',250,80,10,'2026-06-30',FALSE,FALSE),
('MED009','Omeprazole','Omeprazole','Capsule','20mg','Teva',110,140,10,'2027-03-01',FALSE,TRUE),
('MED010','Voltaren','Diclofenac','Injection','75mg','Novartis',300,60,10,'2026-09-15',TRUE,TRUE);

insert into prescriptions (consultation_id,prescription_date,treatment_duration,general_instructions) values
(1,DEFAULT,5,'Rest and hydration'),
(2,DEFAULT,7,'Complete treatment'),
(3,DEFAULT,10,'Low salt diet'),
(4,DEFAULT,5,'Avoid allergens'),
(6,DEFAULT,30,'Long term treatment'),
(7,DEFAULT,7,'Cough syrup'),
(3,DEFAULT,15,'Heart medication');

insert into prescription_details (prescription_id,medication_id,quantity,dosage_instructions,duration,total_price)values
(1,1,10,'2 tablets/day',5,500),
(2,2,14,'2/day',7,1680),
(2,7,7,'1/day',7,630),
(3,5,30,'1 injection/day',30,45000),
(3,9,15,'1/day',15,1650),
(4,7,5,'1/day',5,450),
(5,1,20,'2/day',10,1000),
(6,8,1,'3/day',7,250),
(6,4,10,'2/day',5,700),
(7,10,5,'1/day',5,1500),
(7,6,10,'2/day',5,600),
(1,4,5,'1/day',5,350);

--Queries 

--Qestion1
select concat(last_name,' ',first_name) as full_name ,
file_number, date_of_birth, phone, city
from patients;

--Question 2
select concat(d.last_name,' ',d.first_name) as doctor_name,
s.specialty_name, d.office, d.active
from doctors d
join specialties s on d.specialty_id = s.specialty_id;

--Question3
select medication_code, commercial_name, unit_price, available_stock
from medications
where unit_price < 500;

--Question 4
select c.consultation_date, concat(p.last_name,' ',p.first_name) as patient_name, 
concat(d.last_name,' ',d.first_name) as doctor_name,
c.status 
from consultations c
join patients p on c.patient_id = p.patient_id
join doctors d on c.doctor_id = d.doctor_id
where consultation_date > '2025-01-01';

--Question 5
select commercial_name, available_stock, minimum_stock ,(minimum_stock - available_stock) as difference
from medications
where available_stock < minimum_stock ;

--Question 6
select c.consultation_date, 
concat(p.last_name,' ',p.first_name) as patient_name,
concat(d.last_name,' ',d.first_name) as doctor_name,
c.diagnosis,
c.amount
from consultations c
join patients p on c.patient_id = p.patient_id
join doctors d on c.doctor_id = d.doctor_id;

--Question 7 
select pr.prescription_date, concat(p.last_name,' ',p.first_name) as patient_name,
m.commercial_name as medication_name, 
pd.quantity, pd.dosage_instructions
from  prescription_details pd
join prescriptions pr on pd.prescription_id = pr.prescription_id
join medications m on pd.medication_id = m.medication_id
join consultations c on pr.consultation_id = c.consultation_id
join patients p on c.patient_id = p.patient_id;
 
--Question 8
select  concat(p.last_name,' ',p.first_name) as patient_name,
max(c.consultation_date) as last_consultation_date, 
concat(d.last_name,' ',d.first_name) as doctor_name
from patients p
join consultations c on p.patient_id = c.patient_id
join doctors d on c.doctor_id = d.doctor_id
group by p.patient_id;

--Question 9

select concat(d.last_name,' ',d.first_name) as doctor_name,
count(c.consultation_id) as  consultation_count
from doctors d
left join consultations c on d.doctor_id =  c.doctor_id
group by d.doctor_id;

--Question 10
select s.specialty_name, sum (c.amount) as total_revenue,
count(c.consultation_id)as consultation_count
from specialties s
join doctors d on s.specialty_id = d.specialty_id
join consultations c on d.doctor_id = c.doctor_id
where c.paid= TRUE
group by s.specialty_id;

--Question 11
select concat(p.last_name,' ', p.first_name) as patient_name,
 sum(pd.total_price) as total_prescription_cost
from prescription_details pd 
join prescriptions pr on pd.prescription_id = pr.prescription_id
join consultations c on pr.consultation_id = c.consultation_id
join patients p on c.patient_id = p.patient_id
group by p.patient_id;

--Question 12
select concat(d.last_name,' ',d.first_name) as doctor_name,
count(c.consultation_id) as consultation_count
from doctors d
left join consultations c on d.doctor_id= c.doctor_id
group by d.doctor_id; 

--Question 13
select count(*) as total_medications,
sum(available_stock * unit_price) as total_stock_value
from medications 
group by medication_id ;

--Question 14

select s.specialty_name, avg(c.amount) as average_price
from specialties s
join doctors d on s.specialty_id = d.specialty_id
join consultations c on d.doctor_id = c.doctor_id
group by s.specialty_id;
 
 --Question 15
select blood_type, count (*) as patient_count
from patients
group by blood_type;
 
 --Question 16
select (m.commercial_name) as medication_name,
count (pd.detail_id) as times_prescribed, 
sum(pd.quantity) as total_quantity
from prescription_details pd
join medications m on  pd.medication_id =  m.madication_id 
group by m.medication_id
order by time_prescribed DESC
LIMIT 5;

--Question 17
select concat(p.last_name,' ',p.first_name) as patient_name, p.registration_date
from patients p
left join consultations c on p.patient_id = c.patient_id
where c.consultation_date is null;

--Question 18
select concat(d.last_name,' ',d.first_name) as doctor_name ,
s.specialty_name as speciality,
count(c.consultation_id) as  consultation_count
from doctors d
join specialties s on d.specialty_id= s.specialty_id
join consultations c on d.doctor_id = c.doctor_id
group by d.doctor_id 
having count(c.consultation_id) > 2;

--Question 19
select concat(p.last_name,' ',p.first_name) as patient_name,
c.consultation_date, c.amount,
concat(d.last_name,' ',d.first_name) as doctor_name
from consultations c  
join patients p  on c.patient_id = p.patient_id
join doctors d on c.doctor_id = d.doctor_id
where c.pais = FALSE;

--Question 20
select commercial_name as medication_name,
expiration_date,
DATEDIFF(expiration_date ,CURDATE()) AS days_until_expiration
from medications
where expiration_date <= DATE_ADD(CURDATE(),INTERVAL 6 MONTH );

--Question 21
select concat(p.last_name,' ',p.first_name) as patient_name,
count(c.consultation_id) as consultation_count
from patients p
join consultations c on p.patient_id = c.patient_id
group by p.patient_id ,p.last_name,p.first_name
having count(c.consultation_id) >
	(
		select avg(cnt)
		from (
			select count(*) as cnt 
			from consultations
			group by patient_id
		) as t
	);
	
--Question 22
SELECT 
    commercial_name AS medication_name,
    unit_price,
    (SELECT AVG(unit_price)
     FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

--Question 23
SELECT 
CONCAT(d.lastName, ' ', d.firstName) AS name, 
s.name AS specialty, 
COUNT(c.id) AS totalConsultations
FROM specialties s
JOIN doctors d ON (s.id = d.specialtyId)
JOIN consultations c ON (d.id = c.doctorId)
GROUP BY s.id, d.id
HAVING COUNT(c.id) = 
(SELECT MAX(totalConsultations) 
FROM 
(SELECT COUNT(id) AS totalConsultations 
FROM doctors d2 
JOIN consultations c2 ON (d2.id = c2.doctorId) 
GROUP BY d2.specialtyId) AS t);

--Question 24
select c.consultation_date,
concat(p.last_name,' ',p.first_name) as patient_name,
c.amount
from consultations c 
join patients p on  c.patient_id = p.patient_id
where c.amount > (select avg(amount) from consultations);

--Question 25
select concat(p.last_name,' ',p.first_name) as patient_name,
p.allergies,
count(pr.prescription_id) as prescription_count
from patients p
join consultations c on p.patient_id = c.patient_id
join prescriptions pr on c.consultation_id = pr.consultation_id
where p.allergies is not null
group by p.patient_id;

--Question 26
select concat(d.last_name,' ',d.first_name) as doctor_name,
count(c.consultation_id) as total_consultations,
sum(c.amount) as total_revenue
from doctors d
join consultations c on d.doctor_id = c.doctor_id
where c.paid = TRUE
group by d.doctor_id;

--Question 27
select s.specialty_name,
sum (c.amount) as total_revenue
from specialties s
join doctors d on s.specialty_id = d.specialty_id
join consultations c on d.doctor_id = c.doctor_id
where c.paid=TRUE
group by s.specialty_name,s.specialty_id
order by total_revenue DESC
limit 3;

--Question 28
select commercial_name as medication_name,
available_stock as current_stock,
minimum_stock,
(minimum_stock - available_stock) as quantity_needed
from medications
where available_stock < minimum_stock ;

--Question 29
select avg(med_count) as average_medications_per_prescription,
from (
select count(*) as med_count
from prescription_details
group by prescription_id
) as t;

--Question 30
SELECT 
    age_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 2) AS percentage
FROM (
    SELECT 
        CASE 
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 18 THEN '0-18'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 40 THEN '19-40'
            WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) <= 60 THEN '41-60'
            ELSE '60+'
        END AS age_group
    FROM patients
) AS t
GROUP BY age_group;
