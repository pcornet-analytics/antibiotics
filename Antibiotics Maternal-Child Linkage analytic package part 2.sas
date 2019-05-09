*PCORnet_IJO_2019_GitHub_Part2_050819.sas;

*Heerman W, Daley M, Boone-Heinonen J, Rifas-Shiman SL, Bailey LC, Forrest C, 
Young J, Gillman M, Horgan C, Janicke D, Jenter C, Kharbanda E, Lunsford D, Messito MJ, Toh S, Block J. 
Maternal Antibiotic Use During Pregnancy and Childhood Obesity at Age Five Years. 
Int J Obes (Lond). 2019 Jan 22. doi: 10.1038/s41366-018-0316-6.;

*Part 2 - analysis for Tables 1-3 and Supplemental Tables 1-4;

*Removed libnames and paths before uploading to GitHub;

libname rr 'F:\PCORnet\Mom child aim\R&R IJO';

proc format;
	value bmic 0 = '<5' 1 = 'x5-<85' 2 = '85-<95' 3 = '>=95';
	value racen 
    1 = 'American Indian or Alaska Native'
	2 = 'Asian'
	3 = 'Black or African American'
	4 = 'Native Hawaiian or other Pacific Islander'
	5 = 'White'
	6 = 'Multiple race'
	7 = 'Refuse to answer'
	8 = 'Other'
	9 = 'Unknown'
	10 = 'No information';
	value racenx 
	2 = 'Asian'
	3 = 'Black or African American'
	5 = 'White'
	8 = 'Other'
	9 = 'Unknown';
	value yn 1 = 'Yes' 0 = 'xNo' 9 = 'Other/DK'; 
	value ncx 0 = 'x0' 1 = '1' 2 = '2' 3 = '3' 4 = '4+' ;
	value siten
	5 = 'C2VAN'
	12 = 'C5HP'
	13 = 'C5KPCO'
	14 = 'C5KPMA'
	15 = 'C5KPNW'
	25 = 'C10ADV'
	29 = 'C5KPWA';
    value smoking
	1 = 'Current every day smoker'
    2 = 'Current some day smoker' 
    3 = 'Former smoker' 
    4 = 'Never smoker'
    5 = 'Smoker, current status unknown'
    6 = 'Unknown if ever smoked' 
    7 = 'Heavy tobacco smoker' 
    8 = 'Light tobacco smoker' 
	9 = 'Other/DK';
    value tobacco
	1 = 'Current user' 
    2 = 'Never' 
    3 = 'Quit/former user'
    4 = 'Passive or environmental exposure'
    6 = 'Not asked'
	9 = 'Other/DK';
	value tobacco_type 
	1 = 'Smoked tobacco only'
    2 = 'Non-smoked tobacco only' 
	3 = 'Use of both smoked and non-smoked tobacco products' 
    4 = 'None' 
    5 = 'Use of smoked tobacco but no info about non-smoked tobacco use'
    9 = 'Other/DK';
    value smk
	1 = 'Never'
    2 = 'Former' 
    3 = 'During pregnancy' 
	9 = 'Other/DK';
	value mc_abx  
	1 = 'xM0,C0'
	2 = 'M1,C0'
	3 = 'M0,C1'
	4 = 'M1,C1';
	value glu
	1 = 'xNormal'
	2 = 'GDM'
	3 = 'T1 or T2 DM';
run;

data person_levelx; 
 set rr.person_level_072418; 
run;

proc freq data = person_levelx; tables y5; where any_vitals_273d = 1; run;
*106277 any mom vitals. Of 106277, 53320 have 5y BMI-z and 52957 do not have 5y BMI-z. 
I compared characteristics of participants with v. without 5y BMI-z;

