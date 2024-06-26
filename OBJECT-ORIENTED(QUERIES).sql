CREATE TYPE addr_ty AS OBJECT
  2  (street varchar2(60),
  3  city varchar2(30),
  4  state char(2),
  5  zip varchar(9));
  6  /

Type created.

SQL> CREATE TYPE person_ty AS OBJECT
  2  (name varchar2(25),
  3   address addr_ty);
  4  /

Type created.

SQL> CREATE TYPE emp_ty AS OBJECT
  2  (empt_id varchar2(9),
  3  person  person_ty);
  4  /

Type created.


SQL> CREATE TABLE EMP_OO
  2 (full_emp emp_ty);


insert into EMP_OO values( emp_ty('100', person_ty('ram', addr_ty('100st','Patiala','up','605001'))));
insert into EMP_OO values( emp_ty('101', person_ty('sam', addr_ty('101st','sire','Blore','105001'))));

select * from emp_oo;


FULL_EMP(EMPT_ID, PERSON(NAME, ADDRESS(STREET, CITY, STATE, ZIP)))
--------------------------------------------------------------------------------
EMP_TY('100', PERSON_TY('Ram', ADDR_TY('1000 TU', 'Patiala', 'PB', '147001')))
EMP_TY('101', PERSON_TY('Sham', ADDR_TY('1001 TU', 'Patiala', 'PB', '147001')))


select e.full_emp.empt_id ID,e.full_emp.person.name NAME, e.full_emp.person.address.city CITY from emp_oo e;

ID        NAME                      CITY
--------- ------------------------- ------------------------------
100       Raj                       Patiala
101       sam                       sire

update emp_oo e set e.full_emp.person.name = 'Raj' where e.full_emp.empt_id = '1000';


create or replace type newemp_ty as object (
firstname varchar2(25),
lastname Varchar2(25), 
birthdate Date, 
member function age (birthdate in date) return number);



create or replace type body newemp_ty as 
member function age(birthdate in date) return number is 
begin
return round(sysdate - birthdate);
end;
end;



create table new_emp_oo (employee newemp_ty);

insert into new_emp_oo values(newemp_ty('ram', 'lal','1976-12-12'));

select e.employee.firstname, e.employee.age, e.employee.age(e.employee.birthdate) from new_emp_oo e;

create table new_emp1 of emp_ty;

insert into new_emp1 values('102',person_ty('raul',addr_ty('100 TU', 'Pta','PB', '147002'))));

select * from new_emp1;

PERSON_TY('raul', ADDR_TY('100 TU', 'Pta', 'PB', '147002'))

select ref(p) from new_emp1 p;

REF(P)
--------------------------------------------------------------------------------
D20041B968804F006224F4E05FBAFA083F349DC41DC2310E79DAD5409623SB349887BSDF3243DFSGF
O60000

create type new_dept_oo as object (deptno number(3),dname varchar(10));

create table dept_table of new_dept_oo;

insert into dept_table values (10,'comp');
insert into dept_table values (20,'chem');
insert into dept_table values (30,'math');

create table emp_test_fk(empno number(3), name varchar2(10), dept ref new_dept_oo);

insert into emp_test_fk select 100, 'raj', ref(p) from dept_table p where deptno =10;
insert into emp_test_fk select 101, 'sam', ref(p) from dept_table p where deptno = 20;

select empno, name, deref(e.dept) from emp_test_fk e;
     EMPNO NAME
---------- ----------
DEREF(E.DEPT)(DEPTNO, DNAME)
--------------------------------------------------------------------------------
       100 raj
NEW_DEPT_OO(10, 'comp')

       101 sam
NEW_DEPT_OO(20, 'chem')

select empno, name, deref(e.dept), deref(e.dept).deptno DEPTNO,deref(e.dept).dname DNAME from emp_test_fk e;
     EMPNO NAME
---------- ----------
DEREF(E.DEPT)(DEPTNO, DNAME)
--------------------------------------------------------------------------------
    DEPTNO DNAME
---------- ----------
       100 raj
NEW_DEPT_OO(10, 'comp') 10 comp

       101 sam
NEW_DEPT_OO(20, 'chem') 20 chem

     EMPNO NAME
---------- ----------
DEREF(E.DEPT)(DEPTNO, DNAME)
--------------------------------------------------------------------------------
    DEPTNO DNAME
---------- ----------

-- query 22
 create table emp_table_fk (employee emp_ty, dept ref new_dept_oo);

insert into emp_table_fk 
values (emp_ty('100', person_ty('ram', addr_ty('100 st','Patiala','up','605001'))), (select ref(p) from dept_table p where deptno = 10));

1 row created

select * from em_table_fk;
EMPLOYEE(EMPT_ID, PERSON(NAME, ADDRESS(STREET, CITY, STATE, ZIP)))
--------------------------------------------------------------------------------
DEPT
--------------------------------------------------------------------------------
EMP_TY('100', PERSON_TY('ram', ADDR_TY('100 st', 'Patiala', 'up', '605001')))
000023043IW72049HI7489276HW7623Q020307PF03703870237AHL2302702520WEF2039487

select e.employee.empt_id ID, e.employee.person.name NAME, 
deref(e.dept), deref(e.dept).deptno DEPTNO,
deref(e.dept).dname DNAME from emp_table_fk e;


ID        NAME
--------- -------------------------
DEREF(E.DEPT)(DEPTNO, DNAME)
--------------------------------------------------------------------------------
    DEPTNO DNAME
---------- ----------
100       ram
NEW_DEPT_OO(10, 'comp')
        10 comp