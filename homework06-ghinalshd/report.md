# Overview
1. Name / Title: Electric Vehicle Population Data
2. Link to Data: https://catalog.data.gov/dataset/electric-vehicle-population-data 
    * Format: csv
    * Size: 36.5 MB
    * Number of Records: 150483 rows
3. Source / Origin: 
	* Author or Creator: Washington State Department of Licensing (DOL)
	* Publication Date: 2022-06-16
	* Publisher: data.wa.gov
	* Version or Data Accessed: 2023-09-14
4. License: http://opendatacommons.org/licenses/odbl/1.0/ (intended for public access and use)
5. Can You Use this Data Set for Your Intended Use Case? Yes!

### Field/Column Headers:
* Field/Column 1: VIN (1-10), string
* Field/Column 2: County, string
* Field/Column 3: City, string
* Field/Column 4: State, string
* Field/Column 5: Postal Code, string
* Field/Column 6: Model Year, string
* Field/Column 7: Make, string
* Field/Column 8: Model, string
* Field/Column 9: Electric Vehicle Type, string
* Field/Column 10: Clean Alternative Fuel Vehicle (CAFV) Eligibility, string
* Field/Column 11: Electric Range, string
* Field/Column 12: Base MSRP, string
* Field/Column 13: Legislative District, string
* Field/Column 14: DOL Vehicle ID, string
* Field/Column 15: Vehicle Location, string
* Field/Column 16: Electric Utility, string
* Field/Column 17: 2020 Census Tract, string

# Table Design
* Field/Column 1: VIN (1-10) stands for Vehicle ID Number. This column will be used as our primary key since each vehicle must have a unique id. Since the vehicle id number consists of both letters and numbers with length ranging from 1-10, the field type is 'varchar' where I will additionally be implementing the "not null" function considering that each entry is unique
* Field/Column 4: the 'State' column has a field type of 'varchar' of length 2 since each state is abbreviated to two letters (e.g., the state of New York is represented as NY in the original csv file)
* Field/Column 6: the 'Model Year' column represents vehicle manufacturing year, and so the field type is an integer 
* Field/Column 7: this column represents the 'Make' of the vehicle; in other words, the make of the vehicle is considered to be the vehicle brand where the field type is 'varchar' 
* Field/Column 8: the 'Model' column specifies the vehicle's 'name'. In many cases, the model contains the make of the actual vehicle (the vehicle brand) as well as a numerical value that differentiates vehicles from the same make from one another. The field type for the 'Model' column is 'varchar'
* Field/Column 9: the 'Electric Vehicle Type' column contains two different entries: 'Battery Electric Vehicle (BEV)' and 'Plug-in Hybrid Electric Vehicle (PHEV)'. I will be normalizing the values by abbreviating 'Battery Electric Vehicle (BEV)' to 'BEV' and 'Plug-in Hybrid Electric Vehicle (PHEV)' to PHEV where the field type is 'varchar'
* Field/Column 10: the 'Clean Alternative Fuel Vehicle (CAFV) Eligibility' determines whether a vehicle is eligible for clean fuel based on battery range, and so the field type is a boolean value where T indicates elgibility and F indicates non-eligibility as well as unknown eligibility
* Field/Column 11: the 'Electric Range' column is the estimated number of miles the vehicle can travel (in miles) while charged before the battery runs out of fuel where the field type is an integer 
* Field/Column 17: the '2020 Census Tract' shows the relatively permanent geographic entities within counties (or the statistical equivalents of counties). The field type of the '2020 Census Tract' column is an integer, where all missing values are filled in by 0

### Columns Emitted
* Several columns from the original dataset were omitted due to their relevance and to avoid redundancy. I additionally preprocessed and cleaned the data in python where I used the 'to_csv' function to ensure smooth and accurate implementation in SQL 

# Import
ERROR: value "53077002803" is out of range for type integer

