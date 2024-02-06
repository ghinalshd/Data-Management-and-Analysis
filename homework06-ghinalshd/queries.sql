-- write your queries underneath each number:
 
-- 1. the total number of rows in the database
SELECT COUNT(*) FROM electric_vehicle_population_data;

-- 2. show the first 15 rows, but only display 3 columns (your choice)
SELECT vin, us_state, model_year FROM electric_vehicle_population_data LIMIT 15;

-- 3. do the same as above, but chose a column to sort on, and sort in descending order
SELECT vin, us_state, model_year FROM electric_vehicle_population_data ORDER BY model_year DESC LIMIT 15;

-- 4. add a new column without a default value
ALTER TABLE electric_vehicle_population_data ADD COLUMN new_column VARCHAR;

-- 5. set the value of that new column
UPDATE electric_vehicle_population_data SET new_column = 'New Value';

-- 6. show only the unique (non duplicates) of a column of your choice
SELECT DISTINCT make FROM electric_vehicle_population_data;

-- 7.group rows together by a column value (your choice) and use an aggregate function to calculate something about that group 
SELECT COUNT(*), make FROM electric_vehicle_population_data GROUP BY make;

-- 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups 
SELECT COUNT(*), make 
FROM electric_vehicle_population_data 
GROUP BY make 
HAVING COUNT(*) > 100 --filters manuafacturers with more than 100 cars
ORDER BY COUNT(*) DESC; --orders vehicles in descending order

-- 9. Calculate the average electric range for all vehicles
SELECT AVG(electric_range) AS electric_average_range FROM electric_vehicle_population_data;
-- query 9 calculates the average electric range for all vehicles in the database

-- 10. Count how many vehicles are eligible and how many are not for CAFV
SELECT cafv_eligibility, COUNT(*) AS eligibility_count FROM electric_vehicle_population_data GROUP BY cafv_eligibility;
-- query 10 counts how many vehicles are eligible and how many are not

-- 11. List the top 5 makes with the highest average electric range
SELECT make, AVG(electric_range) AS average_electric_range FROM electric_vehicle_population_data GROUP BY make 
ORDER BY average_electric_range DESC 
LIMIT 5;
-- query 11 calculates the average electric range for each vehicle make and lists the top 5 makes with the highest averages

-- 12. Count the number of unique makes whose vehicles have an electric range greater than the overall average electric range
SELECT COUNT(DISTINCT make) 
FROM electric_vehicle_population_data 
WHERE electric_range > (SELECT AVG(electric_range) FROM electric_vehicle_population_data);
-- query 12 counts the number of unique vehicle makes where any of their vehicles have an electric range greater than the overall average electric range of the dataset
