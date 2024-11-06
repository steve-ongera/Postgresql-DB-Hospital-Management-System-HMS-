-- File: 01_schema.sql
-- Purpose: Database schema for Hospital Management System
-- Description: Creates all necessary tables with their relationships

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Departments Table
CREATE TABLE departments (
    dept_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    head_doctor_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Staff Table
CREATE TABLE staff (
    staff_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    dept_id UUID REFERENCES departments(dept_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role ENUM('doctor', 'nurse', 'receptionist', 'admin') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('active', 'on_leave', 'terminated') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Patients Table
CREATE TABLE patients (
    patient_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    blood_group VARCHAR(5),
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    insurance_provider VARCHAR(100),
    insurance_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Appointments Table
CREATE TABLE appointments (
    appointment_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    patient_id UUID REFERENCES patients(patient_id),
    staff_id UUID REFERENCES staff(staff_id),
    dept_id UUID REFERENCES departments(dept_id),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('scheduled', 'completed', 'cancelled', 'no_show') DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Medical Records Table
CREATE TABLE medical_records (
    record_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    patient_id UUID REFERENCES patients(patient_id),
    staff_id UUID REFERENCES staff(staff_id),
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    notes TEXT,
    date_of_visit DATE NOT NULL,
    follow_up_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Medications Table
CREATE TABLE medications (
    medication_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10,2),
    stock_quantity INTEGER,
    reorder_level INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Prescriptions Table
CREATE TABLE prescriptions (
    prescription_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    record_id UUID REFERENCES medical_records(record_id),
    medication_id UUID REFERENCES medications(medication_id),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraint for head_doctor_id in departments
ALTER TABLE departments 
ADD CONSTRAINT fk_head_doctor 
FOREIGN KEY (head_doctor_id) REFERENCES staff(staff_id);

-- Create indexes for frequently accessed columns
CREATE INDEX idx_staff_dept ON staff(dept_id);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_staff ON appointments(staff_id);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_prescriptions_record ON prescriptions(record_id);