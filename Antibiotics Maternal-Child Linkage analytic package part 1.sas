*PCORnet_IJO_2019_GitHub_Part1_050819.sas;

*Heerman W, Daley M, Boone-Heinonen J, Rifas-Shiman SL, Bailey LC, Forrest C, 
Young J, Gillman M, Horgan C, Janicke D, Jenter C, Kharbanda E, Lunsford D, Messito MJ, Toh S, Block J. 
Maternal Antibiotic Use During Pregnancy and Childhood Obesity at Age Five Years. 
Int J Obes (Lond). 2019 Jan 22. doi: 10.1038/s41366-018-0316-6.;

*Part 1 - combine sites and prepare analysis datasets;

*Removed libnames and paths before uploading to GitHub;

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

%macro x (siten,ds,site);
data test_dups;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1demog;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 keep patidx_site; 
run;
proc sort; by patidx_site; run;
data &ds._test_dups;
 retain ct_dups;
 set test_dups;
 by patidx_site;
 if first.patidx_site then ct_dups = 1;
 else ct_dups = ct_dups + 1;
 if last.patidx_site;
 if ct_dups >1;
 keep patidx_site ct_dups;
run;
proc sort; by patidx_site; run;
%MEND;
%x(14,C5KPMA,'C5KPMA');*22 dups;
%x(15,C5KPNW,'C5KPNW');*5 dups;

*child demographic dataset;
%macro x (siten,ds,site);
data &ds._demog1;
 length patidx $64. site $6. patidx_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort1demog;
 patidx = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 linkidx_site = compress(linkidx||site);
 if sex = 'F' then female = 1; else if sex = 'M' then female = 0; drop sex;
run;
proc sort nodupkey; by patidx_site; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data demog1;
 set C2VAN_demog1
 C5HP_demog1
 C5KPCO_demog1
 C5KPMA_demog1
 C5KPNW_demog1
 C5KPWA_demog1
 C10ADV_demog1;
run;
proc sort nodupkey; by patidx_site; run;*0 dups;
proc sort nodupkey; by linkidx_site; run;*0 dups;

*mom demographic dataset;
%macro x (siten,ds,site);
data &ds._demog2;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2demog;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 bw_m = birth_wt;
 ga_m = gest_age;
 hisp_m = hispanic;
 race_m = race;
 age_m = AgeIndex;
 keep patidm_site linkidx_site bw_m ga_m hisp_m race_m age_m;
run;
proc sort nodupkey; by linkidx_site; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data demog2;
 set C2VAN_demog2
 C5HP_demog2
 C5KPCO_demog2
 C5KPMA_demog2
 C5KPNW_demog2
 C5KPWA_demog2
 C10ADV_demog2;
run;
proc sort nodupkey; by linkidx_site; run;*0 dups;

data demog12;
 merge demog1 (in=a) demog2 (in=b);
 by linkidx_site;
 if a and b;
 drop bw_m ga_m;*same in demog1 and demog2;
run;*137815;
proc sort data = demog12; by patidx_site; run;

*delete n=27 participants from analysis since we don't know which linkid to use;
data demog12; 
 merge demog12 (in=a) C5KPMA_test_dups (in=b) C5KPNW_test_dups (in=c);
 by patidx_site;
 if a;
 if b or c then delete;
run;*137815-27=137788;

*Child outcomes:
The primary outcome was child age and sex-specific BMIz
from 48 to <72 months (“age 5 years”), if multiple
measures were available, we chose the BMI-z value that
was closest to 60 months of age as the outcome measure.
We used standard CDC statistical macros to calculate BMIz
and percentiles using same-day heights and weights, we
excluded outlier BMI-z values that were >+8 or <-4, as is
recommended by the CDC. The secondary outcome
was overweight or obesity from 48 to <72 months, defined
as an age and sex-specific BMI = 85th percentile;

/*
%macro x (siten,ds,site);
data &ds._vital;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1vital;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=48 and age <72;
 if ht >0 or wt >0;*could be on different rows;
 *remove extreme BIV heights and weights before picking 1;
 if wt >250 then wt = .;*>250 lbs;
 if wt <20 then wt = .;*<20 lbs;
 if ht >84 then ht = .;*7 feet;
 if ht <24 then ht = .;*2 feet;
run;
data &ds._ht;
 set &ds._vital;
 if ht >0;
 keep patidx_site age age_order days_btw_rec ht;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;*same ID, age, age_order;
data &ds._wt;
 set &ds._vital;
 if wt >0;
 keep patidx_site age age_order days_btw_rec wt;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;*same ID, age, age_order;
data &ds._ht_wt;
 merge &ds._ht (in=a) &ds._wt (in=b);
 by patidx_site age age_order days_btw_rec;
 if a and b;*height and weight measured on same day;
 abs_5y = abs(60-age);
 keep patidx_site age age_order days_btw_rec ht wt abs_5y;
run;
proc sort; by patidx_site abs_5y; run;
proc sort nodupkey; by patidx_site; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');

data ht_wt;
 length patidx_site $70.;
 set C2VAN_ht_wt C5HP_ht_wt C5KPCO_ht_wt C5KPMA_ht_wt C5KPNW_ht_wt C5KPWA_ht_wt C10ADV_ht_wt;
 height = ht*2.54;*convert from inches to cm for CDC macro;
 weight = wt*0.453592;*convert from pounds to kgs for CDC macro;
 agemos = age;
 keep patidx_site height weight agemos;
run;
proc sort data = ht_wt nodupkey; by patidx_site; run;

data f.cdc_in;
 merge demog12 (in=a) ht_wt (in=b);
 by patidx_site;
 if a and b;
 recumbnt = 0;
 if female = 1 then sex = 2;
 else if female = 0 then sex = 1;*for CDC 1=male 2=female;
 keep patidx_site agemos height weight sex recumbnt;
run;

*CDC 2000 macro;
%let datalib='F:\PCORnet\Mom child aim\';*subdirectory for your existing dataset;
%let datain=cdc_in;*the name of your existing SAS dataset;
%let dataout=cdc_out;*the name of the dataset you wish to put the results into;
%let saspgm='F:\PCORnet\gc-calculate-BIV.sas';*subdirectory for the downloaded program gc-calculate-BIV.sas;
Libname mydata &datalib;
data _INDATA; set mydata.&datain;
%include &saspgm;
data mydata.&dataout; set _INDATA;
proc means; run;
*/

data cdc_out;
 set f.cdc_out;
 if bmiz >8 or bmiz <-4 then flag_bmi = 1; else flag_bmi = 0;
 if flag_bmi = 1 then delete;
 keep patidx_site agemos weight height BMI BMIPCT BMIZ;
run;
proc sort data = cdc_out nodupkey; by patidx_site; run;

*Complex chronic conditions 0-<72m:
We used the list of complex chronic conditions reported by Feudtner et al. 
To this we added some growth-related conditions, including hypothyroidism
and pituitary disorders, which could be related to antibiotics
and weight.;

%macro x (siten,ds,site);
data &ds._dxflags;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1dxflags;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if DX_group ne '';
 if age >=0 and age <72;
 keep patidx_site age age_order days_btw_rec DX_group;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec DX_group; run;*1/person/date/DX_group;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data dxflags;
 set C2VAN_dxflags C5HP_dxflags C5KPCO_dxflags C5KPMA_dxflags C5KPNW_dxflags C5KPWA_dxflags C10ADV_dxflags;
 complex_dx = 1;
 keep patidx_site complex_dx;
run;

*person-level count of complex chronic conditions 0-<72m;
proc sql;
 create table dxflags_n as
 select patidx_site, 
 sum(complex_dx) as complex_dx_lt72m_n
 from dxflags
 group by patidx_site;
quit;
proc sort data = dxflags_n nodupkey; by patidx_site; run;

*diagnosis data, de-duplicate same date and same DX_group
 not limited to <24 months because we use it for asthma and wellchild <72m;
%macro x (siten,ds,site);
data &ds._dx;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1dx;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0;
 if DX_group ne '';
 keep patidx_site age age_order days_btw_rec DX_group;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec DX_group; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data cohort1dx;
 set C2VAN_dx C5HP_dx C5KPCO_dx C5KPMA_dx C5KPNW_dx C5KPWA_dx C10ADV_dx;
run;

