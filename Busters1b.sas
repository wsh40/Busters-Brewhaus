/*This program is called Busters1b*/

*First, clean the log and results windows;
ODS HTML CLOSE ;
ODS HTML ;
DM 'LOG; CLEAR; ODSRESULTS; CLEAR' ;

*The next line of code inserts a title on the first line of each page of output;
TITLE 'Will Hallgren ' ;

*The Next block of code reads the data file from the flash drive (E:);
PROC IMPORT DATAFILE = 'E:/Busters/Data/BUSTERS1bCSV.csv '
OUT = BUSTERS1b
DBMS = CSV
REPLACE ;
GETNAMES = YES ;
RUN ;

*The next block of code will drop unreasonable or outlier observations (+-2.5*stddev);
DATA BUSTERS2;
SET BUSTERS1;
IF Store_ID=1 or Store_ID=2 THEN DELETE;
IF SALES < 1219372 OR SALES > 3654479 THEN DELETE;
RUN;

*The next block of code will replace the missing observation in pop_45to50 with the mean value ;
Data BUSTERS3 ;
Set BUSTERS2 ;
IF Store_ID= 4 THEN Pop_45to50= 153
RUN;

* The next line of code will generate summary statistics for all variables in the data set ;
PROC MEANS MAXDEC = 2
DATA = Busters1b N Mean std min max cv;
RUN ;

*The next block of code will generate summary statistics for SALES after removing bad data ;
PROC MEANS MAXDEC = 2
DATA = Busters1b;
VAR SALES
RUN; 

*The next blocks of code generate plots of SALES with every single regressor ;
PROC PLOT;
PLOT SALES * POP_45 = '*';
RUN;

PROC PLOT;
PLOT SALES * HISP_POP = '*';
RUN;

PROC PLOT;
PLOT SALES * AF_AM_POP = '*';
RUN;

PROC PLOT;
PLOT SALES * ASIAN_POP = '*';
RUN;

PROC PLOT;
PLOT SALES * SINGLE_POP = '*';
RUN;

PROC PLOT;
PLOT SALES * MARRIED_POP = '*';
RUN;

PROC PLOT;
PLOT SALES * INC_40KTO100K = '*';
RUN;

PROC PLOT;
PLOT SALES * INC_GT_100K = '*';
RUN;

PROC PLOT;
PLOT SALES * AVG_INC = '*';
RUN;

PROC PLOT;
PLOT SALES * EDUC_BACHELORS + '*';
RUN;

PROC PLOT;
PLOT SALES * EDUC_GE_MASTER = '*';
RUN;

PROC PLOT;
PLOT SALES * OCC_BUSINES = '*';
RUN;

PROC PLOT;
PLOT SALES * OCC_FINANCIAL = '*';
RUN;

PROC PLOT;
PLOT SALES * OCC_COMPUTER = '*';
RUN;

PROC PLOT;
PLOT SALES * OCC_ENGINEER = '*';
RUN;

PROC PLOT;
PLOT SALES * OCC_SOCIAL_SCIENCE = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_BASEBALL = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_BASKETBALL = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_BOWLING = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_FOOTBALL = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_HOCKEY = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_VOLLEYBALL = '*';
RUN;

PROC PLOT;
PLOT SALES * PLAYED_YOGA = '*';
RUN;

PROC PLOT;
PLOT SALES * EXERCISE_REGULARLY = '*';
RUN;

PROC PLOT;
PLOT SALES * RESTAURANT_SCORE = '*';
RUN;

PROC PLOT;
PLOT SALES * NIGHT_LIFE_SCORE = '*';
RUN;

*The next several block os code generate correlation coefficients between sales and each regressor;

PROC CORR;
VAR SALES POP_45TO50 HISP_POP CAUC_POP AF_AM_POP ASIAN_POP;
RUN;

PROC CORR;
VAR SALES INC_GT_1--K PER_CAP_INC AVG_INC;
RUN;

PROC CORR;
VAR SALES EDUC_BACHELORS EDUC_GE_MASTER OCC_BUSINESS OCC_FINANCIAL;
RUN;

PROC CORR;
VAR SALES OCC_COMPUTER OCC_ENGINEER OCC_SOCIAL_SCIENCE OCC_REPAIR;
RUN;

PROC CORR;
VAR SALES PLAYED_BASEBALL PLAYED_BASKETBALL PLAYED_BOWLING PLAYED_FOOTBALL;
RUN;

PROC CORR;
VAR SALES PLAYED_HOCKEY PLAYED_VOLLEYBALL PLAYED_YOGA EXERCISE_REGULARLY;
RUN;

PROC CORR;
VAR SALES RESTAURANT_SCORE NIGHT_LIFE_SCORE;
RUN;

* In order to close of the DM call at the beginning of the program, end with a QUIT statement. ;
QUIT;



