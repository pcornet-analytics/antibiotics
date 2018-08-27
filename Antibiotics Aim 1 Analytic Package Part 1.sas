*PCORnet_Peds_2018_GitHub_Part1_082418.sas;

*Pediatrics 2018 manuscript: 
 Early Life Antibiotic Use and Weight Outcomes in Children Ages 48 to <72 Months of Age;

*Part 1 - combine sites and prepare analysis datasets;

*Removed libnames and paths before uploading to GitHub;

********************** demographic data **********************;

%macro x (siten,ds,site,r);
data &ds._demog;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortdemog;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
run;
proc sort nodupkey; by patidx_site; run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data demog;
 length patidx $128. site $8. patidx_site $136.;
 set C9RU_demog
 C1BMC_demog 
 C1WF_demog      
 C2GWN_demog     
 C2UNC_demog     
 C2VAN_demog     
 C4MCRF_demog  
 C4MCW_demog 
 C4UI_demog      
 C4UT_demog      
 C5DH_demog      
 C5GH_demog      
 C5HP_demog      
 C5KPCO_demog    
 C5KPMA_demog    
 C5KPNW_demog    
 C6BAY_demog     
 C6OCH_demog     
 C6TUL_demog      
 C7CCHMC_demog   
 C8NYC_demog     
 C9LM_demog      
 C9NS_demog      
 C9UC_demog      
 C10ADV_demog
 C13OF_demog
 C9LC_demog
 C7CPED_demog;
 if sex = 'F' then female = 1; 
 else if sex = 'M' then female = 0;
 drop sex;
run;
proc sort data = demog nodupkey; by patidx_site; run;

********************** vitals data **********************;

*Keep 48-<72 months (5 years). Select visit closest to abs(60);
%macro x (siten,ds,site,r);
data &ds._vital;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortvital;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
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
proc sort data = &ds._ht_wt; by patidx_site abs_5y; run;
proc sort data = &ds._ht_wt nodupkey; by patidx_site; run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data ht_wt;
 length patidx_site $136.;
 set C9RU_ht_wt 
 C1BMC_ht_wt 
 C1WF_ht_wt      
 C2GWN_ht_wt     
 C2UNC_ht_wt     
 C2VAN_ht_wt     
 C4MCRF_ht_wt  
 C4MCW_ht_wt 
 C4UI_ht_wt      
 C4UT_ht_wt      
 C5DH_ht_wt      
 C5GH_ht_wt      
 C5HP_ht_wt      
 C5KPCO_ht_wt    
 C5KPMA_ht_wt    
 C5KPNW_ht_wt    
 C6BAY_ht_wt     
 C6OCH_ht_wt     
 C6TUL_ht_wt      
 C7CCHMC_ht_wt   
 C8NYC_ht_wt     
 C9LM_ht_wt      
 C9NS_ht_wt         
 C9UC_ht_wt      
 C10ADV_ht_wt
 C13OF_ht_wt
 C9LC_ht_wt
 C7CPED_ht_wt;
 height = ht*2.54;*convert from inches to cm for CDC macro;
 weight = wt*0.453592;*convert from pounds to kgs for CDC macro;
 agemos = age;
 keep patidx_site height weight agemos;
run;
proc sort data = ht_wt nodupkey; by patidx_site; run;

*save permanent dataset;
data f.cdc_in_5y;
 merge demog (in=a) ht_wt (in=b);
 by patidx_site;
 if a and b;
 recumbnt = 0;
 if female = 1 then sex = 2;
 else if female = 0 then sex = 1;*for CDC 1=male 2=female;
 keep patidx site siten patidx_site HISPANIC RACE agemos height weight sex recumbnt;
run;*363491 with 5y outcome data;

*CDC 2000 macro;
%let datalib='F:\PCORnet\Aim 1 ms\RR March 2018\';*subdirectory for your existing dataset;
%let datain=cdc_in_5y;*the name of your existing SAS dataset;
%let dataout=cdc_out_5y;*the name of the dataset you wish to put the results into;
%let saspgm='F:\PCORnet\gc-calculate-BIV.sas';*subdirectory for the downloaded program gc-calculate-BIV.sas;
Libname mydata &datalib;
data _INDATA; set mydata.&datain;
%include &saspgm;
data mydata.&dataout; set _INDATA;
proc means; run;

*save permanent dataset; 
data f.cdc_out_5y;
 set f.cdc_out_5y;
 if bmiz >8 or bmiz <-4 then flag_bmi = 1; else flag_bmi = 0;
 if flag_bmi = 1 then delete;
 keep patidx site siten patidx_site HISPANIC race sex agemos weight height BMI BMIPCT BMIZ;
run;
proc sort data = f.cdc_out_5y nodupkey; by patidx_site; run;*363491;