*Use hierarchy to assign 1 tier value per day 0-<24m, 1=most severe to 3=least severe
1 record/person/date;
data dx_tier123_lt24m;
 set cohort1dx;
 if age >=0 and age <24;*10/25/17;
 if DX_group = 'Tier1_DX' then tier = 1;
 else if DX_group = 'Tier2_DX' then tier = 2;
 else if DX_group = 'Tier3_DX' then tier = 3;
 else tier = 9;*not tier 1-2-3;
run;
proc sort data = dx_tier123_lt24m nodupkey; by patidx_site age age_order days_btw_rec tier; run;*order 1-2-3-9;
proc sort data = dx_tier123_lt24m nodupkey; by patidx_site age age_order days_btw_rec; run;*select lowest tier;

*encounter data 0-<24m
1 record/person/date. AV/ED/IP/EI trumps OA/OT;
%macro x (siten,ds,site);
data &ds._enc_lt24m;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1encounter;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 if ENC_TYPE in ('AV','ED','EI','IP') then ENC_TYPE_n = 1;
 else if ENC_TYPE in ('OA','OT') then ENC_TYPE_n = 2;
 else if ENC_TYPE in ('IS','NI','UN') then ENC_TYPE_n = 3;
 keep patidx_site age age_order days_btw_rec ENC_TYPE ENC_TYPE_n; 
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec ENC_TYPE_n; run;*used ENC_TYPE_n hierarchy;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data enc_lt24m;
 set C2VAN_enc_lt24m C5HP_enc_lt24m C5KPCO_enc_lt24m C5KPMA_enc_lt24m C5KPNW_enc_lt24m C5KPWA_enc_lt24m C10ADV_enc_lt24m;
run;

*Prescriptions 0-<24m;
%macro x (siten,ds,site);
data &ds._presc_lt24m;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1presc;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 RXNORM_CUI = compress(RXNORM_CUI);
 keep patidx_site age age_order days_btw_rec RXNORM_CUI rxnorm_cui_group;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec RXNORM_CUI; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data presc_lt24m; 
 set C2VAN_presc_lt24m C5HP_presc_lt24m C5KPCO_presc_lt24m C5KPMA_presc_lt24m C5KPNW_presc_lt24m C5KPWA_presc_lt24m C10ADV_presc_lt24m;
run;

data steroids_lt24m;
 set presc_lt24m;
 if rxnorm_cui_group = 'Corticosteroids_all';
 corticosteroids = 1;
 keep patidx_site age age_order days_btw_rec corticosteroids RXNORM_CUI;
run;
proc sort data = steroids_lt24m; by rxnorm_cui; run;

data steriods_jb;
 set fx.steriods_jb;
run;
proc sort data = steriods_jb nodupkey; by rxnorm_cui; run;

data steroids_lt24mx;
 merge steroids_lt24m (in=a) steriods_jb (in=b);
 by RXNORM_CUI;
 if a and b;
 if exclude_steriods = 0;
 keep patidx_site age age_order days_btw_rec corticosteroids;
run;
proc sort data = steroids_lt24mx nodupkey; by patidx_site age age_order days_btw_rec; run;

*Antibiotics <24m;
data abx_lt24m;
 set presc_lt24m;
 if rxnorm_cui_group = 'Antibiotics_all';
run;
proc sort data = abx_lt24m; by RXNORM_CUI; run;

*broad/narrow spectrum codebook;
data all_RXNORM_CUI;
 length RXNORM_CUI $32.;
 set fx.all_RXNORM_CUI;
run;
proc sort data = all_RXNORM_CUI nodupkey; by RXNORM_CUI; run;*734 unique RXNORM_CUI;

data abx_lt24m_spectrum;
 merge abx_lt24m (in=a) all_RXNORM_CUI (in=b);
 by RXNORM_CUI;
 if a and b;
 tot_abx = 1;
 if abx_category = 'Broad' then broad = 1;
 else if abx_category = 'Narrow' then narrow = 1;
run;

*de-dup if same day and same abx_category;
proc sort data = abx_lt24m_spectrum nodupkey; by patidx_site age age_order days_btw_rec abx_category; run;

*if broad and narrow on same date, call broad (broad before narrow);
proc sort data = abx_lt24m_spectrum nodupkey; by patidx_site age age_order days_btw_rec; run;

************************** put together person-level dataset, child variables **************************;

*person-level count of asthma dx 0-<72m;
data asthmax;
 set cohort1dx;
 if age <72;
 if DX_group = 'Asthma';
 keep patidx_site age age_order days_btw_rec;
run;
proc sort data = asthmax nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = asthmax; by patidx_site; run;
data asthma_ct;
 retain asthma_ct;
 set asthmax;
 by patidx_site;
 if first.patidx_site then asthma_ct = 1;
 else asthma_ct = asthma_ct + 1;
 if last.patidx_site;
 keep patidx_site asthma_ct;
run;
proc sort data = asthma_ct nodupkey; by patidx_site; run;

*person-level count of wellchild dx 0-<72m;
data wellchild;
 set cohort1dx;
 if age <72;
 if DX_group = 'Wellchild_dx';
 keep patidx_site age age_order days_btw_rec;
run;
proc sort data = wellchild nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = wellchild; by patidx_site; run;
data wellchild_ct;
 retain wellchild_ct;
 set wellchild;
 by patidx_site;
 if first.patidx_site then wellchild_ct = 1;
 else wellchild_ct = wellchild_ct + 1;
 if last.patidx_site;
 keep patidx_site wellchild_ct;
run;
proc sort data = wellchild_ct nodupkey; by patidx_site; run;

*person-level any preterm dx 0-<24m;
data preterm;
 set cohort1dx;
 if age <24;
 if DX_group = 'Preterm';
 preterm = 1;
 keep patidx_site preterm;
run;
proc sort data = preterm nodupkey; by patidx_site; run;

*Count of encounters 0-<24m;
data count_enc;
 set enc_lt24m;
 if ENC_TYPE_n = 1 then ENC_TYPE_1 = 1;
 else if ENC_TYPE_n = 2 then ENC_TYPE_2 = 1;
 else if ENC_TYPE_n = 3 then ENC_TYPE_3 = 1;
 keep patidx_site age ENC_TYPE_1 ENC_TYPE_2 ENC_TYPE_3;
run;
%macro x (ds1,ds2,lowage,highage,ENC_TYPE_1_n,ENC_TYPE_2_n,ENC_TYPE_3_n);
data &ds1;
 set count_enc;
 if age >=&lowage and age <=&highage;
run;
proc sql;
 create table &ds2 as
 select patidx_site, 
 sum(ENC_TYPE_1) as &ENC_TYPE_1_n,
 sum(ENC_TYPE_2) as &ENC_TYPE_2_n,
 sum(ENC_TYPE_3) as &ENC_TYPE_3_n
 from &ds1
 group by patidx_site;
quit;
proc sort data = &ds2 nodupkey; by patidx_site; run;
%MEND;
%x(enc_0_23,encn_0_23,0,23,n_enc1_0_23,n_enc2_0_23,n_enc3_0_23);

