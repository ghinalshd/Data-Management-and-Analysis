DROP TABLE IF EXISTS product;

CREATE TABLE IF NOT EXISTS product(
	PRIMARY KEY (product_type, product),
    product_type text,
    product text,
    product_code text
   	);
	
DROP TABLE IF EXISTS patient;

CREATE TABLE IF NOT EXISTS patient(
	PRIMARY KEY (report_id),
    report_id character varying(255),
    patient_id character varying(255),
    patient_age numeric,
    age_units character varying(255),
    terms text,
    sex character varying(255),
    outcomes text
);

DROP TABLE IF EXISTS product_description;

CREATE TABLE IF NOT EXISTS product_description(
	PRIMARY KEY (product_code),
    product_code text,
    description text
);


DROP TABLE IF EXISTS report;

CREATE TABLE IF NOT EXISTS report(
	staging_caers_event_product_id serial PRIMARY KEY,
    created_date date,
    report_id character varying(255),
    event_date date,
    product_type text,
    product text
);

DROP TABLE IF EXISTS outcomes;

CREATE TABLE IF NOT EXISTS outcomes(
    outcome_id serial PRIMARY KEY,
    outcome_description text,
);
