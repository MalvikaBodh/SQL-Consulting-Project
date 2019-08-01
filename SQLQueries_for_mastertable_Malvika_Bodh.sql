/*********** xxxx Analyst Position Interview Task - Malvika Bodh (07/04/2019) **************/

/***********STEPS***********/
/* PART I - Understanding the dataset, and performing preliminary age categorization */

/* Viewing 20 records from all four tables */
SELECT * FROM pony_fact limit 20;
SELECT * FROM pony_power limit 20;
SELECT * FROM pony_rltn limit 20;
SELECT * FROM pony_treatment_hist limit 20;

/* Calculating Age using Date of Birth */
/* Assume that every year is made of 365.25 days, thus incorporating the leap year */
SELECT (julianday('now') - julianday(DATE_OF_BIRTH))/365.25 AS 'Age' from pony_fact;

/*Viewing Minimum and Maximum Ages of Ponies on the farm */
SELECT min(Age) from (SELECT (julianday('now') - julianday(DATE_OF_BIRTH))/365.25 AS 'Age' from pony_fact);
SELECT max(Age) from (SELECT (julianday('now') - julianday(DATE_OF_BIRTH))/365.25 AS 'Age' from pony_fact);

/*Creating Age Groups*/
SELECT CAST(Age as INTEGER) As 'Age_group', count(*) from (SELECT (julianday('now') - julianday(DATE_OF_BIRTH))/365.25 AS 'Age' from pony_fact) T group by cast(Age as INTEGER);

/*Viewing these age groups by creating bins*/ 
SELECT Age_groups, count(*) 
FROM
(SELECT 
CASE 
   WHEN Age < 1 THEN 'Less than 1' 
   WHEN Age >= 1 AND Age <2 THEN '1 to 2' 
   WHEN Age >= 2 AND Age <3 THEN '2 to 3' 
   WHEN Age >= 3 AND Age <4 THEN '3 to 4' 
   WHEN Age >= 4 AND Age <5 THEN '4 to 5' 
   WHEN Age >= 5 AND Age <6 THEN '5 to 6' 
   WHEN Age >= 6 AND Age <7 THEN '6 to 7' 
   WHEN Age >= 7 AND Age <8 THEN '7 to 8' 
   WHEN Age >= 8 AND Age <10 THEN '8 to 10' 
   ELSE 'Greater than 10'
END 'Age_groups'
FROM (SELECT (julianday('now') - julianday(DATE_OF_BIRTH))/365.25 AS 'Age' from pony_fact) T) Final_table
GROUP BY Age_groups ;


/* PART II(a) - Finding the Total Magical Powers that each Pony has by counting the number of powers listed for each PONY_ID. */
/* Also incorporating the age groups */

SELECT T.PONY_ID,
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
ON pony_fact.PONY_ID = pony_power.PONY_ID) T GROUP BY T.PONY_ID;


/*PART II(b) - Categorizing each Pony as 'Puny vs Powerful' from total number of powers and age [Table for Powerful vs Puny using Age and Powers]*/

SELECT U.PONY_ID, U.Age, U.Age_Group, U.`Total_Powers`, 
(CASE
	WHEN U.`Total_Powers` = 4 THEN 'Powerful_Pony' /* A Pony that has all 4 powers */
	WHEN U.`Total_Powers` = 1 AND U.Age >5 THEN 'Puny_Pony' /* A Pony that only has 1 power past the age of 5*/
	ELSE 'Pony' 
	END) AS 'PowerfulvsPuny' /* Column for categorization as powerful or puny */
	FROM

(SELECT T.PONY_ID,
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
ON pony_fact.PONY_ID = pony_power.PONY_ID) T GROUP BY T.PONY_ID) U;


/* PART III  - Popularity calculations */

/* Calculating the total family members for all ponies using their LAST_NAME */
SELECT PONY_ID, (count(PONY_ID)-1) as "Family_Members"
FROM pony_fact GROUP BY LAST_NAME ORDER BY PONY_ID;


/* Creating Boolean Columns for pony powers to avoid multiple records for same PONY_ID*/

select PONY_ID, MAX(CASE 
WHEN POWER_NAME = 'The Power of Friendship' THEN 'True'
ELSE 'False' END) AS Poweroffriendship,
MAX(CASE 
WHEN POWER_NAME = 'The Power of Love' THEN 'True'
ELSE 'False' END) AS Poweroflove
FROM pony_power GROUP BY PONY_ID;

/*Popularity due to friends, enemy and frenemies: Calculation with consideration for power of Ponies*/

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
ON pony_fact.PONY_ID = pony_rltn.TARGET_PONY_ID;

/*Combining New Power table, pony_rltn and pony_fact */



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
ON pony_fact.PONY_ID = pony_rltn.TARGET_PONY_ID;

/* Selecting Intensities */
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
ON pony_fact.PONY_ID = pony_rltn.TARGET_PONY_ID) Popularitytable;

/* Friend and enemy score Sum for each pony id */
SELECT PONY_ID, LAST_NAME, sum(FriendenemyScore), sum(FrenemyScore)


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
ON pony_fact.PONY_ID = pony_rltn.TARGET_PONY_ID) Popularitytable) FriendEnemytableagg GROUP BY PONY_ID;

/* Joining Family Members to the table */
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
ON FEagg_table.LAST_NAME = Familytable.LAST_NAME;


/* Categorizing Ponies on the basis of their Total Popularity */
SELECT PONY_ID, Totalpopularity,
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
ON FEagg_table.LAST_NAME = Familytable.LAST_NAME) Tablepariahvspony; 



/* PART IV Treatments */

/* PONYID and Treatment calculation based on power of gratitude. */

/* Treated or not Treated Ponies */
SELECT pony_treatment_hist.PONY_ID AS "Pony_treatment_ID", 
(CASE 
WHEN ((SUM((CASE WHEN (pony_power.POWER_NAME = 'The Power of Gratitude') THEN 1 
ELSE 0 
END)) = 0) 
AND 
(CAST(pony_treatment_hist.PONY_ID AS VARCHAR) <> 'Null')) THEN 'Treated' 
ELSE NULL 
END) AS "TreatedORnot" /* Column for determining if a pony was treated, and did not have the power of gratitude - thus, at cost */
  FROM pony_power
  LEFT JOIN pony_treatment_hist ON (pony_power.PONY_ID = pony_treatment_hist.PONY_ID)
WHERE (NOT (pony_treatment_hist.PONY_ID IS NULL))
GROUP BY 1;

/*No. of treatments based on counting the treated cases for PONY_ID for all treated ponies irrespective of their power*/
SELECT PONY_ID, count(*) AS No_ofTreatments FROM pony_treatment_hist GROUP BY PONY_ID;


/*Joining these two tables together*/
SELECT PONY_ID, TreatedoRnot, No_ofTreatments FROM

(SELECT pony_treatment_hist.PONY_ID AS "Pony_treatment_ID", 
(CASE 
WHEN ((SUM((CASE WHEN (pony_power.POWER_NAME = 'The Power of Gratitude') THEN 1 
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
WHERE table1.TreatedORnot IS NOT NULL;


/* Master Table for drawing conclusions */

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



