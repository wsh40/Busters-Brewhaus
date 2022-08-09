
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

  * The next block of code generates summary statistics for SALES for all observations;
PROC MEANS N MEAN STDDEV MIN MAX MAXDEC=2;
VAR SALES;
RUN;

* The next line of code prints SALES, Store_ID and close_date for all observations; 
PROC PRINT;
  VAR SALES Store_ID close_date;
  RUN;

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

  * The next block of code generates summary statistics for SALES after removing unreasonable observations;
PROC MEANS N MEAN STDDEV MIN MAX MAXDEC=2;
VAR SALES;
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

* The next block of code generates the 5 basic summary statistics for the new variables;
PROC MEANS MAXDEC=2;
  VAR music football baseball basketball soccer university CC cover_charge;
  RUN;

* The next blocks of code generate correlation coefficients between Sales and the dummy variables;
PROC CORR;
  VAR SALES football baseball basketball;
  RUN;

*PROC CORR;
  VAR SALES soccer cover_charge;
    RUN;

* The next block of code generates the 5 basic summary statistics for the new variables;
PROC MEANS MAXDEC=2
  DATA= BUSTERS2 N MEAN STD MIN MAX; 
  VAR music football baseball basketball soccer university;
  RUN;

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
  cover_charge = 0;
  IF CC = 2 THEN cover_charge = 1;
  RUN;

*The Next block of code generates dummy variables Drive_Thru, Bar_tax, and Sports_champ from the alpha variables;

DATA BUSTERS4;
  SET BUSTERS3;
  pop_high_medium = pop_high + pop_medium;
  W_MW = West + MW;
  Drive_thru = 0;
  IF DT = 'yes' THEN Drive_thru = 1;
  High_tax = 0;
  IF BT = 'low' THEN Bar_tax = 1;
  Champion = 0;
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

* The next block of code generates summary statistics;
PROC MEANS MAXDEC=2;
  VAR stand_alone strip_mall life_style pop_high pop_medium pop_low pop_negative West MW SW East;
  RUN;

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
PROC MEANS MAXDEC=2;
  VAR Hooters Buffalo Metrics;
  RUN;

* Generate correlation coefficients between sales and the new dummy variables;
PROC CORR;
  VAR SALES Hooters Buffalo Metrics;
  RUN;

  * The next block of code cleans up the dummy variables;
DATA BUSTERS3;
  SET BUSTERS2;
  pop_high_medium = pop_high + pop_medium;
  W_MW = West + MW;
  RUN;

* Generate correlation coefficients between sales and the new dummy variables;
PROC CORR;
  VAR SALES Hooters Buffalo Metrics champion high_tax;
  RUN;

 *The next block of code regresses multiple models on the dependent variable;
ODS GRAPHICS OFF;
PROC REG;
A: MODEL Sales = Occ_engineer Occ_repair played_baseball played_basketball played_bowling 
played_football played_hockey restaurant_score night_life_score;

B: MODEL Sales = played_baseball baseball played_basketball basketball 
played_football football restaurant_score night_life_score; 

C: MODEL Sales = stand_alone strip_mall W_MW SW high_tax 
cover_charge champion Hooters Buffalo football baseball;

D: MODEL Sales = Occ_engineer Occ_repair played_baseball played_basketball played_bowling 
played_football played_hockey restaurant_score night_life_score football baseball cover_charge high_tax champion SW;

E: MODEL Sales = Occ_engineer Occ_repair played_baseball played_basketball played_bowling 
played_football played_hockey restaurant_score night_life_score cover_charge high_tax champion;

F: MODEL Sales = restaurant_score night_life_score stand_alone 
strip_mall hooters buffalo Occ_engineer Occ_Repair;

G: MODEL Sales = Occ_Repair cover_charge football baseball 
champion standalone stripmall hooters buffalo high_tax;

H: MODEL Sales = Occ_engineer Occ_repair restaurant_score 
night_life_score cover_charge high_tax W_MW SW;

I: MODEL Sales = played_baseball played_basketball played_bowling 
played_football played_hockey stand_alone strip_mall W_MW SW;

J: MODEL Sales = played_baseball played_basketball played_bowling played_football 
played_hockey cover_charge high_tax hooters buffalo;

K: MODEL Sales = Occ_engineer Occ_repair played_baseball played_basketball 
played_bowling played_football played_hockey hooters buffalo high_tax;

L: MODEL Sales = Occ_engineer Occ_repair restaurant_score night_life_score 
stand_alone strip_mall high_tax football baseball;

M: MODEL Sales = played_bowling played_hockey football baseball 
cover_charge high_tax champion stand_alone strip_mall W_MW SW;

N: MODEL Sales = played_bowling played_hockey football baseball cover_charge 
high_tax champion stand_alone strip_mall hooters buffalo;

O: MODEL Sales = Occ_engineer Occ_repair played_baseball played_basketball 
played_football played_hockey football champion W_MW SW;

