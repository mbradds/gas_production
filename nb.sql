/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Date]
      ,[Month]
      ,[Year]
      ,[Value]
      ,[Product]
      ,[Units]
  FROM [EnergyData].[dbo].[NB_Production]
  order by [Date] desc