%let path=/folders/myfolders/sasuser.v94/ecprg193; 
libname orion "&path";

***** SAS Programming 1 Essentials - Lesson 11 Summary Reports and Validation; 

***** Univariate looks for outlying, missing, and extreme values for vars specified nextraobs=n will show more or fewer extreme obs;
    proc univariate data=orion.price_current;
        var Unit_Sales_Price Factor;
    run;

    proc univariate data=orion.sales;
        var salary;
    run;
    
***** Validate using print and where;
proc print data=orion.sales;
    where salary<25000;
run;

    
***** nmiss shows num of obs with missing values for validation;
    title 'Number of Missing and Non-Missing 
          Date Values';
    proc means data=orion.staff nmiss nonobs n;
        var Birth_Date Emp_Hire_Date Emp_Term_Date;
        class gender;
    run;
    title;


***** Calculating mean averages on var Salary but in a list table by gender and country;
    proc means data=orion.sales;
        var Salary;
        class gender country;
    run;

***** Calculating mean averages on var Salary;
    proc means data=orion.sales;
        var Salary;
    run;

***** Using value formatting to change numerical catagories into descriptive strings;
    proc format;
       value ordertypes
             1='Retail'
             2='Catalog'
             3='Internet';
    run;
    title 'Revenue from All Orders';
    proc means data=orion.order_fact sum;
        var total_retail_price;
        class order_date order_type;
        format order_type ordertypes. order_date year4.;
    run;
    title;
    
    
***** Simple use of freq to rank product_id;
    title 'Ch 11 - 3.2 challenge';
    proc freq data=orion.order_fact order=freq;
        tables product_id;
    run;
    title;

***** Validation using freq and nlevels to find missing values;
    title 'Ch 11 - Practice 3.2';
    proc freq data=orion.qtr2_2011 nlevels;
        tables order_id order_type;
        where not order_type or order_type not between 1 and 3;
    run;
    title;
    
***** Validating data using freq;
    *noprint suppresses actual freq table display, leaving just the nlevels summary table for readability;
    title 'ch 11 - practice 3: validating data with nlevels and noprint options';
    proc freq data=orion.orders nlevels;
       tables customer_id employee_id/noprint;
       where order_type=1;
    run;
    title;
    
***** Using freq to find number of orders by customer_id, shows repete customers, ordered by highest to lowest;
    proc freq data=orion.orders order=freq;
        tables customer_id/nocum;
        where order_type ne 1;
    run;
    
    
***** Validating with freq and nlevels shows total number of, and missing values for Job_Title var, along with job_title orderd by freq;
    title 'Practice 2';
    proc freq data=orion.nonsales2 nlevels order=freq;
       tables Job_Title/nocum nopercent;
    run;
    title;
    
    
***** Build tables using freq to display orders by year and type with various formatting and options for readability;
    title1 'Order Summary by Year and Type';
    proc format;
        *convert numerical types to string
       value ordertypes
             1='Retail'
             2='Catalog'
             3='Internet';
    run;
    proc freq data=orion.orders;
            tables order_date;
            format order_date year4.;
            tables order_type/nofreq nocum;
            format order_type ordertype.;
            tables order_date*order_type/nopercent norow nocol;
            length order_date 4;
    run;
    proc contents data=orion.orders;
    run;
    title;
    
    
    
***** Freq procedure for gender. Sorting by country requires sorting table first by same variable;

    * Asterisk between tables listed combines the feq output into one crosstabulation table. You can also 
    use options /list or /crosslist for other table displays, 
    vs using two one-way tables like: tables Gender/nocum; by country;
    
    proc sort data=orion.sales out=sorted;
        by country;
    run;
    proc freq data=work.sorted;
        tables gender*country;      
    run;

***** freq proc on country doesnt tell much, just freq of sales personel in AU. Proc contents shows that this is personel not materiel;
    proc freq data=orion.sales;
        tables Country/nocum nopercent;
            where country="AU";
    run;
    proc contents data=orion.sales;
    run;
    

***** output delivery system using ods to make exportable data like pdf;
    ods trace on;
    ods select ExtremeObs;
    proc univariate data=orion.shoes_tracker;
        var product_id;
    run;
    ods trace off;

    
***** Converting continuous numeric var salary to four ranges for freq analysis;
    proc format;
        value tiers low-25000='Tier1'
            25000<-50000='Tier2'
            50000<-100000='Tier3'
            100000<-high='Tier4';
    run;
    proc freq data=orion.sales order=freq;
        tables Salary/nocum nopercent;
        * where country="AU";
        format Salary tiers.;
    run;

