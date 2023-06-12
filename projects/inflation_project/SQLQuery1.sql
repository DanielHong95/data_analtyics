Select * from cpi_all

 -- Join CPI Data into one table

SELECT cpia.date, cpia.cpi_all, cpig.cpi_gas, cpie.cpi_mpfe
FROM inflation_project..cpi_all cpia
	JOIN inflation_project..cpi_gas cpig ON cpia.date = cpig.date
	JOIN inflation_project..cpi_mpfe cpie ON cpia.date = cpie.date

-- Create Table 

DROP TABLE IF EXISTS #cpi_comparison
CREATE TABLE #cpi_comparison
(
Date datetime,
cpi_all decimal (5,2),
cpi_gas decimal (5,2),
cpi_mpfe decimal (5,2)
)

INSERT INTO #cpi_comparison
SELECT cpia.date, cpia.cpi_all, cpig.cpi_gas, cpie.cpi_mpfe
FROM inflation_project..cpi_all cpia
	JOIN inflation_project..cpi_gas cpig ON cpia.date = cpig.date
	JOIN inflation_project..cpi_mpfe cpie ON cpia.date = cpie.date
WHERE cpia.date >= '2020-1-1'

SELECT * FROM #cpi_comparison

-- Create View

CREATE VIEW
cpi_comparison AS
SELECT cpia.date, cpia.cpi_all, cpig.cpi_gas, cpie.cpi_mpfe
FROM inflation_project..cpi_all cpia
	JOIN inflation_project..cpi_gas cpig ON cpia.date = cpig.date
	JOIN inflation_project..cpi_mpfe cpie ON cpia.date = cpie.date

SELECT * FROM cpi_comparison

-- calm financials

select * from calm_financials

SELECT cpie.date, cpie.cpi_mpfe, calm.gross_profits_millions, calm.gross_profits_millions
FROM inflation_project..cpi_mpfe cpie
	full outer join inflation_project..calm_financials calm ON cpie.date = calm.date

drop table calm_financials