********************** complex chronic conditions data (<72m) **********************;

%macro x (siten,ds,site,r);
data &ds._cohortdxflags;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortdxflags;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if DX_group ne '';
 if age >=0 and age <72;
 keep patidx_site age age_order days_btw_rec DX_group;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec DX_group; run;*1/person/date/DX_group;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data dxflags_10_lt72m;
 length patidx_site $136.;
 set C9RU_cohortdxflags 
 C1BMC_cohortdxflags
 C1WF_cohortdxflags
 C2GWN_cohortdxflags
 C2UNC_cohortdxflags
 C2VAN_cohortdxflags
 C4MCRF_cohortdxflags
 C4MCW_cohortdxflags
 C4UI_cohortdxflags
 C4UT_cohortdxflags
 C5DH_cohortdxflags
 C5GH_cohortdxflags
 C5HP_cohortdxflags
 C5KPCO_cohortdxflags
 C5KPMA_cohortdxflags
 C5KPNW_cohortdxflags
 C6BAY_cohortdxflags
 C6OCH_cohortdxflags
 C6TUL_cohortdxflags
 C7CCHMC_cohortdxflags
 C8NYC_cohortdxflags
 C9LM_cohortdxflags
 C9NS_cohortdxflags
 C9UC_cohortdxflags
 C10ADV_cohortdxflags
 C13OF_cohortdxflags
 C9LC_cohortdxflags
 C7CPED_cohortdxflags;
 if DX_group = 'Cardiovascular' then Cardiovascular = 1;
 else if DX_group = 'Gastrointestinal' then Gastrointestinal = 1; 
 else if DX_group = 'Growth Cond' then Growth_Cond = 1; 
 else if DX_group = 'Hemato Immuno' then Hemato_Immuno = 1; 
 else if DX_group = 'Malignant Neoplasms' then Malignant_Neoplasms = 1; 
 else if DX_group = 'Metabolic' then Metabolic = 1; 
 else if DX_group = 'Neuromuscular' then Neuromuscular = 1; 
 else if DX_group = 'Other defect' then Other_defect = 1; 
 else if DX_group = 'Renal' then Renal = 1;
 else if DX_group = 'Respiratory' then Respiratory = 1; 
 complex_dx = 1;
 keep patidx_site age 
 complex_dx Cardiovascular Gastrointestinal Growth_Cond Hemato_Immuno Malignant_Neoplasms 
 Metabolic Neuromuscular Other_defect Renal Respiratory;
run;

proc sql;
 create table dxflags_10_lt72m_n as
 select patidx_site, 
 sum(Cardiovascular) as Cardiovascular_lt72m_n,
 sum(Gastrointestinal) as Gastrointestinal_lt72m_n,
 sum(Growth_Cond) as Growth_Cond_lt72m_n, 
 sum(Hemato_Immuno) as Hemato_Immuno_lt72m_n, 
 sum(Malignant_Neoplasms) as Malignant_Neoplasms_lt72m_n, 
 sum(Metabolic) as Metabolic_lt72m_n, 
 sum(Neuromuscular) as Neuromuscular_lt72m_n, 
 sum(Other_defect) as Other_defect_lt72m_n, 
 sum(Renal) as Renal_lt72m_n, 
 sum(Respiratory) as Respiratory_lt72m_n,
 sum(complex_dx) as complex_dx_lt72m_n
 from dxflags_10_lt72m
 group by patidx_site;
quit;
proc sort data = dxflags_10_lt72m_n nodupkey; by patidx_site; run;

********************** diagnosis data **********************;

*cohortdx, de-duplicate same date and same DX_group;
%macro x (siten,ds,site,r);
data &ds._cohortdx;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortdx;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0;
 if DX_group ne '';
 keep patidx_site age age_order days_btw_rec DX_group;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec DX_group; run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data cohortdx;
 length patidx_site $136.;
 set C9RU_cohortdx 
 C1BMC_cohortdx
 C1WF_cohortdx      
 C2GWN_cohortdx     
 C2UNC_cohortdx     
 C2VAN_cohortdx     
 C4MCRF_cohortdx  
 C4MCW_cohortdx 
 C4UI_cohortdx      
 C4UT_cohortdx      
 C5DH_cohortdx      
 C5GH_cohortdx      
 C5HP_cohortdx      
 C5KPCO_cohortdx    
 C5KPMA_cohortdx    
 C5KPNW_cohortdx    
 C6BAY_cohortdx     
 C6OCH_cohortdx     
 C6TUL_cohortdx      
 C7CCHMC_cohortdx   
 C8NYC_cohortdx     
 C9LM_cohortdx      
 C9NS_cohortdx          
 C9UC_cohortdx      
 C10ADV_cohortdx
 C13OF_cohortdx
 C9LC_cohortdx
 C7CPED_cohortdx;
