SELECT
[Production Month],
sum([Total Gas Production (10^3m3)]) as [Total Gas Production (10^3m3)],
sum([Gas Available for Use or Sale (10^3m3)]) as [Gas Available for Use or Sale (10^3m3)]
FROM [EnergyData].[dbo].[SK_Production_Gas]
group by [Production Month]
order by [Production Month] desc