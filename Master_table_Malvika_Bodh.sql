CREATE TABLE master_table AS
SELECT * FROM

/* Incorporate other parameters of breed, height, weight, and color for future analysis */
(SELECT U.PONY_ID, U.Age, U.Age_Group, U.`Total_Powers`, U.BREED,U.FOOD, U.HEIGHT, U.WEIGHT, U.COLOR, 
(CASE
	WHEN U.`Total_Powers` = 4 THEN 'Powerful_Pony'
	WHEN U.`Total_Powers` = 1 AND U.Age >5 THEN 'Puny_Pony'
	ELSE 'Pony'
	END) AS 'PowerfulvsPuny'
	FROM

(SELECT T.PONY_ID, T.BREED, T.FOOD, T.HEIGHT, T.WEIGHT, T.COLOR,
 (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 AS 'Age',
(CASE
    WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 1 THEN 'Less than 1' 
    WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 1 AND (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 2 THEN '1-2'
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 2 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 3 THEN '2-3' 
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 3 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 4 THEN '3-4' 
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 4 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 5 THEN '4-5' 
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 5 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 6 THEN '5-6' 
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 6 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 7 THEN '6-7' 
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 7 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 8 THEN '7-8' 
	WHEN (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 > 8 and (julianday('now') - julianday(T.DATE_OF_BIRTH))/365.25 <= 10 THEN '8-10' 	
    ELSE 'More than 10'
END) AS 'Age_Group',
COUNT (DISTINCT T.POWER_NAME) AS "Total_Powers"
FROM
(
SELECT * FROM  pony_fact 
LEFT JOIN pony_power 
ON pony_fact.PONY_ID = pony_power.PONY_ID) T GROUP BY T.PONY_ID) U) Table1forjoin



LEFT JOIN


(SELECT PONY_ID, Totalpopularity,
(CASE
WHEN Totalpopularity >= 150 THEN 'Popular Pony' 
WHEN Totalpopularity < 0 THEN 'Pariah Pony'
WHEN Totalpopularity>=0 AND Totalpopularity<150 THEN 'Pony'
END) AS PonyPopularityCategory /* Column for categorization of ponies as popular vs pariah based on total popularity */

FROM (
SELECT PONY_ID,

(CASE
WHEN FriendenemyScoresum >=0 THEN FriendenemyScoresum + FrenemyScoresum + Family_Members
WHEN FriendenemyScoresum <0 THEN FriendenemyScoresum - FrenemyScoresum + Family_Members
END) AS Totalpopularity /* Column for calculating total popularity using intensities computed for friends, enemies, and frenemies for various pony powers*/ 
                        /*Also, adding the effect of family members on popularity */



FROM (
SELECT PONY_ID, LAST_NAME, sum(FriendenemyScore) AS 'FriendenemyScoresum', sum(FrenemyScore) AS 'FrenemyScoresum'


FROM (
SELECT Popularitytable.PONY_ID,Popularitytable.LAST_NAME,
(CASE 
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'True' AND Popularitytable.RELATIONSHIP_TYPE = 'Friend' THEN 2*Popularitytable.INTENSITY
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'True'  AND Popularitytable.RELATIONSHIP_TYPE = 'Enemy' THEN  0
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'True'  AND Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  0
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'False'  AND Popularitytable.RELATIONSHIP_TYPE = 'Friend' THEN  1*Popularitytable.INTENSITY
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'False'  AND Popularitytable.RELATIONSHIP_TYPE = 'Enemy' THEN  0
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'False'  AND Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  0
WHEN Popularitytable.Poweroffriendship='False' AND  Poweroflove = 'True' AND Popularitytable.RELATIONSHIP_TYPE = 'Friend' THEN 2*Popularitytable.INTENSITY
WHEN Popularitytable.Poweroffriendship='False' AND  Poweroflove = 'True'  AND Popularitytable.RELATIONSHIP_TYPE = 'Enemy' THEN  -1*Popularitytable.INTENSITY
WHEN Popularitytable.Poweroffriendship='False' AND  Poweroflove = 'True'  AND Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  0
WHEN Popularitytable.RELATIONSHIP_TYPE = 'Friend' THEN  1*Popularitytable.INTENSITY
WHEN Popularitytable.RELATIONSHIP_TYPE = 'Enemy' THEN  -1*Popularitytable.INTENSITY
WHEN Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  0
END
) AS 'FriendenemyScore',/* Here, we ignore the effect of Frenemy intensity as it depends on combined intensity of Friends and Enemies */

(CASE 
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'True'  AND Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  0
WHEN Popularitytable.Poweroffriendship='True' AND  Poweroflove = 'False'  AND Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  0
WHEN Popularitytable.RELATIONSHIP_TYPE = 'Frenemy' THEN  1*Popularitytable.INTENSITY
ELSE 0
END
) AS 'FrenemyScore' /* Here, we incorporate the effect of Frenemy intensity */


FROM (
SELECT pony_fact.PONY_ID, pony_fact.LAST_NAME,Poweroffriendship, Poweroflove, RELATIONSHIP_TYPE, INTENSITY FROM  pony_fact 
LEFT JOIN (select PONY_ID, max(CASE 
WHEN POWER_NAME = 'The Power of Friendship' THEN 'True'
ELSE 'False' END) AS Poweroffriendship,
max(CASE 
WHEN POWER_NAME = 'The Power of Love' THEN 'True'
ELSE 'False' END) AS Poweroflove
FROM pony_power GROUP BY PONY_ID) pony_power_final 
ON pony_fact.PONY_ID = pony_power_final.PONY_ID
LEFT JOIN pony_rltn 
ON pony_fact.PONY_ID = pony_rltn.TARGET_PONY_ID) Popularitytable) FriendEnemytableagg GROUP BY PONY_ID) FEagg_table 
LEFT JOIN (SELECT pony_fact.LAST_NAME, (count(PONY_ID)-1) as "Family_Members" FROM pony_fact GROUP BY LAST_NAME) Familytable
ON FEagg_table.LAST_NAME = Familytable.LAST_NAME) Tablepariahvspony) Table2forjoin


ON Table1forjoin.PONY_ID = Table2forjoin.PONY_ID

LEFT JOIN



(SELECT PONY_ID, TreatedoRnot, No_ofTreatments FROM

(SELECT pony_treatment_hist.PONY_ID AS "Pony_treatment_ID", 
(CASE 
WHEN ((SUM((CASE 
WHEN (pony_power.POWER_NAME = 'The Power of Gratitude') THEN 1 
ELSE 0 
END)) = 0) 
AND 
(CAST(pony_treatment_hist.PONY_ID AS VARCHAR) <> 'Null')) THEN 'Treated' 
ELSE NULL 
END) AS "TreatedORnot"
  FROM pony_power
  LEFT JOIN pony_treatment_hist ON (pony_power.PONY_ID = pony_treatment_hist.PONY_ID)
WHERE (NOT (pony_treatment_hist.PONY_ID IS NULL))
GROUP BY 1) table1 JOIN
(SELECT PONY_ID, count(*) AS No_ofTreatments FROM pony_treatment_hist GROUP BY PONY_ID) table2
ON table1.Pony_treatment_ID = table2.PONY_ID
WHERE table1.TreatedORnot IS NOT NULL) Table3forjoin

ON Table1forjoin.PONY_ID = Table3forjoin.PONY_ID