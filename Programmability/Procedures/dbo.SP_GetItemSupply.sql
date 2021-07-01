SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemSupply]
(@ItemStoreID nvarchar(50))
As 


select * from dbo.ItemSupply
where ItemStoreNo=@ItemStoreID
GO