/* 03_listings_tables.sas */
/* Clinical Data Review - Listings and Tables */

/* Update these paths as needed */
%let in_lib = work;
%let out_csv = c:\Users\saraq\Desktop\Biostat\output\clinical_clean.csv;

/* Listing of key variables by subject */
proc sort data=&in_lib..clinical_clean out=&in_lib..clinical_clean_sorted;
    by subject_id visit;
run;

proc report data=&in_lib..clinical_clean_sorted nowd;
    columns subject_id visit treatment_group biomarker1 biomarker2 biomarker3;
    define subject_id / "Subject ID";
    define visit / "Visit";
    define treatment_group / "Treatment Group";
    define biomarker1 / "Biomarker 1";
    define biomarker2 / "Biomarker 2";
    define biomarker3 / "Biomarker 3";
    title "Subject Listing - Key Variables";
run;

/* Summary tables for review */
proc means data=&in_lib..clinical_clean n mean std min max maxdec=2;
    class treatment_group;
    var biomarker1 biomarker2 biomarker3;
    title "Biomarker Summary by Treatment Group";
run;

proc freq data=&in_lib..clinical_clean;
    tables visit*treatment_group / norow nocol nopercent;
    title "Visit by Treatment Group Counts";
run;

/* Export final cleaned dataset to CSV */
proc export data=&in_lib..clinical_clean
    outfile="&out_csv"
    dbms=csv
    replace;
run;
