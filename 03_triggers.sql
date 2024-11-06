-- File: 03_triggers.sql
-- Purpose: Database triggers for Hospital Management System
-- Description: Automatic actions on data changes

-- Trigger to update timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to all tables
CREATE TRIGGER update_departments_timestamp
    BEFORE UPDATE ON departments
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_staff_timestamp
    BEFORE UPDATE ON staff
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_patients_timestamp
    BEFORE UPDATE ON patients
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp();

-- Trigger to check medication stock and create alert
CREATE OR REPLACE FUNCTION check_medication_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stock_quantity <= NEW.reorder_level THEN
        INSERT INTO alerts (
            alert_type,
            message,
            status
        ) VALUES (
            'stock_alert',
            format('Medication %s is low on stock. Current quantity: %s', NEW.name, NEW.stock_quantity),
            'active'
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER medication_stock_check
    AFTER UPDATE OR INSERT ON medications
    FOR EACH ROW
    EXECUTE FUNCTION check_medication_stock();

-- Trigger to validate appointment scheduling
CREATE OR REPLACE FUNCTION validate_appointment()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if doctor exists and is active
    IF NOT EXISTS (
        SELECT 1 FROM staff 
        WHERE staff_id = NEW.staff_id 
        AND role = 'doctor' 
        AND status = 'active'
    ) THEN
        RAISE EXCEPTION 'Invalid or inactive doctor selected';
    END IF;

    -- Check if department exists
    IF NOT EXISTS (
        SELECT 1 FROM departments 
        WHERE dept_id = NEW.dept_id
    ) THEN
        RAISE EXCEPTION 'Invalid department selected';
    END IF;

    -- Check if patient exists
    IF NOT EXISTS (
        SELECT 1 FROM patients 
        WHERE patient_id = NEW.patient_id
    ) THEN
        RAISE EXCEPTION 'Invalid patient selected';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER appointment_validation
    BEFORE INSERT ON appointments
    FOR EACH ROW
    EXECUTE FUNCTION validate_appointment();