*PCORnet_Peds_2018_GitHub_Part2_082418.sas;

*Pediatrics 2018 manuscript: 
 Early Life Antibiotic Use and Weight Outcomes in Children Ages 48 to <72 Months of Age;

*Part 2 - analysis for Tables 1-4, Supplemental Tables 1-12, Figure 1;

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
	value hisp 1 = 'Yes' 0 = 'zNo' 9 = 'Other/DK'; 
run;*value siten - removed before uploading to GitHub;

data two;
 set f.PCORnet_Aim1;

 array x (58) 
 preterm complex_dx_lt72m_n asthma_ct wellchild_ct reflux_lt24m_ct 
 n_enc1_0_23 n_enc1_0_5 n_enc1_6_11 n_enc1_12_23
 ep14d_tier_0_23 dx_tier_0_23
 ep14d_tier_0_5 dx_tier_0_5
 ep14d_tier_6_11 dx_tier_6_11
 ep14d_tier_12_23 dx_tier_12_23
 ep10d_steroids_0_23 script_steroids_0_23 
 ep10d_steroids_0_5 script_steroids_0_5 
 ep10d_steroids_6_11 script_steroids_6_11 
 ep10d_steroids_12_23 script_steroids_12_23 
 ep10d_steroidsx_0_23 script_steroidsx_0_23 
 ep10d_steroidsx_0_5 script_steroidsx_0_5 
 ep10d_steroidsx_6_11 script_steroidsx_6_11 
 ep10d_steroidsx_12_23 script_steroidsx_12_23 
 ep10d_abx_0_23 script_abx_0_23
 ep10d_abx_0_5 script_abx_0_5
 ep10d_abx_6_11 script_abx_6_11
 ep10d_abx_12_23 script_abx_12_23
 ep10d_babx_0_23 script_babx_0_23
 ep10d_babx_0_5 script_babx_0_5
 ep10d_babx_6_11 script_babx_6_11
 ep10d_babx_12_23 script_babx_12_23
 ep10d_nabx_0_23 script_nabx_0_23
 ep10d_nabx_0_5 script_nabx_0_5
 ep10d_nabx_6_11 script_nabx_6_11
 ep10d_nabx_12_23 script_nabx_12_23
 ep14d_tier1_0_23;
 do i = 1 to 58;
 if x(i) = . then x(i) = 0;
 end;

 if complex_dx_lt72m_n >=2 then complex_dx_lt72m_ge2 = 1;
 else complex_dx_lt72m_ge2 = 0;*for stratified analysis >=2 codes <72m;

 if asthma_ct >=2 then asthma_ge2 = 1;
 else asthma_ge2 = 0;*covariate >=2 codes <72m;

 *sex for CDC: 1 = male 2 = female;
 if sex = 1 then female = 0;
 else if sex = 2 then female = 1;

 if race in ('UN','NI','07','10') then race_progress_report = 9;
 else if race = '01' then race_progress_report = 1;
 else if race = '04' then race_progress_report = 4;
 else if race = '06' then race_progress_report = 6;
 else if race = '08' then race_progress_report = 8;
 else if race = 'OT' then race_progress_report = 8;
 else if race = '02' then race_progress_report = 2;
 else if race = '03' then race_progress_report = 3;
 else if race = '05' then race_progress_report = 5;

 if race in ('UN','NI','07','10') then racen = 9;
 else if race in ('01','04','06','08','OT') then racen = 8;
 else if race = '02' then racen = 2;
 else if race = '03' then racen = 3;
 else if race = '05' then racen = 5;

 if HISPANIC = 'N' then hispanicn = 0;
 else if HISPANIC = 'Y' then hispanicn = 1;
 else if HISPANIC in ('NI','OT','R','UN') then hispanicn = 9;

 if hispanicn = 1 then hispanic_yn = 1;
 else if hispanicn in (0,9) then hispanic_yn = 0;

 *add a small value so that I can log transform;
 array l (9) n_enc1_0_23 n_enc1_0_5 n_enc1_6_11 n_enc1_12_23
 ep14d_tier_0_23 ep14d_tier_0_5 ep14d_tier_6_11 ep14d_tier_12_23
 ep14d_tier1_0_23;
 array ll (9) n_enc1_0_23l n_enc1_0_5l n_enc1_6_11l n_enc1_12_23l
 ep14d_tier_0_23l ep14d_tier_0_5l ep14d_tier_6_11l ep14d_tier_12_23l
 ep14d_tier1_0_23l;
 array lg (9) logn_enc1_0_23 logn_enc1_0_5 logn_enc1_6_11 logn_enc1_12_23
 logn_ep14d_tier_0_23 logn_ep14d_tier_0_5 logn_ep14d_tier_6_11 logn_ep14d_tier_12_23
 logn_ep14d_tier1_0_23;
 do i = 1 to 9;
 ll(i) = l(i);
 if ll(i) = 0 then ll(i) = 0.05;
 lg(i) = log(ll(i));
 end;
 drop n_enc1_0_23l n_enc1_0_5l n_enc1_6_11l n_enc1_12_23l
 ep14d_tier_0_23l ep14d_tier_0_5l ep14d_tier_6_11l ep14d_tier_12_23l
 ep14d_tier1_0_23l;

 *dichotomous BMI >=85th v. <85th %tile;
 if BMIPCT >=85 then BMI_ge85 = 1; else if BMIPCT >. then BMI_ge85 = 0;

 *dichotomous BMI >=95th v. <95th %tile;
 if BMIPCT >=95 then BMI_ge95 = 1; else if BMIPCT >. then BMI_ge95 = 0;

 *dichotomous BMI >=95th v. <85th %tile;
 if BMIPCT >=95 then BMI_ge95_lt85 = 1; else if BMIPCT >. and BMIPCT <85 then BMI_ge95_lt85 = 0;

 *4-category BMI: <5th, 5-<85th, 85-<95th, >=95th %tile;
 if BMIPCT >=95 then BMIPCTc = 3;
 else if BMIPCT >=85 then BMIPCTc = 2;
 else if BMIPCT >=5 then BMIPCTc = 1;
 else if BMIPCT >. then BMIPCTc = 0;

 *any y/n;
 array y (31) 
 wellchild_ct reflux_lt24m_ct 
 n_enc1_0_23 n_enc1_0_5 n_enc1_6_11 n_enc1_12_23
 ep14d_tier_0_23
 ep14d_tier_0_5
 ep14d_tier_6_11
 ep14d_tier_12_23
 ep10d_steroids_0_23 
 ep10d_steroids_0_5  
 ep10d_steroids_6_11 
 ep10d_steroids_12_23
 ep10d_steroidsx_0_23
 ep10d_steroidsx_0_5 
 ep10d_steroidsx_6_11
 ep10d_steroidsx_12_23
 ep10d_abx_0_23 
 ep10d_abx_0_5 	
 ep10d_abx_6_11 
 ep10d_abx_12_23
 ep10d_babx_0_23
 ep10d_babx_0_5 
 ep10d_babx_6_11
 ep10d_babx_12_23
 ep10d_nabx_0_23 
 ep10d_nabx_0_5  
 ep10d_nabx_6_11 
 ep10d_nabx_12_23
 ep14d_tier1_0_23;
 array yy (31) 
 wellchild_ctx reflux_lt24m_ctx 
 n_enc1_0_23x n_enc1_0_5x n_enc1_6_11x n_enc1_12_23x
 ep14d_tier_0_23x
 ep14d_tier_0_5x
 ep14d_tier_6_11x
 ep14d_tier_12_23x
 ep10d_steroids_0_23x 
 ep10d_steroids_0_5x  
 ep10d_steroids_6_11x 
 ep10d_steroids_12_23x
 ep10d_steroidsx_0_23x
 ep10d_steroidsx_0_5x 
 ep10d_steroidsx_6_11x
 ep10d_steroidsx_12_23x
 ep10d_abx_0_23x 
 ep10d_abx_0_5x 	
 ep10d_abx_6_11x 
 ep10d_abx_12_23x
 ep10d_babx_0_23x
 ep10d_babx_0_5x 
 ep10d_babx_6_11x
 ep10d_babx_12_23x
 ep10d_nabx_0_23x 
 ep10d_nabx_0_5x  
 ep10d_nabx_6_11x 
 ep10d_nabx_12_23x
 ep14d_tier1_0_23x;
 array zz (31) 
 wellchild_ct_c reflux_lt24m_ct_c 
 n_enc1_0_23_c n_enc1_0_5_c n_enc1_6_11_c n_enc1_12_23_c
 ep14d_tier_0_23_c
 ep14d_tier_0_5_c
 ep14d_tier_6_11_c
 ep14d_tier_12_23_c
 ep10d_steroids_0_23_c 
 ep10d_steroids_0_5_c  
 ep10d_steroids_6_11_c 
 ep10d_steroids_12_23_c
 ep10d_steroidsx_0_23_c
 ep10d_steroidsx_0_5_c 
 ep10d_steroidsx_6_11_c
 ep10d_steroidsx_12_23_c
 ep10d_abx_0_23_c 
 ep10d_abx_0_5_c 	
 ep10d_abx_6_11_c 
 ep10d_abx_12_23_c
 ep10d_babx_0_23_c
 ep10d_babx_0_5_c 
 ep10d_babx_6_11_c
 ep10d_babx_12_23_c
 ep10d_nabx_0_23_c 
 ep10d_nabx_0_5_c  
 ep10d_nabx_6_11_c 
 ep10d_nabx_12_23_c
 ep14d_tier1_0_23_c;
 do i = 1 to 31;
 yy(i) = y(i);
 if yy(i) >=1 then yy(i) = 1;
 zz(i) = y(i);
 if zz(i) >=4 then zz(i) = 4;*1-2-3-4+;
 end;

 agem_5y = agemos;
 weight_5y = weight;
 height_5y = height;
 bmi_5y = bmi;
 bmiz_5y = bmiz;
 drop agemos height weight BMI BMIZ;

 if siten in (1,2,7,10,18,20,23,24,27) then lt40pct_abx = 1;
 else lt40pct_abx = 0;

 if abx_tier1_7d_flag = . then abx_tier1_7d_flag = 0;

 if ep10d_abx_0_5x = 1 or ep10d_abx_6_11x = 1 then ep10d_abx_0_11x = 1; else ep10d_abx_0_11x = 0;
 if ep10d_babx_0_5x = 1 or ep10d_babx_6_11x = 1 then ep10d_babx_0_11x = 1; else ep10d_babx_0_11x = 0;
 if ep10d_nabx_0_5x = 1 or ep10d_nabx_6_11x = 1 then ep10d_nabx_0_11x = 1; else ep10d_nabx_0_11x = 0;

 *Time window	Broad exclusion		Previous abx
				for narrow exp		covariate
 0-<24			0-<24				x
 0-<6			0-<6				x
 6-<12			0-<12				0-<6
 12-<24			0-<24				0-<12;

 if ep14d_tier_0_23_c in (0,1) then gt1_tier_0_23_c = 0;
 else if ep14d_tier_0_23_c in (2,3,4) then gt1_tier_0_23_c = 1;

 if ep14d_tier_0_23_c in (0,1) then tier_0_23_3c = 1;
 else if ep14d_tier_0_23_c in (2,3) then tier_0_23_3c = 2;
 else if ep14d_tier_0_23_c = 4 then tier_0_23_3c = 3;

