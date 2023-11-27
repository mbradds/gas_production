/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Date]
      ,[Year]
      ,[Month]
      ,[Field]
      ,[Commodity]
      ,[Units]
      ,[Value]
      ,[Confidential]
  FROM [EnergyData].[dbo].[NWT_Production]
  order by [Date] desc