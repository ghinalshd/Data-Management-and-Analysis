COPY staging_caers_event_product(
    created_date, 
    report_id, 
    event_date, 
    product_type,
    product, 
    product_code, 
    description, 
    patient_age,
    age_units, 
    sex, 
    terms, 
    outcomes) 
FROM '/Users/ghinaalshdaifat/Desktop/homework07-ghinalshd/caers.csv'
(format csv, header, encoding 'LATIN1');