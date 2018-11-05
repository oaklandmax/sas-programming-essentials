%let path=/folders/myfolders/sasuser.v94/ecprg193; 
libname orion "&path";
libname proclib 'orion';
* options nodate pageno=1 linesize=80 pagesize=40;
 
 
    ***** proc sql creating an sql table and adding data;
    proc sql;
       create table work.paylist
           (IdNum char(4),
            Gender char(1),
            Jobcode char(3),
            Salary num,
            Birth num informat=date7.
                      format=date7.,
            Hired num informat=date7.
                      format=date7.);
        
    insert into work.paylist
        values('1639','F','TA1',42260,'26JUN70'd,'28JAN91'd)
        values('1065','M','ME3',38090,'26JAN54'd,'07JAN92'd)
        values('1400','M','ME1',29769.'05NOV67'd,'16OCT90'd)
        values('1561','M',null,36514,'30NOV63'd,'07OCT87'd)
        values('1221','F','FA3',.,'22SEP63'd,'04OCT94'd);
        
       title 'work.PAYLIST Table';
        
    select *
       from work.paylist;
       
    quit;
    
    
    ***** creating sql table from another table or sas data set using 'as';
    * select IdNumber, Salary format=dollar8., salary*.025 as Bonus format=dollar8.from work.payroll;
    proc sql;
        create table work.bonus as
            select jobcode, gender from work.paylist where gender = 'F';
            title 'BONUS Information';
        select *
            from work.bonus(obs=10);
    quit;


***** proc sql update table;
    data Employees;
       input IdNum $4. +2 LName $11. FName $11. JobCode $3.
              +1 Salary 5. +1 Phone $12.;
       datalines;
    1639  CHIN       JACK       TA1 42400 212/588-5634
    1065  GREENWALD  JANICE     ME3 38000 212/588-1092
    1400  PENNINGTON MICHAEL    ME1 29860 718/383-5681
    1561  PARKER     MARY       FA3 65800 914/455-2337
    1221  WOOD       DEBORAH    FA3 36514 212/587-0013
    ;
    run;
    
    proc sql;
       title 'Employees Table';
       select * from Employees;
    
    update employees
          set salary=salary*
          case when jobcode like '__1' then 1.04
               else 1.025
          end;
          
    ***** proc sql alter table;
       alter table employees
          modify salary num format=dollar8.
          drop jobcode, salary;
    
       title 'Updated Employees Table';
    
       select * from employees;
    quit;



***** proc sql joining the above two tables adds vars from one table to another with matching key variable;

    proc sql number;
        title 'Joining two tables';
        * if you dont use the create..as statement, you dont need to explicitly use the select statment below to
        display the table, it just does it automatically if noprint isnt set.;
        
        create table work.joined_empdata as
        select em.IdNum, Lname, Fname, Salary, Jobcode, phone
           from work.employees as em, work.paylist as pl
           where pl.idnum=em.idnum and pl.idnum in 
                  ('1639', '1400', '1561', '1221');
        
        * select statement required to display table made by create..as above;
        select * from work.joined_empdata;
    quit;



***** proc sql combine tables adds two tables with same vars into longer table;
    proc sql;
           create table work.paylist2
               (IdNum char(4),
                Gender char(1),
                Jobcode char(3),
                Salary num,
                Birth num informat=date7.
                          format=date7.,
                Hired num informat=date7.
                          format=date7.);
            
        insert into work.paylist2
            values('1919','F','TA5',34376,'12SEP66'd,'04JUN87'd)
            values('1653','M','ME5',31896,'15OCT64'd,'09AUG92'd)
            values('1350','M','ME5',38822.'31AUG55'd,'29JUL91'd)
            values('1401','M',null,36886,'13DEC55'd,'17NOV93'd)
            values('1499','F','FA5',.,'26APR74'd,'07JUN92'd);
            
    
       create table work.paylist_combined as
          select * from work.paylist
          union
          select * from work.paylist2;
          
       delete from work.paylist_combined
          where jobcode is missing or salary is missing;
          
          * double space the output in non-ods report. does nothing here in the sas studio;
       reset double;
       
       title 'Combine Tables of Personnel Data';
       select *
          from work.paylist_combined;
    quit;


***** 

** some addtional sql and proc sql for ranking numerical results
** will select top salaries from each dept and include full dept name
select e.f_name, e.l_name, e.salary d.dept_name
from employees e, inner join department d on (e.dept_id = d.dept_id)
where salary in (select max(salary) from employee group by dept_id);

** select second highes salary
select max(salary) from employee
where salart not in ((select max(salary) from employee);

** second salary (or nth salary)
select sal from 
(select sal, rownum position from (select distinct (salary) sal from employees e order by 1 desc)) 
where position = 2 /*n*/

** SAS sort: you can get highest , second highest and so on.
PROC SORT DATA=EMPLOYEE OUT=EMPLOYEE1; 
    BY DESCENDING SALARY; 
RUN; 

