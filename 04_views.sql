-- File: 04_views.sql
-- Purpose: Database views for Hospital Management System
-- Description: Commonly used data views

-- View for doctor's daily schedule
CREATE OR REPLACE VIEW doctor_schedule AS
SELECT 
    a.appointment_id,
    concat(s.first_name, ' ', s.last_name) as doctor_name,
    concat(p.first_name, ' ', p.last_name) as patient_name,
    d.dept_name,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM appointments a
JOIN staff s ON a.staff_id = s.staff_id
JOIN patients p ON a.patient_id = p.patient_id
JOIN departments d ON a.dept_id = d.dept_id
WHERE s.role = 'doctor'
ORDER BY a.appointment_date, a.appointment_time;

-- View for department statistics
CREATE OR REPLACE VIEW department_stats AS
SELECT 
    d.dept_id,
    d.dept_name,
    COUNT(DISTINCT s.staff_id) as staff_count,
    COUNT(DISTINCT CASE WHEN s.role = 'doctor' THEN s.staff_id END) as doctor_count,
    COUNT(DISTINCT CASE WHEN s.role = 'nurse' THEN s.staff_id END) as nurse_count,
    COUNT(DISTINCT a.appointment_id) as monthly_appointments,
    ROUND(AVG(s.salary), 2) as avg_staff_salary
FROM departments d
LEFT JOIN staff s ON d.dept_id = s.dept_id
LEFT JOIN appointments a ON d.dept_id = a.dept_id 
    AND a.appointment_date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY d.dept_id, d.dept_name;

-- View for patient summary
CREATE OR REPLACE VIEW patient_summary AS
SELECT 
    p.patient_id,
    concat(p.first_name, ' ', p.last_name) as patient_name,
    get_patient_age(p.date_of_birth) as age,
    p.gender,
    p.blood_group,
    COUNT(DISTINCT a.appointment_id) as total_appointments,
    COUNT(DISTINCT mr.record_id) as total_visits,
    MAX(mr.date_of_visit) as last_visit_date
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
LEFT JOIN medical_records mr ON p.patient_id = mr.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name, p.date_of_birth, p.gender, p.blood_group;

-- View for medication inventory
CREATE OR REPLACE VIEW medication_inventory AS
SELECT 
    m.medication_id,
    m.name,
    m.manufacturer,
    m.stock_quantity,
    m.unit_price,
    (m.stock_quantity * m.unit_price) as total_value,
    CASE 
        WHEN m.stock_quantity <= m.reorder_level THEN 'Reorder Required'
        WHEN m.stock_quantity <= m.reorder_level * 2 THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END as stock_status
FROM medications m;

-- View for staff workload
CREATE OR REPLACE VIEW staff_workload AS
SELECT 
    s.staff_id,
    concat(s.first_name, ' ', s.last_name) as staff_name,
    s.role,
    d.dept_name,
    COUNT(DISTINCT a.appointment_id) as monthly_appointments,
    COUNT(DISTINCT mr.record_id) as monthly_patients_treated,
    COUNT(DISTINCT p.prescription_id) as monthly_prescriptions
FROM staff s
JOIN departments d ON s.dept_id = d.dept_id
LEFT JOIN appointments a ON s.staff_id = a.staff_id 
    AND a.appointment_date >= DATE_TRUNC('month', CURRENT_DATE)
LEFT JOIN medical_records mr ON s.staff_id = mr.staff_id 
    AND mr.date_of_visit >= DATE_TRUNC('month', CURRENT_DATE)
LEFT JOIN prescriptions p ON mr.record_id = p.record_id
GROUP BY s.staff_id, s.first_name, s.last_name, s.role, d.dept_name;