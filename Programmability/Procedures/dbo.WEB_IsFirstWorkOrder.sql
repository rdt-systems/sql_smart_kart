SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_IsFirstWorkOrder]
(@CustomerID uniqueidentifier)
As 

if (select Count(1) from dbo.workorder
where CustomerID = @CustomerID and Status>-1) > 0
	select  0
else
	select  1
GO