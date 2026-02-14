-- Q1
SELECT 
    file_number,
    CONCAT(first_name,' ',last_name) AS full_name,
    date_of_birth,
    phone,
    city
FROM patients;

-- Q2
SELECT 
    CONCAT(first_name,' ',last_name) AS doctor_name,
    s.specialty_name,
    office,
    active
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id;

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
    consultation_date,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    status
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE consultation_date BETWEEN '2025-01-01' AND '2025-01-31';

-- Q5
SELECT 
    commercial_name,
    available_stock,
    minimum_stock,
    (minimum_stock - available_stock) AS difference
FROM medications
WHERE available_stock < minimum_stock;


-- Q6
SELECT 
    consultation_date,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    diagnosis,
    amount
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7
SELECT 
    pr.prescription_date,
    CONCAT(pt.first_name,' ',pt.last_name) AS patient_name,
    m.commercial_name AS medication_name,
    pd.quantity,
    pd.dosage_instructions
FROM prescriptions pr
JOIN consultations c ON pr.consultation_id = c.consultation_id
JOIN patients pt ON c.patient_id = pt.patient_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8
SELECT 
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    MAX(c.consultation_date) AS last_consultation_date,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name
FROM patients p
LEFT JOIN consultations c ON p.patient_id = c.patient_id
LEFT JOIN doctors d ON c.doctor_id = d.doctor_id
GROUP BY p.patient_id, CONCAT(d.first_name,' ',d.last_name);

-- Q9
SELECT 
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, CONCAT(d.first_name,' ',d.last_name);

-- Q10
SELECT 
    s.specialty_name,
    SUM(c.amount) AS total_revenue,
    COUNT(c.consultation_id) AS consultation_count
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

-- Q11
SELECT 
    CONCAT(pt.first_name,' ',pt.last_name) AS patient_name,
    SUM(pd.total_price) AS total_prescription_cost
FROM patients pt
JOIN consultations c ON pt.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id
GROUP BY pt.patient_id, CONCAT(pt.first_name,' ',pt.last_name);

-- Q12
SELECT 
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, CONCAT(d.first_name,' ',d.last_name);

-- Q13
SELECT 
    COUNT(*) AS total_medications,
    SUM(unit_price * available_stock) AS total_stock_value
FROM medications;

-- Q14
SELECT 
    s.specialty_name,
    AVG(c.amount) AS average_price
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_id, s.specialty_name;

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
GROUP BY m.commercial_name
ORDER BY times_prescribed DESC
LIMIT 5;


-- Q17
SELECT 
    CONCAT(first_name,' ',last_name) AS patient_name,
    registration_date
FROM patients
WHERE patient_id NOT IN (SELECT patient_id FROM consultations);

-- Q18
SELECT 
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY d.doctor_id, CONCAT(d.first_name,' ',d.last_name), s.specialty_name
HAVING COUNT(c.consultation_id) > 2;

-- Q19
SELECT 
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    consultation_date,
    amount,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name
FROM consultations c
JOIN patients p ON c.patient_id = p.patient_id
JOIN doctors d ON c.doctor_id = d.doctor_id
WHERE paid = 0;

-- Q20
SELECT 
    commercial_name AS medication_name,
    expiration_date,
    DATEDIFF(DAY, GETDATE(), expiration_date) AS days_until_expiration
FROM medications
WHERE expiration_date BETWEEN GETDATE() AND DATEADD(MONTH, 6, GETDATE());

-- Q21
SELECT 
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    COUNT(c.consultation_id) AS consultation_count,
    (SELECT AVG(cnt) 
     FROM (SELECT COUNT(*) AS cnt FROM consultations GROUP BY patient_id) AS avg_table) AS average_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
GROUP BY p.patient_id, CONCAT(p.first_name,' ',p.last_name)
HAVING COUNT(c.consultation_id) > 
       (SELECT AVG(cnt) 
        FROM (SELECT COUNT(*) AS cnt FROM consultations GROUP BY patient_id) AS avg_table);

-- Q22
SELECT 
    commercial_name AS medication_name,
    unit_price,
    (SELECT AVG(unit_price) FROM medications) AS average_price
FROM medications
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23
SELECT 
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    s.specialty_name,
    COUNT(c.consultation_id) AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE s.specialty_id = (
    SELECT TOP 1 specialty_id
    FROM doctors d2
    JOIN consultations c2 ON d2.doctor_id = c2.doctor_id
    GROUP BY d2.specialty_id
    ORDER BY COUNT(c2.consultation_id) DESC
)
GROUP BY d.doctor_id, CONCAT(d.first_name,' ',d.last_name), s.specialty_name;

-- Q24
SELECT 
    consultation_date,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    amount,
    (SELECT AVG(amount) FROM consultations) AS average_amount
FROM consultations
WHERE amount > (SELECT AVG(amount) FROM consultations);

-- Q25
SELECT 
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    allergies,
    COUNT(pr.prescription_id) AS prescription_count
FROM patients p
JOIN consultations c ON p.patient_id = c.patient_id
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id
WHERE allergies IS NOT NULL AND allergies != ''
GROUP BY p.patient_id, CONCAT(p.first_name,' ',p.last_name), allergies;


-- Q26
SELECT 
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    COUNT(c.consultation_id) AS total_consultations,
    SUM(c.amount) AS total_revenue
FROM doctors d
JOIN consultations c ON d.doctor_id = c.doctor_id
WHERE c.paid = 1
GROUP BY d.doctor_id, CONCAT(d.first_name,' ',d.last_name);

-- Q27
SELECT TOP 3
    s.specialty_name,
    SUM(c.amount) AS total_revenue
FROM specialties s
JOIN doctors d ON s.specialty_id = d.specialty_id
JOIN consultations c ON d.doctor_id = c.doctor_id
GROUP BY s.specialty_name
ORDER BY total_revenue DESC;

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
    AVG(med_count * 1.0) AS average_medications_per_prescription
FROM (
    SELECT COUNT(*) AS med_count
    FROM prescription_details
    GROUP BY prescription_id
) AS t;

-- Q30
SELECT
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(COUNT(*)*100 / (SELECT COUNT(*) FROM patients),2) AS percentage
FROM patients
GROUP BY age_group;

