-- TODO: use explain / analyze, create an index
-- 1. Drop an existing index (in case you've created an index already)
DROP INDEX if exists athlete_event_name_idx;

-- 2. Show all rows that contain the athlete Michael Fred Phelps, II 
SELECT * FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- 3. Using EXPLAIN ANALYZE we can show how much time it takes to run 2. query
EXPLAIN ANALYZE SELECT * FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- 4. Add an index to the name column of the athlete_event table
CREATE INDEX athlete_event_name_idx ON athlete_event (name);

-- 5. Repeating query 3. to verify improved performance 
EXPLAIN ANALYZE SELECT * FROM athlete_event
WHERE name = 'Michael Fred Phelps, II';

-- 6. Write a query using the name column in the where clause, 
--    use other operation or filter so that the index is not used 
SELECT * FROM athlete_event
WHERE name ILIKE '%Phelps%' AND year >= 2010;-- TODO: use explain / analyze, create an index