run;

*no complex chronic condition dataset;
data no_ccd;
 set two; 
 if complex_dx_lt72m_ge2 = 0;
run;

*yes complex chronic condition dataset;
data yes_ccd;
 set two; 
 if complex_dx_lt72m_ge2 = 1;
run;

*Table 1. Demographic and clinical characteristics of the study population, 
overall and stratified by chronic condition status and antibiotic use;

*no ABX 0-<24 months;
proc freq data = two;
 tables (female racen hispanic_yn preterm asthma_ge2 ep10d_steroids_0_23_c ep14d_tier_0_23_c
 ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c BMIPCTc)*complex_dx_lt72m_ge2;
 where ep10d_abx_0_23x = 0;*no ABX 0-<24 months;
 format female hispanic_yn preterm asthma_ge2 yn.
 racen racenx. 
 ep10d_steroids_0_23_c ep14d_tier_0_23_c ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.
 BMIPCTc bmic.;
run;

*yes ABX 0-<24 months;
proc freq data = two;
 tables (female racen hispanic_yn preterm asthma_ge2 ep10d_steroids_0_23_c ep14d_tier_0_23_c
 ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c BMIPCTc)*complex_dx_lt72m_ge2;
 where ep10d_abx_0_23x = 1;
 format female hispanic_yn preterm asthma_ge2 yn.
 racen racenx. 
 ep10d_steroids_0_23_c ep14d_tier_0_23_c ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.
 BMIPCTc bmic.;