data person_level;
 merge demog12 (in=a) cdc_out (in=b) dxflags_n
 asthma_ct wellchild_ct preterm encn_0_23;
 by patidx_site;
 *if a and b;*submitted;
 if a;*R&R not limited to participants with 5y outcome data, to compare included v. excluded;

 *value racen 
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
 *value racenx 
	2 = 'Asian'
	3 = 'Black or African American'
	5 = 'White'
	8 = 'Other'
	9 = 'Unknown';
 if race in ('UN','NI','07','10') then racen = 9;
 else if race in ('01','04','06','08','OT') then racen = 8;
 else if race = '02' then racen = 2;
 else if race = '03' then racen = 3;
 else if race = '05' then racen = 5;

 if HISPANIC = 'Y' then hispanicn = 1;
 else hispanicn = 0;*no + unknown;

 *mom demographics;
 if race_m in ('UN','NI','07','10') then race_mom_n = 9;
 else if race_m in ('01','04','06','08','OT') then race_mom_n = 8;
 else if race_m = '02' then race_mom_n = 2;
 else if race_m = '03' then race_mom_n = 3;
 else if race_m = '05' then race_mom_n = 5;

 if hisp_m = 'Y' then hisp_mom_n = 1;
 else hisp_mom_n = 0;*no + unknown;

 racenx = racen;
 if racenx = 9 then racenx = race_mom_n;*use mom if child unknown;

 *rename to clarify that these are 5y variables;
 agem_5y = agemos;
 weight_5y = weight;
 height_5y = height;
 bmi_5y = bmi;
 bmiz_5y = bmiz;
 bmipct_5y = bmipct;
 drop agemos height weight bmi bmiz bmipct;

 *dichotomous BMI >=85th v. <85th %tile;
 if bmipct_5y >=85 then BMI_ge85_5y = 1; else if bmipct_5y >. then BMI_ge85_5y = 0;

 *4-category BMI: <5th, 5-<85th, 85-<95th, >=95th %tile;
 if bmipct_5y >=95 then bmic_5y = 3;
 else if bmipct_5y >=85 then bmic_5y = 2;
 else if bmipct_5y >=5 then bmic_5y = 1;
 else if bmipct_5y >. then bmic_5y = 0;

 *main analysis stratified by >=2 complex chronic conditions <72m;
 if complex_dx_lt72m_n >=2 then complex_dx_lt72m_ge2 = 1;
 else complex_dx_lt72m_ge2 = 0;

 *covariate >=2 asthma codes <72m;
 if asthma_ct >=2 then asthma_ge2 = 1;
 else asthma_ge2 = 0;

 array x (3) preterm wellchild_ct n_enc1_0_23;
 do i = 1 to 3;
 if x(i) = . then x(i) = 0;
 end;

 *add a small value so that we can log transform count of encounters covariate;
 array l (1) n_enc1_0_23;
 array ll (1) n_enc1_0_23l;
 array lg (1) logn_enc1_0_23;
 do i = 1 to 1;
 ll(i) = l(i);
 if ll(i) = 0 then ll(i) = 0.05;
 lg(i) = log(ll(i));
 end;
 drop n_enc1_0_23l;

 if site = 'C5HP' then gest_age = gest_age*7;*units are weeks, change to days;
 if site = 'C5KPCO' then BIRTH_WT = BIRTH_WT*28.3;*units are ounces, change to grams;

 if gest_age ne . and gest_age <140 then gest_age_lt_20w = 1;*20w*7=140;
 if gest_age >300 then gest_age_gt_10m = 1;*10m*30=300;
 gest_agex = gest_age;
 if gest_age_lt_20w = 1 or gest_age_gt_10m = 1 then gest_agex = .;
 gest_agex_weeks = gest_agex/7;

 *bw is in gm. 1 lb = 454 gm. 2 lbs = 908 gm, 14 lbs = 6356 gm;
 if BIRTH_WT ne . and BIRTH_WT <908 then BIRTH_WT_lt908 = 1;
 if BIRTH_WT >6356 then BIRTH_WT_gt6356 = 1;
 BIRTH_WTx = BIRTH_WT;
 if BIRTH_WT_lt908 = 1 or BIRTH_WT_gt6356 = 1 then BIRTH_WTx = .;

 if age_m = 0 then age_m = .;*1 value;

run;*73475 original, 137788 R&R;

*To derive fake dates 0-<24m anchored at 1/1/2000:
String together all records (encounters, vitals, prescriptions, dispensings,dxflags,dx).
Derive 10 day abx episodes
Derive 10 day corticosteriod episodes(2 versions)
Derive 14 day infection episodes (any tier)
“Age” is month of age as an integer.
“Age_order” is the order of the encounters within the month of age.
“Days_btw_rec” the days since the previous encounter
enc_lt24m
vitals_lt24m_date
presc_lt24m
disp_lt24m_dates
dxflags_lt24m_dates
dx_lt24m_dates;

%macro x (siten,ds,site);
data &ds._vital;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1vital;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data vitals_lt24m_date;
 set C2VAN_vital C5HP_vital C5KPCO_vital C5KPMA_vital C5KPNW_vital C5KPWA_vital C10ADV_vital;
run;

*Dispensings 0-<24m;
%macro x (siten,ds,site);
data &ds._disp_lt24m;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1disp;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(5,C2VAN,'C2VAN');*no data, the rest have dispensing data;
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data disp_lt24m_dates; 
 set C2VAN_disp_lt24m C5HP_disp_lt24m C5KPCO_disp_lt24m C5KPMA_disp_lt24m C5KPNW_disp_lt24m C5KPWA_disp_lt24m C10ADV_disp_lt24m;
run;

*dxflags;
%macro x (siten,ds,site);
data &ds._dxflags;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1dxflags;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data dxflags_lt24m_dates;
 set C2VAN_dxflags C5HP_dxflags C5KPCO_dxflags C5KPMA_dxflags C5KPNW_dxflags C5KPWA_dxflags C10ADV_dxflags;
run;

*diagnosis data;
%macro x (siten,ds,site);
data &ds._dx;
 length patidx $64. site $6. patidx_site $70.;
 set &ds..r01_cohort1dx;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data dx_lt24m_dates;
 set C2VAN_dx C5HP_dx C5KPCO_dx C5KPMA_dx C5KPNW_dx C5KPWA_dx C10ADV_dx;
run;

proc sort data = enc_lt24m nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = vitals_lt24m_date nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = presc_lt24m nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = disp_lt24m_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = dxflags_lt24m_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = dx_lt24m_dates nodupkey; by patidx_site age age_order days_btw_rec; run;

data all_dates;
 merge enc_lt24m vitals_lt24m_date presc_lt24m disp_lt24m_dates dxflags_lt24m_dates dx_lt24m_dates;
 by patidx_site age age_order days_btw_rec;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort data = all_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = all_dates; by patidx_site; run;

data analysis_sample;*R&R, not limited to +5y oc;
 set person_level; 
 keep patidx_site site;
run;
proc sort data = analysis_sample nodupkey; by patidx_site; run;

data all_dates_sample;
 merge analysis_sample (in=a) all_dates (in=b);
 by patidx_site;
 if a and b;
run;
proc sort data = all_dates_sample; by patidx_site; run;

*derive fake date, anchored at 1/1/2000;
data all_dates_samplex;
 retain date_ID_ct;
 set all_dates_sample;
 by patidx_site;
 if first.patidx_site then date_ID_ct = mdy(01,01,2000);
 else date_ID_ct = date_ID_ct +  days_btw_rec;
 format date_ID_ct mmddyy8.;
run;

*add fake dates to abx_lt24m_spectrum, steroids_oral, dx_tier123.
R&R, not limited to +5y oc;;
data abx1;
 merge analysis_sample (in=a) abx_lt24m_spectrum (in=b);
 by patidx_site;
 if a and b;
run;

data dx1;
 merge analysis_sample (in=a) dx_tier123_lt24m (in=b);
 by patidx_site;
 if a and b;
run;

data steroids1;
 merge analysis_sample (in=a) steroids_lt24mx (in=b);
 by patidx_site;
 if a and b;
run;

proc sort data = all_dates_samplex nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = abx1 nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = dx1 nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = steroids1 nodupkey; by patidx_site age age_order days_btw_rec; run;

data abx_date;
 merge all_dates_samplex (in=a) abx1 (in=b);
 by patidx_site age age_order days_btw_rec; 
 if a and b;*100%;
 abx_date = date_ID_ct; drop date_ID_ct;
 format abx_date mmddyy8.;
run;

data dx_date;
 merge all_dates_samplex (in=a) dx1 (in=b);
 by patidx_site age age_order days_btw_rec; 
 if a and b;*100%;
 dx_date = date_ID_ct; drop date_ID_ct;
 format dx_date mmddyy8.;
run;

data steroids_date;
 merge all_dates_samplex (in=a) steroids1 (in=b);
 by patidx_site age age_order days_btw_rec; 
 if a and b;*100%;
 steroids_date = date_ID_ct; drop date_ID_ct;
 format steroids_date mmddyy8.;
run;

*********************** link abx and dx, choose closest within 7d before abx ***********************;

proc sql;
 create table abx_dx_7d as 
 select *
 from dx_date v , abx_date p
 where (v.patidx_site = p.patidx_site) and
 (0 <= p.abx_date - v.dx_date <=7);
quit;
proc sort data = abx_dx_7d; by patidx_site abx_date descending dx_date; run;
proc sort data = abx_dx_7d nodupkey; by patidx_site abx_date; run;

*********************** flag for sensitivity analysis: any abx linked to a tier 1 dx ***********************;

data abx_tier1_7d_flag;
 set abx_dx_7d;
 if tier = 1;
 abx_tier1_7d_flag = 1;
 keep patidx_site abx_tier1_7d_flag;
run;
proc sort data = abx_tier1_7d_flag nodupkey; by patidx_site; run;

