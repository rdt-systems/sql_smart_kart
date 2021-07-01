SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ItemStore_Exists]
(@ItemID uniqueidentifier)
As 

if (select Count(1) from dbo.ItemStoreView
where ItemNo = @ItemID ) = 1 
	select Status from dbo.ItemStoreView
	where ItemNo = @ItemID

else
	select -2
GO