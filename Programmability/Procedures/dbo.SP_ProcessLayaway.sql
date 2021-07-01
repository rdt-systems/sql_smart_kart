SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ProcessLayaway]
           (@LayawayID uniqueidentifier,
            @LayawayStatus int,--0 Void,1 On layaway 2 Sold
			@Qty decimal,
			@ItemStoreID uniqueidentifier,
			@UserModified uniqueidentifier)
AS          
           UPDATE [Layaway]
		   SET [LayawayStatus]=@LayawayStatus,
		       [DateModified] = dbo.GetLocalDATE(),
               [UserModified] = @UserModified
           WHERE ([LayawayID] =@LayawayID) AND ([LayawayStatus]<>@LayawayStatus)

	IF  (@LayawayStatus =0) --VOID
	BEGIN
		UPDATE ItemStore SET OnHand = IsNull(OnHand,0)+@Qty,datemodified=dbo.GetLocalDATE() WHERE ItemStoreID =@ItemStoreID   
	END
    ELSE IF (@LayawayStatus =1)--layaway 
	BEGIN
		UPDATE ItemStore SET OnHand = IsNull(OnHand,0)-@Qty,datemodified=dbo.GetLocalDATE() WHERE ItemStoreID =@ItemStoreID 
	END
GO