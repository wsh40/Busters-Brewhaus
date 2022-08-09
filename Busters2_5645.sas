* This program is called Busters2_5645.SAS ;

/* First, clean the log and results windows
NOTE: The program must end with "quit" */
ODS HTML CLOSE ;
ODS HTML ;
DM 'LOG; CLEAR; ODSRESULTS; CLEAR' ;

* The next line of code inserts a title on the first line of each page of output;
TITLE ' Will Hallgren ' ;

* The next block of code reads the data file from the D drive;
PROC IMPORT DATAFILE = ' E:/Busters/Data/Busters2_5645.CSV ' 
  OUT = BUSTERS1
  DBMS = CSV
  REPLACE ;
  GETNAMES = YES ;
  RUN ;

* The next block of code drops unreasonable & outlier observations for SALES 
  and replaces the missing observation for Pop_45to50;
DATA BUSTERS2;
  SET BUSTERS1;
  IF Store_ID=1 or Store_ID=2 THEN DELETE;
  IF SALES < 1219372 or SALES > 3654479 THEN DELETE;
  IF Pop_45to50 = . THEN Pop_45to50 = 156.68;
  RUN;

* The next block of code generates the 5 basic summary statistics for the new variables;
PROC MEANS MAXDEC=2
  DATA= BUSTERS2 N MEAN STD MIN MAX; 
  VAR music football baseball basketball soccer university;
  RUN;

*The next block of code generates dummy variables cover_charge;
DATA BUSTERS3;
  SET BUSTERS2;
  cover_charge = 0;
  IF CC = 2 THEN cover_charge = 1;
  RUN;

  *The Next block of code generates dummy variables Drive_Thru, Bar_tax, and Sports_champ from the alpha variables;

DATA BUSTERS4;
  SET BUSTERS3;
  Drive_thru = 0;
  IF DT = 'yes' THEN Drive_thru = 1;
  Bar_tax = 0;
  IF BT = 'high' THEN Bar_tax = 1;
  Sports_champ = 0;
  IF champ = "Y" THEN Sports_champ = 1;
  RUN;

PROC MEANS MAXDEC=2
  DATA= BUSTERS4 N MEAN STD MIN MAX;
  VAR cover_charge Drive_thru Bar_tax Sports_champ;
  RUN;

* The next blocks of code generate correlation coefficients between Sales and the dummy variables;

PROC CORR;
  VAR SALES football baseball basketball soccer cover_charge Drive_thru Bar_tax Sports_champ;
  RUN;


* End end with a QUIT statement ;
QUIT;
