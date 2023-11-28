select 
[Date], 
([Norman Wells]-([Norman Wells]*0.015)) + ([Ikhil, Inuvik]- ([Ikhil, Inuvik]*0.05)) as [Marketable Gas (103m3)]
from
(
SELECT
[Date],
[Field],
[Value]
FROM [EnergyData].[dbo].[NWT_Production]
where Commodity = 'NATURAL GAS' and Field in ('Norman Wells', 'Ikhil, Inuvik')
) as SourceTable
PIVOT
(
max([Value]) for Field in ([Norman Wells], [Ikhil, Inuvik])
) as PivotTable