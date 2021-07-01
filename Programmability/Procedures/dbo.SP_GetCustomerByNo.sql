SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetCustomerByNo]
(@No nvarchar(50))
As 


select * from dbo.CustomerView
where CustomerNo=@No and status>-1
GO