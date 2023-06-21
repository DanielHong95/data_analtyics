-- EXPLORING DATA --

select * from craft_beer_project..beers

select * from craft_beer_project..breweries

-- count of all breweries in US

SELECT COUNT(DISTINCT brewery_name) as brewery_count
FROM breweries

-- count of all distinct beers in US

SELECT COUNT(DISTINCT beer_name) as beer_count
FROM beers

-- count of breweries per state

SELECT state, COUNT(*) as brewery_count
FROM breweries
GROUP BY state
HAVING COUNT(*) >= 1
ORDER BY 2 DESC

-- count of breweries per city

SELECT city, state, COUNT(*) as city_count
FROM breweries
GROUP BY city, state
HAVING COUNT(*) >= 1
ORDER BY 3 DESC

SELECT city, state, brewery_name
FROM breweries
WHERE city like 'Dallas'

-- count of beer styles

SELECT style, COUNT(*) as style_count
FROM beers
GROUP BY style
HAVING COUNT(*) >= 1
ORDER BY 2 DESC

-- join breweries and beers tables

SELECT id, beer_name, style, brew.brewery_id, brewery_name, city, state
FROM craft_beer_project..beers br
	JOIN craft_beer_project..breweries brew ON br.brewery_id = brew.brewery_id

-- temp table

DROP TABLE IF EXISTS #breweries_beers
CREATE TABLE #breweries_beers
(
id numeric,
beer_name nvarchar (255),
style nvarchar (255),
brewery_id numeric,
brewery_name nvarchar (255),
city nvarchar (255),
state nvarchar (255)
)

INSERT INTO #breweries_beers
SELECT id, beer_name, style, brew.brewery_id, brewery_name, city, state
FROM craft_beer_project..beers br
	JOIN craft_beer_project..breweries brew ON br.brewery_id = brew.brewery_id

SELECT * FROM #breweries_beers

-- create view

CREATE VIEW
beers_breweries AS
SELECT id, beer_name, style, brew.brewery_id, brewery_name, city, state
FROM craft_beer_project..beers br
	JOIN craft_beer_project..breweries brew ON br.brewery_id = brew.brewery_id

SELECT * FROM beers_breweries

-- What beer style is most brewed in each state

SELECT state, style, COUNT(*) as style_count
FROM #breweries_beers
GROUP BY state, style
HAVING COUNT(*) = (
    SELECT MAX(style_count)
    FROM (
        SELECT state, style, COUNT(*) as style_count
        FROM #breweries_beers
        GROUP BY state, style
    ) AS counts
    WHERE counts.state = #breweries_beers.state
)
ORDER BY 3 DESC

-- What beer style is most brewed in each state (non repeating state)

SELECT state, style, style_count
FROM (
    SELECT state, style, COUNT(*) as style_count,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY COUNT(*) DESC) as rn
    FROM #breweries_beers
    GROUP BY state, style
) 
subquery
WHERE rn = 1;