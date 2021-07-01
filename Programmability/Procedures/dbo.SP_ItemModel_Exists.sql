SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemModel_Exists]
(@Model nvarchar(50))
As 

if (select Count(1) from dbo.ItemMain
where (ModalNumber = @Model or BarcodeNumber=@Model or CaseBarcodeNumber=@Model) and Status>-1) 
+
(select Count(1) from dbo.ItemAlias
where (BarcodeNumber = @Model and Status>-1))
+
(select Count(1) from dbo.Discounts
where (UPCDiscount = @Model and Status>-1))
> 0
	select 1
	
else
	select 0
GO