run;
proc sort data = cohortdx nodupkey; by patidx_site age age_order days_btw_rec DX_group; run;
*later in program derive person-level preterm <24m, 2+ asthma diags <72m, any well child visits <72m;

*Use hierarchy to assign tier 1/day (1-2-3) 1=most severe to 3=least severe;
data dx_tier123;
 set cohortdx;
 if age >=0 and age <24;
 if DX_group = 'Tier1_DX' then tier = 1;
 else if DX_group = 'Tier2_DX' then tier = 2;
 else if DX_group = 'Tier3_DX' then tier = 3;
 else tier = 9;*but not tier 1-2-3;
run;
proc sort data = dx_tier123 nodupkey; by patidx_site age age_order days_btw_rec tier; run;*order 1-2-3-9;
proc sort data = dx_tier123 nodupkey; by patidx_site age age_order days_btw_rec; run;*select lowest tier;

********************************************************************;

*Encounter files, keep 1 record/person/date. AV, ED, IP, or EI trumps OA or OT;
%macro x (siten,ds,site,r);
data &ds._enc;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortencounter;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 if ENC_TYPE in ('AV','ED','EI','IP') then ENC_TYPE_n = 1;
 else if ENC_TYPE in ('OA','OT') then ENC_TYPE_n = 2;
 else if ENC_TYPE in ('IS','NI','UN') then ENC_TYPE_n = 3;
 keep patidx_site age age_order days_btw_rec ENC_TYPE ENC_TYPE_n; 
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec ENC_TYPE_n; run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

*all encounters, 1/person/date, used ENC_TYPE_n hierarchy, 
not limited to people in analysis sample (with 5y outcome data);
data all_enc_lt24m;
 length patidx_site $136.;
 set C9RU_enc 
 C1BMC_enc
 C1WF_enc      
 C2GWN_enc     
 C2UNC_enc     
 C2VAN_enc     
 C4MCRF_enc  
 C4MCW_enc 
 C4UI_enc      
 C4UT_enc      
 C5DH_enc      
 C5GH_enc      
 C5HP_enc      
 C5KPCO_enc    
 C5KPMA_enc    
 C5KPNW_enc    
 C6BAY_enc     
 C6OCH_enc     
 C6TUL_enc      
 C7CCHMC_enc   
 C8NYC_enc     
 C9LM_enc      
 C9NS_enc          
 C9UC_enc      
 C10ADV_enc
 C13OF_enc
 C9LC_enc
 C7CPED_enc;
run;
*later in program derive person-level count of encounters 0-<24, 0-<6, 6-<12, 12-<24;

********************************************************************;

*Prescriptions 0-<24m;
%macro x (siten,ds,site,r);
data &ds._presc;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortpresc;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec RXNORM_CUI rxnorm_cui_group;
run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data presc_lt24m;
 length patidx_site $136.;
 set C9RU_presc 
 C1BMC_presc 
 C1WF_presc      
 C2GWN_presc     
 C2UNC_presc     
 C2VAN_presc     
 C4MCRF_presc  
 C4MCW_presc 
 C4UI_presc      
 C4UT_presc      
 C5DH_presc      
 C5GH_presc      
 C5HP_presc      
 C5KPCO_presc    
 C5KPMA_presc    
 C5KPNW_presc    
 C6BAY_presc     
 C6OCH_presc     
 C6TUL_presc     
 C7CCHMC_presc   
 C8NYC_presc     
 C9LM_presc      
 C9NS_presc        
 C9UC_presc      
 C10ADV_presc
 C13OF_presc
 C9LC_presc
 C7CPED_presc;
 RXNORM_CUI = compress(RXNORM_CUI);
run;
proc sort nodupkey data = presc_lt24m; by patidx_site age age_order days_btw_rec RXNORM_CUI; run;

*Corticosteroids (2 versions);
PROC IMPORT OUT= WORK.steriods_jb 
            DATAFILE= "F:\PCORnet\Aim 1 ms\code lookups\csteroids_lt24m_glossed_cbaily_jb050917.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="Sheet1$"; 
     GETNAMES=YES;
     MIXED=YES;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
data steriods_jb;
 length rxnorm_cui $32.;
 set steriods_jb;
 rxnorm_cui = compress(rxnorm_cuix);
 drop rxnorm_cuix;
run;
proc sort data = steriods_jb nodupkey; by rxnorm_cui; run;

data steroids_all;
 set presc_lt24m;
 if rxnorm_cui_group = 'Corticosteroids_all';
 if RXNORM_CUI in 
 ('105396','10760','206837','343040','345816','364478','367601','368772','373585','381062','429332',
 '574125','692477','763185','813683','855602','858137','896023','896186','966635') 
 then delete;*n=35 obs, have another coded corticosteroid on same date (309513-35=309478);
 corticosteroids = 1;
 keep patidx_site age age_order days_btw_rec corticosteroids RXNORM_CUI;
