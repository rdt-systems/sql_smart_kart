SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemSupplierExist]
(
	@ItemStoreID uniqueidentifier,
	@SupplierID uniqueidentifier = null
)
AS
	SELECT Count(*)as C from ItemSupply where SupplierNo = @SupplierID and ItemStoreNo =@ItemStoreID And Status>0
GO