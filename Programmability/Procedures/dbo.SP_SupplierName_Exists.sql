SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_SupplierName_Exists]
(@Name nvarchar(50))
As 

if (select Count(1) from dbo.Supplier
where (Name = @Name and Status>-1)) > 0
	select 1
	
else
	select 0
GO