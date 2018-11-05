%let path=/folders/myfolders/sasuser.v94/ecprg193; 
libname orion "&path";


***** SAS Programming 1 Essentials - Lesson 4: Producing detail reports;

***** Using noobs, where, and var;
    title2 "Using noobs, where statement, and choosing vars to print";
    title4 "Senior Sales Representatives";
    footnote5 "End table";
    
    proc print data=orion.sales noobs;
       where Country='AU' and Job_Title contains 'Rep. IV';
       var Employee_ID First_Name Last_Name Gender Salary;
    run;
    
    title;
    footnote;

***** Using Proc sort and print labels;
    title 'Sorted by salary';
    proc sort data=orion.employee_payroll out=work.sort_salary;
        by salary;
    run;
    proc print data=sort_salary label;
        label employee_gender="Sex" employee_id="Sales Identifier";
    run;
    title;
    footnote;


***** Using two sort criteria;
    title 'Sorting by country and gender';
    proc sort data=orion.sales
              out=work.sorted;
       by Gender country;
    run;
    proc print data=work.sorted; 
       by gender;
       * odd, if i use the second sort criteria here it errors;
    run;
    title;
    footnote;

***** Using single sort criteria, by descending order;
    title 'Sorted by salary';
    proc sort data=orion.sales out=work.sales_salary_sort;
        by descending salary;
    run;
    proc print data=work.sales_salary_sort;
    run;
    title;
    footnote;

***** Adding sum to report, where clause usage, and setting var order in proc print;
    title 'Adding sum, where clause usage, and setting var order in proc print';
    proc print data=orion.order_fact;
    where Total_Retail_Price > 500;
        sum Total_Retail_Price;
        id customer_id;
        var Order_ID Order_Type Quantity Total_Retail_Price;
    run;
    title;
    footnote;

***** Using proc contents, and specifying ID format for var;
    title 'Specifying ID format for var';
    proc contents data=orion.sales nods;
    run;
    proc print data=orion.sales noobs;
        var first_name last_name country salary;
        id employee_id;
        where Country='AU' & Salary < 25500;
    run;
    title;
    footnote;

****** Print vars with sum statement;
    title 'Print vars with sum statement';
    proc print data=orion.sales;
        var first_name last_name salary;
        where salary < 25000;
        sum salary;
    run;
    title;
    footnote;

