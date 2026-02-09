/* 01_data_qc.sas */
/* Clinical Data Review - Data Quality Checks */

/* Update these paths as needed */
%let in_csv = c:\Users\saraq\Desktop\Biostat\data\clinical_data.csv;
%let out_lib = work;

/* Import CSV */
proc import datafile="&in_csv"
    out=&out_lib..clinical_raw
    dbms=csv
    replace;
    guessingrows=max;
    getnames=yes;
run;

/* Quick structure check */
proc contents data=&out_lib..clinical_raw varnum;
    title "Clinical Raw Data - Variable Listing";
run;

/* Missing values summary for all variables */
proc means data=&out_lib..clinical_raw n nmiss;
    title "Missing Values Summary";
run;

/* Frequency checks for key categorical variables */
proc freq data=&out_lib..clinical_raw;
    tables visit treatment_group / missing;
    title "Frequencies: Visit and Treatment Group";
run;

/* Distribution summaries for biomarker variables */
proc means data=&out_lib..clinical_raw n mean std min p25 median p75 max maxdec=2;
    var biomarker1 biomarker2 biomarker3;
    title "Biomarker Summary Statistics";
run;

/* Identify outliers using PROC UNIVARIATE (flag extreme values) */
proc univariate data=&out_lib..clinical_raw;
    var biomarker1 biomarker2 biomarker3;
    ods select ExtremeObs;
    title "Extreme Observations (Potential Outliers)";
run;

/* Optional: create a cleaned dataset with basic checks */
data &out_lib..clinical_clean;
    set &out_lib..clinical_raw;
    /* Example: standardize visit and treatment group to uppercase */
    visit = upcase(strip(visit));
    treatment_group = upcase(strip(treatment_group));
run;

proc contents data=&out_lib..clinical_clean varnum;
    title "Clinical Clean Data - Variable Listing";
run;
