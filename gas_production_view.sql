USE EnergyData
GO

CREATE OR ALTER VIEW dbo.vwMarketableGasProduction
AS

with ab_cte as (
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
sk_cte as (
	SELECT
	[Production Month],
	sum([Total Gas Production (10^3m3)]) as [Total Gas Production (10^3m3)],
	sum([Gas Available for Use or Sale (10^3m3)]) as [SK Marketable Gas (103m3)]
	FROM [EnergyData].[dbo].[SK_Production_Gas]
	group by [Production Month]
),
bc_cte as (
	select [Date], [Sum of Raw Gas 103m3], [Sum of Marketable Gas 103m3] as [BC Marketable Gas (103m3)]
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
),
on_cte as (
	select [REF_DATE], [Gross withdrawals], [Marketable production] as [ON Marketable Gas (103m3)]
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
),
nb_cte as (
	SELECT 
	[Date],
	[Value] as [Raw Gas (103m3)],
	[Value] as [NB Marketable Gas (103m3)]
	FROM [EnergyData].[dbo].[NB_Production]
	where [Product] = 'Natural Gas' and Units = 'thousand m3'
),
nt_cte as (
	select 
	[Date], 
	([Norman Wells]-([Norman Wells]*0.015)) + ([Ikhil, Inuvik]- ([Ikhil, Inuvik]*0.05)) as [NT Marketable Gas (103m3)]
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
)


select
[Date],
[NB Marketable Gas (103m3)]/DaysInMonth as [NB 103m3d],
[ON Marketable Gas (103m3)]/DaysInMonth as [ON 103m3d],
[SK Marketable Gas (103m3)]/DaysInMonth as [SK 103m3d],
[AB Marketable Gas (103m3)]/DaysInMonth as [AB 103m3d],
[BC Marketable Gas (103m3)]/DaysInMonth as [BC 103m3d],
[NT Marketable Gas (103m3)]/DaysInMonth as [NWT 103m3d]

from
(
select 
ab_cte.[Date],
DATEDIFF(DAY, DATEFROMPARTS(YEAR(ab_cte.[Date]), MONTH(ab_cte.[Date]), 1), EOMONTH(ab_cte.[Date])) + 1 AS DaysInMonth,
[AB Marketable Gas (103m3)],
[SK Marketable Gas (103m3)],
[BC Marketable Gas (103m3)],
[ON Marketable Gas (103m3)],
[NB Marketable Gas (103m3)],
[NT Marketable Gas (103m3)]
from ab_cte 
full outer join sk_cte on ab_cte.[Date] = sk_cte.[Production Month]
full outer join bc_cte on ab_cte.[Date] = bc_cte.[Date]
full outer join on_cte on ab_cte.[Date] = on_cte.REF_DATE
full outer join nb_cte on ab_cte.[Date] = nb_cte.[Date]
full outer join nt_cte on ab_cte.[Date] = nt_cte.[Date]
where year(ab_cte.[Date]) >= 2021
) as thousandm3
--order by [Date]