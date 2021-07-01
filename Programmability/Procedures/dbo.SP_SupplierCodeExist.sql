SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create PROCEDURE [dbo].[SP_SupplierCodeExist]
(@ItemCode nvarchar(50),
@SupplierID uniqueidentifier)
as
select ItemStoreNo
from dbo.ItemSupplyView
where ItemCode=@ItemCode and SupplierNo=@SupplierID
GO