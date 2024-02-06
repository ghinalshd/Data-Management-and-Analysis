DROP TABLE IF EXISTS staging_caers_event_product;
-- Create a staging table for the caers_event_product table
CREATE TABLE staging_caers_event_product(
    -- Artificial primary key
    staging_caers_event_product_id serial primary key,
    created_date date,
    report_id varchar(255),
    event_date date,
    product_type text,
    product text,
    product_code text,
    description text,
    patient_age numeric,
    age_units varchar(255),
    sex varchar(255),
    terms text,
    outcomes text);
