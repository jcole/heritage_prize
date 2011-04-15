
-- relationships
select m.ageatfirstclaim, count(*), avg(dh.daysinhospital_y2), stddev(dh.daysinhospital_y2), avg(log(dh.daysinhospital_y2 + 1)), stddev(log(dh.daysinhospital_y2 + 1))
from days_in_hospital_y2 dh, members m
where m.memberid = dh.memberid
group by 1
order by 1

select specialty, count(*), avg(claim_days), stddev(claim_days ), avg(log(claim_days + 1)), stddev(log(claim_days + 1))
from (
   select specialty, 
	CASE WHEN lengthofstay='12-26 weeks' THEN 12*7
             WHEN lengthofstay='1- 2 weeks' THEN 7
             WHEN lengthofstay='1 day' THEN 1
             WHEN lengthofstay='2- 4 weeks' THEN 2
             WHEN lengthofstay='26+ weeks' THEN 26*7
             WHEN lengthofstay='2 days' THEN 2*7
             WHEN lengthofstay='3 days' THEN 3*7
             WHEN lengthofstay='4- 8 weeks' THEN 4*7
             WHEN lengthofstay='4 days' THEN 4
             WHEN lengthofstay='5 days' THEN 5
             WHEN lengthofstay='6 days' THEN 6
             WHEN lengthofstay='8-12 weeks' THEN 8*7
             ELSE 0
        END as claim_days
    from claims_y1
    ) claim_summary
group by 1
order by 1



--days in h. y2 by specialty in claims y1
select c.specialty, sum(dih.daysinhospital_y2) sum_dih, count(*) as claims, cast(sum(dih.daysinhospital_y2) as float)/cast(count(*) as float) as avg_dih_per_claim
from claims_y1 c, days_in_hospital_y2 dih
where c.memberid = dih.memberid
group by 1
order by 2 desc

         specialty         | sum_dih | claims | avg_dih_per_claim 
---------------------------+---------+--------+-------------------
 Internal                  |  211317 | 170642 |  1.23836452924837
 Laboratory                |  128750 | 124325 |  1.03559219786849
 General Practice          |  115409 | 129284 | 0.892678134958696
 Diagnostic Imaging        |   79696 |  66641 |  1.19590042166234
 Surgery                   |   60797 |  53774 |  1.13060214973779
 Emergency                 |   42272 |  31988 |  1.32149556083531
 Other                     |   27412 |  20983 |   1.3063908878616
 Anesthesiology            |    8270 |   7499 |  1.10281370849447
 Obstetrics and Gynecology |    7772 |  10419 | 0.745944908340532
 Rehabilitation            |    7065 |   7282 | 0.970200494369679
 Pediatrics                |    6476 |  17675 | 0.366393210749646
 Pathology                 |    4114 |   4194 | 0.980925131139723



--days in h. y2 by placesvc in claims y1
select c.placesvc, sum(dih.daysinhospital_y2) sum_dih, count(*) as claims, cast(sum(dih.daysinhospital_y2) as float)/cast(count(*) as float) as avg_dih_per_claim
from claims_y1 c, days_in_hospital_y2 dih
where c.memberid = dih.memberid
group by 1
order by 2 desc

      placesvc       | sum_dih | claims | avg_dih_per_claim 
---------------------+---------+--------+-------------------
 Office              |  401156 | 404309 | 0.992201509241694
 Independent Lab     |  129343 | 125498 |   1.0306379384532
 Urgent Care         |   68558 |  49748 |  1.37810565248854
 Inpatient Hospital  |   46271 |  21783 |  2.12417940595878
 Outpatient Hospital |   36544 |  30989 |  1.17925715576495
 Other               |    7649 |   3143 |   2.4336621062679
 Ambulance           |    7081 |   8251 | 0.858199006181069
 Home                |    2748 |    985 |  2.78984771573604