run;

proc means data = two n mean std median;
 var n_enc1_0_23 agem_5y BMIZ_5y;
 class complex_dx_lt72m_ge2 ep10d_abx_0_23x;
run;

*Table 2. Multivariable linear regression results for the association of any exposure to antibiotics <24
months of age with BMI z-score 48 to <72 months of age, by timing of antibiotic prescription;

*Model 1. Corrected for clustering by site
Model 2. Corrected for clustering by site + adjusted for sex, race, ethnicity, preterm birth, asthma,
corticosteroid episodes (continuous 0-1-2-3-4+) at 0-<24 months, number of encounters (continuous, log
transformed) at 0-<24 months, infection episodes (continuous, log transformed) at 0-<24 months, and age
at outcome.

For exposure time windows, additionally adjusted Model 2 for previous antibiotics:
Antibiotics 6 to <12 months, adjusted for 0 to <6 months antibiotics
Antibiotics 12 to <24 months, adjusted for 0 to <12 months antibiotics.

For exposure time windows, used covariates during the same time window (corticosteroids, encounters):
Antibiotics 0 to <6 months, used covariates 0 to <6 months
Antibiotics 6 to <12 months, used covariates for 6 to <12 months
Antibiotics 12 to <24 months, used covariates for 12 to <24 months.

For narrow antibiotic exposures, analyses limited to participants with no broad during the same time
window as exposure or before;

