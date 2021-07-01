SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintLabelsUpdate]
(@PrintLabelsID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Tag Bit,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@Qty int=1,
@SortOrder int = 1,
@Storeid uniqueidentifier = NULL)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.PrintLabels

SET 
--ItemStoreID= @ItemStoreID,
Tag=@Tag,
Status=@Status,
DateModified=@UpdateTime,
UserModified= @ModifierID,
Qty=@Qty,
StoreID = @Storeid 


WHERE (PrintLabelsID = @PrintLabelsID) 





select @UpdateTime as DateModified
GO