*Dataset: no complex chronic conditions;
data no_ccd;
 set person_levelx;

 if any_abx_mom_tri1 = 1 or any_abx_mom_tri2 = 1 then any_abx_mom_tri12 = 1;
 else any_abx_mom_tri12 = 0;*covariate for any_abx_mom_tri3;

 ep14d_tier_0_23l = ep14d_tier_0_23;
 if ep14d_tier_0_23l = 0 then ep14d_tier_0_23l = 0.05;
 logn_ep14d_tier_0_23 = log(ep14d_tier_0_23l);
 drop ep14d_tier_0_23l;
 
 if y5 = 1;
 if any_vitals_273d = 1;*53320;
 if complex_dx_lt72m_ge2 = 0;*48908;
 *if bmi_prepreg ne . and gwg_kg ne .;*22310;
 format ep10d_abx_mom_pregc ep10d_babx_mom_pregc ep10d_nabx_mom_pregc ep10d_nabx_mom_prgcx 
 ep10d_abx_0_23c ep10d_babx_0_23c ep10d_nabx_0_23c ncx.
 mc_abx mc_abx. glucose_status glu.;
run;

*Dataset: yes complex chronic conditions;
data yes_ccd;
 set person_levelx;
 
 if any_abx_mom_tri1 = 1 or any_abx_mom_tri2 = 1 then any_abx_mom_tri12 = 1;
 else any_abx_mom_tri12 = 0;*covariate for any_abx_mom_tri3;

 ep14d_tier_0_23l = ep14d_tier_0_23;
 if ep14d_tier_0_23l = 0 then ep14d_tier_0_23l = 0.05;
 logn_ep14d_tier_0_23 = log(ep14d_tier_0_23l);
 drop ep14d_tier_0_23l;
 
 if y5 = 1;
 if any_vitals_273d = 1;*53320;
 if complex_dx_lt72m_ge2 = 1;*4412;
 *if bmi_prepreg ne . and gwg_kg ne .;*1980;
 format ep10d_abx_mom_pregc ep10d_babx_mom_pregc ep10d_nabx_mom_pregc ep10d_nabx_mom_prgcx 
 ep10d_abx_0_23c ep10d_babx_0_23c ep10d_nabx_0_23c ncx.
 mc_abx mc_abx. glucose_status glu.;
run;

*Dataset: no + yes complex chronic conditions (used for main analysis, Tables 2 and 3);
data yn_ccd;
 set no_ccd yes_ccd;
run;

*Table 1. Demographic and clinical characteristics of the study population (n = 53,320);

*Table 1 footnote:
Sample size for maternal pre-pregnancy BMI is 25,976, gestational
weight gain is 24,290, gestational age is 31,328, and birth weight is 27,468;

proc freq data = person_levelx; 
 tables pregsmk mbmic glucose_status ep10d_abx_mom_pregc ep10d_babx_mom_pregc ep10d_nabx_mom_pregc
 any_abx_mom_tri1 any_abx_mom_tri2 any_abx_mom_tri3 csection preterm female racenx hispanicn
 ep10d_abx_0_23c ep10d_abx_0_23c;
 where y5 = 1 and any_vitals_273d = 1;
run;

proc means data = person_levelx; 
 var bmi_prepreg gwg_kg age_m gest_agex_weeks BIRTH_WTx bmic_5y agem_5y BMIZ_5y; 
 where y5 = 1 and any_vitals_273d = 1;
run;

*Table 2 Multivariable linear regression results for the associations of
antibiotics during pregnancy with BMI-z at ages 48 to <72 months (n = 24,290);

proc mixed data = yn_ccd;
 class site racenx glucose_status;
 model bmiz_5y = any_abx_mom_preg bmi_prepreg gwg_kg pregsmk glucose_status 
 age_m csection racenx hispanicn female agem_5y /s cl;
 random site / type=simple;
 format racenx racenx.;
run; quit;

*Table 3 Dose, timing, and spectrum of maternal antibiotics during
pregnancy and child BMI-z at 48 to <72 months;

