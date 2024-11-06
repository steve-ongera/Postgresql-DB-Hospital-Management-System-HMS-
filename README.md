# POSTGRESQL DB Hospital Management System (HMS)

## 🏥 Overview
A comprehensive PostgreSQL-based Hospital Management System that handles patient records, staff management, appointments, medical records, and inventory management. This system is designed to streamline hospital operations and improve healthcare service delivery.

## 📋 Table of Contents
- [Features](#features)
- [Database Schema](#database-schema)
- [System Components](#system-components)
- [Installation](#installation)
- [Usage](#usage)
- [Database Functions](#database-functions)
- [Views](#views)
- [Triggers](#triggers)
- [Security](#security)
- [Maintenance](#maintenance)
- [Contributing](#contributing)

## ✨ Features
- Patient management
- Staff and department administration
- Appointment scheduling
- Medical records management
- Medication inventory tracking
- Prescription management
- Automated alerts system
- Comprehensive reporting system

## 🗄️ Database Schema

### Core Tables
1. **Departments**
   - UUID-based primary key
   - Department name and location
   - Head doctor reference
   - Timestamps for record tracking

2. **Staff**
   - Personal and professional information
   - Role-based classification
   - Department association
   - Employment status tracking

3. **Patients**
   - Comprehensive patient information
   - Emergency contact details
   - Insurance information
   - Medical history linkage

4. **Appointments**
   - Schedule management
   - Status tracking
   - Patient-doctor association
   - Department allocation

5. **Medical Records**
   - Patient visit history
   - Diagnosis and treatment details
   - Follow-up tracking
   - Prescription linkage

6. **Medications**
   - Inventory management
   - Stock tracking
   - Pricing information
   - Reorder level monitoring

7. **Prescriptions**
   - Medication assignments
   - Dosage information
   - Duration and frequency details
   - Medical record association

## 🛠️ System Components

### 1. Schema File (01_schema.sql)
- Table definitions
- Relationships and constraints
- Indexes for performance optimization
- UUID extension implementation

### 2. Functions File (02_functions.sql)
- `get_patient_age()`: Calculate patient age
- `is_doctor_available()`: Check doctor availability
- `schedule_appointment()`: Handle appointment booking
- `calculate_medication_stock_value()`: Inventory valuation
- `get_patient_medical_history()`: Retrieve patient history

### 3. Triggers File (03_triggers.sql)
- Timestamp updates
- Stock level monitoring
- Appointment validation
- Data integrity maintenance

### 4. Views File (04_views.sql)
- Doctor's schedule view
- Department statistics
- Patient summary
- Medication inventory
- Staff workload metrics

## 📥 Installation

### Prerequisites
- PostgreSQL 12 or higher
- Minimum 8GB RAM recommended
- 50GB storage space
- Linux/Unix environment (recommended)

### Setup Steps
1. Clone the repository:
```bash
git clone [repository-url]
cd hospital-management-system
```

2. Create the database:
```sql
CREATE DATABASE hospital_management;
```

3. Execute the SQL files in order:
```bash
psql -d hospital_management -f 01_schema.sql
psql -d hospital_management -f 02_functions.sql
psql -d hospital_management -f 03_triggers.sql
psql -d hospital_management -f 04_views.sql
```

## 💻 Usage

### Basic Operations

#### Adding a New Patient
```sql
INSERT INTO patients (
    first_name, last_name, date_of_birth, gender
) VALUES (
    'John', 'Doe', '1990-01-01', 'male'
);
```

#### Scheduling an Appointment
```sql
SELECT schedule_appointment(
    patient_id, 
    doctor_id,
    dept_id,
    appointment_date,
    appointment_time
);
```

#### Viewing Doctor's Schedule
```sql
SELECT * FROM doctor_schedule 
WHERE appointment_date = CURRENT_DATE;
```

## 📊 Database Functions

### Key Functions
- Patient Age Calculation
- Appointment Scheduling
- Inventory Management
- Medical History Retrieval
- Stock Valuation

## 👁️ Views

### Available Views
- `doctor_schedule`: Daily appointment schedule
- `department_stats`: Departmental statistics
- `patient_summary`: Patient overview
- `medication_inventory`: Stock status
- `staff_workload`: Staff performance metrics

## ⚡ Triggers

### Automated Actions
- Timestamp updates
- Stock level alerts
- Appointment validation
- Data integrity checks

## 🔒 Security

### Implementation
- Role-based access control
- Data encryption recommendations
- Audit trail maintenance
- Backup procedures

## 🔧 Maintenance

### Regular Tasks
1. Database backup
2. Performance monitoring
3. Index optimization
4. Data archiving

## 📈 Performance Optimization

### Implemented Features
- Indexed queries
- Optimized views
- Efficient triggers
- Query performance monitoring

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create Pull Request

## 📝 License
This project is licensed under the MIT License

## 👥 Contact
For support or queries, contact [gadafisteve001@gmail.com]

## 🗓️ Version History
- v1.0 - Initial release
- v1.1 - Added medication management
- v1.2 - Added advanced reporting
- v1.3 - Performance optimization

## 📚 Additional Documentation
- User Manual
- API Documentation
- Deployment Guide
- Troubleshooting Guide

## ⚠️ Known Issues
- List any known issues or limitations
- Planned fixes and improvements
- Workarounds if available

## 🌟 Best Practices
- Regular backups
- Index maintenance
- Performance monitoring
- Security updates