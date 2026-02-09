/* 02_exploratory_analysis.sas */
/* Clinical Data Review - Exploratory Analysis */

/* Update these paths as needed */
%let in_lib = work;

/* Sort cleaned dataset */
proc sort data=&in_lib..clinical_clean out=&in_lib..clinical_clean_sorted;
    by treatment_group visit subject_id;
run;

/* Summary statistics by treatment group and visit */
proc means data=&in_lib..clinical_clean_sorted n mean std min max maxdec=2;
    class treatment_group visit;
    var biomarker1 biomarker2 biomarker3;
    title "Biomarker Summary by Treatment Group and Visit";
run;

/* Trend plot for biomarker1 by visit and treatment group */
proc sgplot data=&in_lib..clinical_clean_sorted;
    series x=visit y=biomarker1 / group=treatment_group markers;
    xaxis label="Visit";
    yaxis label="Biomarker 1";
    title "Biomarker 1 Trend by Visit and Treatment Group";
run;
