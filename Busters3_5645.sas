* This program is called Busters3_5645.SAS ;

* First, clean the log and results windows;
ODS HTML CLOSE ;
ODS HTML ;
DM 'LOG; CLEAR; ODSRESULTS; CLEAR' ;

* The next line of code inserts a title on the first line of each page of output;
TITLE ' Will Hallgren ' ;

* The next block of code reads the data file from the D drive;
PROC IMPORT DATAFILE = ' E:/Busters/Data/Busters3_5645.CSV ' 
  OUT = BUSTERS1
  DBMS = CSV
  REPLACE ;
  GETNAMES = YES ;
  RUN ;

* The next block of code drops unreasonable & outlier observations for SALES, replaces the missing observation 
  for Pop_45to50, and creates proper dummy variables from the existing qualitative variables.  ;
DATA BUSTERS2;
  SET BUSTERS1;
  IF Store_ID=1 or Store_ID=2 THEN DELETE;
  IF SALES < 1219372 or SALES > 3654479 THEN DELETE;
  IF Pop_45to50 = . THEN Pop_45to50 = 156.68;
  cover_charge = 0;
  IF CC = 2 THEN cover_charge = 1;

  RUN;

* The next block of code generates the 5 basic summary statistics for the new variables;
*PROC MEANS MAXDEC=2;
*  VAR music football baseball basketball soccer university CC cover_charge;
*  RUN;

* The next blocks of code generate correlation coefficients between Sales and the dummy variables;
*PROC CORR;
*  VAR SALES football baseball basketball;
*  RUN;

*PROC CORR;
*  VAR SALES soccer cover_charge;
*  RUN;

* The next block of code generates the dummy variables pop_high, pop_medium, pop_low and pop_negative from the variable pop_growth, and it generates the variables West, MW, SW and East from the variable Region;
DATA BUSTERS3;
  SET BUSTERS2;
  pop_high = 0;
  IF pop_growth = 1 THEN pop_high = 1;
  pop_medium = 0;
  IF pop_growth = 2 THEN pop_medium = 1;
  pop_low = 0;
  IF pop_growth = 3 THEN pop_low = 1;
  pop_negative = 0;
  IF pop_growth = 4 THEN pop_negative = 1;
  West = 0;
  IF Region = "W" THEN West = 1;
  MW = 0;
  IF Region = "MWest" THEN MW = 1;
  SW = 0;
  IF Region = "SWest" THEN SW = 1;
  East = 0;
  IF Region = "e" THEN East = 1;
  RUN;

* The next block of code generates summary statistics;
PROC MEANS MAXDEC=2;
  VAR stand_alone strip_mall life_style pop_high pop_medium pop_low pop_negative West MW SW East;
  RUN;

* The next block of code cleans up the dummy variables;
DATA BUSTERS4;
  SET BUSTERS3;
  pop_high_medium = pop_high + pop_medium;
  W_MW = West + MW;
  run;

* Generate summary statistics one more time;
PROC MEANS MAXDEC=2;
  VAR pop_high_medium W_MW;
  RUN;

* Generate correlation coefficients for the dummies;
PROC CORR;
  VAR SALES stand_alone strip_mall life_style ;
  RUN;

PROC CORR;
  VAR SALES pop_high_medium pop_low pop_negative;
  RUN;

PROC CORR;
  VAR SALES W_MW SW East;
  RUN;

* Generate frequency tables for the LIV variables;
PROC FREQ;
  TABLES Hooters TP BWW Metrics;
  RUN;

* Create the 2-trait dummies from BB and CC;
DATA BUSTERS5;
  SET BUSTERS4;
  Buffalo = 0;
  IF BWW > 0 THEN Buffalo = 1;
  RUN;

* Generate summary statistics for these new dummy variables;
PROC MEANS N MEAN STDDEV MIN MAX CV MAXDEC=2;
  VAR Hooters Buffalo Metrics;
  RUN;

* Generate correlation coefficients between sales and the new dummy variables;
PROC CORR;
  VAR SALES Hooters Buffalo Metrics;
  RUN;


* End end with a QUIT statement ;
QUIT;