*No complex chronic conditions, any and broad ABX;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
%x(1,t3,'ep10d_abx_0_5x',ep10d_abx_0_5x); 
%x(2,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 
%x(1,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x); 
%x(2,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);  
%x(1,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x); 
%x(2,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   
*Broad;
%x(1,b1,'ep10d_babx_0_23x',ep10d_babx_0_23x); 
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
%x(1,b3,'ep10d_babx_0_5x',ep10d_babx_0_5x); 
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 
%x(1,b5,'ep10d_babx_6_11x',ep10d_babx_6_11x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);   
%x(1,b7,'ep10d_babx_12_23x',ep10d_babx_12_23x); 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 

*No complex chronic conditions, narrow ABX;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &broad = 0;
run; quit;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,1,n3,'ep10d_nabx_0_5x',ep10d_nabx_0_5x); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,1,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,1,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x); 
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Yes complex chronic conditions, any and broad ABX;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
%x(1,t3,'ep10d_abx_0_5x',ep10d_abx_0_5x); 
%x(2,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 
%x(1,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x); 
%x(2,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);  
%x(1,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x); 
%x(2,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   
*Broad;
%x(1,b1,'ep10d_babx_0_23x',ep10d_babx_0_23x); 
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
%x(1,b3,'ep10d_babx_0_5x',ep10d_babx_0_5x); 
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 
%x(1,b5,'ep10d_babx_6_11x',ep10d_babx_6_11x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);   
%x(1,b7,'ep10d_babx_12_23x',ep10d_babx_12_23x); 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 

*Yes complex chronic conditions, narrow ABX;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &broad = 0;
run; quit;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,1,n3,'ep10d_nabx_0_5x',ep10d_nabx_0_5x); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,1,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,1,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x); 
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Table 3. Multivariable logistic regression results for the association of any exposure to antibiotics <24
months of age and risk of overweight/obesity 48 to <72 months of age, by timing of antibiotic
prescription;

*Model 1. Corrected for clustering by site.
Model 2. Corrected for clustering by site + adjusted for sex, race, ethnicity, preterm birth, asthma,
corticosteroid episodes (continuous 0-1-2-3-4+) at 0-<24 months, number of encounters (continuous,
transformed) at 0-<24 months, infection episodes (continuous, log transformed) at 0-<24 months, and
at outcome.

For exposure time windows, additionally adjusted Model 2 for previous antibiotics:
Antibiotics 6 to <12 months, adjusted for 0 to <6 months antibiotics
Antibiotics 12 to <24 months, adjusted for 0 to <12 months antibiotics.

For exposure time windows, used covariates during the same time window (corticosteroids, encounters):
Antibiotics 0 to <6 months, used covariates 0 to <6 months
Antibiotics 6 to <12 months, used covariates for 6 to <12 months
Antibiotics 12 to <24 months, used covariates for 12 to <24 months.

For narrow antibiotic exposures, analyses limited to participants with no broad during the same time
window as exposure or before;

*No complex chronic conditions, any and broad ABX;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
run;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,t3,'ep10d_abx_0_5x',ep10d_abx_0_5x); 
%x(2,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x); 
%x(2,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);   

%x(1,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x); 
%x(2,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   

*Broad;
%x(1,b1,'ep10d_babx_0_23x',ep10d_babx_0_23x); 
%x(2,b3,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,b3,'ep10d_babx_0_5x',ep10d_babx_0_5x); 
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,b5,'ep10d_babx_6_11x',ep10d_babx_6_11x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);   

%x(1,b7,'ep10d_babx_12_23x',ep10d_babx_12_23x); 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x);

*No complex chronic conditions, narrow ABX;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 where &broad = 0;
run;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,1,n3,'ep10d_nabx_0_5x',ep10d_nabx_0_5x); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,1,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,1,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x); 
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Yes complex chronic conditions, any and broad ABX;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = yes_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
run;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,t3,'ep10d_abx_0_5x',ep10d_abx_0_5x); 
%x(2,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x); 
%x(2,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);   

%x(1,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x); 
%x(2,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   

*Broad;
%x(1,b1,'ep10d_babx_0_23x',ep10d_babx_0_23x); 
%x(2,b3,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,b3,'ep10d_babx_0_5x',ep10d_babx_0_5x); 
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,b5,'ep10d_babx_6_11x',ep10d_babx_6_11x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);   

%x(1,b7,'ep10d_babx_12_23x',ep10d_babx_12_23x); 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 
 
*Yes complex chronic conditions, narrow ABX;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = yes_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 where &broad = 0;
run;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,1,n3,'ep10d_nabx_0_5x',ep10d_nabx_0_5x); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,1,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,1,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x); 
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Table 4. Multivariable logistic regression results for the association of antibiotics episodes <24 months of
age and risk for overweight/obesity 48 to <72 months of age, by courses of antibiotics;

*Model 1. Corrected for clustering by site.
Model 2. Corrected for clustering by site + adjusted for sex, race, ethnicity, preterm birth, asthma,
corticosteroid episodes (continuous 0-1-2-3-4+) at 0-<24 months, number of encounters (continuous, log
transformed) at 0-<24 months, infection episodes (continuous, log transformed) at 0-<24 months, and age
at outcome.

For narrow antibiotic exposures, analyses limited to participants with no broad during the same time
window as exposure or before.;

