SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetWorkOrderWithCustomer]

@CustomerID uniqueidentifier = null

AS


if @CustomerID is null

	SELECT * 
	FROM dbo.WorkOrderView
	WHERE status=1 AND WOStatus>-1 
	and (convert(varchar,dbo.GetLocalDATE(),21) >= convert(varchar,ActiveDate,21)  Or ActiveDate is null)
	and (convert(varchar,dbo.GetLocalDATE(),21) < convert(varchar,ExpirationDate,21) Or ExpirationDate is null)
else
	SELECT * 
	FROM dbo.WorkOrderView
	WHERE status=1 AND WOStatus>-1 
	and CustomerID=@CustomerID 
	and (convert(varchar,dbo.GetLocalDATE(),21) >= convert(varchar,ActiveDate,21)  Or ActiveDate is null)
	and (convert(varchar,dbo.GetLocalDATE(),21) < convert(varchar,ExpirationDate,21) Or ExpirationDate is null)
GO