This error message indicates that while trying to insert or update a value in a PostgreSQL database, the given value (53077002803 in this case) exceeded the range allowed for the integer data type.
The integer type has a range from -2,147,483,648 to 2,147,483,647. The 53077002803 value is clearly outside of this range. Therefore, I managed to resolve the issue by changing the data type of the 'electric_range' field from integer to bigint, where the bigint type in PostgreSQL has a range from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807.

# Database Information

### Databases in the postgres instance

                                        List of databases
    Name    |      Owner      | Encoding | Collate | Ctype |          Access privileges          
------------+-----------------+----------+---------+-------+-------------------------------------
 homework06 | ghinaalshdaifat | UTF8     | C       | C     | 
 postgres   | ghinaalshdaifat | UTF8     | C       | C     | 
 template0  | ghinaalshdaifat | UTF8     | C       | C     | =c/ghinaalshdaifat                 +
            |                 |          |         |       | ghinaalshdaifat=CTc/ghinaalshdaifat
 template1  | ghinaalshdaifat | UTF8     | C       | C     | =c/ghinaalshdaifat                 +
            |                 |          |         |       | ghinaalshdaifat=CTc/ghinaalshdaifat
(4 rows)

### Tables in the 'homework06' database

                          List of relations
 Schema |               Name               | Type  |      Owner      
--------+----------------------------------+-------+-----------------
 public | electric_vehicle_population_data | table | ghinaalshdaifat
(1 row)

### Information about the electric vehicle data 

                 Table "public.electric_vehicle_population_data"
        Column         |          Type          | Collation | Nullable | Default 
-----------------------+------------------------+-----------+----------+---------
 vin                   | character varying(10)  |           | not null | 
 us_state              | character varying(2)   |           | not null | 
 model_year            | integer                |           |          | 
 make                  | character varying(255) |           |          | 
 model                 | character varying(255) |           |          | 
 electric_vehicle_type | character varying(4)   |           |          | 
 cafv_eligibility      | boolean                |           |          | 
 electric_range        | integer                |           |          | 
 census_tract          | bigint                 |           |          | 
 new_column            | character varying      |           |          | 

Indexes:
    "electric_vehicle_population_data_pkey" PRIMARY KEY, btree (vin)
Check constraints:
    "electric_vehicle_population_data_electric_vehicle_type_check" CHECK (electric_vehicle_type::text = ANY (ARRAY['BEV'::character varying, 'PHEV'::character varying]::text[]))

# Query Results

### 1. the total number of rows in the database

 count 
-------
  9671
(1 row)

### 2. show the first 15 rows, but only display 3 columns (your choice)

    vin     | us_state | model_year 
------------+----------+------------
 5UXTA6C05P | WA       |       2023
 5YJRE11B48 | BC       |       2008
 5YJSA1E24G | WA       |       2016
 1N4AZ1CP5J | WA       |       2018
 5YJ3E1EA6J | WA       |       2018
 1G1FW6S00H | WA       |       2017
 5YJ3E1EA0J | WA       |       2018
 1N4BZ1BV4M | WA       |       2021
 5YJ3E1EB3J | WA       |       2018
 SADHB2S1XK | WA       |       2019
 5YJXCAE21G | WA       |       2016
 1N4AZ0CP8D | WA       |       2013
 WBY1Z4C53F | WA       |       2015
 5YJ3E1EA3L | WA       |       2020
 WP0AC2Y13L | WA       |       2020
(15 rows)

### 3. do the same as above, but chose a column to sort on, and sort in descending order

    vin     | us_state | model_year 
