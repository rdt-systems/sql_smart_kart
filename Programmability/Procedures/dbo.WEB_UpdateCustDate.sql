SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_UpdateCustDate]
(@CustomerID uniqueidentifier)
AS 
update customer
set datemodified=dbo.GetLocalDATE()
where status>0
and customerid=@CustomerID
GO