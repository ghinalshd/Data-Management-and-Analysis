-- TODO: write the task number and description followed by the query
-- 1. This view left joins two tables, athlete_event and noc_region 
DROP VIEW IF EXISTS athlete_event_noc_region;
CREATE VIEW athlete_event_noc_region AS
SELECT ae.*, nr.region
FROM athlete_event AS ae
LEFT JOIN noc_region AS nr ON ae.noc = nr.noc;

-- 2. using rank() function this query shows the top 3 ranked regions for each fencing event based on the 
--    # of total gold medalists for a specific region 
SELECT COALESCE(aenr.region, CASE WHEN aenr.noc = 'SGP' THEN 'Singapore'
WHEN aenr.noc = 'ROT' THEN 'Refugee' WHEN aenr.noc = 'TUV' THEN 'Tuvalu'
WHEN aenr.noc = 'UNK' THEN 'Unknown' ELSE aenr.team END) AS region, aenr.event,
COUNT(CASE WHEN aenr.medal = 'Gold' THEN 1 END) AS gold_medals,
RANK() OVER (PARTITION BY aenr.event ORDER BY COUNT(CASE WHEN aenr.medal = 'Gold' THEN 1 END) DESC) AS rank
FROM athlete_event_noc_region AS aenr
WHERE aenr.sport = 'Fencing'
GROUP BY aenr.event, aenr.region, aenr.noc, aenr.team
HAVING COUNT(CASE WHEN aenr.medal = 'Gold' THEN 1 END) > 0
ORDER BY aenr.event ASC, rank ASC;

-- 3. this query shows the rolling sum of medals per region, per year, and per medal type using aggregate functions as window functions
SELECT CASE WHEN athlete_event.noc = 'SGP' THEN 'Singapore'
    WHEN noc_region.region IS NULL THEN athlete_event.team
    ELSE noc_region.region END AS region,
  athlete_event.year,
  athlete_event.medal,
  COUNT(*) AS c, SUM(COUNT(*))
  OVER (PARTITION BY noc_region.region, athlete_event.medal  
  ORDER BY noc_region.region, athlete_event.year, athlete_event.medal)
  AS sum
FROM  athlete_event LEFT JOIN noc_region ON athlete_event.noc = noc_region.noc
WHERE medal IS NOT NULL GROUP BY 
  athlete_event.noc, athlete_event.year, 
  athlete_event.medal, athlete_event.team, noc_region.region
ORDER BY region, year, medal;


-- 4. this query show the height of every gold medalist for pole valut events, 
--    along with the height of the gold medalist for that same pole value event in the previous year
SELECT ae.event, ae.year, ae.height,
LAG(ae.height) OVER (PARTITION BY ae.event ORDER BY ae.year) AS previous_height
FROM athlete_event AS ae
WHERE ae.medal = 'Gold' AND ae.sport = 'Athletics' AND ae.event LIKE '%Pole Vault%'
GROUP BY ae.height, ae.event, ae.year
HAVING ae.height IS NOT NULL
ORDER BY ae.event, ae.year ASC;