*Results shown for 6 separate models, each with the outcome of child
BMI-Z at 48 to <72 months and the reference group of no antibiotics
during pregnancy
Model 1: Exposure is any antibiotics in the 1st trimester
Model 2: Exposure is any antibiotics in the 2nd trimester (any
antibiotics in the 1st trimester as a covariate)
Model 3: Exposure is any antibiotics in the 3rd trimester (any
antibiotics in the 1st or second trimester as covariates)
Model 4: Exposure is any broad-spectrum antibiotics during
pregnancy
Model 5: Exposure is any narrow spectrum antibiotics during
pregnancy (limited to participants with no broad-spectrum antibiotics
during pregnancy)
Model 6: Exposure is the number of antibiotic prescribing episodes
during pregnancy (categorized as 0 [ref]1–4+)
All models were corrected for clustering by site plus adjusted for
maternal pre-pregnancy BMI, total gestational weight gain, smoking
during pregnancy, glucose status, age at delivery, and mode of
delivery and child race, ethnicity, sex, and age at outcome.;

%macro x (mv,outds,expc,exp,cont,cat);
proc mixed data = yn_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(3,d1,'any_abx_mom_tri1',any_abx_mom_tri1,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);
%x(3,d2,'any_abx_mom_tri2',any_abx_mom_tri2,any_abx_mom_tri1 female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, 
   racenx glucose_status);
%x(3,d3,'any_abx_mom_tri3',any_abx_mom_tri3,any_abx_mom_tri12 female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, 
   racenx glucose_status);
