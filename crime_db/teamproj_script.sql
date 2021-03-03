-- 1. Create a report that displays the number of crimes committed in the United States, showing the violent crimes, 
-- property crimes, part I and part II crimes per year. 

SELECT year(c.crime_datetime) as "Year", COUNT(c.crime_id) as "Crimes in thE US", 
       ct.violent as "Violent Crimes"
FROM crime_type ct, crime c
WHERE c.crime = ct.crime
GROUP BY ct.violent, Year
ORDER BY Year asc;


-- 2. Create a report that displays the number of crimes per city on a given year.

SELECT cy.name as "City", COUNT(*) as "Number of Crimes"
FROM crime c, crime_type ct, address a, city cy
WHERE c.crime = ct.crime
AND c.address_id = a.address_id
AND a.city_id = cy.city_id
AND year(c.crime_datetime) = 2018
GROUP BY cy.name;



-- 3. Create a report that displays the number of domestic crimes that happened in the United States per year. //PROCEDURE 1//

SELECT year(crime_datetime) as "Year", COUNT(crime_id) as "Domestic Crimes"
FROM crime 
WHERE domestic = "Yes"
GROUP BY Year
ORDER BY Year asc;


-- 4. Create a report that displays the proportions of crimes that happened per city. 


select cy.name as "City", c.crime as "Crime", COUNT(crime_id) as "Number of Crimes"
FROM crime c, address a, city cy
WHERE c.address_id = a.address_id
AND a.city_id = cy.city_id
GROUP BY c.crime, cy.name
ORDER BY city;


-- 5. Create a report that displays the average number of crimes and its movements over months (is there a seasonality?).

CREATE OR REPLACE VIEW n_crimes_per_month AS
SELECT year(c.crime_datetime), monthname(c.crime_datetime) as Months, COUNT(c.crime_id) as 'Number of Crimes'
FROM crime c, address a, city cy, crime_type ct
WHERE c.address_id = a.address_id
AND c.crime = ct.crime
AND a.city_id = cy.city_id
GROUP BY monthname(c.crime_datetime), month(c.crime_datetime), year(c.crime_datetime);

SELECT Months, ROUND(AVG(`Number of Crimes`),1) AS 'Average number of crimes' 
FROM n_crimes_per_month cm, city cy
GROUP BY Months
ORDER BY 'Average number of crimes' DESC;



-- 6.  Socioeconomic factors are said to be linked to crime rates where areas with exposure to crime greatly affect its people 
-- having poor access to education, poverty, exposure to chemicals, etc.. Create a report that displays the number of crimes 
-- happened per neighborhood in a given city.

SELECT ct.name as "City", a.neighborhood as "Neighborhood",  COUNT(crime_id) as "Number of Crimes"
FROM crime c, address a, city ct
WHERE c.address_id = a.address_id
AND a.city_id = ct.city_id
GROUP BY a.neighborhood, ct.name
ORDER BY ct.name, a.neighborhood;


-- 7. In reference to the query above, create a report that displays the number of crimes committed by people living in a 
-- specific neighborhood to know whether the crimes can also stem from criminals residing in those areas. 

SELECT ct.name as "City", a.neighborhood, COUNT(p.person_id) as "Number of Offenders"
FROM offender o, person p, crime c, address a, person_address pa, city ct
WHERE c.crime_id = o.crime_id
AND o.person_id = p.person_id
AND p.person_id = pa.person_id
AND pa.type = "Home"
AND pa.address_id = a.address_id
AND ct.city_id = a.city_id
GROUP BY ct.name, a.neighborhood;



-- 8. Violence against women. According to https://now.org/resource/violence-against-women-in-the-united-states-statistic/, 
-- advocacy groups are working together to halt the gender-based violence where approximately 1,200 women lives were
-- spared. Given this, create a report that displays the number of Femicides in the US by city name. 


SELECT ct.name as City, COUNT(1) AS "Femicides"
FROM victim v, offender o, crime cr, person po, person pv, address a, city ct
WHERE cr.crime_id = o.crime_id
AND cr.crime_id = v.crime_id
AND o.person_id = po.person_id
AND v.person_id = pv.person_id
AND cr.crime = "Murder"
AND po.gender = "M"
AND pv.gender = "F"
AND cr.address_id = a.address_id
AND a.city_id = ct.city_id
AND (2020 - YEAR(cr.crime_datetime)) < 10
GROUP BY ct.name;




-- 9. Given that there is a controversy between the race/ethnicity, create a report that displays the number of offenders that
--  have committed murder and group them by racial groups. This is to identify whether the racial minorities in the criminal justice.

SELECT c.crime as "Crime", p.race as "Race/Ethnicity", COUNT(o.crime_id) as "Number of offenders"
FROM person p, crime c, offender o, crime_type ct
WHERE p.person_id = o.person_id
AND o.crime_id = c.crime_id
AND ct.crime = c.crime
AND c.crime = "Murder"
GROUP BY p.race, c.crime;


-- 10. Create a report that shows the crime name and how many crimes have been committed by age. 
-- In this case, we can determine among which age group is most likely to commit a crime? //PROCEDURE 2//

SELECT cy.name as "City",TRUNCATE(avg(p.age), 0) as "Average age"
FROM crime c, address a, city cy, crime_type ct, offender o, person p
WHERE c.address_id = a.address_id
AND c.crime = ct.crime
AND a.city_id = cy.city_id
AND c.crime_id = o.crime_id
AND o.person_id = p.person_id
AND year(c.crime_datetime) = 2019
AND ct.crime = "Drug Offense"
GROUP BY cy.name;
