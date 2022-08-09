* This program is called Busters1b_5645.SAS ;

* First, clean the log and results windows;
ODS HTML CLOSE ;
ODS HTML ;
DM 'LOG; CLEAR; ODSRESULTS; CLEAR' ;

* The next line of code inserts a title on the first line of each page of output;
TITLE ' insert your name here ' ;

* The next block of code reads the data file from the D drive;
PROC IMPORT DATAFILE = ' D:Busters1b.CSV ' 
  OUT = BUSTERS1
  DBMS = CSV
  REPLACE ;
  GETNAMES = YES ;
  RUN ;

* The next block of code drops unreasonable & outlier observations for SALES;
DATA BUSTERS2;
  SET BUSTERS1;
  IF Store_ID=1 or Store_ID=2 THEN DELETE;
  IF SALES < 1219372 or SALES > 3654479 THEN DELETE;
  RUN;

* The next block of code generates the 5 basic summary statistics and CV for all variables;
PROC MEANS N MEAN STDDEV MIN MAX CV MAXDEC=2;
  RUN;




* The next several blocks of code generate plots of Sales versus each regressor;
PROC PLOT;
  PLOT SALES * Pop_45to50 = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Hisp_pop = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Cauc_pop = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Af_Am_pop = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Asian_pop = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Single_pop = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Married_pop = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Inc_40Kto100K = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Inc_GT_100K = '*';
  RUN;

PROC PLOT;
  PLOT SALES * per_cap_inc = '*';
  RUN;

PROC PLOT;
  PLOT SALES * avg_inc = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Educ_Bachelors = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Educ_GE_Master = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Occ_business = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Occ_financial = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Occ_computer = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Occ_engineer = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Occ_social_science = '*';
  RUN;

PROC PLOT;
  PLOT SALES * Occ_repair = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_baseball = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_basketball = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_bowling = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_football = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_hockey = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_volleyball = '*';
  RUN;

PROC PLOT;
  PLOT SALES * played_yoga = '*';
  RUN;

PROC PLOT;
  PLOT SALES * exercise_regularly = '*';
  RUN;

PROC PLOT;
  PLOT SALES * restaurant_score = '*';
  RUN;

PROC PLOT;
  PLOT SALES * night_life_score = '*';
  RUN;


* The next several blocks of code generate correlation coefficients between Sales and each regressor;

PROC CORR;
  VAR SALES Pop_45to50 Hisp_pop Cauc_pop Af_Am_pop Asian_pop;
  RUN;

PROC CORR;
  VAR SALES Single_pop Married_pop Inc_40Kto100K ;
  RUN;

PROC CORR;
  VAR SALES Inc_GT_100K per_cap_inc avg_inc ;
  RUN;


PROC CORR; 
  VAR SALES Educ_Bachelors Educ_GE_Master Occ_business Occ_financial ;
  RUN;

PROC CORR;
  VAR SALES Occ_computer Occ_engineer Occ_social_science Occ_repair ;
  RUN;

PROC CORR;
  VAR SALES played_baseball played_basketball played_bowling played_football ;
  RUN;

PROC CORR;
  VAR SALES played_hockey played_volleyball played_yoga exercise_regularly ;
  RUN;

PROC CORR;
  VAR sales restaurant_score night_life_score;
  RUN;


* End end with a QUIT statement ;
QUIT;
