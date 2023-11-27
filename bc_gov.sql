/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Activity]
      ,[Category]
      ,[Year]
      ,[Month]
      ,[Value]
      ,[Date]
  FROM [EnergyData].[dbo].[BC_Production_Gas_Plants]
  order by [Date] desc