P: MODEL Sales = football cover_charge high_tax 
champion stand_alone strip_mall hooters buffalo;

Q: MODEL Sales = restaurant_score night_life_score
stand_alone strip_mall W_MW SW hooters buffalo;

R: MODEL Sales = Occ_engineer Occ_repair played_bowling 
played_hockey restaurant_score night_life_score cover_charge high_tax;

S: MODEL Sales = Occ_engineer Occ_repair cover_charge 
high_tax stand_alone strip_mall hooters buffalo;

T: MODEL Sales = played_baseball played_basketball played_hockey 
champion stand_alone strip_mall hooters buffalo;

U: MODEL Sales = played_baseball played_basketball played_hockey 
football cover_charge high_tax hooters buffalo;

V: MODEL Sales = Occ_Engineer Occ_repair played_baseball played_basketball 
played_hockey football cover_charge high_tax hooters buffalo;

W: MODEL Sales = played_baseball played_basketball played_hockey football 
cover_charge high_tax hooters buffalo W_MW SW Stand_alone Strip_mall;

X:  MODEL Sales = Occ_engineer Occ_repair restaurant_score 
night_life_score cover_charge high_tax;
RUN;

*Generate correlation coefficients between the variables of the top 5 regression models;

*H;
PROC CORR;
VAR Occ_engineer Occ_repair restaurant_score 
night_life_score cover_charge high_tax W_MW SW;
RUN;

*J;
PROC CORR;
VAR played_baseball played_basketball played_bowling played_football 
played_hockey cover_charge high_tax hooters buffalo;
RUN;

*P;
PROC CORR;
VAR football cover_charge high_tax champion 
stand_alone strip_mall hooters buffalo;
RUN;

*T;
PROC CORR;
VAR played_baseball played_basketball played_hockey 
champion stand_alone strip_mall hooters buffalo;
RUN;

*U;
PROC CORR;
VAR played_baseball played_basketball played_hockey 
football cover_charge high_tax hooters buffalo;
RUN;


* Forward-selection method;
PROC REG;
   Forward: MODEL SALES = Occ_Engineer Occ_Repair played_baseball played_basketball played_bowling played_football played_hockey
restaurant_score night_life_score football baseball cover_charge high_tax champion Hooters Buffalo/ SELECTION=FORWARD SLENTRY=0.20  ;
   RUN;

* Best model from Forward-selection regressed with multi-trait dummies;
 *Same for stepwise :) ;
PROC REG;
A: MODEL Sales = baseball cover_charge champion Hooters Buffalo;

B: MODEL Sales = baseball cover_charge champion Hooters Buffalo stand_alone strip_mall;

C: MODEL Sales = baseball cover_charge champion Hooters Buffalo W_MW SW;

D: MODEL Sales = baseball cover_charge champion Hooters Buffalo stand_alone strip_mall W_MW SW;


* Stepwise selection method;
PROC REG;
   STEPWISE: MODEL SALES = Occ_Engineer Occ_Repair played_baseball played_basketball played_bowling played_football played_hockey
restaurant_score night_life_score football baseball cover_charge high_tax champion Hooters Buffalo / SELECTION=STEPWISE SLENTRY=0.20 SLSTAY=0.20;
   RUN;


* Backward selection method;
PROC REG;
   Backward: MODEL SALES = Occ_Engineer Occ_Repair played_baseball played_basketball played_bowling played_football played_hockey
restaurant_score night_life_score football baseball cover_charge high_tax champion Hooters Buffalo / SELECTION=BACKWARD SLSTAY=0.20 ;
   RUN;

* Best backward selection model with multi-trait dummies;
PROC REG;
A: MODEL Sales = played_bowling played_hockey baseball cover_charge champion Hooters Buffalo;

B: MODEL Sales = played_bowling played_hockey baseball cover_charge champion Hooters Buffalo stand_alone strip_mall;

C: MODEL Sales = played_bowling played_hockey baseball cover_charge champion Hooters Buffalo W_MW SW;

D: MODEL Sales = played_bowling played_hockey baseball cover_charge champion Hooters Buffalo stand_alone strip_mall W_MW SW;
RUN;


* Maximum R-square improvement selection method;
PROC REG;
   Max_R_square: MODEL SALES = Occ_Engineer Occ_Repair played_baseball played_basketball played_bowling played_football played_hockey
restaurant_score night_life_score football baseball cover_charge high_tax champion Hooters Buffalo / SELECTION=MAXR;
   RUN;

*Best R-square improvement model;
PROC REG;
A: MODEL Sales = played_baseball baseball cover_charge champion Hooters Buffalo;

* Adjusted R-square selection method;
PROC REG;
   Adj_R_square: MODEL SALES = Occ_Engineer Occ_Repair played_baseball played_basketball played_bowling played_football played_hockey
restaurant_score night_life_score football baseball cover_charge high_tax champion Hooters Buffalo / SELECTION=ADJRSQ BEST=20;
   RUN;

* End end with a QUIT statement ;
QUIT;
