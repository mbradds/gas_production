--create view vwMarketableGasProduction as

with ab_cte as
(
select [Date], 
([Well Production] + [In Situ Well Production]) - ([Flare]+[Fuel]+[Vent]+[Shrinkage]+[Acid Gas Injection]+[Gas Injection]) as [AB Marketable Gas (103m3)]
from
(

SELECT 
[Category],[Value],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Production' and Category = 'Well Production'

union all

SELECT 
[Category],[Value],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Production' and Category = 'In Situ Well Production'

union all

SELECT 
[Category],[Value],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Field Gas Use' and Category in ('Flare', 'Fuel', 'Vent', 'Shrinkage') 

union all

SELECT 
[Category],[Value],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Injection  (Enhanced Recovery)' and Category in ('Acid Gas Injection', 'Gas Injection')
) as SourceTable
PIVOT
(
MAX([Value]) FOR Category IN ([Well Production], [In Situ Well Production], [Flare], [Fuel], [Vent], [Shrinkage], [Acid Gas Injection], [Gas Injection])
) as PivotTable
),
sk_cte as
(
SELECT
[Production Month],
sum([Total Gas Production (10^3m3)]) as [Total Gas Production (10^3m3)],
sum([Gas Available for Use or Sale (10^3m3)]) as [SK Marketable Gas (103m3)]
FROM [EnergyData].[dbo].[SK_Production_Gas]
group by [Production Month]
)


select 
[Date],
DATEDIFF(DAY, DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1), EOMONTH([Date])) + 1 AS DaysInMonth,
[AB Marketable Gas (103m3)],
[SK Marketable Gas (103m3)]
from ab_cte full outer join sk_cte on ab_cte.Date = sk_cte.[Production Month]

order by [Date] desc