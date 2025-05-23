DROP DATABASE IF EXISTS hospitality;
CREATE DATABASE hospitality;
USE hospitality;

CREATE TABLE dim_date (
    date_key VARCHAR(30) PRIMARY KEY,
    date DATE,
    mmm_yy VARCHAR(30),
    week_no VARCHAR(20),
    day_type VARCHAR(20)
);

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date (
    date_key VARCHAR(30) PRIMARY KEY,
    mmm_yy VARCHAR(30),
    week_no VARCHAR(20),
    day_type VARCHAR(20)
);

SELECT COUNT(*) FROM dim_date;
SELECT * FROM dim_date LIMIT 5;

DROP TABLE IF EXISTS dim_hotels;

CREATE TABLE dim_hotels (
    property_id INT PRIMARY KEY,
    property_name VARCHAR(100),
    category VARCHAR(100),
    city VARCHAR(100)
);

SELECT COUNT(*) FROM dim_hotels;
SELECT * FROM dim_hotels LIMIT 5;

DROP TABLE IF EXISTS dim_rooms;

CREATE TABLE dim_rooms (
    room_id INT PRIMARY KEY,
    room_class VARCHAR(50),
    max_occupancy INT
);

SELECT COUNT(*) FROM dim_rooms;
SELECT * FROM dim_rooms LIMIT 5;

DROP TABLE IF EXISTS dim_rooms;

CREATE TABLE dim_rooms (
    room_id INT PRIMARY KEY,
    room_class VARCHAR(50)
);

SELECT COUNT(*) FROM dim_rooms;
SELECT * FROM dim_rooms LIMIT 5;

DROP TABLE IF EXISTS dim_rooms;

CREATE TABLE dim_rooms (
    room_id VARCHAR(10) PRIMARY KEY,
    room_class VARCHAR(50)
);

SELECT * FROM dim_rooms;
SELECT COUNT(*) FROM dim_rooms;

DROP TABLE IF EXISTS fact_bookings;

CREATE TABLE fact_bookings (
    booking_id VARCHAR(20) PRIMARY KEY,
    property_id INT,
    booking_date VARCHAR(30),
    check_in_date VARCHAR(30),
    checkout_date VARCHAR(30),
    no_guests INT,
    room_category VARCHAR(10),
    booking_platform VARCHAR(50),
    ratings_given FLOAT,
    booking_status VARCHAR(30),
    revenue_generated DECIMAL(10,2),
    revenue_realized DECIMAL(10,2)
);

DROP TABLE IF EXISTS fact_bookings;