*No complex chronic conditions, any and broad ABX, categorical exp;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat &exp;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23_c',ep10d_abx_0_23_c); 
%x(2,t2,'ep10d_abx_0_23_c',ep10d_abx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
*Broad;
%x(1,b1,'ep10d_babx_0_23_c',ep10d_babx_0_23_c); 
%x(2,b2,'ep10d_babx_0_23_c',ep10d_babx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

*No complex chronic conditions, narrow ABX, categorical exp;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat &exp;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 where &broad = 0;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

*Yes complex chronic conditions, any and broad ABX, categorical exp;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = yes_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat &exp;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23_c',ep10d_abx_0_23_c); 
%x(2,t2,'ep10d_abx_0_23_c',ep10d_abx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
*Broad;
%x(1,b1,'ep10d_babx_0_23_c',ep10d_babx_0_23_c); 
%x(2,b2,'ep10d_babx_0_23_c',ep10d_babx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

*Yes complex chronic conditions, narrow ABX, categorical exp;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = yes_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat &exp;
 model BMI_ge85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 where &broad = 0;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

*Figure 1. Dose response relationship for association of antibiotic episodes <24 months of age with BMI z-score 48 to <72 months of
age;

*This figure shows the difference in BMI z-score 48 to <72 months of age (“5 years”) according
to the number of antibiotic episodes a child received <24 months of age. Results show BMI z
score differences and 95% confidence intervals for 1, 2, 3, and 4+ antibiotic episodes overall and
for narrow- and broad-spectrum antibiotics, compared to the reference of 0 antibiotic episodes.
Results are stratified by whether a child have a complex chronic condition (CCC) or not.;

*No complex chronic conditions, any and broad ABX, categorical exp;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run; quit;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23_c',ep10d_abx_0_23_c);*used Model 1 and Model 2 in Supplemental Table 3; 
%x(2,t2,'ep10d_abx_0_23_c',ep10d_abx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);*used Model 2 in Figure;
*Broad;
%x(1,b1,'ep10d_babx_0_23_c',ep10d_babx_0_23_c);*used Model 1 and Model 2 in Supplemental Table 3; 
%x(2,b2,'ep10d_babx_0_23_c',ep10d_babx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);*used Model 2 in Figure;

*No complex chronic conditions, narrow ABX, categorical exp;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &broad = 0;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run; quit;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

*Yes complex chronic conditions, any and broad ABX, categorical exp;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run; quit;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23_c',ep10d_abx_0_23_c); 
%x(2,t2,'ep10d_abx_0_23_c',ep10d_abx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);*used Model 2 in Figure;
*Broad;
%x(1,b1,'ep10d_babx_0_23_c',ep10d_babx_0_23_c); 
%x(2,b2,'ep10d_babx_0_23_c',ep10d_babx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);*used Model 2 in Figure;

*Yes complex chronic conditions, narrow ABX, categorical exp;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat &exp;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &broad = 0;
 format ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.;
run; quit;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23_c',ep10d_nabx_0_23_c,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

*Supplemental Table 1: PCORnet Network Partners Participating in PCORnet Antibiotics and Childhood Growth Study
No results, just a list of CDRN names and network partners; 

*Supplemental Table 2: Demographic and clinical characteristics of the study population, overall and
stratified by chronic condition status;

*Overall;
proc freq data = two;
 tables female racen hispanic_yn preterm asthma_ge2 ep10d_steroids_0_23_c ep14d_tier_0_23_c
 ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c BMIPCTc;
 format female hispanic_yn preterm asthma_ge2 yn.
 racen racenx. 
 ep10d_steroids_0_23_c ep14d_tier_0_23_c ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.
 BMIPCTc bmic.;
run;

proc means data = two n mean std median;
 var n_enc1_0_23 agem_5y BMIZ_5y;
run;

*by chronic condition status;
proc freq data = two;
 tables (female racen hispanic_yn preterm asthma_ge2 ep10d_steroids_0_23_c ep14d_tier_0_23_c
 ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c BMIPCTc)*complex_dx_lt72m_ge2;
 format female hispanic_yn preterm asthma_ge2 yn.
 racen racenx. 
 ep10d_steroids_0_23_c ep14d_tier_0_23_c ep10d_abx_0_23_c ep10d_babx_0_23_c ep10d_nabx_0_23_c ncx.
 BMIPCTc bmic.;
run;

proc means data = two n mean std median;
 var n_enc1_0_23 agem_5y BMIZ_5y;
 class complex_dx_lt72m_ge2;
run;

*Supplemental Table 3. Multivariable linear regression results for the association of antibiotics episodes
<24 months of age with BMI z-score 48-<72 months of age, by antibiotic spectrum.;
*Same results as Figure 1 above (Model 1 and Model 2);

*Supplemental Table 5. Comparing Results of Models with v. without Including Infections as a covariate.
Multivariable linear regression results for the association of any exposure to antibiotics <24 months of
age with BMI z-score 48-<72 months of age, by timing of antibiotic prescription 

AND

Supplemental Table 7. Comparing Results of Models with v. without Including Asthma as a covariate.
Multivariable linear regression results for the association of any exposure to antibiotics <24 months of
age with BMI z-score 48-<72 months of age, by timing of antibiotic prescription

*No complex chronic conditions, any and broad ABX, w/o infections (ST5), w/o asthma (ST7). See Table 2 for original Model 2;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   /*logn_ep14d_tier_0_23*/,racen);
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(3,t2,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   /*logn_ep14d_tier_0_5*/,racen); 
%x(4,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(5,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   /*logn_ep14d_tier_6_11*/,racen,ep10d_abx_0_5x);
%x(6,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);  

%x(7,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   /*logn_ep14d_tier_12_23*/,racen,ep10d_abx_0_11x);   
%x(8,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   

*Broad;
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   /*logn_ep14d_tier_0_23*/,racen);
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   /*logn_ep14d_tier_0_5*/,racen);  
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   /*logn_ep14d_tier_6_11*/,racen,ep10d_babx_0_5x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);  
 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   /*logn_ep14d_tier_12_23*/,racen,ep10d_babx_0_11x);
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 

*No complex chronic conditions, narrow ABX, w/o infections (ST5), w/o asthma (ST7). See Table 2 for original Model 2;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &broad = 0;
run; quit;
%MEND; 
%x(ep10d_babx_0_23x,2,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn /*logn_ep14d_tier_0_23*/,racen); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,2,n2,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn /*logn_ep14d_tier_0_5*/,racen); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,2,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn /*logn_ep14d_tier_6_11*/,racen,ep10d_nabx_0_5x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,2,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn /*logn_ep14d_tier_12_23*/,racen,ep10d_nabx_0_11x);
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Yes complex chronic conditions, any and broad ABX, w/o infections (ST5), w/o asthma (ST7). See Table 2 for original Model 2;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   /*logn_ep14d_tier_0_23*/,racen);
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(3,t2,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   /*logn_ep14d_tier_0_5*/,racen); 
%x(4,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(5,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   /*logn_ep14d_tier_6_11*/,racen,ep10d_abx_0_5x);
%x(6,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);  

%x(7,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   /*logn_ep14d_tier_12_23*/,racen,ep10d_abx_0_11x);   
%x(8,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   

*Broad;
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   /*logn_ep14d_tier_0_23*/,racen);
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   /*logn_ep14d_tier_0_5*/,racen);  
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   /*logn_ep14d_tier_6_11*/,racen,ep10d_babx_0_5x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);  
 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   /*logn_ep14d_tier_12_23*/,racen,ep10d_babx_0_11x);
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 

