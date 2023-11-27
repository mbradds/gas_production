/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Production Month]
      ,[Area Name]
      ,[Area #]
      ,[Gas Produced From Gas Wells (10^3m3)]
      ,[Gas Produced From Oil Wells (10^3m3)]
      ,[Total Gas Production (10^3m3)]
      ,[Gas Flared/Vented (10^3m3)]
      ,[Gas Available for Use or Sale (10^3m3)]
      ,[Est. Value of Gas Available for Use or Sale ($ CAD)]
  FROM [EnergyData].[dbo].[SK_Production_Gas]

  order by [Production Month] desc