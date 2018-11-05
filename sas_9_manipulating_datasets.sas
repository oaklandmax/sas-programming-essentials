%let path=/folders/myfolders/sasuser.v94/ecprg193; 
libname orion "&path";

***** SAS Programming 1 Essentials - Lesson 9 Manipulating datasets;

***** Using multiple if conditions and do code blocks for executing multiple var assignments per condition;
title1 'Lesson 9 Modifying Datasets, Challenge 1: Adding vars calculated from existing data';
data work.region;
   set orion.supplier;
   if upcase(country)='CA' | upcase(country)='US' then
    do;
        Discount = 0.10;
        DiscountType = 'Required';
        Region = 'North America';
    end;
   else do;
        Discount = 0.05;
        DiscountType = 'Optional';
        Region = 'Overseas';
   end;
run;

proc print data=work.region;
run;
title;
footnote;

*****  Assigning multiple new vars by using do statements to allow if statement to execute code block ;
    title1 "Lesson 9 Modifying Datasets: Assign bonus by job title using do block in if-else statements";
    footnote "challenge";
    * note any missing empid or salary in records;
    data work.bonus;
       set orion.nonsales;
       if upcase(Country) = 'US' then
       do;
        Bonus=500;
        freq=1;
       end;
       else if upcase(country)='AU' then
       do;
        Bonus=300;
        freq=2;
       end;
    run;
    
    proc print data=work.bonus;
    run;
    title;
    footnote;

***** evaluating condition using if-else statements and assigning new vars accordingly;
    title1 "Lesson 9 Modifying Datasets: Assign bonus by region using if-else statements";
    data work.emp_bonus;
        set orion.sales;
        if job_title='Sales Rep. IV' | job_title='Sales Rep. III' 
            then Bonus=1000;
        else if job_title='Sales Manager' 
            then Bonus=1500;
        else if job_title='Senior Sales Manager' 
            then Bonus=2000;
        else if job_title='Chief Sales Officer' 
            then Bonus=2500;
        else bonus=500;
    
        format bonus dollar8.0;
    run;
    
    proc print data=work.emp_bonus;
        var last_name job_title bonus;
    run;
    title;
    footnote;

**** Concatonating vars into new var, and using intck function to calc time unit offset, in this case 'year';
    title1 "Calculating new vars using catx and intck";
    data work.employees;
        set orion.sales;
        FullName = catx(' ', first_name, last_name);
        Years2012 = intck('year', Hire_Date, '01Jan12'd);
        format birth_date hire_date date9. salary dollar12.2;
        label years2012='Years of Employment in 2012';
    run;
    
    proc print data=work.employees label;
        var fullname hire_date years2012;
    run;
    title;
    footnote;

***** Assiging new variables using functions and passing params to calulate new date vars from existing vars in data step;
    title1 "Calculating new date vars from existing vars";
    footnote "End of challenge 9.2";
    data work.birthday;
        set orion.customer;
        BDay2012 = mdy(month(birth_date),day(birth_date),2012);
        BDayDOW2012 = weekday(birth_date);
        Age2012 = sum(bday2012, -birth_date)/365.25;
        format bday2012 date9.;
        format Age2012 3.0;
        keep Customer_Name Birth_Date Bday2012 BdayDOW2012 Age2012;
    run;
    
    proc print data=work.birthday;
    run;
    title;
    footnote;

***** Assiging new variables based on calculations from existing variables with some formatting and choosing of vars in data step;
    title1 "Calculating birthdays and dates";
    footnote "End of challenge 9.1";
    data work.increase;
       set orion.staff;
       Increase = salary*0.1;
       NewSalary = sum(salary, increase);
       BdayQtr = qtr(birth_date);
       keep Employee_ID Salary Birth_Date increase newsalary bdayqtr;
       format salary increase newsalary dollar12.2;
       label newsalary='New Salary' bdayqtr='Birthday Quarter';
    run;
    
    proc print data=work.increase label;
    run;
    title;
    footnote;