*Yes complex chronic conditions, narrow ABX, w/o infections (ST5), w/o asthma (ST7). See Table 2 for original Model 2;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &broad = 0;
run; quit;
%MEND; 
%x(ep10d_babx_0_23x,2,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn /*logn_ep14d_tier_0_23*/,racen); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,2,n2,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn /*logn_ep14d_tier_0_5*/,racen); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,2,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn /*logn_ep14d_tier_6_11*/,racen,ep10d_nabx_0_5x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,2,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn /*logn_ep14d_tier_12_23*/,racen,ep10d_nabx_0_11x);
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm /*asthma_ge2*/ ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Supplemental Table 8. Multivariable regression results for the association of any exposure to antibiotics
<24 months of age with BMI z-score score 48-<72 months of age, sensitivity analyses;

*Limited to participants with any well children visits <72 months of age N=280,590, 28,220;
*Limited to sites with =40% antibiotic prescribing rates before 24 months N=284,712, 47,496;
*Limited to participants without an antibiotic prescription linked to a Tier 1 diagnosis N=285,736, 44,382;

proc freq data = two; tables complex_dx_lt72m_ge2; run;
proc freq data = two; tables complex_dx_lt72m_ge2; where wellchild_ctx = 1; run;
proc freq data = two; tables complex_dx_lt72m_ge2; where lt40pct_abx = 0; run;
proc freq data = two; tables complex_dx_lt72m_ge2; where abx_tier1_7d_flag = 0; run;

*No complex chronic condition;
%macro s (stratc,strat,stratval);
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = no_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &strat = &stratval;
run; quit;
%MEND; 
%x(1,d1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,d2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn
   logn_ep14d_tier_0_23,racen);                                         
%MEND; 
%s('wellchild_ctx',wellchild_ctx,1); 
%s('lt40pct_abx',lt40pct_abx,0); 
%s('abx_tier1_7d_flag',abx_tier1_7d_flag,0); 

*Yes complex chronic condition;
%macro s (stratc,strat,stratval);
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 where &strat = &stratval;
run; quit;
%MEND; 
%x(1,d1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,d2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn
   logn_ep14d_tier_0_23,racen);                                         
%MEND; 
%s('wellchild_ctx',wellchild_ctx,1); 
%s('lt40pct_abx',lt40pct_abx,0); 
%s('abx_tier1_7d_flag',abx_tier1_7d_flag,0); 

*Supplemental Tables 9 and 10 - code in a different SAS program - includes maternal covariates:

*Supplement Table 9. Multivariable linear regression results for the association of antibiotics episodes
<24 months of age with BMI z-score 48-<72 months of age, by antibiotic spectrum, incorporating
maternal covariates for 7 healthcare institutions where available – data only for children without complex
chronic conditions

*Supplemental Table 10. Multivariable linear regression results for the association of antibiotics episodes
<24 months of age with BMI z-score 48-<72 months of age, by antibiotic spectrum and number of
episodes, incorporating maternal covariates for 7 healthcare institutions where available – data only for
children without complex chronic conditions;

*Supplemental Table 11. Multivariable logistic regression results for the association of any exposure to
antibiotics <24 months of age and risk obesity (>=95th percentile) at 48-<72 months of age, by timing of
antibiotic prescription, comparison is to BMI <85th percentile;

