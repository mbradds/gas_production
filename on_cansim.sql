
SELECT 
[REF_DATE],
[GEO],
[DGUID],
[Supply and disposition],
[Unit of measure],
[UOM],
[UOM_ID],
[SCALAR_FACTOR],
[SCALAR_ID],
[VECTOR],
[COORDINATE],
[VALUE],
[STATUS],
[SYMBOL],
[TERMINATED],
[DECIMALS]
FROM [EnergyData].[dbo].[CANSIM_25100055_SupplyAndDisposition_Gas]

where [GEO] = 'Ontario' and [Supply and disposition] = 'Marketable production'

order by [REF_DATE] desc