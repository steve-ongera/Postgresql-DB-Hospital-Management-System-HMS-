-- File: 02_functions.sql
-- Purpose: Custom functions for Hospital Management System
-- Description: Contains useful functions for common operations

-- Function to get patient's age
CREATE OR REPLACE FUNCTION get_patient_age(date_of_birth DATE)
RETURNS INTEGER AS $$
BEGIN
    RETURN date_part('year', age(current_date, date_of_birth));
END;
$$ LANGUAGE plpgsql;

-- Function to check doctor availability
CREATE OR REPLACE FUNCTION is_doctor_available(
    p_doctor_id UUID,
    p_appointment_date DATE,
    p_appointment_time TIME
)
RETURNS BOOLEAN AS $$
DECLARE
    existing_appointments INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO existing_appointments
    FROM appointments
    WHERE staff_id = p_doctor_id
    AND appointment_date = p_appointment_date
    AND appointment_time = p_appointment_time
    AND status != 'cancelled';
    
    RETURN existing_appointments = 0;
END;
$$ LANGUAGE plpgsql;

-- Function to schedule appointment
CREATE OR REPLACE FUNCTION schedule_appointment(
    p_patient_id UUID,
    p_doctor_id UUID,
    p_dept_id UUID,
    p_appointment_date DATE,
    p_appointment_time TIME
)
RETURNS UUID AS $$
DECLARE
    new_appointment_id UUID;
BEGIN
    IF NOT is_doctor_available(p_doctor_id, p_appointment_date, p_appointment_time) THEN
        RAISE EXCEPTION 'Doctor is not available at the specified time';
    END IF;

    INSERT INTO appointments (
        patient_id,
        staff_id,
        dept_id,
        appointment_date,
        appointment_time
    ) VALUES (
        p_patient_id,
        p_doctor_id,
        p_dept_id,
        p_appointment_date,
        p_appointment_time
    ) RETURNING appointment_id INTO new_appointment_id;

    RETURN new_appointment_id;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate medication stock value
CREATE OR REPLACE FUNCTION calculate_medication_stock_value()
RETURNS DECIMAL AS $$
DECLARE
    total_value DECIMAL(10,2);
BEGIN
    SELECT SUM(unit_price * stock_quantity)
    INTO total_value
    FROM medications;
    
    RETURN total_value;
END;
$$ LANGUAGE plpgsql;

-- Function to get patient's medical history
CREATE OR REPLACE FUNCTION get_patient_medical_history(p_patient_id UUID)
RETURNS TABLE (
    visit_date DATE,
    doctor_name TEXT,
    diagnosis TEXT,
    treatment TEXT,
    medications TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mr.date_of_visit,
        concat(s.first_name, ' ', s.last_name) as doctor_name,
        mr.diagnosis,
        mr.treatment,
        string_agg(m.name, ', ') as medications
    FROM medical_records mr
    JOIN staff s ON mr.staff_id = s.staff_id
    LEFT JOIN prescriptions p ON mr.record_id = p.record_id
    LEFT JOIN medications m ON p.medication_id = m.medication_id
    WHERE mr.patient_id = p_patient_id
    GROUP BY mr.date_of_visit, doctor_name, mr.diagnosis, mr.treatment
    ORDER BY mr.date_of_visit DESC;
END;
$$ LANGUAGE plpgsql;