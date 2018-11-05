%let path=/folders/myfolders/sasuser.v94/ecprg193; 
libname orion "&path";

***** SAS Programming 1 Essentials - Lesson 8: Reading raw datafiles;

***** Using DSD and missover with non-default delimiter to input data;
title1 "8.6 Using DSD and missover with non-default delimiter";
footnote "End 8.6";
data work.prices;
   infile "&path/prices.dat" dlm='*' dsd missover;
   input ProductID StartDate :date. EndDate :date. UnitCostPrice :dollar. UnitSalesPrice :dollar.;
   format StartDate MMDDYY10. EndDate MMDDYY10. UnitCostPrice dollar.2 UnitSalesPrice dollar8.2;
   label ProductID='Product ID' startdate='Start Date' enddate='End Date' unitcostprice='Unit Cost Price' unitsalesprice='Unit Sales Price';
run;

proc print data=work.prices label;
run;
title;
footnote;
    
    
***** Using missover option to keep from moving to next record if data field is blank;
    title1 "8.5 Using missover option";
    footnote "End 8.5";
    data work.contacts;
       infile "&path/donation.csv" dlm=',' dsd missover;
       input EmpID Q1 Q2 Q3 Q4;
    run;
    
    proc print data=work.contacts;
    run;
    title;
    footnote;


***** Using DSD to preserve delimiter defined missing fields and quoted fields;
    title1 "8.4 Using DSD (Delimiter Sensitive Data) to preserve consecutive delimiters, usually a comma, instead misreading it as a single var";
    footnote "End 8.4";
    data work.contacts;
       length Name $ 20 Phone Mobile $ 14;
       infile "&path/phone2.csv" dlm=',' dsd;
       input Name $ Phone $ Mobile $;
    run;
    
    proc print data=work.contacts noobs;
    run;
    title;
    footnote;


***** Importing data and setting Length and data type;
    title1 "8.3 importing data and setting input length and format on input instead of length attribute";
    footnote "End 8.3";
        
    data work.canada_customers;
        infile "&path/custca.csv" dlm=',';
        input first :$15. last :$20. id gender :$1. birth_date :mmddyy. age age_group :$12.;
        format birth_date date.;
        drop id age;
    run;
    
    proc print data=work.canada_customers;
    run;
    
    proc contents data=work.canada_customers;
    run;


***** Importing data and setting Length and data type;
    title1 "8.3 Importing data and setting Length and data type and some format attributes";
    footnote "End 8.3";
    data work.canada_customers;
        * need to set birthdate length to make it display correctly. see above for correct solution;
       length First Last $ 20 Gender $ 1 AgeGroup $ 12;
       infile "&path/custca.csv" dlm=',';
       input First $ Last $ ID Gender $ BirthDate :ddmmyy. Age AgeGroup $;
    run;
    proc print data=work.canada_customers;
    run;
    
    title;
    footnote;
    

***** Importing CSV file and setting multiple imput data types with one setting;
    title1 "8.2: Importing CSV file and setting multiple imput data types";
    footnote "End 8.2";
    
    data work.newemployees;
        infile "&path/donation.dat";
        length IDNum $ 6;
        input IDNum $ Qtr1 Qtr2 Qtr3;
    run;
    
    proc contents data=work.newemployees;
    run;
    
    proc print data=work.newemployees;
    run;
    title;
    footnote;

    
    
***** importing CSV file, setting delimiters, variable lengths and type;
    title1 "8.1 Importing CSV file";
    footnote "End 8.1"; 
    data work.newemployees;
        infile "&path/newemps.csv" dlm=',';
        length First $ 12 Last $ 18 Title $ 25;
        input First $ Last $ Title $ Salary;
    run;
    
    proc print data=work.newemployees;
    run;
    
    proc contents data=work.newemployees;
    run;
    
    title;
    footnote;