*********************** derive 10d abx episodes ***********************;

proc sort data = abx_date nodupkey; by patidx_site abx_date; run;

*Total;
%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set abx_date;
 if age >=&lowage and age <=&highage;
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by patidx_site abx_date;
 lag_abx_date = lag (abx_date);
 if first.patidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if abx_date - lag_abx_date >10 then &ep10d = &ep10d + 1;
 if abx_date - lag_abx_date >0 then &script = &script + 1;
 end;
 if last.patidx_site;
 keep patidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by patidx_site; run;
%MEND;
%x(abx_0_23,0,23,ep10d_abx_0_23,script_abx_0_23);

*Broad;
%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set abx_date;
 if age >=&lowage and age <=&highage;
 if broad = 1;
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by patidx_site abx_date;
 lag_abx_date = lag (abx_date);
 if first.patidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if abx_date - lag_abx_date >10 then &ep10d = &ep10d + 1;
 if abx_date - lag_abx_date >0 then &script = &script + 1;
 end;
 if last.patidx_site;
 keep patidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by patidx_site; run;
%MEND;
%x(babx_0_23,0,23,ep10d_babx_0_23,script_babx_0_23);

*Narrow;
%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set abx_date;
 if age >=&lowage and age <=&highage;
 if narrow = 1;
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by patidx_site abx_date;
 lag_abx_date = lag (abx_date);
 if first.patidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if abx_date - lag_abx_date >10 then &ep10d = &ep10d + 1;
 if abx_date - lag_abx_date >0 then &script = &script + 1;
 end;
 if last.patidx_site;
 keep patidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by patidx_site; run;
%MEND;
%x(nabx_0_23,0,23,ep10d_nabx_0_23,script_nabx_0_23);

proc sort data = steroids_date nodupkey; by patidx_site steroids_date; run;

%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set steroids_date;
 if age >=&lowage and age <=&highage;
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by patidx_site steroids_date;
 lag_steroids_date = lag (steroids_date);
 if first.patidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if steroids_date - lag_steroids_date >10 then &ep10d = &ep10d + 1;
 if steroids_date - lag_steroids_date >0 then &script = &script + 1;
 end;
 if last.patidx_site;
 keep patidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by patidx_site; run;
%MEND;
%x(steroids_0_23,0,23,ep10d_steroids_0_23,script_steroids_0_23);

*derive 14d infection episodes (include any tier);
proc sort data = dx_date nodupkey; by patidx_site dx_date; run;

%macro x (ds,lowage,highage,ep14d,dx);
data &ds;
 set dx_date;
 if age >=&lowage and age <=&highage;
 if DX_group in ('Tier1_DX','Tier2_DX','Tier3_DX');
run;
data &ds;
 retain &ep14d &dx;
 set &ds;
 by patidx_site dx_date;
 lag_dx_date = lag (dx_date);
 if first.patidx_site then do;
 &ep14d = 1;
 &dx = 1;
 end;
 else do;
 if dx_date - lag_dx_date >14 then &ep14d = &ep14d + 1;
 if dx_date - lag_dx_date >0 then &dx = &dx + 1;
 end;
 if last.patidx_site;
 keep patidx_site &ep14d &dx;
run;
proc sort data = &ds nodupkey; by patidx_site; run;
%MEND;
%x(tier_0_23,0,23,ep14d_tier_0_23,dx_tier_0_23);

data person_level;
 merge person_level (in=a)
 abx_tier1_7d_flag abx_0_23 babx_0_23 nabx_0_23 steroids_0_23 tier_0_23;
 by patidx_site;
 if a;
 
 array x (11) 
 abx_tier1_7d_flag
 ep14d_tier_0_23 dx_tier_0_23
 ep10d_steroids_0_23 script_steroids_0_23  
 ep10d_abx_0_23 script_abx_0_23
 ep10d_babx_0_23 script_babx_0_23
 ep10d_nabx_0_23 script_nabx_0_23;
 do i = 1 to 11;
 if x(i) = . then x(i) = 0;
 end;

 array xx (5) ep14d_tier_0_23 ep10d_steroids_0_23 ep10d_abx_0_23 ep10d_babx_0_23 ep10d_nabx_0_23;
 array yy (5) ep14d_tier_0_23c ep10d_steroids_0_23c ep10d_abx_0_23c ep10d_babx_0_23c ep10d_nabx_0_23c;
 array zz (5) any_tier_0_23 any_steroids_0_23 any_abx_0_23 any_babx_0_23 any_nabx_0_23;
 do i = 1 to 5;
 yy(i) = xx(i);
 if yy(i) >=4 then yy(i) = 4;*4+;
 zz(i) = xx(i);
 if zz(i) >=1 then zz(i) = 1;*0/1;
 end;

run;

************************** mom variables **************************;

*Maternal prescriptions:
We created antibiotic episodes to define exposure during
pregnancy. We utilized episodes, encompassing all prescriptions
ordered within 10 days of a prior prescription
because prescribing records often do not have days’ supply
or end date, precluding a determination of the exact dose or
number of days for each individual prescription. If multiple
antibiotics were given during an episode, the episode was
defined as broad or narrow based on the broadest spectrum
antibiotic prescribed.
For capturing outpatient maternal exposures during
pregnancy, we defined pregnancy as 9 months (273 days)
prior to the index child’s date of birth. We also created
trimester-specific exposures (1st trimester as days 1–90, 2nd
trimester as days 91–181, 3rd trimester as days 182–273).
We used this definition for pregnancy because child gestational
age was not included in the PCORnet CDM and was
not available on all children.
Our main-independent variable was outpatient maternal
antibiotic prescriptions during pregnancy, defined as any
versus no antibiotic prescription. To further assess for a
dose response to antibiotics, we created a categorical count
of antibiotic episodes (0 to 4+). We also separately examined
narrow (amoxicillin, penicillin, and dicloxacillin) and
broad-spectrum exposures, including the most-commonly
prescribed classes of broad-spectrum antibiotics—penicillin
combinations (i.e., amoxicillin/clavulanic acid), 1st/2nd
generation cephalosporins, 3rd generation cephalosporins,
sulfa drugs, nitrofurans, and macrolides.;

%macro x (siten,ds,site);
data &ds._mom_presc;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2presc;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 RXNORM_CUI = compress(RXNORM_CUI);
 keep site patidm_site linkidx_site
 RXNORM_CUI rxnorm_cui_group rel_rx_start_date;
run;
proc sort nodupkey; by linkidx_site rel_rx_start_date RXNORM_CUI; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data mom_presc; 
 set C2VAN_mom_presc C5HP_mom_presc C5KPCO_mom_presc C5KPMA_mom_presc C5KPNW_mom_presc C5KPWA_mom_presc C10ADV_mom_presc;
run;

*mom antibiotics during pregnancy: 9*30.4=273;
data mom_abx_preg;
 set mom_presc;
 if rxnorm_cui_group = 'Antibiotics_all';
 if rel_rx_start_date ne . and rel_rx_start_date >=-273 and rel_rx_start_date <=0;*rel_rx_start_date is delivery date/child DOB;
 mom_abx_273d = 1;
 keep patidm_site linkidx_site rel_rx_start_date mom_abx_273d RXNORM_CUI;
run;
proc sort data = mom_abx_preg; by RXNORM_CUI; run;

*broad/narrow spectrum codebook from Jason Block (Aim 1);
data all_RXNORM_CUI;
 length RXNORM_CUI $32.;
 set fx.all_RXNORM_CUI;
run;
proc sort data = all_RXNORM_CUI nodupkey; by RXNORM_CUI; run;*734 unique RXNORM_CUI;

data ABX_codes_mom; 
 set f.ABX_codes_mom;
 keep RXNORM_CUI abx_category class;
run;
proc sort nodupkey; by RXNORM_CUI; run;*53 unique RXNORM_CUI;

data abx_codes_all;
 set all_RXNORM_CUI ABX_codes_mom;
run;
proc sort nodupkey; by RXNORM_CUI; run;*734 (Aim 1) + 53 (new) = 787 unique RXNORM_CUI;

