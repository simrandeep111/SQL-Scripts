use Netflix;
CREATE TABLE netflix_titles (
    show_id VARCHAR(10),
    `type` VARCHAR(20),
    title VARCHAR(255),
    director VARCHAR(255),
    `cast` TEXT,
    country VARCHAR(255),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(50),
    listed_in VARCHAR(255),
    `description` TEXT
);
ALTER TABLE netflix_titles ADD FULLTEXT(description);
LOAD DATA LOCAL INFILE 'D:/sql scripts/archive/netflix_titles.csv'
INTO TABLE netflix_titles
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS;

SET GLOBAL local_infile = 1;
select * from netflix_titles;

WITH RankedShows AS (
    SELECT 
        country, title, date_added,
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY STR_TO_DATE(date_added, '%d-%b-%y') DESC) AS rnk
    FROM netflix_titles
    WHERE country IS NOT NULL
)
SELECT country, title, date_added
FROM RankedShows
WHERE rnk = 1;
SELECT listed_in, COUNT(*) AS count
FROM netflix_titles
GROUP BY listed_in
ORDER BY count DESC
LIMIT 3;
WITH YearlyCounts AS (
    SELECT release_year, COUNT(*) AS total_shows
    FROM netflix_titles
    GROUP BY release_year
),
Total AS (
    SELECT SUM(total_shows) AS all_shows FROM YearlyCounts
)
SELECT y.release_year, y.total_shows, 
       ROUND((y.total_shows / t.all_shows) * 100, 2) AS percentage_of_total
FROM YearlyCounts y, Total t
ORDER BY y.release_year DESC;
SELECT title, type, duration
FROM netflix_titles
WHERE duration = (SELECT MAX(CAST(duration AS SIGNED)) FROM netflix_titles WHERE type='Movie')
   OR duration = (SELECT MAX(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS SIGNED)) FROM netflix_titles WHERE type='TV Show');
   
SELECT title, director
FROM netflix_titles
WHERE director LIKE '%,%';

SELECT title, 
       JSON_ARRAYAGG(listed_in) AS genres 
FROM netflix_titles
GROUP BY title;


SELECT country, COUNT(*) AS total_shows,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
LIMIT 10;

SELECT title, description
FROM netflix_titles
WHERE MATCH(description) AGAINST('Time Travel History' IN NATURAL LANGUAGE MODE);

SELECT rating, COUNT(*) AS total
FROM netflix_titles
GROUP BY rating
ORDER BY total DESC;

SELECT title, date_added 
FROM netflix_titles
WHERE date_added = (SELECT MIN(date_added) FROM netflix_titles)
   OR date_added = (SELECT MAX(date_added) FROM netflix_titles);
   
   
   WITH RatingStats AS (
    SELECT 
        rating, 
        COUNT(*) AS total,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_position
    FROM netflix_titles
    WHERE rating IS NOT NULL
    GROUP BY rating
),
TopRatings AS (
    SELECT rating, total 
    FROM RatingStats
    WHERE rank_position <= 5  -- Fetch top 5 most frequent ratings
)
SELECT 
    nt.rating, 
    COUNT(*) AS total, 
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage,  -- % share of each rating
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_position,
    SUM(CASE WHEN nt.type = 'Movie' THEN 1 ELSE 0 END) AS movie_count,
    SUM(CASE WHEN nt.type = 'TV Show' THEN 1 ELSE 0 END) AS tv_show_count
FROM netflix_titles nt
WHERE nt.rating IN (SELECT rating FROM TopRatings)  -- Filter only top 5 ratings
GROUP BY nt.rating
ORDER BY total DESC;





