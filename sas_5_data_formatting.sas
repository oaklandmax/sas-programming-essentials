%let path=/folders/myfolders/sasuser.v94/ecprg193; 
libname orion "&path";

***** SAS Programming 1 Essentials - Lesson 5: Formatting data values, adding format library;


***** Applying user defined formats;
title2 "User Defined Data Formats";
title4 "Senior Sales Representatives";
footnote5 "Job_Title: Sales Rep. IV";

data q1birthdays;
   set orion.employee_payroll;
   BirthMonth=month(Birth_Date);
   if BirthMonth le 3;
run;

proc format;
    value $gender 
    'M'='Male'
    'F'='Female'
    other ='Whatevs';
    
    value month_full
    1='January'
    2='February'
    3='March';
    
    value $marital_status 
    'M'='Married'
    'S'='Single'
    other ='Whatevs';
run;

proc print data=q1birthdays label;
    format Employee_Gender $gender.;
    format BirthMonth month_full.;
    format Marital_Status $marital_status.;
    format salary dollar10. Birth_Date Employee_Hire_Date Employee_Term_Date date9.;
    label employee_id="Emloyee ID" salary="Salary" Birth_Date="Date of Birth" Employee_Hire_Date="Hire Date" Employee_Term_Date="Date of Termination";
run;

proc contents data=work.q1birthdays;
run;

title;
footnote;

***** Formatting values to currency, dates. Adding Labels;
    title1 "Formatting values";
    proc print data=orion.sales label;
        var employee_id first_name last_name job_title;
        label employee_id="Employee ID" first_name="First Name" last_name="Last Name" job_title="Job Title";
        format first_name $upcase. last_name $upcase. job_title $quote.;
        format salary dollar10. Birth_Date Employee_Hire_Date hire_date Employee_Term_Date date9.;
    run;
    
    proc print data=orion.employee_payroll label;
        var employee_id salary Birth_Date Employee_Hire_Date Employee_Term_Date;
        format salary dollar10. Birth_Date Employee_Hire_Date Employee_Term_Date date9.;
        label employee_id="Emloyee ID" salary="Salary" Birth_Date="Date of Birth" Employee_Hire_Date="Hire Date" Employee_Term_Date="Date of Termination";
    run;
    
    title;
    footnote;
    
