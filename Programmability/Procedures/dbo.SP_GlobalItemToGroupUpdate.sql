SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GlobalItemToGroupUpdate]
(@AllStores bit=0,
@ModifierID uniqueidentifier)

AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
If @AllStores =1
begin
UPDATE       ItemToGroup
SET                Status = - 1, DateModified = dbo.GetLocalDATE()
WHERE        (ItemStoreID IN
                             (SELECT        ItemStoreID
                               FROM            ItemStore
                               WHERE        (ItemNo IN
                                                             (SELECT        ItemNo
                                                               FROM            ItemStore
                                                               WHERE        (ItemStoreID IN
                                                                                             (SELECT        ItemStoreID
                                                                                               FROM            ItemStoreIDs
                                                                                               WHERE        (UserID = @ModifierID)))))))
end
else begin
Update ItemToGroup Set Status =-1, DateModified = dbo.GetLocalDATE()
Where ItemStoreID IN (Select ItemStoreID From ItemStoreIDs Where UserID = @ModifierID)
end

select @UpdateTime as DateModified
GO