data mom_abx_pregx;
 merge mom_abx_preg (in=a) abx_codes_all (in=b);
 by RXNORM_CUI;
 if a and b;

 if abx_category = 'Broad' then do;
    if class = '2nd Gen Cephalosporin' then cephalosporin_gen12 = 1;
    else if class = '3rd Gen Cephalosporin' then cephalosporin_gen3 = 1;
    else if class in ('Sulfa','Sulfone') then sulfa = 1;
    else if class = 'Nitrofurans' then nitrofurans = 1;
    else if class = 'Macrolide' then macrolide = 1;
    else if class = 'Penicillin Combination' then pen_combo = 1;

	else if abx_class in ('1st Gen Cephalosporin', '2nd Gen Cephalosporin') then cephalosporin_gen12 = 1;
	else if abx_class = '3rd Gen Cephalosporin' then cephalosporin_gen3 = 1;
	else if abx_class in ('Sulfa','Sulfone') then sulfa = 1; 
    else if abx_class = 'Nitrofurans' then nitrofurans = 1; 
    else if abx_class in ('Macrolide','PenMacro') then macrolide = 1;
    else if abx_class = 'Penicillin Combination' then pen_combo = 1;
	else if abx_class in ('Penicillin','penicillin') then pen_and_broad = 1;
 end;

run;*53922;

*de-dup if same day and same abx_category;
proc sort data = mom_abx_pregx nodupkey; by linkidx_site rel_rx_start_date abx_category; run;

*if broad and narrow on same date, call broad (broad before narrow);
proc sort data = mom_abx_pregx nodupkey; by linkidx_site rel_rx_start_date; run;

*any broad spectrum 6 (7 with pen_and_broad) classes during pregnancy;
%macro x (ds);
data &ds;
 set mom_abx_pregx;
 if rel_rx_start_date >=-273 and rel_rx_start_date <=0;
 if &ds = 1;
 keep linkidx_site &ds;
run; 
proc sort data = &ds nodupkey; by linkidx_site; run;
%MEND;
%x(cephalosporin_gen12);
%x(cephalosporin_gen3);
%x(sulfa);
%x(nitrofurans);
%x(macrolide);
%x(pen_combo);
%x(pen_and_broad);

*derive 0, 1, 2, 3, 4+ episodes. Combine 10d scripts into episodes;
*Total and trimester-specific;
%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set mom_abx_pregx;
 if rel_rx_start_date >=&lowage and rel_rx_start_date <=&highage;
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by linkidx_site rel_rx_start_date;
 lag_abx_date = lag (rel_rx_start_date);
 if first.linkidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if rel_rx_start_date - lag_abx_date >10 then &ep10d = &ep10d + 1;
 if rel_rx_start_date - lag_abx_date >0 then &script = &script + 1;
 end;
 if last.linkidx_site;
 keep linkidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by linkidx_site; run;
%MEND;
%x(ep10d_abx_mom_preg,-273,0,ep10d_abx_mom_preg,script_abx_mom_preg);
%x(ep10d_abx_mom_tri1,-273,-182,ep10d_abx_mom_tri1,script_abx_mom_tri1);
%x(ep10d_abx_mom_tri2,-181,-91,ep10d_abx_mom_tri2,script_abx_mom_tri2);
%x(ep10d_abx_mom_tri3,-90,0,ep10d_abx_mom_tri3,script_abx_mom_tri3);

%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set mom_abx_pregx;
 if rel_rx_start_date >=&lowage and rel_rx_start_date <=&highage;
 if abx_category = 'Broad';
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by linkidx_site rel_rx_start_date;
 lag_abx_date = lag (rel_rx_start_date);
 if first.linkidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if rel_rx_start_date - lag_abx_date >10 then &ep10d = &ep10d + 1;
 if rel_rx_start_date - lag_abx_date >0 then &script = &script + 1;
 end;
 if last.linkidx_site;
 keep linkidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by linkidx_site; run;
%MEND;
%x(ep10d_babx_mom_preg,-273,0,ep10d_babx_mom_preg,script_babx_mom_preg);
%x(ep10d_babx_mom_tri1,-273,-182,ep10d_babx_mom_tri1,script_babx_mom_tri1);
%x(ep10d_babx_mom_tri2,-181,-91,ep10d_babx_mom_tri2,script_babx_mom_tri2);
%x(ep10d_babx_mom_tri3,-90,0,ep10d_babx_mom_tri3,script_babx_mom_tri3);

%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set mom_abx_pregx;
 if rel_rx_start_date >=&lowage and rel_rx_start_date <=&highage;
 if abx_category = 'Narrow';
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by linkidx_site rel_rx_start_date;
 lag_abx_date = lag (rel_rx_start_date);
 if first.linkidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if rel_rx_start_date - lag_abx_date >10 then &ep10d = &ep10d + 1;
 if rel_rx_start_date - lag_abx_date >0 then &script = &script + 1;
 end;
 if last.linkidx_site;
 keep linkidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by linkidx_site; run;
%MEND;
%x(ep10d_nabx_mom_preg,-273,0,ep10d_nabx_mom_preg,script_nabx_mom_preg);
%x(ep10d_nabx_mom_tri1,-273,-182,ep10d_nabx_mom_tri1,script_nabx_mom_tri1);
%x(ep10d_nabx_mom_tri2,-181,-91,ep10d_nabx_mom_tri2,script_nabx_mom_tri2);
%x(ep10d_nabx_mom_tri3,-90,0,ep10d_nabx_mom_tri3,script_nabx_mom_tri3);

*Maternal covariates:
We extracted maternal age at delivery, pre-pregnancy BMI,
diagnoses of diabetes or gestational diabetes (GDM),
maternal smoking, method of delivery (cesarean vs. vaginal
delivery), and gestational weight gain.
To calculate maternal pre-pregnancy BMI (kg/m2), we
used any height that was available after age 18 and the
weight closest to the beginning of the defined pregnancy
period. We made use of any weight from 21 to 8 months
prior to delivery. We calculated total gestational weight gain
as the last weight during pregnancy (within 31 days before
delivery) minus pre-pregnancy weight.
We classified mothers as having diabetes if they met two
or more of the following pre-pregnancy criteria (during the
period 21 to 9 months before the child’s date of birth):
glycosylated hemoglobin (HbA1c) =6.5%, ICD-9 code for
diabetes, or receipt of any diabetes prescription. We classified
the mother as having GDM if she did not have type 1
or type 2 DM and she had an ICD-9 code for GDM during
pregnancy.
Smoking status was available in the CDM and was
defined according to the status recorded during the pregnancy
period, including never/former vs. active smoker. We
classified mothers as active smokers if they had any such
categorization during pregnancy. We captured delivery
method (cesarean vs. vaginal) using diagnostic codes and
Healthcare Common Procedure Coding System (HCPCS)
and Current Procedural Terminology (CPT) procedure
codes.;

*mom vitals:
From JB, cutoffs for biologically implausible values for weight, height, bmi for adults in weight cohort analysis:
Weight measurements >50lb and <700lb 
Height measurements >48in and <84in 
BMI measurements >15 and <90;
%macro x (siten,ds,site);
data &ds._mom_vital;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2vital;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 if wt >700 then wt = .;
 if wt <50 then wt = .;
 if ht <48 then ht = .;
 if ht >84 then ht = .;
 ht_m = ht * 0.0254;
 wt_kg = wt * 0.453592;
 keep site patidm_site linkidx_site rel_measure_date ht_m wt_kg smoking tobacco tobacco_type;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data mom_vital; 
 set C2VAN_mom_vital C5HP_mom_vital C5KPCO_mom_vital C5KPMA_mom_vital C5KPNW_mom_vital C5KPWA_mom_vital C10ADV_mom_vital;
run;