CREATE TABLE fact_bookings (
    booking_id VARCHAR(20) PRIMARY KEY,
    property_id INT,
    booking_date VARCHAR(30),
    check_in_date VARCHAR(30),
    checkout_date VARCHAR(30),
    no_guests INT,
    room_category VARCHAR(10),
    booking_platform VARCHAR(50),
    ratings_given VARCHAR(10),
    booking_status VARCHAR(30),
    revenue_generated DECIMAL(10,2),
    revenue_realized DECIMAL(10,2)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_bookings.csv'
INTO TABLE fact_bookings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS fact_bookings;

CREATE TABLE fact_bookings (
    booking_id VARCHAR(20),
    property_id INT,
    booking_date VARCHAR(30),
    check_in_date VARCHAR(30),
    checkout_date VARCHAR(30),
    no_guests INT,
    room_category VARCHAR(10),
    booking_platform VARCHAR(50),
    ratings_given VARCHAR(10),
    booking_status VARCHAR(30),
    revenue_generated DECIMAL(10,2),
    revenue_realized DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_bookings.csv'
INTO TABLE fact_bookings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM fact_bookings;
SELECT * FROM fact_bookings LIMIT 5;

DROP TABLE IF EXISTS fact_aggregated_bookings;

CREATE TABLE fact_aggregated_bookings (
    property_id INT,
    check_in_date VARCHAR(30),
    capacity INT,
    successful_bookings INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_aggregated_bookings.csv'
INTO TABLE fact_aggregated_bookings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS fact_aggregated_bookings;

CREATE TABLE fact_aggregated_bookings (
    property_id INT,
    check_in_date VARCHAR(30),
    room_category VARCHAR(10),
    successful_bookings INT,
    capacity INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_aggregated_bookings.csv'
INTO TABLE fact_aggregated_bookings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM fact_aggregated_bookings;
SELECT * FROM fact_aggregated_bookings LIMIT 5;

SELECT * FROM fact_bookings LIMIT 10;

SELECT COUNT(booking_id) AS Total_Bookings
FROM fact_bookings;

SELECT 
    ROUND(COUNT(CASE WHEN booking_status = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*), 2)
    AS cancellation_rate_percentage
FROM fact_bookings;

SELECT 
    ROUND(SUM(successful_bookings) * 100.0 / SUM(capacity), 2) AS occupancy_percentage
FROM fact_aggregated_bookings;

SELECT SUM(capacity) AS Total_Capacity
FROM fact_aggregated_bookings;

SELECT *
FROM fact_bookings
WHERE booking_status IN ('Checked Out', 'Cancelled', 'No Show')
ORDER BY booking_status;

SELECT 
    SUM(f.successful_bookings) AS total_revenue
FROM 
    fact_aggregated_bookings f
JOIN 
    dim_date d ON f.check_in_date = d.date_key;
    
    SELECT 
    d.day_type,
    COUNT(f.booking_id) AS total_bookings,
    SUM(f.revenue_realized) AS total_revenue
FROM 
    fact_bookings f
JOIN 
    dim_date d ON f.check_in_date = d.date_key
GROUP BY 
    d.day_type;
    
    SELECT DISTINCT check_in_date FROM fact_bookings LIMIT 10;
    
    SELECT DISTINCT date_key FROM dim_date LIMIT 10;
    
    ALTER TABLE dim_date ADD COLUMN formatted_date DATE;
    
    UPDATE dim_date
SET formatted_date = STR_TO_DATE(date_key, '%e-%b-%y');

UPDATE dim_date
SET formatted_date = STR_TO_DATE(date_key, '%e-%b-%y');

UPDATE dim_date
SET formatted_date = STR_TO_DATE(date_key, '%e-%b-%y')
WHERE date_key IS NOT NULL;

SELECT 
    CASE 
        WHEN DAYOFWEEK(check_in_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS total_bookings,
    SUM(revenue_realized) AS total_revenue
FROM 
    fact_bookings
WHERE 
    booking_status = 'Checked Out'
GROUP BY 
    day_type;
    
    SELECT 
    dr.room_class,
    SUM(fb.revenue_realized) AS total_revenue
FROM 
    fact_bookings fb
JOIN 
    dim_rooms dr
    ON fb.room_category = dr.room_id
WHERE 
    fb.booking_status = 'Checked Out'
GROUP BY 
    dr.room_class;
    
    SELECT 
    h.city AS city,
    h.property_name AS hotel_name,
    SUM(b.revenue_realized) AS total_revenue
FROM 
    fact_bookings b
JOIN 
    dim_hotels h ON b.property_id = h.property_id
WHERE 
    b.booking_status = 'Checked Out'
GROUP BY 
    h.city, h.property_name
ORDER BY 
    h.city, total_revenue DESC;
    
    SELECT
    DATE_FORMAT(booking_date, '%b-%Y') AS month_year,
    SUM(revenue_generated) AS total_revenue_generated,
    SUM(revenue_realized) AS total_revenue_realized
FROM
    fact_bookings
GROUP BY
    DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY
    STR_TO_DATE(DATE_FORMAT(booking_date, '%Y-%m-01'), '%Y-%m-%d');
    
    SELECT
    YEAR(booking_date) AS year,
    SUM(revenue_generated) AS total_revenue_generated,
    SUM(revenue_realized) AS total_revenue_realized
FROM
    fact_bookings
GROUP BY
    YEAR(booking_date)
ORDER BY
    year;