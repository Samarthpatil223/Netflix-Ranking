-- create table
CREATE TABLE netflix (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(20),
    title VARCHAR(150),
    director VARCHAR(210),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(100),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

-- displays all content of netflix table
SELECT * FROM netflix;

-- counts the total no.of content in netflix table
SELECT 
COUNT(*) as total_content
FROM netflix;

-- displays different types of content in the netflix table
SELECT 
DISTINCT type 
FROM netflix;

-- 15 buisness problems

-- 1. Count the number of Movies vs TV Shows
SELECT 
type,
COUNT(*) as total_content
FROM netflix
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows

-- This query retrieves all records from the netflix table and returns the values in the type and rating columns for each record.

-- SELECT Clause:
-- This part specifies the columns you want to retrieve from the database. In this case, you are selecting two columns: type and rating.
-- FROM Clause:
-- This indicates the source of the data, which in this case is the table named netflix.

-- SELECT 
-- type,
-- rating
-- FROM netflix;



-- This query retrieves the count of entries for each unique combination of type and rating from the netflix table.
-- The results will be grouped so that you see how many entries correspond to each type and rating pair.
-- The output will be sorted first by type in ascending order, and then within each type, it will be sorted by the count in descending order.

-- GROUP BY Clause:
-- The GROUP BY 1, 2 indicates that the results should be grouped by the first column (type) and the second column (rating).
-- This means each unique combination of type and rating will be considered as a group.

-- COUNT(*):
-- This function counts the number of rows in each group. So, for each unique type and rating combination,
-- it will return the total number of occurrences.
-- means that type Movie and rating TV-MA is one group and their total count in the table is 2062

-- ORDER BY CLAUSE:
-- The ORDER BY 1, 3 DESC specifies the order of the results:
-- 1 refers to the first column (type), which means the results will be sorted by type in ascending order.
-- 3 DESC refers to the third column (the count), which means the counts will be sorted in descending order within each type.

-- SELECT 
-- type,
-- rating,
-- COUNT(*)
-- FROM netflix
-- GROUP BY 1,2
-- ORDER BY 1,3 DESC


-- Aggregate cannot used on text or string
-- RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking:
-- This uses the RANK() window function to assign a rank to each row based on the count of rows. 
-- The partitioning is done by type, meaning the ranking restarts for each type group.
-- It orders the counts in descending order, so the highest count gets the rank of 1.

SELECT 
type,
rating
FROM(
SELECT 
type,
rating,
COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1,2
)
WHERE ranking =1

-- 3. List all movies of the specific year (2020)

SELECT 
* 
FROM netflix
WHERE
type='Movie'
AND
release_year=2020;


-- Find top 5 countries with most content on netflix

SELECT 
UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--Identify the longest movie

SELECT
* 
FROM netflix
WHERE
	type='Movie'
	AND
	duration=(SELECT MAX(duration) FROM netflix);


-- Find out the content which was in last 5 years

SELECT 
    *
	FROM netflix
WHERE 	
     TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- TV shows and movies directed By 'Rajiv Chilaka'

SELECT 
	*
	FROM netflix
WHERE 
	director ILIKE '%Rajiv Chilaka%' -- multiple directors where Rajiv Chilaka is present will also be displayed
-- LIKE will be case sensitive eg -> Ragiv Chilaka
-- ILIKE is not case sensitive eg -> it can take both ragiv chilaka and Rajiv Chilaka als

-- List all TV shows with more than 5 seasons

SELECT 
    title
FROM netflix
WHERE 
    type = 'TV Show'
    AND 
	SPLIT_PART(duration, ' ', 1)::numeric > 5;  -- if I need everything before first space then use it  delemiter is space , converted to number

-- count the number of content item of each genre(listed_in)

SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;
