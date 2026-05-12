ALTER DATABASE crowdfunding_project_grp_6
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

cREATE TABLE calendar_table (
    date DATE,
    Year INT,
    Month INT,
    Month_Name VARCHAR(20),
    Quarter VARCHAR(5),
    YearMonth VARCHAR(10),
    Day_of_Week INT,
    Day_Name VARCHAR(15),
    FinancialMonth VARCHAR(5),
    FinancialQuarter VARCHAR(5)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE Category (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    parent_id INT,
    position INT
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE Creator (
    id int PRIMARY KEY,
    name varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    del varchar(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;



cREATE TABLE location (
       id INT PRIMARY KEY,
    displayable_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    type VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    state VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    short_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    is_root VARCHAR(20),
    country VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
)  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;



ALTER TABLE calendar_table 
MODIFY date VARCHAR(10);

select * from calendar_table;

UPDATE calendar_table
SET date = STR_TO_DATE(date, '%d-%m-%Y');


load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\creator.csv'
into table creator
fields terminated by ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
ignore 1 rows;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\location.csv'
into table location
fields terminated by ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
ignore 1 rows;

ALTER TABLE calendar_table 
MODIFY date DATE;

alter table projects add column GOAL_USD decimal(12,2);

UPDATE projects SET GOAL_USD = GOAL * STATIC_USD_RATE;
set sql_safe_updates=0;

alter table projects add column goal_range varchar(30);
SET goal_range = CASE
    WHEN goal_usd < 5000 THEN 'Less than $5K'
    WHEN goal_usd BETWEEN 5000 AND 20000 THEN '$5K-$20K'
    WHEN goal_usd BETWEEN 20000 AND 50000 THEN '$20K-$50K'
    WHEN goal_usd BETWEEN 50000 AND 100000 THEN '$50K-$100K'
    ELSE 'More than $100K'
END;
