SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintLabelsInsert_HandHeld]
(@PrintLabelsID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Tag bit,
@ModifierID uniqueidentifier,
@Qty int=1)
AS INSERT INTO dbo.PrintLabels
           (PrintLabelsID, ItemStoreID, Tag,Qty,Status,DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@PrintLabelsID,@ItemStoreID, @Tag,@Qty,1,dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)
GO