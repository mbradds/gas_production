SELECT 
[Date],
[Value] as [Raw Gas (103m3)],
[Value] as [Marketable Gas (103m3)]
FROM [EnergyData].[dbo].[NB_Production]
where [Product] = 'Natural Gas' and Units = 'thousand m3'