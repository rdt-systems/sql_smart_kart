SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintLabelsInsert]
(@PrintLabelsID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Tag bit,
@ModifierID uniqueidentifier,
@Status smallint=1,-- 1 =print label, 10= receive
@Qty int=1,
@SortOrder int = 1,
@Storeid uniqueidentifier = NULL)
AS INSERT INTO dbo.PrintLabels
           (PrintLabelsID, ItemStoreID, Tag,Qty, Status, DateCreated, UserCreated, DateModified, UserModified,StoreID)
VALUES     (@PrintLabelsID,@ItemStoreID, @Tag,@Qty, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID,@Storeid)
GO