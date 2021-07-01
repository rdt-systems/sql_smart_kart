SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemByBarcode]
(@BarcodeNumber nvarchar(50))
As 


select * from dbo.ItemMain
where BarcodeNumber=@BarcodeNumber
GO