-- Title: Hertz Clinic Booking System Database Script
-- Description: This script creates a database schema for a clinic booking system.

-- Create the database
CREATE DATABASE ClinicDB;
USE ClinicDB;

-- Create tables for the clinic booking system
-- This includes tables for patients, doctors, appointments, treatments, and prescriptions.
--------------------------------------
-- Table: Patients
-- The Patients table holds patient details with unique constraints on phone and email.
--------------------------------------
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

--------------------------------------
-- Table: Doctors
-- The Doctors table represents doctor details with unique constraints on email and phone.
-- It also includes a specialty field to categorize doctors.
--------------------------------------
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    Specialty VARCHAR(100),
    HireDate DATE NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

--------------------------------------
-- Table: Appointments
-- The Appointments table links patients and doctors via foreign keys.
-- It also includes a unique constraint on (DoctorID, AppointmentDate) to help avoid double-booking.
--------------------------------------
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Reason VARCHAR(255),
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_appointment_patient FOREIGN KEY (PatientID)
        REFERENCES Patients(PatientID)
        ON DELETE CASCADE,
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (DoctorID)
        REFERENCES Doctors(DoctorID)
        ON DELETE CASCADE,
    CONSTRAINT uq_doctor_appointment UNIQUE (DoctorID, AppointmentDate)  -- Prevent double-booking a doctor
) ENGINE=InnoDB;

--------------------------------------
-- Table: Treatments
-- The Treatments table records treatment details linked to appointments.
-- It includes a foreign key to the Appointments table and a timestamp for when the treatment was created.
--------------------------------------
CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    Description TEXT NOT NULL,
    TreatmentDate DATETIME NOT NULL,
    Notes TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_treatment_appointment FOREIGN KEY (AppointmentID)
        REFERENCES Appointments(AppointmentID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

--------------------------------------
-- Table: Prescriptions
-- The Prescriptions table records medication prescribed during treatments.
-- It includes a foreign key to the Treatments table and fields for dosage and duration.
--------------------------------------
CREATE TABLE Prescriptions (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    TreatmentID INT NOT NULL,
    MedicineName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(50) NOT NULL,
    Duration VARCHAR(50) NOT NULL,
    Instructions TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_treatment FOREIGN KEY (TreatmentID)
        REFERENCES Treatments(TreatmentID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

--------------------------------------
-- Example of Many-to-Many: Doctor Specializations
-- In a real-world scenario, doctors may have multiple specializations.
-- A many-to-many relationship is demonstrated through the DoctorSpecializations table that joins Doctors with Specializations.
--------------------------------------
-- If a doctor can have multiple specialties and specialties can belong to many doctors,
-- we can have a join table between Doctors and Specializations.

-- Create a Specializations table
CREATE TABLE Specializations (
    SpecializationID INT AUTO_INCREMENT PRIMARY KEY,
    SpecializationName VARCHAR(100) NOT NULL,
    UNIQUE (SpecializationName)
) ENGINE=InnoDB;

-- Then create a join table for the many-to-many relationship:
CREATE TABLE DoctorSpecializations (
    DoctorID INT NOT NULL,
    SpecializationID INT NOT NULL,
    PRIMARY KEY (DoctorID, SpecializationID),
    CONSTRAINT fk_ds_doctor FOREIGN KEY (DoctorID)
        REFERENCES Doctors(DoctorID)
        ON DELETE CASCADE,
    CONSTRAINT fk_ds_specialization FOREIGN KEY (SpecializationID)
        REFERENCES Specializations(SpecializationID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

------------------------------------------------------------
-- End of Hertz Clinic Booking System Database Script
------------------------------------------------------------