data mom_smk_preg;
 set mom_vital;

 if rel_measure_date ne . and rel_measure_date >=-273 and rel_measure_date <=0;
 any_vitals_273d = 1;

 smokingx = smoking;
 if smokingx in ('UN','OT','NI') then smokingx = '09';

 tobaccox = tobacco;
 if tobaccox in ('UN','OT','NI') then tobaccox = '09';

 tobacco_typex = tobacco_type;
 if tobacco_typex in ('UN','OT','NI') then tobacco_typex = '09';

 smokingn = smokingx*1;
 tobaccon = tobaccox*1;
 tobacco_typen = tobacco_typex*1;

 *value smoking
 1 = 'Current every day smoker'
 2 = 'Current some day smoker' 
 3 = 'Former smoker' 
 4 = 'Never smoker'
 5 = 'Smoker, current status unknown'
 6 = 'Unknown if ever smoked' 
 7 = 'Heavy tobacco smoker' 
 8 = 'Light tobacco smoker' 
 9 = 'Other/DK';
 if smokingn in (1,2,5,7,8) then smk_273d = 3;*smoked during pregnancy;
 else if smokingn = 3 then smk_273d = 2;*former;
 else if smokingn = 4 then smk_273d = 1;*never;
 else if smokingn in (6,9) then smk_273d = -9;

 *value tobacco
 1 = 'Current user' 
 2 = 'Never' 
 3 = 'Quit/former user'
 4 = 'Passive or environmental exposure'
 6 = 'Not asked'
 9 = 'Other/DK';
 if tobaccon = 1 then tobac_273d = 3;*tobacco during pregnancy;
 else if tobaccon = 3 then tobac_273d = 2;*former;
 else if tobaccon in (2,4,5) then tobac_273d = 1;*never, 4=passive exp, 5=???;
 else if tobaccon in (6,9) then tobac_273d = -9;

 *value smk
 1 = 'Never'
 2 = 'Former' 
 3 = 'During pregnancy' 
 -9 = 'Other/DK';
 smk_tobac_273d = max(smk_273d,tobac_273d);*max of the 2 variables;

 keep patidm_site linkidx_site smk_tobac_273d any_vitals_273d;
run;
proc sort data = mom_smk_preg; by linkidx_site descending smk_tobac_273d; run;*pick highest smoking value;
proc sort data = mom_smk_preg nodupkey; by linkidx_site; run;

data wt_prepreg_kg;
 set mom_vital;
 if wt_kg ne .;
 if rel_measure_date ne . and rel_measure_date <=-273+30;*allowed 1st month of pregnancy;
 abs_LMP_date = abs(-273-rel_measure_date);
 wt_prepreg_kg = wt_kg;
 keep patidm_site linkidx_site rel_measure_date wt_prepreg_kg abs_LMP_date;
run;
proc sort data = wt_prepreg_kg; by linkidx_site abs_LMP_date; run;
proc sort nodupkey data = wt_prepreg_kg; by linkidx_site; run;

data ht_m;
 set mom_vital;
 if ht_m ne .;
 abs_LMP_date = abs(-273-rel_measure_date);*any height, closest to 273 days before delivery;
 keep patidm_site linkidx_site abs_LMP_date ht_m;
run;
proc sort data = ht_m; by linkidx_site abs_LMP_date; run;
proc sort nodupkey data = ht_m; by linkidx_site; run;

data last_wt_preg_kg;
 set mom_vital;
 if wt_kg ne .;
 if rel_measure_date ne . and rel_measure_date >=-31 and rel_measure_date <=0;*last month of pregnancy;
 last_wt_preg_kg = wt_kg;
 keep patidm_site linkidx_site rel_measure_date last_wt_preg_kg;
run;
proc sort data = last_wt_preg_kg; by linkidx_site descending rel_measure_date; run;
proc sort nodupkey data = last_wt_preg_kg; by linkidx_site; run;

data mom_gwg_ppbmi;
 merge wt_prepreg_kg ht_m last_wt_preg_kg;
 by linkidx_site;
 bmi_prepreg = wt_prepreg_kg/(ht_m*ht_m);
 gwg_kg = last_wt_preg_kg - wt_prepreg_kg;
 keep patidm_site linkidx_site bmi_prepreg wt_prepreg_kg last_wt_preg_kg gwg_kg;
run;
proc sort nodupkey; by linkidx_site; run;

*mom encounter data;
%macro x (siten,ds,site);
data &ds._mom_enc;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2encounter;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 keep site patidm_site linkidx_site rel_admit_date;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data any_mom_enc_data; 
 set C2VAN_mom_enc C5HP_mom_enc C5KPCO_mom_enc C5KPMA_mom_enc C5KPNW_mom_enc C5KPWA_mom_enc C10ADV_mom_enc;
 any_mom_enc_data = 1;
 keep linkidx_site any_mom_enc_data;
run;
proc sort nodupkey; by linkidx_site; run;

data any_mom_enc_preg_data; 
 set C2VAN_mom_enc C5HP_mom_enc C5KPCO_mom_enc C5KPMA_mom_enc C5KPNW_mom_enc C5KPWA_mom_enc C10ADV_mom_enc;
 if rel_admit_date ne . and rel_admit_date >=-273 and rel_admit_date <=0;
 any_mom_enc_preg_data = 1;
 keep linkidx_site any_mom_enc_preg_data;
run;
proc sort nodupkey; by linkidx_site; run;

*mode of delivery - I did not limit time window;

*PX;
%macro x (siten,ds,site);
data &ds._mom_px;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2px;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 keep site patidm_site linkidx_site LookUpName PX rel_admit_date rel_px_date;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data mom_px; 
 set C2VAN_mom_px C5HP_mom_px C5KPCO_mom_px C5KPMA_mom_px C5KPNW_mom_px C5KPWA_mom_px C10ADV_mom_px;
run;

data livebirth_px;
 set mom_px;
 if LookUpName = 'livebirth_px';
run;
proc sort data = livebirth_px; by PX; run;

data appendix_px;
 length PX $18.;
 set f.appendix_p;
 PX = compress(Code);
 if Mode_of_delivery_PX ne '';
 keep PX Mode_of_delivery_PX;
run;
proc sort data = appendix_px nodupkey; by PX; run;*39;

data cs_px;
 merge livebirth_px (in=a) appendix_px (in=b);
 by PX;
 if a and b;
 keep linkidx_site Mode_of_delivery_PX;
run;
proc sort data = cs_px; by linkidx_site Mode_of_delivery_PX; run;*Mode_of_delivery_PX (cs then vag);
proc sort data = cs_px nodupkey; by linkidx_site; run;*63357;

*delivery type from dx;
%macro x (siten,ds,site);
data &ds._mom_dx;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2dx;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 keep site patidm_site linkidx_site LookUpName DX DX_group rel_admit_date;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data mom_dx; 
 set C2VAN_mom_dx C5HP_mom_dx C5KPCO_mom_dx C5KPMA_mom_dx C5KPNW_mom_dx C5KPWA_mom_dx C10ADV_mom_dx;
run;

data livebirth_dx;
 set mom_dx;
 if LookUpName = 'livebirth_dx';
run;

data appendix_ox;
 length DX $18.;
 set f.appendix_o;
 DX = compress(code,'.');
 if Mode_of_delivery_DX ne '';
 keep DX Mode_of_delivery_DX;
run;
proc sort data = appendix_ox nodupkey; by DX; run;*24;
proc sort data = livebirth_dx; by DX; run;

data cs_dx;
 merge livebirth_dx (in=a) appendix_ox (in=b);
 by DX;
 if a and b;
run;
proc sort data = cs_dx; by linkidx_site Mode_of_delivery_DX; run;*Mode_of_delivery_DX (cs then vag);
proc sort data = cs_dx nodupkey; by linkidx_site; run;*58129;

********************** Derive GDM/DM **********************;

*diabetes prescriptions;
%macro x (siten,ds,site);
data &ds._mom_diab_presc;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2presc;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 RXNORM_CUI = compress(RXNORM_CUI);
 if rxnorm_cui_group = 'DIABETES_RN';
 keep site patidm_site linkidx_site
 RXNORM_CUI RAW_RX_MED_NAME rel_rx_start_date;
run;
proc sort nodupkey; by linkidx_site rel_rx_start_date RXNORM_CUI; run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data mom_diab_presc; 
 set C2VAN_mom_diab_presc C5HP_mom_diab_presc C5KPCO_mom_diab_presc C5KPMA_mom_diab_presc C5KPNW_mom_diab_presc C5KPWA_mom_diab_presc C10ADV_mom_diab_presc;
run;

data gdm_dm_rx;
 set f.gdm_dm_rx;
run;
proc sort nodupkey data = gdm_dm_rx; by RXNORM_CUI; run; 
proc sort data = mom_diab_presc; by RXNORM_CUI; run; 

data diab_rx_linked;
 length dm_rx_type $25.;
 merge mom_diab_presc (in=a) gdm_dm_rx (in=b);
 by RXNORM_CUI;
 if a and b;
 if delete = 'x' then delete;
 else if Insulins = 'x' then dm_rx_type = 'Insulin';
 else if Metformin = 'x' then dm_rx_type = 'Metformin';
 else if Sulfonylurea = 'x' then dm_rx_type = 'Sulfonylurea';
 else if Thiazolidinedione = 'x' then dm_rx_type = 'Thiazolidinedione';
 else if Other_Diabetes_Medication = 'x' then dm_rx_type = 'Other';
 keep site patidm_site linkidx_site rel_rx_start_date dm_rx_type;