run;
proc sort data = steroids_all; by rxnorm_cui; run;

data steroids_oral;
 merge steroids_all (in=a) steriods_jb (in=b);
 by RXNORM_CUI;
 if a and b;
 if exclude_steriods = 0;
 drop exclude_steriods exclude_steriods_sens;
run;
proc sort data = steroids_oral nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = steroids_oral; by patidx_site; run;
*later in program derive person-level counts;

data steroids_oral_sens;
 merge steroids_all (in=a) steriods_jb (in=b);
 by RXNORM_CUI;
 if a and b;
 if exclude_steriods_sens = 0;
 drop exclude_steriods exclude_steriods_sens;
run;
proc sort data = steroids_oral_sens nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = steroids_oral_sens; by patidx_site; run;
*later in program derive person-level counts;

*Antibiotics <24m;
data abx_lt24m;
 set presc_lt24m;
 if rxnorm_cui_group = 'Antibiotics_all';
run;
proc sort data = abx_lt24m; by RXNORM_CUI; run;

*Broad/narrow spectrum RXNORM_CUI info from Jason Block;
data all_RXNORM_CUI;
 set fx.all_RXNORM_CUI;
run;
proc sort data = all_RXNORM_CUI nodupkey; by RXNORM_CUI; run;*734 unique RXNORM_CUI;

*Peds R&R broad spectrum class-specific analysis;
*5 categories:
1) Penicillin Combination
2) Macrolide
3) 3rd Gen Cephalosporin
4) Sulfa
5) 1st Gen Cephalosporin and 2nd Gen Cephalosporin

JB email: In terms of combining other of these categories: 
1) Sulfa should include Pen/Sulfa, Pen Sulfa, Sulfone ('Pen/Sulfa','PenSulf','Sulfone')
2) Macrolide should include PenMacro ('PenMacro')
3) Both Sulfa and Macrolide should include the MacroSulfa ('Macro/Sulfa');

data abx_lt24m_spectrum_dups;
 merge all_RXNORM_CUI (in=a) abx_lt24m (in=b);
 by RXNORM_CUI;
 if a and b;

 if abx_class = 'sulfa' then abx_class = 'Sulfa';
 if abx_class = 'penicillin combination' then abx_class = 'Penicillin Combination';
 if abx_class = 'tetracycline' then abx_class = 'Tetracycline';
 if abx_class = 'other' then abx_class = 'Other';
 if abx_class = 'penicillin' then abx_class = 'Penicillin';
 if abx_class = 'macrocyclic' then abx_class = 'Macrocyclic';
 if abx_class in ('Pencillin','penicilllin') then abx_class = 'Penicillin';
 if (abx_category = 'Broad' and abx_class = '' and abx_specific = 'cefuroxime') then abx_class = '2nd Gen Cephalosporin';
 if (abx_category = 'Broad' and abx_class = '' and abx_specific = 'cefaclor') then abx_class = '2nd Gen Cephalosporin';

 tot_abx = 1;
 if abx_category = 'Broad' then broad = 1;
 if abx_category = 'Narrow' then narrow = 1;
 if abx_category = 'Broad' then do;
 if abx_class = '3rd Gen Cephalosporin' then cephalosporin_gen3 = 1;
 if abx_class = 'Penicillin Combination' then pen_combo = 1;
 if abx_class in ('Macrolide','PenMacro') then macrolide = 1;
 if abx_class in ('Sulfa','Pen/Sulfa','PenSulf','Sulfone','Macro/Sulfa') then sulfa = 1;
 if abx_class in ('1st Gen Cephalosporin','2nd Gen Cephalosporin','Macro/Sulfa') then cephalosporin_gen12 = 1;
 end;

run;

*de-dup if same day and same abx_category;
proc sort data = abx_lt24m_spectrum_dups out = abx_lt24m_spectrum nodupkey; by patidx_site age age_order days_btw_rec abx_category; run;
*NOTE: kept 1/abx_category/d. If >1 broad (could be different class), deleted;

*if broad and narrow on same date, call broad (Broad before Narrow);
proc sort data = abx_lt24m_spectrum nodupkey; by patidx_site age age_order days_btw_rec; run;
*NOTE: later in program derive person-level counts;

*********************** put together person-level dataset ***********************;

*person-level count of asthma dx <72m;
data asthmax;
 set cohortdx;
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

*person-level count of wellchild dx <72m;
data wellchild;
 set cohortdx;
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