proc freq data = two; tables BMI_ge95_lt85*complex_dx_lt72m_ge2; run;

*No complex chronic conditions, any and broad ABX;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge95_lt85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
run;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,t3,'ep10d_abx_0_5x',ep10d_abx_0_5x); 
%x(2,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x); 
%x(2,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);   

%x(1,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x); 
%x(2,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   

*Broad;
%x(1,b1,'ep10d_babx_0_23x',ep10d_babx_0_23x); 
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,b3,'ep10d_babx_0_5x',ep10d_babx_0_5x); 
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,b5,'ep10d_babx_6_11x',ep10d_babx_6_11x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);   

%x(1,b7,'ep10d_babx_12_23x',ep10d_babx_12_23x); 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 

*No complex chronic conditions, narrow ABX;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge95_lt85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 where &broad = 0;
run;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,1,n3,'ep10d_nabx_0_5x',ep10d_nabx_0_5x); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,1,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,1,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x); 
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Yes complex chronic conditions, any and broad ABX;
%macro x (mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge95_lt85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
run;
%MEND;
*Total;
%x(1,t1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,t2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,t3,'ep10d_abx_0_5x',ep10d_abx_0_5x); 
%x(2,t4,'ep10d_abx_0_5x',ep10d_abx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,t5,'ep10d_abx_6_11x',ep10d_abx_6_11x); 
%x(2,t6,'ep10d_abx_6_11x',ep10d_abx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_abx_0_5x);   

%x(1,t7,'ep10d_abx_12_23x',ep10d_abx_12_23x); 
%x(2,t8,'ep10d_abx_12_23x',ep10d_abx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_abx_0_11x);   

*Broad;
%x(1,b1,'ep10d_babx_0_23x',ep10d_babx_0_23x); 
%x(2,b2,'ep10d_babx_0_23x',ep10d_babx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);

%x(1,b3,'ep10d_babx_0_5x',ep10d_babx_0_5x); 
%x(2,b4,'ep10d_babx_0_5x',ep10d_babx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 hispanic_yn 
   logn_ep14d_tier_0_5,racen); 

%x(1,b5,'ep10d_babx_6_11x',ep10d_babx_6_11x); 
%x(2,b6,'ep10d_babx_6_11x',ep10d_babx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 hispanic_yn 
   logn_ep14d_tier_6_11,racen,ep10d_babx_0_5x);   

%x(1,b7,'ep10d_babx_12_23x',ep10d_babx_12_23x); 
%x(2,b8,'ep10d_babx_12_23x',ep10d_babx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 hispanic_yn 
   logn_ep14d_tier_12_23,racen,ep10d_babx_0_11x); 

*Yes complex chronic conditions, narrow ABX;
%macro x (broad,mv,outds,expc,exp,cont,cat,extra);
proc glimmix data = no_ccd noitprint NOCLPRINT;*exponentiate OR and 95% CI;
 class site &cat;
 model BMI_ge95_lt85 (descending) = &exp &cat &cont &extra /s dist=binary or cl;
 random site;
 where &broad = 0;
run;
%MEND; 
%x(ep10d_babx_0_23x,1,n1,'ep10d_nabx_0_23x',ep10d_nabx_0_23x); 
%x(ep10d_babx_0_23x,2,n2,'ep10d_nabx_0_23x',ep10d_nabx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 
  hispanic_yn logn_ep14d_tier_0_23,racen);

%x(ep10d_babx_0_5x,1,n3,'ep10d_nabx_0_5x',ep10d_nabx_0_5x); 
%x(ep10d_babx_0_5x,2,n4,'ep10d_nabx_0_5x',ep10d_nabx_0_5x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_5_c logn_enc1_0_5 
  hispanic_yn logn_ep14d_tier_0_5,racen);

%x(ep10d_babx_0_11x,1,n5,'ep10d_nabx_6_11x',ep10d_nabx_6_11x); 
%x(ep10d_babx_0_11x,2,n6,'ep10d_nabx_6_11x',ep10d_nabx_6_11x,female agem_5y preterm asthma_ge2 ep10d_steroids_6_11_c logn_enc1_6_11 
  hispanic_yn logn_ep14d_tier_6_11,racen,ep10d_nabx_0_5x);

%x(ep10d_babx_0_23x,1,n7,'ep10d_nabx_12_23x',ep10d_nabx_12_23x); 
%x(ep10d_babx_0_23x,2,n8,'ep10d_nabx_12_23x',ep10d_nabx_12_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_12_23_c logn_enc1_12_23 
  hispanic_yn logn_ep14d_tier_12_23,racen,ep10d_nabx_0_11x);

*Supplemental Table 12. Association of Covariates with BMI z-score 48-<72 months of age in Models
with infections included;

proc mixed data = no_ccd;
 class site racen;
 model bmiz_5y = ep10d_abx_0_23x female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 logn_ep14d_tier_0_23
 racen hispanic_yn /s cl;
 random site / type=simple;
 format racen racen.;
run; quit;

proc mixed data = yes_ccd;
 class site racen;
 model bmiz_5y = ep10d_abx_0_23x female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 logn_ep14d_tier_0_23
 racen hispanic_yn /s cl;
 random site / type=simple;
 format racen racen.;
run; quit;

*Supplemental Table 6. Multivariable regression results for the association of any exposure to antibiotics
<24 months of age with BMI z-score score 48-<72 months of age, by strata of number of infections <24
months of age;

%macro x (mv,outds,expc,exp,cont,cat,extra);
*proc mixed data = no_ccd;
proc mixed data = yes_ccd;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
 *where tier_0_23_3c = 1;*0-1;
 *where tier_0_23_3c = 2;*2-3;
 *where tier_0_23_3c = 3;*4+;
run; quit;
%MEND;
%x(1,d1,'ep10d_abx_0_23x',ep10d_abx_0_23x); 
%x(2,d2,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn
  logn_ep14d_tier_0_23,racen);
%x(3,d3,'ep10d_abx_0_23x',ep10d_abx_0_23x,female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn
  logn_ep14d_tier1_0_23,racen);

*We statistically assessed whether infections were an effect modifier of the association between
antibiotics and BMI z-score. To Model 2, we added interaction terms for infections (coded as continuous,
log transformed)* antibiotic use (yes vs. no), interaction p-values were <0.0001 and 0.0009 for children
without and with complex chronic conditions, respectively;

proc mixed data = no_ccd;
 class site racen;
 model bmiz_5y = ep10d_abx_0_23x female agem_5y preterm asthma_ge2 gt1_tier_0_23_c 
 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn logn_ep14d_tier1_0_23 racen 
 ep10d_abx_0_23x*logn_ep14d_tier_0_23/s cl;
 random site / type=simple;
run; quit;*interaction p-value = <.0001;

proc mixed data = yes_ccd;
 class site racen;
 model bmiz_5y = ep10d_abx_0_23x female agem_5y preterm asthma_ge2 gt1_tier_0_23_c 
 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn logn_ep14d_tier1_0_23 racen 
 ep10d_abx_0_23x*logn_ep14d_tier_0_23/s cl;
 random site / type=simple;
run; quit;*interaction p-value = 0.0009;

*Supplemental Table 4. Multivariable linear regression results for the association of antibiotics episodes
<24 months of age with BMI z-score 48-<72 months of age, by broad-spectrum antibiotic class (any of
this class of antibiotic vs. none of this class as reference);

%macro x (bclass);
data &bclass;
 set abx_lt24m_spectrum_dups;*can include >1 prescription/d;
 if &bclass = 1;
 keep patidx_site &bclass;
run;
proc sort nodupkey; by patidx_site; run;
%MEND; 
%x(cephalosporin_gen3); 
%x(pen_combo); 
%x(macrolide); 
%x(sulfa); 
%x(cephalosporin_gen12); 
data bclass;
 merge cephalosporin_gen3 pen_combo macrolide sulfa cephalosporin_gen12; 
 by patidx_site;
run;
proc sort nodupkey; by patidx_site; run;

data bclass_all;
 merge bclass two (in=a);
 by patidx_site;
 if a;
 array x (5) cephalosporin_gen3 pen_combo macrolide sulfa cephalosporin_gen12;
 array xx (5) cephalosporin_gen3x pen_combox macrolidex sulfax cephalosporin_gen12x;
 do i = 1 to 5;
 if x(i) = . then x(i) = 0;
 xx(i) = x(i);
 if xx(i) = 0 and ep10d_babx_0_23x = 1 then xx(i) = .;
 end;
run;

data no_ccdx;
 set bclass_all; 
 if complex_dx_lt72m_ge2 = 0;
run;

data yes_ccdx;
 set bclass_all; 
 if complex_dx_lt72m_ge2 = 1;
run;

proc freq data = bclass_all; 
 tables (cephalosporin_gen3 pen_combo macrolide sulfa cephalosporin_gen12)*complex_dx_lt72m_ge2;
run;

%macro x (mv,outds,expc,exp,cont,cat,extra);
*proc mixed data = no_ccdx;
proc mixed data = yes_ccdx;
 class site &cat;
 model bmiz_5y = &exp &cont &cat &extra /s cl;
 random site / type=simple;
run; quit;
%MEND;
%x(1,d1,'cephalosporin_gen3',cephalosporin_gen3); 
%x(1,d2,'pen_combo',pen_combo); 
%x(1,d3,'macrolide',macrolide); 
%x(1,d4,'sulfa',sulfa); 
%x(1,d5,'cephalosporin_gen12',cephalosporin_gen12);
%x(2,d6,'cephalosporin_gen3',cephalosporin_gen3,
   female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen); 
%x(2,d7,'pen_combo',pen_combo,
   female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen); 
%x(2,d8,'macrolide',macrolide,
   female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen); 
%x(2,d9,'sulfa',sulfa,
   female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen); 
%x(2,d10,'cephalosporin_gen12',cephalosporin_gen12,
   female agem_5y preterm asthma_ge2 ep10d_steroids_0_23_c logn_enc1_0_23 hispanic_yn 
   logn_ep14d_tier_0_23,racen);
