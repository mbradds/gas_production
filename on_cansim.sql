select [REF_DATE], [Gross withdrawals], [Marketable production]
from
(
SELECT 
[REF_DATE],
[Supply and disposition],
[VALUE]
FROM [EnergyData].[dbo].[CANSIM_25100055_SupplyAndDisposition_Gas]
where [GEO] = 'Ontario' and [Supply and disposition] in ('Marketable production', 'Gross withdrawals') and [Unit of measure] = 'Cubic metres'
) as SourceTable
PIVOT
(
max([VALUE]) for [Supply and disposition] in ([Gross withdrawals], [Marketable production])
) as PivotTable