%x(3,d4,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);
%x(3,d5,'any_babx_mom_preg',any_babx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

*Narrow;
%macro x (mv,outds,expc,exp,cont,cat);
proc mixed data = yn_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat /s cl;
 random site / type=simple;
 where any_babx_mom_preg = 0;
run; quit;
%MEND;
%x(3,d5,'any_nabx_mom_preg',any_nabx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

*Categorical;
%macro x (mv,outds,expc,exp,cont,cat);
proc mixed data = yn_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(3,d5,'ep10d_abx_mom_pregc',ep10d_abx_mom_pregc,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

*Supplemental tables;

*Supplemental Table 1. PCORnet Network Partners Participating in PCORnet Antibiotics and
Childhood Growth Study and included in analysis sample.
(no results);

*Supplemental Table 2. Demographic and clinical characteristics among the included v. excluded participants;

*Supplemental Table 2 footnote:
Among included: 
sample size for maternal pre-pregnancy BMI is 25976, gestational weight gain is 24290, gestational age is 31328, and birthweight is 27468.  
Among excluded: 
sample size for maternal pre-pregnancy BMI is 30885, gestational weight gain is 28603, gestational age is 32424, and birthweight is 28109;  

proc freq data = person_levelx; 
 tables (pregsmk mbmic glucose_status ep10d_abx_mom_pregc ep10d_babx_mom_pregc ep10d_nabx_mom_pregc
 any_abx_mom_tri1 any_abx_mom_tri2 any_abx_mom_tri3 csection preterm female racenx hispanicn
 ep10d_abx_0_23c ep10d_abx_0_23c)*y5;
 where any_vitals_273d = 1;
run;

proc means data = person_levelx; 
 var bmi_prepreg gwg_kg age_m gest_agex_weeks BIRTH_WTx bmic_5y agem_5y BMIZ_5y; 
 class y5;
 where any_vitals_273d = 1;
run;

*Supplemental Table 4. Multivariable linear regression results for the association of antibiotics during pregnancy 
with BMI-z at 48 to <72 months of age, according to complex chronic condition status;

*Model 1. Corrected for clustering by site
Model 2. Corrected for clustering by site + adjusted for child race, ethnicity, sex, and age at outcome. 
Model 3. Model 2 + adjusted for maternal pre-pregnancy BMI, total gestational weight gain, smoking during pregnancy, 
glucose status, age at delivery, and mode of delivery.
The sample size for each model was as follows: 
No complex chronic conditions (Model 1 N=48908, Model 2 N=48908, Model 3 N=22310). 
Complex Chronic Conditions (Model 1 N=4412, Model 2 N=4412, Model 3 N=1980);

*run with each dataset (no_ccd and yes_ccd);
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
*proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,d1,'any_abx_mom_preg',any_abx_mom_preg); 
%x(2,d2,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn, racenx);
%x(3,d3,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);
%x(1,d4,'any_babx_mom_preg',any_babx_mom_preg); 
%x(2,d5,'any_babx_mom_preg',any_babx_mom_preg,female agem_5y hispanicn, racenx);
%x(3,d6,'any_babx_mom_preg',any_babx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
*proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where any_babx_mom_preg = 0;
run; quit;
%MEND;
%x(1,d7,'any_nabx_mom_preg',any_nabx_mom_preg); 
%x(2,d8,'any_nabx_mom_preg',any_nabx_mom_preg,female agem_5y hispanicn, racenx);
%x(3,d9,'any_nabx_mom_preg',any_nabx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

*categorical exposures;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
*proc mixed data = yes_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,d10,'ep10d_abx_mom_pregc',ep10d_abx_mom_pregc); 
%x(2,d11,'ep10d_abx_mom_pregc',ep10d_abx_mom_pregc,female agem_5y hispanicn, racenx);
%x(3,d12,'ep10d_abx_mom_pregc',ep10d_abx_mom_pregc,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);
%x(1,d13,'ep10d_babx_mom_pregc',ep10d_babx_mom_pregc); 
%x(2,d14,'ep10d_babx_mom_pregc',ep10d_babx_mom_pregc,female agem_5y hispanicn, racenx);
%x(3,d15,'ep10d_babx_mom_pregc',ep10d_babx_mom_pregc,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
*proc mixed data = yes_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where any_babx_mom_preg = 0;
run; quit;
%MEND;
%x(1,d16,'ep10d_nabx_mom_prgcx',ep10d_nabx_mom_prgcx); 
%x(2,d17,'ep10d_nabx_mom_prgcx',ep10d_nabx_mom_prgcx,female agem_5y hispanicn, racenx);
%x(3,d18,'ep10d_nabx_mom_prgcx',ep10d_nabx_mom_prgcx,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);

*Supplemental Table 3. Multivariable linear regression results for the associations of antibiotics during pregnancy 
with BMI-z at 48 to <72 months of age, 
according to complex chronic condition status and pre-pregnancy BMI category;

*Model 1. Corrected for clustering by site
Model 2. Corrected for clustering by site + adjusted for child race, ethnicity, sex, and age at outcome. 
Model 3. Model 2 + adjusted for maternal pre-pregnancy BMI, total gestational weight gain, smoking during pregnancy, glucose status, age at delivery, and mode of delivery (for BMI stratified models) 
The sample size was the same for all 3 models.;

*kept same N M1-M3;
data yes_ccdx;
 set yes_ccd; 
 if bmi_prepreg ne . and gwg_kg ne .;
run;

data no_ccdx;
 set no_ccd; 
 if bmi_prepreg ne . and gwg_kg ne .;
run;

*run with each dataset (no_ccdx and yes_ccdx);
*stratified by maternal BMI status;
%macro s (mbmic);
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccdx;
*proc mixed data = yes_ccdx;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where mbmic = &mbmic;
run; quit;
%MEND;
%x(1,d1,'any_abx_mom_preg',any_abx_mom_preg); 
%x(2,d2,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn, racenx);
%x(3,d3,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk csection, racenx glucose_status);
%MEND;
%s(1); 
%s(2); 
%s(3);

*run with each dataset (no_ccdx and yes_ccdx);
*stratified by c-section status;
%macro s (csection);
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccdx;
*proc mixed data = yes_ccdx;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where csection = &csection;
run; quit;
%MEND;
%x(1,d1,'any_abx_mom_preg',any_abx_mom_preg); 
%x(2,d2,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn, racenx);
%x(3,d3,'any_abx_mom_preg',any_abx_mom_preg,female agem_5y hispanicn bmi_prepreg gwg_kg age_m pregsmk /*csection*/, racenx glucose_status);
%MEND;
%s(1); 
%s(0); 
