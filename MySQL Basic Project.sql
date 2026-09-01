create database hospital_db;
use hospital_db;

create table patients
(
patient_id int primary key auto_increment,
name varchar(100) not null,
age int,
gender varchar(10),
phone varchar(15) unique
);

create table doctors
(
doctor_id int primary key auto_increment,
name varchar(100),
specialization varchar(100),
consultation_fee decimal(10,2)
);

create table appointments
(
appointment_id int primary key auto_increment,
patient_id int,
doctor_id int,
appointment_date date,
status varchar(20),
foreign key (patient_id) references patients(patient_id),
foreign key (doctor_id) references doctors(doctor_id)
);

create table treatments
(
treatment_id int primary key auto_increment,
appointment_id int,
description text,
cost decimal(10,2),
foreign key (appointment_id) references appointments(appointment_id)
);

create table bills
(
bill_id int primary key auto_increment,
patient_id int,
total_amount decimal(10,2),
bill_date date,
foreign key (patient_id) references patients(patient_id)
);

insert into patients (name, age, gender, phone)
values
('Rahul Sharma', 28, 'Male', '9876543210'),
('Priya Verma', 35, 'Female', '9876543211'),
('Amit Singh', 42, 'Male', '9876543212'),
('Neha Gupta', 24, 'Female', '9876543213'),
('Rohan Mehta', 51, 'Male', '9876543214'),
('Sneha Kapoor', 31, 'Female', '9876543215'),
('Vikas Yadav', 46, 'Male', '9876543216'),
('Anjali Mishra', 29, 'Female', '9876543217'),
('Karan Malhotra', 63, 'Male', '9876543218'),
('Pooja Agarwal', 38, 'Female', '9876543219');

insert into doctors (name, specialization, consultation_fee)
values
('Dr. Rajiv Kumar', 'Cardiology', 1200.00),
('Dr. Meena Sharma', 'Dermatology', 800.00),
('Dr. Arjun Verma', 'Orthopedic', 1000.00),
('Dr. Neha Kapoor', 'Cardiology', 1000.00),
('Dr. Amit Malhotra', 'Neurology', 1500.00),
('Dr. Pankaj Singh', 'Neurology', 1800.00),
('Dr. Ritu Gupta', 'Orthopedic', 700.00),
('Dr. Sameer Khan', 'Dermatology', 750.00);

#1
select * from patients;

#2
select * from doctors where specialization = 'Cardiology';

insert into appointments
(patient_id, doctor_id, appointment_date, status)
values
(1, 1, '2026-01-10', 'Completed'),
(2, 2, '2026-01-12', 'Completed'),
(3, 1, '2026-01-15', 'Completed'),
(1, 3, '2026-01-20', 'Completed'),
(4, 4, '2026-01-25', 'Cancelled'),
(5, 5, '2026-02-02', 'Completed'),
(6, 6, '2026-02-05', 'Completed'),
(2, 1, '2026-02-10', 'Completed'),
(7, 3, '2026-02-15', 'Completed'),
(8, 8, '2026-02-20', 'Scheduled'),
(1, 4, '2026-03-01', 'Completed'),
(9, 5, '2026-03-05', 'Completed'),
(3, 6, '2026-03-10', 'Scheduled'),
(5, 7, '2026-03-15', 'Completed');

select * from appointments;

#3
select a.appointment_id, p.name, d.name, a.appointment_date, a.status 
from appointments a left join patients p on p.patient_id = a.patient_id
left join doctors d on d.doctor_id = a.doctor_id;  

#4
select d.name, count(a.doctor_id) as no_of_appointments
from doctors d left join appointments a on d.doctor_id = a.doctor_id
group by d.doctor_id, d.name;

#5
with appointment_count as
(
	select d.doctor_id, d.name, count(a.doctor_id) as no_of_appointments 
	from doctors d left join appointments a on d.doctor_id = a.doctor_id
	group by d.doctor_id, d.name
)
select ac.name, ac.no_of_appointments, 
ac.no_of_appointments * d.consultation_fee as revenue_generated
from appointment_count ac left join doctors d on d.doctor_id = ac.doctor_id
;

#6
with patient_appointment_count as
(
	select p.patient_id, p.name, count(a.patient_id) as no_of_appointments
	from patients p left join appointments a on p.patient_id = a.patient_id
	group by p.patient_id, p.name
)
select p.* from patients p
join patient_appointment_count as apc on p.patient_id = apc.patient_id
where apc.no_of_appointments = 0; 

select p.*
from patients p
left join appointments a
    on p.patient_id = a.patient_id
where a.patient_id is null;