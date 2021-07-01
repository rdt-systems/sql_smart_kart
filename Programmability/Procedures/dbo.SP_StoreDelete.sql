SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_StoreDelete]
(@StoreID uniqueidentifier,
@ModifierID uniqueidentifier)

AS UPDATE dbo.Store
   
SET        Status  = -1 ,  DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
            
WHERE StoreID =@StoreID
GO