-- write your COPY statement to import a csv here
COPY electric_vehicle_population_data(
    vin, 
    us_state, 
    model_year, 
    make, 
    model, 
    electric_vehicle_type, 
    cafv_eligibility, 
    electric_range, 
    census_tract)
FROM '/Users/ghinaalshdaifat/Desktop/homework06-ghinalshd/Electric_Vehicle_Population_Data.csv' 
DELIMITER ',' 
CSV HEADER;


