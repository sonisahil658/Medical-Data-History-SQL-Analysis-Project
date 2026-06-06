Use project_medical_data_history;

Select * from admissions;
Select * from doctors;
Select * from patients;
Select * from province_names;

-- Show first name, last name, and gender of patients who's gender is 'M'
Select first_name, last_name, gender 
From patients where gender like 'M';

-- Show first name and last name of patients who does not have allergies.
Select first_name, last_name, allergies
From patients WHERE allergies IS NULL;

-- Show first name of patients that start with the letter 'C'
Select first_name 
From patients where first_name Like 'C%';

-- Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
Select first_name, last_name, weight 
From patients Where weight between 100 and 120;

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
Update patients Set alergies= 'NKA' where alergies IS Null;  -- Update is not working because of dataset is not grant permission

-- Show first name and last name concatenated into one column to show their full name.
Select concat(first_name, ' ', last_name)
From patients;

-- Show first name, last name, and the full province name of each patient.
Select pa.first_name, pa.last_name, pr.province_name
From patients pa Join province_names pr
On pa.province_id = pr.province_id;

-- Show how many patients have a birth_date with 2010 as the birth year.
Select Count(*) From patients
Where Year(birth_date) = 2010;

-- Show the first_name, last_name, and height of the patient with the greatest height.
Select first_name, last_name, height
From patients where height = (SELECT MAX(height))
Order by height Desc Limit 1;

-- Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
Select * From patients 
where patient_id IN(1,45,534,879,1000);

-- Show the total number of admissions
Select Count(*) From admissions;

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
Select * From admissions 
Where admission_date = discharge_date;

-- Show the total number of admissions for patient_id 579
Select count(*) From admissions
Where patient_id = 579;

-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
Select distinct(city)
From province_names Where province_id = 'NS';

-- Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
Select first_name, last_name, birth_date
From patients Where height > 160 And weight > 70;

-- Show unique birth years from patients and order them by ascending
Select distinct year(birth_date) As birth_year, first_name 
From patients Order by birth_year asc;

-- Show unique first names from the patients table which only occurs once in the list.
Select first_name
From patients group by first_name having count(*) = 1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
Select patient_id, first_name
From patients Where first_name Like 's%s' And character_length(6);

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
Select pa.first_name, pa.last_name, ad.patient_id, diagnosis
From patients pa Join admissions ad 
ON pa.patient_id = ad.patient_id Where diagnosis = 'Dementia';	

-- Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
Select *
From patients Order By Length(first_name) Asc;

-- Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
Select Sum(gender = 'M') As Total_Male, Sum(gender = 'F') As Total_Female
From patients;

-- Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
Select patient_id, diagnosis 
From admissions Group by patient_id, diagnosis Having Count(*) >1;

-- Show the province name and the total number of patients in the province. Order from most to least patients and then by province name ascending.
Select 
pr.province_name, 
Count(pa.patient_id) As total_patients
From patients pa 
Join province_names pr 
On pa.province_id = pr.province_id
Group by province_name 
Order by total_patients Desc, 
pr.province_name Asc;

-- Show first name, last name and role of every person that is either patient or doctor.    The roles are either "Patient" or "Doctor"
Select first_name , 'patient' As Role
From patients
union all
Select first_name, 'doctors' As Role
From doctors;				

-- Show all allergies ordered by popularity. Remove NULL values from query																																																																																																																tors 
Select allergies, count(*) As Total_Diagonsis
From patients
Where allergies Is Not Null
Group by allergies 
Order by Total_Diagonsis Desc;

-- Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
Select first_name, last_name, birth_date 
From patients
Where birth_date Between '1970-01-01' And '1980-01-01'
Order By birth_date;

-- We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane
Select concat(Upper(last_name), ',', Lower(first_name)) AS Full_Name
From patients Order By Full_Name Desc;

-- Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
Select province_id, sum(height) As Total_height 
From patients Group By province_id Having sum(height) >= 7000;

-- Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
Select max(weight) - min(weight) As Weight_differ, last_name
From patients Where last_name = 'Maroni';

-- Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
Select day(admission_date) As day_of_month, 
count(admission_date) As total_admissions	 
From admissions 
Group By(admission_date) 
Order by total_admissions Desc;

-- Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
Select Floor(weight / 10) * 10 As weight_group, 
count(*) As total_patients 
From patients 
Group By weight_group
Order By weight_group Desc;

-- Show patient_id, weight, height, is Obese from the patients table. Display is Obese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm.
Select patient_id, weight, height, 
(Case When weight/(power(height/100.0, 2))
>= 30 Then 1 Else 0 End) As isObese
From patients;

-- Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.
SELECT 
    pa.patient_id,
    pa.first_name,
    pa.last_name,
    da.specialty,
    da.first_name
FROM patients pa
JOIN admissions ad
    ON pa.patient_id = ad.patient_id
JOIN doctors da
    ON ad.attending_doctor_id = da.doctor_id
WHERE ad.diagnosis = 'Epilepsy'
  AND da.first_name = 'Lisa';





