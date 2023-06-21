-- QUERIES FOR TABLEAU EXPORT -- 

-- count of total breweries and beers in US

SELECT COUNT(DISTINCT brewery_name) as total_brewery_count
FROM breweries

SELECT COUNT(DISTINCT beer_name) as total_beer_count
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

-- What beer styles are most brewed in each state

SELECT state, style, COUNT(*) as style_count
FROM beers_breweries
GROUP BY state, style
HAVING COUNT(*) = (
    SELECT MAX(style_count)
    FROM (
        SELECT state, style, COUNT(*) as style_count
        FROM beers_breweries
        GROUP BY state, style
    ) AS counts
    WHERE counts.state = beers_breweries.state
)
ORDER BY 3 DESC
