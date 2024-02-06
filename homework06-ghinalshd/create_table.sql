-- write your table creation sql here!
-- Drop the table if it already exists
DROP TABLE IF EXISTS electric_vehicle_population_data;
-- Create the table with the columns we want and their specific data types
CREATE TABLE electric_vehicle_population_data (
    vin VARCHAR(10) PRIMARY KEY NOT NULL,
    us_state VARCHAR(2) NOT NULL,
    model_year INT,
    make VARCHAR(255),
    model VARCHAR(255),
    electric_vehicle_type VARCHAR(4) CHECK (electric_vehicle_type IN ('BEV', 'PHEV')),
    cafv_eligibility BOOLEAN,
    electric_range INT,
    census_tract BIGINT
);