run;

data diab_rx_9m_21m_lt_deliv;
 set diab_rx_linked;
 if rel_rx_start_date >=-634 and rel_rx_start_date <-273;
run;

%macro x (rx);
data &rx;
 set diab_rx_9m_21m_lt_deliv;
 if dm_rx_type = 'Insulin' then Insulin = 1;
 else if dm_rx_type = 'Metformin' then Metformin = 1;
 else if dm_rx_type = 'Sulfonylurea' then Sulfonylurea = 1;
 else if dm_rx_type = 'Thiazolidinedione' then Thiazolidinedione = 1;
 else if dm_rx_type = 'Other' then Other_dm_rx = 1;
 if &rx = 1;
 keep linkidx_site &rx;
run;
proc sort data = &rx nodupkey; by linkidx_site; run;
%MEND;
%x(Insulin); 
%x(Metformin); 
%x(Sulfonylurea); 
%x(Thiazolidinedione); 
%x(Other_dm_rx);

*lab - A1c_result;
%macro x (siten,ds,site);
data &ds._mom_diab_lab;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2lab;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 keep site patidm_site linkidx_site rel_result_date rel_specimen_date
 LAB_NAME LAB_LOINC LAB_PX LAB_PX_TYPE RESULT_QUAL RESULT_MODIFIER RESULT_NUM;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');

data mom_diab_lab; 
 set C2VAN_mom_diab_lab C5HP_mom_diab_lab C5KPCO_mom_diab_lab C5KPMA_mom_diab_lab C5KPNW_mom_diab_lab C5KPWA_mom_diab_lab C10ADV_mom_diab_lab;*25872;
 A1c_result = RESULT_NUM;
 if A1c_result >=74 and A1c_result <200 then A1c_result = A1c_result/10;
 if A1c_result >=200 then A1c_result = .;
 if A1c_result ne .;
 keep site patidm_site linkidx_site rel_result_date rel_specimen_date A1c_result; 
run;

data HbA1c_ge6p5;
 set mom_diab_lab;
 if rel_result_date >=-634 and rel_result_date <-273;
 if A1c_result >=6.5;
 HbA1c_ge6p5_9m_21m_lt_deliv = 1;
 keep linkidx_site HbA1c_ge6p5_9m_21m_lt_deliv;
run;
proc sort data = HbA1c_ge6p5 nodupkey; by linkidx_site; run;

*GDM px;
%macro x (siten,ds,site);
data &ds._mom_diab_px;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2px;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 if LookUpName = 'gdm_px';
 keep site patidm_site linkidx_site PX rel_admit_date rel_px_date;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data glu_tol_test; 
 set C2VAN_mom_diab_px C5HP_mom_diab_px C5KPCO_mom_diab_px C5KPMA_mom_diab_px C5KPNW_mom_diab_px C5KPWA_mom_diab_px C10ADV_mom_diab_px;
 if rel_px_date ne . and rel_px_date >=-273 and rel_px_date <=0;
 glu_tol_test = 1;
 keep linkidx_site glu_tol_test;
run;
proc sort data = glu_tol_test nodupkey; by linkidx_site; run;

*GDM/DM dx;
%macro x (siten,ds,site);
data &ds._mom_diab_dx;
 length patidm $64. site $6. patidm_site $70. linkidx $64. linkidx_site $70.;
 set &ds..r01_cohort2dx;
 patidm = compress(patid); drop patid;
 linkidx = compress(linkid); drop linkid;
 site = compress(&site);
 siten = &siten;
 patidm_site = compress(patidm||site);
 linkidx_site = compress(linkidx||site);
 if DX_group in ('Diabetes','Gest_Diabetes');
 keep site patidm_site linkidx_site DX_group DX rel_admit_date;
run;
%MEND;
%x(5,C2VAN,'C2VAN');
%x(12,C5HP,'C5HP');
%x(13,C5KPCO,'C5KPCO');
%x(14,C5KPMA,'C5KPMA');
%x(15,C5KPNW,'C5KPNW');
%x(29,C5KPWA,'C5KPWA');
%x(25,C10ADV,'C10ADV');
data mom_diab_dx; 
 set C2VAN_mom_diab_dx C5HP_mom_diab_dx C5KPCO_mom_diab_dx C5KPMA_mom_diab_dx C5KPNW_mom_diab_dx C5KPWA_mom_diab_dx C10ADV_mom_diab_dx;
run;

data appendix_mx;
 length DX $18.;
 set f.appendix_m;
 DX = compress(code,'.');
 keep DX Full_Description Code_Type;
run;
proc sort data = appendix_mx nodupkey; by DX; run;*44;

proc sort data = mom_diab_dx; by DX; run;

data mom_diab_dx1;
 merge mom_diab_dx (in=a) appendix_mx (in=b);
 by DX;
 if a;
 if a and b then linked = 1; else linked = 0;
 *1 = type 1, 2 = type 2, 3 = GDM, 9 = DK if T1 ot T2;
 if linked = 0 then do;
 if DX = '2500' then type_DM = 9;
 else if DX = '25000' then type_DM = 2;
 else if DX = '25001' then type_DM = 1;
 else if DX = '25002' then type_DM = 2;
 else if DX = '25003' then type_DM = 1;
 else if DX = '25010' then type_DM = 2;
 else if DX = '25011' then type_DM = 1;
 else if DX = '25012' then type_DM = 2;
 else if DX = '25013' then type_DM = 1;
 else if DX = '25020' then type_DM = 2;
 else if DX = '25021' then type_DM = 1;
 else if DX = '25022' then type_DM = 2;
 else if DX = '25023' then type_DM = 1;
 else if DX = '25031' then type_DM = 1;
 else if DX = '25033' then type_DM = 1;
 else if DX = '2504' then type_DM = 9;
 else if DX = '25040' then type_DM = 2;
 else if DX = '25041' then type_DM = 1;
 else if DX = '25042' then type_DM = 2;
 else if DX = '25043' then type_DM = 1;
 else if DX = '25050' then type_DM = 2;
 else if DX = '25051' then type_DM = 1;
 else if DX = '25052' then type_DM = 2;
 else if DX = '25053' then type_DM = 1;
 else if DX = '25060' then type_DM = 2;
 else if DX = '25061' then type_DM = 1;
 else if DX = '25062' then type_DM = 2;
 else if DX = '25063' then type_DM = 1;
 else if DX = '25070' then type_DM = 2;
 else if DX = '25071' then type_DM = 1;
 else if DX = '25073' then type_DM = 1;
 else if DX = '25080' then type_DM = 2;
 else if DX = '25081' then type_DM = 1;
 else if DX = '25082' then type_DM = 2;
 else if DX = '25083' then type_DM = 1;
 else if DX = '2509' then type_DM = 9;
 else if DX = '25090' then type_DM = 2;
 else if DX = '25091' then type_DM = 1;
 else if DX = '25092' then type_DM = 2;
 else if DX = '25093' then type_DM = 1;
 end;
 else if linked = 1 then do;
 if DX = '250' then type_DM = 9;
 else if DX = '3572' then type_DM = 9;
 else if DX = '36201' then type_DM = 9;
 else if DX = '36202' then type_DM = 9;
 else if DX = '36203' then type_DM = 9;
 else if DX = '36204' then type_DM = 9;
 else if DX = '36205' then type_DM = 9;
 else if DX = '36206' then type_DM = 9;
 else if DX = '36207' then type_DM = 9;
 else if DX = '36641' then type_DM = 9;
 else if DX = '6480' then type_DM = 9;
 else if DX = '64800' then type_DM = 9;
 else if DX = '64801' then type_DM = 9;
 else if DX = '64802' then type_DM = 9;
 else if DX = '64803' then type_DM = 9;
 else if DX = '64804' then type_DM = 9;
 else if DX = '6488' then type_DM = 3;
 else if DX = '64880' then type_DM = 3;
 else if DX = '64881' then type_DM = 3;
 else if DX = '64882' then type_DM = 3;
 else if DX = '64883' then type_DM = 3;
 else if DX = '64884' then type_DM = 3;
 end;
run;

data type12_dx;
 set mom_diab_dx1;
 if type_DM in (1,2,9);
 if rel_admit_date >=-634 and rel_admit_date <-273;
 type12_dx = 1;
 keep linkidx_site type12_dx;