*person-level any preterm dx <24m;
data preterm;
 set cohortdx;
 if age <24;
 if DX_group = 'Preterm';
 preterm = 1;
 keep patidx_site preterm;
run;
proc sort data = preterm nodupkey; by patidx_site; run;

*count of reflux_meds <24m;
data reflux_lt24m;
 set presc_lt24m;
 if rxnorm_cui_group = 'Reflux_meds_all';
 keep patidx_site age age_order days_btw_rec;
run;
proc sort data = reflux_lt24m nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = reflux_lt24m; by patidx_site; run;
data reflux_lt24m_ct;
 retain reflux_lt24m_ct;
 set reflux_lt24m;
 by patidx_site;
 if first.patidx_site then reflux_lt24m_ct = 1;
 else reflux_lt24m_ct = reflux_lt24m_ct + 1;
 if last.patidx_site;
 keep patidx_site reflux_lt24m_ct;
run;
proc sort data = reflux_lt24m_ct nodupkey; by patidx_site; run;

data count_enc;
 set all_enc_lt24m;
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
%x(enc_0_5,encn_0_5,0,5,n_enc1_0_5,n_enc2_0_5,n_enc3_0_5);
%x(enc_6_11,encn_6_11,6,11,n_enc1_6_11,n_enc2_6_11,n_enc3_6_11);
%x(enc_12_23,encn_12_23,12,23,n_enc1_12_23,n_enc2_12_23,n_enc3_12_23);

*save permanent dataset; 
data f.person_level;
 merge f.cdc_out_5y (in=a) dxflags_10_lt72m_n
 asthma_ct wellchild_ct preterm reflux_lt24m_ct
 encn_0_23 encn_0_5 encn_6_11 encn_12_23;
 by patidx_site;
 if a;
run;*362550;

*********************************************************************************;

*String together all records to:
1. link abx and dx within 7 days
2. abx episodes 10 days
3. corticosteriod episodes 10 days (2 versions)
4. infection episodes 14 days (any tier 1, 2 or 3);

*Encounter files: 1/person/date.
“Age” is month of age as an integer.
“Age_order” is the order of the encounters within the month of age.
“Days_btw_rec” the days since the previous encounter
Include encounters, prescriptions, dispensings to string together all dates;

*<24m, 1/d, not limited to sample with 5y oc;
data enc_dates; 
 set all_enc_lt24m; 
 keep patidx_site age age_order days_btw_rec;
run;

*Vitals <24 months, 1/d, not limited to sample with 5y oc;
%macro x (siten,ds,site,r);
data &ds._vit_dates;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortvital;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data vit_dates;
 length patidx_site $136.;
 set C9RU_vit_dates
 C1BMC_vit_dates
 C1WF_vit_dates      
 C2GWN_vit_dates     
 C2UNC_vit_dates     
 C2VAN_vit_dates     
 C4MCRF_vit_dates  
 C4MCW_vit_dates 
 C4UI_vit_dates      
 C4UT_vit_dates      
 C5DH_vit_dates      
 C5GH_vit_dates      
 C5HP_vit_dates      
 C5KPCO_vit_dates    
 C5KPMA_vit_dates    
 C5KPNW_vit_dates    
 C6BAY_vit_dates     
 C6OCH_vit_dates     
 C6TUL_vit_dates      
 C7CCHMC_vit_dates   
 C8NYC_vit_dates     
 C9LM_vit_dates      
 C9NS_vit_dates        
 C9UC_vit_dates      
 C10ADV_vit_dates
 C13OF_vit_dates
 C9LC_vit_dates
 C7CPED_vit_dates;
run;

*Prescriptions <24 months, 1/d, not limited to sample with 5y oc;
%macro x (siten,ds,site,r);
data &ds._presc_dates;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortpresc;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data presc_dates;
 length patidx_site $136.;
 set C9RU_presc_dates 
 C1BMC_presc_dates
 C1WF_presc_dates      
 C2GWN_presc_dates     
 C2UNC_presc_dates     
 C2VAN_presc_dates     
 C4MCRF_presc_dates  
 C4MCW_presc_dates 
 C4UI_presc_dates      
 C4UT_presc_dates      
 C5DH_presc_dates      
 C5GH_presc_dates      
 C5HP_presc_dates      
 C5KPCO_presc_dates    
 C5KPMA_presc_dates    
 C5KPNW_presc_dates    
 C6BAY_presc_dates     
 C6OCH_presc_dates     
 C6TUL_presc_dates      
 C7CCHMC_presc_dates   
 C8NYC_presc_dates     
 C9LM_presc_dates      
 C9NS_presc_dates         
 C9UC_presc_dates      
 C10ADV_presc_dates
 C13OF_presc_dates
 C9LC_presc_dates
 C7CPED_presc_dates;
run;

