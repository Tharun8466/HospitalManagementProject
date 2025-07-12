CREATE DATABASE HMS;
USE HMS;

-- creating tables

CREATE TABLE Patient (
    email VARCHAR(50) PRIMARY KEY,
    password VARCHAR(30) NOT NULL,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(60) NOT NULL,
    gender VARCHAR(20) NOT NULL
);

CREATE TABLE Doctor (
    email VARCHAR(50) PRIMARY KEY,
    password VARCHAR(30) NOT NULL,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(20) NOT NULL
);

CREATE TABLE MedicalHistory (
    id INT PRIMARY KEY,
    date_time DATETIME NOT NULL,
    conditions VARCHAR(100) NOT NULL,
    surgeries VARCHAR(100) NOT NULL,
    medication VARCHAR(100) NOT NULL,
    patient_email VARCHAR(50) NOT NULL,
    FOREIGN KEY (patient_email) REFERENCES Patient(email) ON DELETE CASCADE
);

CREATE TABLE Appointment (
    id INT PRIMARY KEY,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(15) NOT NULL
);

CREATE TABLE Schedule (
    id INT PRIMARY KEY,
    day VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    breaks TIME NOT NULL,
    doctor_email VARCHAR(50) NOT NULL,
    FOREIGN KEY (doctor_email) REFERENCES Doctor(email) ON DELETE CASCADE
);

CREATE TABLE DoctorViewsHistory (
    doctor_email VARCHAR(50) NOT NULL,
    history_id INT NOT NULL,
    PRIMARY KEY (doctor_email, history_id),
    FOREIGN KEY (doctor_email) REFERENCES Doctor(email) ON DELETE CASCADE,
    FOREIGN KEY (history_id) REFERENCES MedicalHistory(id) ON DELETE CASCADE
);

CREATE TABLE PatientsAttendAppointments (
    patient_email VARCHAR(50) NOT NULL,
    appointment_id INT NOT NULL,
    concerns VARCHAR(40) NOT NULL,
    symptoms VARCHAR(40) NOT NULL,
    PRIMARY KEY (patient_email, appointment_id),
    FOREIGN KEY (patient_email) REFERENCES Patient(email) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id) ON DELETE CASCADE
);

CREATE TABLE Diagnose (
    appointment_id INT NOT NULL,
    doctor_email VARCHAR(50) NOT NULL,
    diagnosis VARCHAR(100) NOT NULL,
    prescription VARCHAR(100) NOT NULL,
    PRIMARY KEY (appointment_id, doctor_email),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_email) REFERENCES Doctor(email) ON DELETE CASCADE
);

CREATE TABLE AppointmentsCorrespondSchedules (
    appointment_id INT NOT NULL,
    schedule_id INT NOT NULL,
    PRIMARY KEY (appointment_id, schedule_id),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES Schedule(id) ON DELETE CASCADE
);

 
-- insertions

INSERT INTO Patient (email, password, name, address, gender) VALUES
('alice@example.com', 'alice123', 'Alice Brown', '123 Main Street', 'Female'),
('bob@example.com', 'bob123', 'Bob Smith', '456 Elm Avenue', 'Male');

INSERT INTO Doctor (email, password, name, gender) VALUES
('dr.john@example.com', 'john123', 'Dr. John Doe', 'Male'),
('dr.lisa@example.com', 'lisa123', 'Dr. Lisa Wong', 'Female');

INSERT INTO MedicalHistory (id, date_time, conditions, surgeries, medication, patient_email) VALUES
(1, '2023-01-10 09:00:00', 'Hypertension', 'Appendectomy', 'Lisinopril', 'alice@example.com'),
(2, '2023-02-15 11:30:00', 'Diabetes', 'None', 'Metformin', 'bob@example.com');

INSERT INTO Schedule (id, day, start_time, end_time, breaks, doctor_email) VALUES
(1, 'Monday', '09:00:00', '17:00:00', '12:00:00', 'dr.john@example.com'),
(2, 'Tuesday', '10:00:00', '18:00:00', '13:00:00', 'dr.lisa@example.com');

INSERT INTO Appointment (id, date, start_time, end_time, status) VALUES
(101, '2023-07-01', '10:00:00', '10:30:00', 'Completed'),
(102, '2023-07-02', '11:00:00', '11:30:00', 'Pending');

INSERT INTO PatientsAttendAppointments (patient_email, appointment_id, concerns, symptoms) VALUES
('alice@example.com', 101, 'Headache', 'Nausea'),
('bob@example.com', 102, 'Checkup', 'Fatigue');

INSERT INTO Diagnose (appointment_id, doctor_email, diagnosis, prescription) VALUES
(101, 'dr.john@example.com', 'Migraine', 'Ibuprofen'),
(102, 'dr.lisa@example.com', 'Routine Check', 'Vitamin D');

INSERT INTO DoctorViewsHistory (doctor_email, history_id) VALUES
('dr.john@example.com', 1),
('dr.lisa@example.com', 2);

INSERT INTO AppointmentsCorrespondSchedules (appointment_id, schedule_id) VALUES
(101, 1),
(102, 2);


-- Questions

-- Q1. List all patients along with their medical conditions

SELECT p.name, p.email, m.conditions, m.medication
FROM Patient p
JOIN MedicalHistory m ON p.email = m.patient_email;

-- Q2. Find all appointments for Dr. John Doe including patient concerns

SELECT 
  a.id AS appointment_id,
  a.date,
  a.start_time,
  pa.concerns,
  pa.symptoms,
  d.diagnosis,
  d.prescription
FROM Appointment a
JOIN PatientsAttendAppointments pa ON a.id = pa.appointment_id
JOIN Diagnose d ON a.id = d.appointment_id
WHERE d.doctor_email = 'dr.john@example.com';

-- Q3. Show doctors and the medical histories they have viewed

SELECT 
  doc.name AS doctor_name,
  mh.conditions,
  mh.medication,
  p.name AS patient_name
FROM DoctorViewsHistory dvh
JOIN Doctor doc ON dvh.doctor_email = doc.email
JOIN MedicalHistory mh ON dvh.history_id = mh.id
JOIN Patient p ON mh.patient_email = p.email;

-- Q4. List all schedules for Dr. Lisa Wong

SELECT 
  s.day,
  s.start_time,
  s.end_time,
  s.breaks
FROM Schedule s
WHERE s.doctor_email = 'dr.lisa@example.com';

--  Q5. Count the number of appointments each doctor has diagnosed 

SELECT 
  d.name,
  COUNT(di.appointment_id) AS num_appointments
FROM Doctor d
LEFT JOIN Diagnose di ON d.email = di.doctor_email
GROUP BY d.name;

-- Q7. List all appointments and the schedules they correspond to

SELECT
  a.id AS appointment_id,
  a.date,
  s.day,
  s.start_time,
  s.end_time
FROM AppointmentsCorrespondSchedules acs
JOIN Appointment a ON acs.appointment_id = a.id
JOIN Schedule s ON acs.schedule_id = s.id; 




 

 


 
   
