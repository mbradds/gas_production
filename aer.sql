select [Date], Units, [Well Production], [In Situ Well Production], [Flare], [Fuel], [Vent], [Shrinkage], [Acid Gas Injection], [Gas Injection]
from
(

SELECT 
[Category],[Value],[Units],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Production' and Category = 'Well Production'

union all

SELECT 
[Category],[Value],[Units],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Production' and Category = 'In Situ Well Production'

union all

SELECT 
[Category],[Value],[Units],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Field Gas Use' and Category in ('Flare', 'Fuel', 'Vent', 'Shrinkage') 

union all

SELECT 
[Category],[Value],[Units],[Date]
FROM [EnergyData].[dbo].[AER_ST3]
where Product = 'Gas' and [Type]  = 'Injection  (Enhanced Recovery)' and Category in ('Acid Gas Injection', 'Gas Injection')
) as SourceTable
PIVOT
(
MAX(Value) FOR Category IN ([Well Production], [In Situ Well Production], [Flare], [Fuel], [Vent], [Shrinkage], [Acid Gas Injection], [Gas Injection])
) as PivotTable