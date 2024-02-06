 -- 1. Show possible values of the year column in country_stats table
SELECT DISTINCT year
FROM country_stats
ORDER BY year DESC;

-- 2. Show names of the first 5 countries in alphabetical order
SELECT name
FROM countries
ORDER BY name
LIMIT 5;

-- 3. Show top 5 countries by GDP in 2018
SELECT countries.name, country_stats.gdp FROM countries 
RIGHT JOIN country_stats ON countries.country_id=country_stats.country_id 
WHERE country_stats.year=2018 ORDER BY gdp DESC LIMIT 5;

-- 4. Count of countries associated with each region ID
SELECT region_id, COUNT(*) AS country_count
FROM countries
GROUP BY region_id
ORDER BY country_count DESC;

-- 5. Average area of countries in each region ID
SELECT region_id, ROUND(AVG(area)) AS avg_area
FROM countries
GROUP BY region_id
ORDER BY avg_area;

-- 6. Average country area less than 1000
SELECT region_id, ROUND(AVG(area)) AS avg_area
FROM countries
GROUP BY region_id
HAVING AVG(area) < 1000
ORDER BY avg_area;

-- 7. Population of every continent in 2018 in millions
SELECT continents.name, SUM(country_stats.population)/1000000 AS tot_pop
FROM continents 
JOIN regions ON continents.continent_id = regions.continent_id
JOIN countries ON regions.region_id = countries.region_id
JOIN country_stats ON countries.country_id = country_stats.country_id
WHERE country_stats.year = 2018 
GROUP BY continents.name 
ORDER BY tot_pop DESC;

-- 8. List countries without a language
SELECT countries.name 
FROM countries FULL JOIN country_languages 
ON countries.country_id = country_languages.country_id
FULL JOIN languages ON country_languages.language_id = languages.language_id
WHERE languages.language IS NULL;

-- 9. Top 10 countries with most languages
SELECT countries.name, COUNT(country_languages.language_id) AS lang_count 
FROM countries 
JOIN country_languages 
ON countries.country_id = country_languages.country_id
GROUP BY countries.name 
ORDER BY lang_count DESC, countries.name 
LIMIT 10;

-- 10. List of spoken languages in top 10 countries
SELECT countries.name, string_agg(languages.language, ', ') AS spoken_languages
FROM countries JOIN country_languages ON countries.country_id = country_languages.country_id
JOIN languages ON country_languages.language_id = languages.language_id
GROUP BY countries.name ORDER BY COUNT(country_languages.language_id) DESC, countries.name 
LIMIT 10;

-- 11. Average number of languages per country in each region
SELECT regions.name, ROUND(AVG(lang_count),1) AS avg_lang_count_per_country
FROM ( SELECT countries.region_id, COUNT(country_languages.language_id) AS lang_count
FROM countries LEFT JOIN country_languages ON countries.country_id = country_languages.country_id
GROUP BY countries.country_id) AS country_lang_count
JOIN regions ON country_lang_count.region_id = regions.region_id
GROUP BY regions.region_id
ORDER BY avg_lang_count_per_country DESC;

-- 12. Most recent and oldest national days
(SELECT name, national_day FROM countries
WHERE national_day = (SELECT MAX(national_day) FROM countries)
LIMIT 1) UNION ALL
(SELECT name, national_day FROM countries 
WHERE national_day = (SELECT MIN(national_day) FROM countries)
LIMIT 1);