run;
proc sort data = type12_dx nodupkey; by linkidx_site; run;

data gdm_dx;
 set mom_diab_dx1;
 if type_DM = 3;
 if rel_admit_date ne . and rel_admit_date >=-273 and rel_admit_date <=0;
 gdm_dx = 1;
 keep linkidx_site gdm_dx;
run;
proc sort data = gdm_dx nodupkey; by linkidx_site; run;

data gdm_dm;
 merge Insulin Metformin Sulfonylurea Thiazolidinedione Other_dm_rx
 HbA1c_ge6p5 glu_tol_test type12_dx gdm_dx;
 by linkidx_site;

 if Insulin = 1 or Metformin = 1 or Sulfonylurea = 1 or Thiazolidinedione = 1 or Other_dm_rx = 1 then any_dm_rx = 1;

 array x (10) Insulin Metformin Sulfonylurea Thiazolidinedione Other_dm_rx any_dm_rx
 HbA1c_ge6p5 glu_tol_test type12_dx gdm_dx;
 do i = 1 to 10;
 if x(i) = . then x(i) = 0;
 end;
 
 DM = 0;
 if Insulin = 1 or Sulfonylurea = 1 or Other_dm_rx = 1 then DM = 1;
 else if (Metformin = 1 or Thiazolidinedione = 1) and (type12_dx = 1 or HbA1c_ge6p5 = 1) then DM = 1;
 else if HbA1c_ge6p5 = 1 then DM = 1;

 DM_alt = sum(type12_dx,HbA1c_ge6p5,any_dm_rx);
 if DM_alt >1 then DM_alt = 1;

 GDM = 0;
 if gdm_dx = 1 and glu_tol_test = 1 then GDM = 1;

 GDM_alt = 0;
 if gdm_dx = 1 then GDM_alt = 1;
 keep linkidx_site DM DM_alt GDM GDM_alt;
run;
proc sort data = gdm_dm nodupkey; by linkidx_site; run;

************************** add maternal variables to person-level dataset **************************;

proc sort data = person_level nodupkey; by linkidx_site; run;

data person_levelx;
 merge person_level (in=a) mom_smk_preg mom_gwg_ppbmi 
 any_mom_enc_data any_mom_enc_preg_data cs_px cs_dx gdm_dm
 ep10d_abx_mom_preg ep10d_babx_mom_preg ep10d_nabx_mom_preg
 ep10d_abx_mom_tri1 ep10d_babx_mom_tri1 ep10d_nabx_mom_tri1
 ep10d_abx_mom_tri2 ep10d_babx_mom_tri2 ep10d_nabx_mom_tri2
 ep10d_abx_mom_tri3 ep10d_babx_mom_tri3 ep10d_nabx_mom_tri3
 cephalosporin_gen12 cephalosporin_gen3 sulfa nitrofurans macrolide pen_combo pen_and_broad; 
 by linkidx_site; 
 if a;

 array x (38) any_mom_enc_data any_mom_enc_preg_data any_vitals_273d
 ep10d_abx_mom_preg script_abx_mom_preg
 ep10d_babx_mom_preg script_babx_mom_preg
 ep10d_nabx_mom_preg script_nabx_mom_preg
 ep10d_abx_mom_tri1 script_abx_mom_tri1
 ep10d_babx_mom_tri1 script_babx_mom_tri1
 ep10d_nabx_mom_tri1 script_nabx_mom_tri1
 ep10d_abx_mom_tri2 script_abx_mom_tri2
 ep10d_babx_mom_tri2 script_babx_mom_tri2
 ep10d_nabx_mom_tri2 script_nabx_mom_tri2
 ep10d_abx_mom_tri3 script_abx_mom_tri3
 ep10d_babx_mom_tri3 script_babx_mom_tri3
 ep10d_nabx_mom_tri3 script_nabx_mom_tri3
 DM DM_alt GDM GDM_alt
 cephalosporin_gen12 cephalosporin_gen3 sulfa nitrofurans macrolide pen_combo pen_and_broad;
 do i = 1 to 38;
 if x(i) = . then x(i) = 0;
 end;

 if cephalosporin_gen12 = 1 or cephalosporin_gen3 = 1 or sulfa = 1 or nitrofurans = 1 or macrolide = 1 or pen_combo = 1
 then broad6 = 1;
 else broad6 = 0;

 if pen_combo = 1 or pen_and_broad = 1 then pen_combox = 1;
 else pen_combox = 0;

 GDMx = GDM;
 GDM_altx = GDM_alt;
 if DM = 1 or DM_alt = 1 then do;
 GDMx = 0;
 GDM_altx = 0;
 end; 

 if DM = 1 or DM_alt = 1 then glucose_status = 3;
 else if GDMx = 1 or GDM_altx = 1 then glucose_status = 2;
 else glucose_status = 1;

 array xx (12) ep10d_abx_mom_preg ep10d_babx_mom_preg ep10d_nabx_mom_preg
 ep10d_abx_mom_tri1 ep10d_babx_mom_tri1 ep10d_nabx_mom_tri1
 ep10d_abx_mom_tri2 ep10d_babx_mom_tri2 ep10d_nabx_mom_tri2
 ep10d_abx_mom_tri3 ep10d_babx_mom_tri3 ep10d_nabx_mom_tri3;
 array yy (12) ep10d_abx_mom_pregc ep10d_babx_mom_pregc ep10d_nabx_mom_pregc
 ep10d_abx_mom_tri1c ep10d_babx_mom_tri1c ep10d_nabx_mom_tri1c
 ep10d_abx_mom_tri2c ep10d_babx_mom_tri2c ep10d_nabx_mom_tri2c
 ep10d_abx_mom_tri3c ep10d_babx_mom_tri3c ep10d_nabx_mom_tri3c;
 array zz (12) any_abx_mom_preg any_babx_mom_preg any_nabx_mom_preg
 any_abx_mom_tri1 any_babx_mom_tri1 any_nabx_mom_tri1
 any_abx_mom_tri2 any_babx_mom_tri2 any_nabx_mom_tri2
 any_abx_mom_tri3 any_babx_mom_tri3 any_nabx_mom_tri3;
 do i = 1 to 12;
 yy(i) = xx(i);
 if yy(i) >=4 then yy(i) = 4;*4+;
 zz(i) = xx(i);
 if zz(i) >=1 then zz(i) = 1;*0/1;
 end;

 ep10d_nabx_mom_prgcx = ep10d_nabx_mom_pregc;
 if ep10d_nabx_mom_prgcx >2 then ep10d_nabx_mom_prgcx = 2;*truncate at 2+;

 if smk_tobac_273d in (.,-9) then smk_tobac_273d = 9;

 if Mode_of_delivery_PX = 'csection' or Mode_of_delivery_DX = 'csection' then csection = 1;
 else if Mode_of_delivery_PX = 'vaginal' or Mode_of_delivery_DX = 'vaginal' then csection = 0;
 else csection = 9;*don't know;
 if csection = 9 then csection = 0;
 
 if bmi_prepreg <15 then do;*n=8;
 bmi_prepreg = .; wt_prepreg_kg = .; last_wt_preg_kg = .; gwg_kg = .;
 end;

 if bmi_prepreg ne . then bmi_prepreg_not_missing = 1; else bmi_prepreg_not_missing = 0;

 if gwg_kg ne . then gwg_not_missing = 1; else gwg_not_missing = 0;

 if bmi_prepreg ne . and gwg_kg ne . then bmi_gwg_not_missing = 1; else bmi_gwg_not_missing = 0;

 if smk_tobac_273d = 3 then pregsmk = 1; else pregsmk = 0;*0 = never, former, missing;

 if any_abx_mom_preg = 0 and any_abx_0_23 = 0 then mc_abx = 1;
 else if any_abx_mom_preg = 1 and any_abx_0_23 = 0 then mc_abx = 2;
 else if any_abx_mom_preg = 0 and any_abx_0_23 = 1 then mc_abx = 3;
 else if any_abx_mom_preg = 1 and any_abx_0_23 = 1 then mc_abx = 4;

 if bmi_prepreg >=30 then mbmic = 3;
 else if bmi_prepreg >=25 then mbmic = 2;
 else if bmi_prepreg >. then mbmic = 1;

 if bmiz_5y ne . then y5 = 1; else y5 = 0;

run;*137788 (73475 with 5y BMI-z);

*save permanent dataset;
data rr.person_level_072418; set person_levelx; run;
