-- SCHEMAS of Netflix

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

SELECT * FROM netflix_titles;


-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*) as total_content
FROM netflix_titles
GROUP BY 1;


-- 2. Find the most common rating for movies and TV shows
SELECT 
	type,
    rating
FROM
(
	SELECT 
		type,
        rating,
        COUNT(*),
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
    FROM netflix_titles
    GROUP BY 1,2
) as t1 
WHERE ranking = 1;
-- 3. List all movies released in a specific year (e.g., 2021)
SELECT * FROM netflix_titles
WHERE
type='Movie'
AND
release_year=2021;


-- 4. Find the top 5 countries with the most content on netflix_titles
SELECT * 
FROM
(
	SELECT 
		country,
		COUNT(*) as total_content
	FROM netflix_titles
	GROUP BY 1
)as t1
WHERE country IS NOT NULL AND TRIM(country) != ''
ORDER BY total_content DESC
LIMIT 5;
-- 5. Identify the longest movie
SELECT *FROM netflix_titles
WHERE
type='Movie'
AND
duration=(SELECT MAX(duration) from netflix_titles);
-- 6. Find content added in the last 5 years
SELECT *
FROM netflix_titles
WHERE 
date_added IS NOT NULL
AND STR_TO_DATE(TRIM(date_added), '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;
-- 7. Find all the movies/TV shows by director 'Bruno Garotti'!
SELECT * FROM netflix_titles 
WHERE director LIKE '%Bruno Garotti%';
-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix_titles
WHERE 
	TYPE = 'TV Show'
	AND
	duration > '5 sessions';
    
    
-- 9. Count the number of content items in each genre
SELECT 
  TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS genre,
  COUNT(*) AS total_content
FROM netflix_titles
WHERE listed_in IS NOT NULL
GROUP BY genre
ORDER BY total_content DESC;
-- 10. Find each year and the average numbers of content release by India on netflix_titles. 
-- return top 5 year with highest avg content release !
SELECT 
  GROUP_CONCAT(DISTINCT countries) AS all_countries,
  AVG(daily_content_count) AS avg_content_per_date
FROM (
  SELECT 
    date_added,
    GROUP_CONCAT(DISTINCT country) AS countries,
    COUNT(*) AS daily_content_count
  FROM netflix_titles
  WHERE country LIKE '%India%'
    AND date_added IS NOT NULL
  GROUP BY date_added
) AS sub;
-- 11. List all movies that are documentaries
SELECT * FROM netflix_titles
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

-- 12. Find all content without a director
SELECT *
FROM netflix_titles
WHERE director IS NULL OR TRIM(director) = '';

-- 13. Find how many movies actor 'Ama Qamata' appeared in last 10 years!
SELECT 
  title,
  COUNT(*) OVER () AS total_movies
FROM netflix_titles
WHERE 
  `cast` LIKE '%Ama Qamata%'
  AND release_year >= YEAR(CURDATE()) - 10;
  
-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT actor, COUNT(*) AS total_movies
FROM (
  SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', 1), ',', -1)) AS actor
  FROM netflix_titles
  WHERE country LIKE '%India%' AND `cast` IS NOT NULL

  UNION ALL

  SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', 2), ',', -1)) AS actor
  FROM netflix_titles
  WHERE country LIKE '%India%' AND `cast` IS NOT NULL

  UNION ALL

  SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`cast`, ',', 3), ',', -1)) AS actor
  FROM netflix_titles
  WHERE country LIKE '%India%' AND `cast` IS NOT NULL
) AS all_actors
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;
/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix_titles
) AS categorized_content
GROUP BY 1,2
ORDER BY 2



