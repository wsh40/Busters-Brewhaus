* This program is called Busters5_5645.sas;

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
  drive_thru = 0;
  IF DT = "yes" THEN drive_thru = 1;
  high_tax = 0;
  IF BT = "high" THEN high_tax = 1;
  champion = 0;
  IF champ = "Y" THEN champion = 1;
  Buffalo = 0;
  IF BWW > 0 THEN Buffalo = 1;
  RUN;

* The next block of code cleans up the dummy variables;
DATA BUSTERS3;
  SET BUSTERS2;
  pop_high_medium = pop_high + pop_medium;
  W_MW = West + MW;
  RUN;

* Compute summary statistics for sales ;
PROC MEANS MAXDEC=2;
  VAR SALES;
  RUN;


ODS GRAPHICS OFF;

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
