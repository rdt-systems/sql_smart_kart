SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMain_Exists]
(@Barcode nvarchar(50))
As 

if (select Count(1) from dbo.ItemMain
where BarcodeNumber = @Barcode And Status>-1) > 0 
	select ItemID from dbo.ItemMain
	where BarcodeNumber = @Barcode and Status >-1
else
	select null
GO