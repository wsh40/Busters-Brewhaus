* This program is called Busters4_5645.SAS ;

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

* Generate correlation coefficients between sales and the new dummy variables;
PROC CORR;
  VAR SALES Hooters Buffalo Metrics champion high_tax;
  RUN;

/*ODS GRAPHICS OFF;
PROC REG;
  A: MODEL Sales = pop_45to50 married_pop inc_40Kto100K occ_engineer occ_repair
     played_baseball played_basketball played_bowling played_football played_hockey
	 restaurant_score night_life_score football baseball basketball cover_charge
     W_MW SW stand_alone strip_mall Hooters Buffalo Metrics champion high_tax;

  B: MODEL Sales = married_pop inc_40Kto100K occ_engineer played_football football 
     cover_charge W_MW SW stand_alone strip_mall Hooters Buffalo;

  C: MODEL Sales = married_pop inc_40Kto100K occ_repair played_baseball baseball cover_charge
     W_MW SW stand_alone strip_mall Hooters Metrics;

  D: MODEL Sales = married_pop inc_40Kto100K played_basketball basketball cover_charge
     stand_alone strip_mall Hooters champion;

  E: MODEL Sales = married_pop inc_40Kto100K played_football football restaurant_score cover_charge
     stand_alone strip_mall Hooters high_tax;

  F: MODEL Sales = married_pop inc_40Kto100K played_hockey football cover_charge
     stand_alone strip_mall metrics champion;
RUN; */

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
 
* End end with a QUIT statement ;
QUIT;