--days in h. y2 by condition in claims y1
select conditions.description, sum(dih.daysinhospital_y2) as sum_dih, count(*) as claims, cast(sum(dih.daysinhospital_y2) as float)/cast(count(*) as float) as avg_dih_per_claim
from claims_y1 c, days_in_hospital_y2 dih, conditions
where c.memberid = dih.memberid
and c.primaryconditiongroup = conditions.primaryconditiongroup
group by 1
order by 2 desc

                          description                          | sum_dih | claims  | avg_dih_per_claim 
---------------------------------------------------------------+---------+--------+-------------------
 Miscellaneous 2                                               |   98067 | 111499 | 0.879532551861452
 Arthropathies                                                 |   75701 |  71711 |  1.05563999944221
 Other metabolic                                               |   74524 |  71800 |  1.03793871866295
 Other neurological                                            |   49462 |  46305 |   1.0681783824641
 Gastrointestinal bleeding                                     |   38262 |  28846 |   1.3264230742564
 Miscellaneous cardiac                                         |   35374 |  31421 |  1.12580758091722
 Acute respiratory                                             |   33042 |  37533 | 0.880345296139397
 Skin and autoimmune disorders                                 |   26420 |  26901 | 0.982119623805807
 Other cardiac conditions                                      |   21913 |  12419 |  1.76447379016024
 Chest pain                                                    |   20457 |  12835 |  1.59384495520062
 All other infections                                          |   18433 |  21541 | 0.855717004781579
 Chronic obstructive pulmonary disorder                        |   16795 |  11706 |  1.43473432427815
 All other trauma                                              |   16426 |  18960 | 0.866350210970464
 Acute myocardial infarction                                   |   16319 |   8891 |  1.83545158024969
 Other renal                                                   |   14500 |  12749 |  1.13734410542003
 Miscellaneous 3                                               |   13421 |  12315 |  1.08980917580187
 Cancer B                                                      |   12951 |   9739 |  1.32980798849985
 Urinary tract infections                                      |   10701 |  10155 |  1.05376661742984
 Non-malignant hematologic                                     |   10229 |   6194 |  1.65143687439458
 Ingestions and benign tumors                                  |   10156 |  12316 | 0.824618382591751
 Atherosclerosis and peripheral vascular disease               |    9855 |   7077 |  1.39253921153031
 Pregnancy                                                     |    9719 |   7833 |  1.24077620324269
 Gynecology                                                    |    8577 |  11234 | 0.763485846537297
 Seizure                                                       |    7564 |   5162 |  1.46532351801627
 Congestive heart failure                                      |    7441 |   3172 |  2.34583858764187
 Fractures and dislocations                                    |    7248 |   8682 | 0.834830684174153
 Chronic renal failure                                         |    5942 |   2103 |  2.82548739895388
 Appendicitis                                                  |    5668 |   5041 |   1.1243800833168
 Pneumonia                                                     |    3610 |   2581 |  1.39868268113134
 Stroke                                                        |    3546 |   2149 |  1.65006979990693
 Gastrointestinal, inflammatory bowel disease, and obstruction |    2895 |   2831 |  1.02260685270223
 Gynecologic cancers                                           |    2001 |   2369 | 0.844660194174757
 Fluid and electrolyte                                         |    1957 |   1247 |  1.56936647955092
 Hip fracture                                                  |    1864 |   1023 |  1.82209188660802
 Miscellaneous 1                                               |    1486 |   1301 |  1.14219830899308
 Cancer A                                                      |    1465 |   1101 |  1.33060853769301
 Diabetic ketoacidosis and related metabolic                   |    1301 |   1024 |      1.2705078125
 Pericarditis                                                  |    1077 |    850 |  1.26705882352941
 Catastrophic conditions                                       |     901 |    445 |   2.0247191011236
 Liver disorders                                               |     760 |    750 |  1.01333333333333
 Ovarian and metastatic cancer                                 |     392 |    231 |   1.6969696969697
 Pancreatic disorders                                          |     300 |    259 |  1.15830115830116
 Acute renal failure                                           |     266 |    124 |  2.14516129032258
 Sepsis                                                        |     232 |    120 |  1.93333333333333
 Perinatal period                                              |     130 |    161 | 0.807453416149068
