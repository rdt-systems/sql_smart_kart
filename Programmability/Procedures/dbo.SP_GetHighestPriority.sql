SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create proc [dbo].[SP_GetHighestPriority]
as 
SELECT MAX(Priority) 
FROM Sales
WHERE Status>0
GO