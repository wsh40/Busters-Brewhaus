* This program is called Busters1a ;

* First, clean the log and results windows;
ODS HTML CLOSE ;
ODS HTML ;
DM 'LOG; CLEAR; ODSRESULTS; CLEAR' ;

* The next line of code inserts a title on the first line of each page of output;
TITLE ' Will Hallgren ' ;

* The next block of code reads the data file from the D drive;
PROC IMPORT DATAFILE = ' E:BUSTERS1a.CSV ' 
  OUT = BUSTERS1
  DBMS = CSV
  REPLACE ;
  GETNAMES = YES ;
  RUN ;

* The next block of code generates summary statistics for SALES for all observations;
PROC MEANS N MEAN STDDEV MIN MAX MAXDEC=2;
VAR SALES;
RUN;

* The next line of code prints SALES, Store_ID and close_date for all observations; 
PROC PRINT;
  VAR SALES Store_ID close_date;
  RUN;

* The next block of code drops unreasonable observations for SALES;
DATA BUSTERS2;
  SET BUSTERS1;
  IF SALES<=0 THEN DELETE;
  RUN;

* The next block of code generates summary statistics for SALES after removing unreasonable observations;
PROC MEANS N MEAN STDDEV MIN MAX MAXDEC=2;
VAR SALES;
RUN;

* The next block of code removes outlier observations for SALES;
DATA BUSTERS3;
  SET BUSTERS2;
  IF SALES < 1219372 or SALES > 3654479 THEN DELETE;
  RUN;

* The next block of code generates summary statistics for SALES after removing unreasonable & outlier observations;
PROC MEANS N MEAN STDDEV MIN MAX CV MAXDEC=2;
VAR SALES;
RUN;

* In order to close off the DM (data manager) call at the beginning of the program,
end with a QUIT statement. ;
QUIT;
