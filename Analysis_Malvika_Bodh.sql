/* Grouping by Age_Groups (Fig 3.a) */
SELECT Age_Group, count(PONY_ID)AS 'Total No. of Ponies' FROM master_table GROUP BY Age_group;

/* Pony Power vs Age (Fig 3.b) */
SELECT Age_Group,PowerfulvsPuny, count(PONY_ID)AS 'Total No. of Ponies' FROM master_table GROUP BY Age_group, PowerfulvsPuny;


/* Age Group vs Total Powers & Popularity (Fig 4) */
SELECT Age_group, PonyPopularityCategory, Total_Powers, count(PONY_ID)AS 'Total No. of Ponies' FROM master_table GROUP BY Age_group, PonyPopularityCategory, Total_Powers 
ORDER BY 1,2,3;

/* No. of Ponies vs Age and Popularity (Fig. 5) */
SELECT Age_group, PonyPopularityCategory, PowerfulvsPuny, count(PONY_ID)AS 'Total No. of Ponies' FROM master_table GROUP BY Age_group, PonyPopularityCategory, PowerfulvsPuny 
ORDER BY 1,2,3;

/* Treatment History vs Age (Fig. 6a) */
SELECT Age_group, TreatedoRnot, count(PONY_ID) FROM master_table GROUP BY Age_group, TreatedoRnot;

/* Popy Popularity vs Age (Fig. 6b) */
SELECT Age_group, PonyPopularityCategory, count(PONY_ID) FROM master_table GROUP BY Age_group, PonyPopularityCategory;

/* Popularity vs Power (Fig. 7) */
SELECT PonyPopularityCategory, PowerfulvsPuny,  count(PONY_ID) FROM master_table GROUP BY PonyPopularityCategory, PowerfulvsPuny;

/* Age Group vs Total Powers (Fig. 8) */
SELECT Age_Group, Total_Powers, count(PONY_ID) FROM master_table GROUP BY Age_Group, Total_Powers;

/* Old Ponies vs Power & Popularity  (Fig.9) */
SELECT PowerfulvsPuny, PonyPopularityCategory, count(PONY_ID) FROM master_table WHERE Age_Group = 'More than 10'
GROUP BY PowerfulvsPuny, PonyPopularityCategory ORDER BY PowerfulvsPuny, PonyPopularityCategory;

/* Power vs Food (Fig. 10) */
SELECT TreatedoRnot, FOOD, PowerfulvsPuny, count(PONY_ID) FROM master_table GROUP BY TreatedoRnot, FOOD, PowerfulvsPuny;


/* Power vs FOOD (Fig. 11b) */
SELECT FOOD, PowerfulvsPuny, count(PONY_ID) FROM master_table WHERE TreatedoRnot = 'Treated' GROUP BY TreatedoRnot, FOOD, PowerfulvsPuny;


/* Power vs FOOD (Fig. 11a) */
SELECT FOOD, PowerfulvsPuny, count(PONY_ID) FROM master_table WHERE TreatedoRnot ISNULL GROUP BY TreatedoRnot, FOOD, PowerfulvsPuny;

/* Pony vs BREED (Fig. 12) */
SELECT BREED, PowerfulvsPuny, count(PONY_ID) FROM master_table GROUP BY BREED, PowerfulvsPuny;

/* Pony Popularity vs BREED (Fig. 12) */
SELECT BREED, PonyPopularityCategory, count(PONY_ID) FROM master_table GROUP BY BREED, PonyPopularityCategory;

/* Treatment history vs BREED */
SELECT BREED, TreatedoRnot, count(PONY_ID) FROM master_table GROUP BY BREED, TreatedoRnot;