------------+----------+------------
 JM3KKEHA3R | WA       |       2024
 WA15AAGE7R | WA       |       2024
 5UX43EU01R | WA       |       2024
 5UX43EU02R | WA       |       2024
 JTJHKCFZ3R | WA       |       2024
 WB523CF06R | WA       |       2024
 WA16AAGE6R | WA       |       2024
 WB523CF08R | WA       |       2024
 5UX43EU03R | WA       |       2024
 1GYKPMRLXR | WA       |       2024
 1C4RJXN67R | WA       |       2024
 5UX43EU0XR | WA       |       2024
 5UX43EU07R | WA       |       2024
 JTJHKCFZ1R | WA       |       2024
 ZASPATDW5R | WA       |       2024
(15 rows)

### 4. add a new column without a default value

### 5. set the value of that new column

### 6. show only the unique (non duplicates) of a column of your choice

         make         
----------------------
 ALFA ROMEO
 LUCID
 RIVIAN
 AUDI
 PORSCHE
 LINCOLN
 HYUNDAI
 AZURE DYNAMICS
 VOLKSWAGEN
 MITSUBISHI
 TESLA
 GENESIS
 LAND ROVER
 FORD
 CHRYSLER
 NISSAN
 MINI
 CADILLAC
 SUBARU
:

### 7.group rows together by a column value (your choice) and use an aggregate function to calculate something about that group 

 count |         make         
-------+----------------------
   332 | VOLKSWAGEN
    13 | ALFA ROMEO
    50 | LUCID
   818 | FORD
   219 | CHRYSLER
   371 | NISSAN
    98 | MINI
   103 | CADILLAC
    22 | SUBARU
    77 | POLESTAR
    54 | LEXUS
   290 | TOYOTA
    77 | JAGUAR
   300 | MERCEDES-BENZ
   109 | RIVIAN
     3 | TH!NK
     2 | WHEEGO ELECTRIC CARS
   209 | JEEP
   789 | AUDI
   739 | CHEVROLET
   382 | PORSCHE
    98 | MITSUBISHI
     1 | BENTLEY
    10 | FISKER
    79 | LINCOLN
   529 | KIA
    31 | MAZDA
    87 | HONDA
  1305 | TESLA
    35 | GENESIS
    74 | FIAT
    31 | LAND ROVER
    80 | SMART
   738 | BMW
   978 | VOLVO
   533 | HYUNDAI
     5 | AZURE DYNAMICS
(37 rows)

### 8. now, using the same grouping query or creating another one, find a way to filter the query results based on the values for the groups 

 count |     make      
-------+---------------
  1305 | TESLA
   978 | VOLVO
   818 | FORD
   789 | AUDI
   739 | CHEVROLET
   738 | BMW
   533 | HYUNDAI
   529 | KIA
   382 | PORSCHE
   371 | NISSAN
   332 | VOLKSWAGEN
   300 | MERCEDES-BENZ
   290 | TOYOTA
   219 | CHRYSLER
   209 | JEEP
   109 | RIVIAN
   103 | CADILLAC
(17 rows)

### 9. Calculate the average electric range for all vehicles

 electric_average_range 
------------------------
    53.6306483300589391
(1 row)

* query 9 calculates the average electric range for all vehicles in the database

### 10. Count how many vehicles are eligible and how many are not for CAFV

 cafv_eligibility | eligibility_count 
------------------+-------------------
 f                |              5717
 t                |              3954
(2 rows)

* query 10 counts how many vehicles are eligible and how many are not

### 11. List the top 5 makes with the highest average electric range

         make         | average_electric_range 
----------------------+------------------------
 JAGUAR               |   170.1818181818181818
 TESLA                |   156.5609195402298851
 TH!NK                |   100.0000000000000000
 WHEEGO ELECTRIC CARS |   100.0000000000000000
 FIAT                 |    85.3378378378378378
(5 rows)

* query 11 calculates the average electric range for each vehicle make and lists the top 5 makes with the highest averages

### 12. Count the number of unique makes whose vehicles have an electric range greater than the overall average electric range

 count 
-------
    21
(1 row)

* query 12 counts the number of unique vehicle makes where any of their vehicles have an electric range greater than the overall average electric range of the dataset
