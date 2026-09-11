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
select d.name, count(a.doctor_id) as no_of_appintments, sum(consultation_fee) as revenue from
appointments a join doctors d on a.doctor_id=d.doctor_id
group by a.doctor_id, d.name;
 
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

insert into treatments
(appointment_id, description, cost)
values
(1, 'ECG and cardiac consultation', 2500.00),
(2, 'Skin allergy examination', 1200.00),
(3, 'Heart checkup and ECG', 2800.00),
(4, 'Knee X-Ray and examination', 2200.00),
(5, 'Neurological examination', 3000.00),
(6, 'Migraine assessment and treatment', 3500.00),
(7, 'Cardiac consultation and ECG', 2400.00),
(8, 'Knee joint examination', 1800.00),
(9, 'Neurological consultation', 3200.00),
(10, 'Skin infection examination', 1100.00),
(11, 'Cardiac stress test', 4000.00),
(12, 'Neurological scan and consultation', 4500.00),
(14, 'Knee X-Ray and physiotherapy', 2500.00);

insert into bills
(patient_id, total_amount, bill_date)
values
(1, 6500.00, '2026-01-10'),
(2, 2000.00, '2026-01-12'),
(3, 4000.00, '2026-01-15'),
(1, 3200.00, '2026-01-20'),
(5, 4500.00, '2026-02-02'),
(6, 5300.00, '2026-02-05'),
(2, 3600.00, '2026-02-10'),
(7, 2800.00, '2026-02-15'),
(8, 1850.00, '2026-02-20'),
(1, 5200.00, '2026-03-01'),
(9, 6000.00, '2026-03-05'),
(5, 3200.00, '2026-03-15');

#7
select p.name, sum(b.total_amount) as total_billing from bills b
join patients p on b.patient_id = p.patient_id
group by p.name, p.patient_id
order by total_billing desc
limit 3;

#8
create view doctor_revenue_summary as
(
	select d.name, count(a.appointment_id) as no_of_appintments, sum(consultation_fee) as revenue from
	appointments a join doctors d on a.doctor_id=d.doctor_id
	group by a.doctor_id, d.name
);
select * from doctor_revenue_summary;

#9
select * from treatments;
select * from bills;
select * from appointments;

#9
delimiter !!
create trigger update_bill
after insert on treatments
for each row
begin
	insert into bills (patient_id, total_amount, bill_date) 
    select a.patient_id, new.cost, curdate() from appointments a 
    where a.appointment_id = new.appointment_id;
end !! delimiter ; 

insert into treatments
(appointment_id, description, cost)
values
(1, 'ECG and cardiac consultation', 2500);

select * from appointments;

#10
delimiter ||
create procedure book_appointment(in p_id int, in d_id int, in a_date date, in a_status varchar(20))
begin
	insert into appointments (patient_id, doctor_id, appointment_date, status)
    value (p_id, d_id, a_date, a_status);
end || delimiter ;

CALL book_appointment(5, 1, '2026-04-10', 'Scheduled');