*9 sites with dispensing data;
*Dispensings <24 months, 1/d, not limited to sample with 5y oc;
%macro x (siten,ds,site,r);
data &ds._disp_dates;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortdisp;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if age >=0 and age <24;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;
%MEND;
%x(7,C4MCW,'C4MCW',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(28,C7CPED,'C7CPED',b01);

data disp_dates;
 length patidx_site $136.;
 set 
 C4MCW_disp_dates   
 C5DH_disp_dates      
 C5GH_disp_dates      
 C5HP_disp_dates      
 C5KPCO_disp_dates    
 C5KPMA_disp_dates    
 C5KPNW_disp_dates    
 C7CPED_disp_dates;
run;

*Not all dates found in enc + vitals + pres + disp. Add dxflag dates;
%macro x (siten,ds,site,r);
data &ds._dxflag_dates;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortdxflags;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if DX_group ne '';
 if age >=0;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;*1/person/date/DX_group;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data dxflag_dates;
 length patidx_site $136.;
 set C9RU_dxflag_dates
 C1BMC_dxflag_dates
 C1WF_dxflag_dates      
 C2GWN_dxflag_dates     
 C2UNC_dxflag_dates     
 C2VAN_dxflag_dates     
 C4MCRF_dxflag_dates  
 C4MCW_dxflag_dates 
 C4UI_dxflag_dates      
 C4UT_dxflag_dates      
 C5DH_dxflag_dates      
 C5GH_dxflag_dates      
 C5HP_dxflag_dates      
 C5KPCO_dxflag_dates    
 C5KPMA_dxflag_dates    
 C5KPNW_dxflag_dates    
 C6BAY_dxflag_dates     
 C6OCH_dxflag_dates     
 C6TUL_dxflag_dates      
 C7CCHMC_dxflag_dates   
 C8NYC_dxflag_dates     
 C9LM_dxflag_dates      
 C9NS_dxflag_dates          
 C9UC_dxflag_dates      
 C10ADV_dxflag_dates
 C13OF_dxflag_dates
 C9LC_dxflag_dates
 C7CPED_dxflag_dates;
run;

*cohortdx dates;
%macro x (siten,ds,site,r);
data &ds._dx_dates;
 length patidx $128. site $8. patidx_site $136.;
 set &ds..&r._cohortdx;
 patidx = compress(patid); drop patid;
 site = compress(&site);
 siten = &siten;
 patidx_site = compress(patidx||site);
 if days_btw_rec = . then days_btw_rec = 0;
 if DX_group ne '';
 if age >=0;
 keep patidx_site age age_order days_btw_rec;
run;
proc sort nodupkey; by patidx_site age age_order days_btw_rec; run;*1/person/date/DX_group;
%MEND;
%x(1,C1BMC,'C1BMC',r01);
%x(2,C1WF,'C1WF',r01);
%x(3,C2GWN,'C2GWN',r01);
%x(4,C2UNC,'C2UNC',r01);
%x(5,C2VAN,'C2VAN',r01);
%x(6,C4MCRF,'C4MCRF',r01);
%x(7,C4MCW,'C4MCW',r01);
%x(8,C4UI,'C4UI',r01);
%x(9,C4UT,'C4UT',r01);
%x(10,C5DH,'C5DH',r01);
%x(11,C5GH,'C5GH',r01);
%x(12,C5HP,'C5HP',r01);
%x(13,C5KPCO,'C5KPCO',r01);
%x(14,C5KPMA,'C5KPMA',r01);
%x(15,C5KPNW,'C5KPNW',r01);
%x(16,C6BAY,'C6BAY',r01);
%x(17,C6OCH,'C6OCH',r01);
%x(18,C6TUL,'C6TUL',r01);
%x(19,C7CCHMC,'C7CCHMC',r01);
%x(20,C8NYC,'C8NYC',r01);
%x(21,C9LM,'C9LM',r01);
%x(22,C9NS,'C9NS',r01);
%x(23,C9RU,'C9RU',r01);
%x(24,C9UC,'C9UC',r01);
%x(25,C10ADV,'C10ADV',r01);
%x(26,C13OF,'C13OF',r01);
%x(27,C9LC,'C9LC',r01);
%x(28,C7CPED,'C7CPED',b01);

data dx_dates;
 length patidx_site $136.;
 set C9RU_dx_dates
 C1BMC_dx_dates
 C1WF_dx_dates      
 C2GWN_dx_dates     
 C2UNC_dx_dates     
 C2VAN_dx_dates     
 C4MCRF_dx_dates  
 C4MCW_dx_dates 
 C4UI_dx_dates      
 C4UT_dx_dates      
 C5DH_dx_dates      
 C5GH_dx_dates      
 C5HP_dx_dates      
 C5KPCO_dx_dates    
 C5KPMA_dx_dates    
 C5KPNW_dx_dates    
 C6BAY_dx_dates     
 C6OCH_dx_dates     
 C6TUL_dx_dates      
 C7CCHMC_dx_dates   
 C8NYC_dx_dates     
 C9LM_dx_dates      
 C9NS_dx_dates           
 C9UC_dx_dates      
 C10ADV_dx_dates
 C13OF_dx_dates
 C9LC_dx_dates
 C7CPED_dx_dates;
run;

proc sort data = enc_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = vit_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = presc_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = disp_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = dx_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = dxflag_dates nodupkey; by patidx_site age age_order days_btw_rec; run;

*save permanent dataset;
data f.all_dates;
 merge enc_dates vit_dates presc_dates disp_dates dx_dates dxflag_dates;
 by patidx_site age age_order days_btw_rec; 
run;*22876055;
proc sort data = f.all_dates nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = f.all_dates; by patidx_site; run;

data analysis_sample;
 set f.person_level; 
 keep patidx_site site;
run;
proc sort data = analysis_sample nodupkey; by patidx_site; run;

data all_dates_sample;
 merge analysis_sample (in=a) f.all_dates (in=b);
 by patidx_site;
 if a and b;
run;
proc sort data = all_dates_sample; by patidx_site; run;

*add fake date, anchored at 1/1/2000.
“Age” is month of age as an integer.
“Age_order” is the order of the encounters within the month of age.
“Days_btw_rec” the days since the previous encounter;
data all_dates_samplex;
 retain date_ID_ct;
 set all_dates_sample;
 by patidx_site;
 if first.patidx_site then date_ID_ct = mdy(01,01,2000);
 else date_ID_ct = date_ID_ct +  days_btw_rec;
 format date_ID_ct mmddyy8.;
run;

*save permanent dataset;
data f.all_dates_samplex; set all_dates_samplex; run;*14169987;

*********************************************************************************;

*Add dates to abx_lt24m_spectrum, steroids_oral, steroids_oral_sens, and dx_tier123;

*limit to analysis sample;
data abx_lt24m_spectrumx;
 merge analysis_sample (in=a) abx_lt24m_spectrum (in=b);
 by patidx_site;
 if a and b;
run;

data dx_tier123x;
 merge analysis_sample (in=a) dx_tier123 (in=b);
 by patidx_site;
 if a and b;
run;

data steroids_oralx;
 merge analysis_sample (in=a) steroids_oral (in=b);
 by patidx_site;
 if a and b;
run;

data steroids_oral_sensx;
 merge analysis_sample (in=a) steroids_oral_sens (in=b);
 by patidx_site;
 if a and b;
run;

proc sort data = all_dates_samplex nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = abx_lt24m_spectrumx nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = dx_tier123x nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = steroids_oralx nodupkey; by patidx_site age age_order days_btw_rec; run;
proc sort data = steroids_oral_sensx nodupkey; by patidx_site age age_order days_btw_rec; run;

data abx_date;
 merge abx_lt24m_spectrumx (in=a) all_dates_samplex (in=b);
 by patidx_site age age_order days_btw_rec;
 if a and b;*100%;
 abx_date = date_ID_ct; drop date_ID_ct;
 format abx_date mmddyy8.;
run;

data dx_date;
 merge dx_tier123x (in=a) all_dates_samplex (in=b);
 by patidx_site age age_order days_btw_rec;
 if a and b;*100%;
 dx_date = date_ID_ct; drop date_ID_ct;
 format dx_date mmddyy8.;
run;

data steroids_oral_date;
 merge steroids_oralx (in=a) all_dates_samplex (in=b);
 by patidx_site age age_order days_btw_rec;
 if a and b;*100%;
 steroids_date = date_ID_ct; drop date_ID_ct;
 format steroids_date mmddyy8.;
run;

data steroids_oral_sens_date;
 merge steroids_oral_sensx (in=a) all_dates_samplex (in=b);
 by patidx_site age age_order days_btw_rec;
 if a and b;*100%;
 steroids_sens_date = date_ID_ct; drop date_ID_ct;
 format steroids_sens_date mmddyy8.;
run;

*****************************************************************************************;

*link abx and dx, closest withing 7 days before abx;
proc sql;
 create table abx_dx_7d as 
 select *
 from dx_date v , abx_date p
 where (v.patidx_site = p.patidx_site) and
 (0 <= p.abx_date - v.dx_date <=7);
quit;

proc sort data = abx_dx_7d; by patidx_site abx_date descending dx_date; run;
proc sort data = abx_dx_7d nodupkey; by patidx_site abx_date; run;

*Flag for sensitivity analysis - any abx linked to a Tier 1 dx;
data abx_tier1_7d_flag;
 set abx_dx_7d;
 if tier = 1;
 abx_tier1_7d_flag = 1;
 keep patidx_site abx_tier1_7d_flag;
run;
proc sort data = abx_tier1_7d_flag nodupkey; by patidx_site; run;

*****************************************************************************************;

*derive antibiotic episodes 10 day;
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
%x(abx_0_5,0,5,ep10d_abx_0_5,script_abx_0_5);
%x(abx_6_11,6,11,ep10d_abx_6_11,script_abx_6_11);
%x(abx_12_23,12,23,ep10d_abx_12_23,script_abx_12_23);

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
%x(babx_0_5,0,5,ep10d_babx_0_5,script_babx_0_5);
%x(babx_6_11,6,11,ep10d_babx_6_11,script_babx_6_11);
%x(babx_12_23,12,23,ep10d_babx_12_23,script_babx_12_23);

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
%x(nabx_0_5,0,5,ep10d_nabx_0_5,script_nabx_0_5);
%x(nabx_6_11,6,11,ep10d_nabx_6_11,script_nabx_6_11);
%x(nabx_12_23,12,23,ep10d_nabx_12_23,script_nabx_12_23);

*derive corticosteroids episodes 10 day;
proc sort data = steroids_oral_date nodupkey; by patidx_site steroids_date; run;

%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set steroids_oral_date;
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
%x(steroids_0_5,0,5,ep10d_steroids_0_5,script_steroids_0_5);
%x(steroids_6_11,6,11,ep10d_steroids_6_11,script_steroids_6_11);
%x(steroids_12_23,12,23,ep10d_steroids_12_23,script_steroids_12_23);

*derive corticosteroids v2 episodes 10 day;
proc sort data = steroids_oral_sens_date nodupkey; by patidx_site steroids_sens_date; run;

%macro x (ds,lowage,highage,ep10d,script);
data &ds;
 set steroids_oral_sens_date;
 if age >=&lowage and age <=&highage;
run;
data &ds;
 retain &ep10d &script;
 set &ds;
 by patidx_site steroids_sens_date;
 lag_steroids_sens_date = lag (steroids_sens_date);
 if first.patidx_site then do;
 &ep10d = 1;
 &script = 1;
 end;
 else do;
 if steroids_sens_date - lag_steroids_sens_date >10 then &ep10d = &ep10d + 1;
 if steroids_sens_date - lag_steroids_sens_date >0 then &script = &script + 1;
 end;
 if last.patidx_site;
 keep patidx_site &ep10d &script;
run;
proc sort data = &ds nodupkey; by patidx_site; run;
%MEND;
%x(steroidsx_0_23,0,23,ep10d_steroidsx_0_23,script_steroidsx_0_23);
%x(steroidsx_0_5,0,5,ep10d_steroidsx_0_5,script_steroidsx_0_5);
%x(steroidsx_6_11,6,11,ep10d_steroidsx_6_11,script_steroidsx_6_11);
%x(steroidsx_12_23,12,23,ep10d_steroidsx_12_23,script_steroidsx_12_23);

*derive tier 1, 2, or 3 infections 14 d;
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
%x(tier_0_5,0,5,ep14d_tier_0_5,dx_tier_0_5);
%x(tier_6_11,6,11,ep14d_tier_6_11,dx_tier_6_11);
%x(tier_12_23,12,23,ep14d_tier_12_23,dx_tier_12_23);

*6/18/18 R&R - Tier 1 only;
%macro x (ds,lowage,highage,ep14d,dx);
data &ds;
 set dx_date;
 if age >=&lowage and age <=&highage;
 if DX_group in ('Tier1_DX');
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
%x(tier1_0_23,0,23,ep14d_tier1_0_23,dx_tier1_0_23);
%x(tier1_0_5,0,5,ep14d_tier1_0_5,dx_tier1_0_5);
%x(tier1_6_11,6,11,ep14d_tier1_6_11,dx_tier1_6_11);
%x(tier1_12_23,12,23,ep14d_tier1_12_23,dx_tier1_12_23);

*save permanent dataset;
data f.PCORnet_Aim1;
 merge f.person_level (in=a)
 abx_tier1_7d_flag
 abx_0_23 abx_0_5 abx_6_11 abx_12_23
 babx_0_23 babx_0_5 babx_6_11 babx_12_23
 nabx_0_23 nabx_0_5 nabx_6_11 nabx_12_23
 steroids_0_23 steroids_0_5 steroids_6_11 steroids_12_23
 steroidsx_0_23 steroidsx_0_5 steroidsx_6_11 steroidsx_12_23
 tier_0_23 tier_0_5 tier_6_11 tier_12_23
 tier1_0_23 tier1_0_5 tier1_6_11 tier1_12_23;
 by patidx_site;
 if a;
run;
