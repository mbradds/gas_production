select [Date], [Sum of Raw Gas 103m3], [Sum of Marketable Gas 103m3]
from
(
SELECT [Date], [Product], [Value]
FROM [EnergyData].[dbo].[BC_Production_Gas_Plant]
where [Plant Code] = 'Grand Total'
) as SourceTable
PIVOT
(
max([Value]) for Product in ([Sum of Raw Gas 103m3], [Sum of Marketable Gas 103m3])
) as PivotTable