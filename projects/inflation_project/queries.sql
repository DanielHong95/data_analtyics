-- Join all tables
SELECT t1.Date, CPI_all, CPI_gas, CPI_mpfe, corp_profits_billions, CALM_gross_profits_millions, XOM_gross_profits_millions, avg_egg_price_dozen, avg_price_gas_gallon
FROM cpi_all t1
LEFT JOIN cpi_gas t2 ON t1.Date = t2.Date
LEFT JOIN cpi_meats_poultry_fish_eggs t3 ON t1.Date = t3.Date
LEFT JOIN corp_profits t4 ON t1.Date = t4.Date
LEFT JOIN calm_profits t5 ON t1.Date = t5.Date
LEFT JOIN xom_profits t6 ON t1.Date = t6.Date
LEFT JOIN egg_price t7 ON t1.Date = t7.Date
LEFT JOIN gas_price t8 ON t1.Date = t8.Date;

-- create view
CREATE VIEW
inflation_data AS
SELECT t1.Date, CPI_all, CPI_gas, CPI_mpfe, corp_profits_billions, CALM_gross_profits_millions, XOM_gross_profits_millions, avg_egg_price_dozen, avg_price_gas_gallon
FROM cpi_all t1
LEFT JOIN cpi_gas t2 ON t1.Date = t2.Date
LEFT JOIN cpi_meats_poultry_fish_eggs t3 ON t1.Date = t3.Date
LEFT JOIN corp_profits t4 ON t1.Date = t4.Date
LEFT JOIN calm_profits t5 ON t1.Date = t5.Date
LEFT JOIN xom_profits t6 ON t1.Date = t6.Date
LEFT JOIN egg_price t7 ON t1.Date = t7.Date
LEFT JOIN gas_price t8 ON t1.Date = t8.Date;

SELECT * FROM inflation_data
order by date desc

