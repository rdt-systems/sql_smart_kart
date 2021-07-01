SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ItemMainUpdate_HandHeld]
(@ItemID uniqueidentifier,
@Name nvarchar(4000),
@Description nvarchar(4000),
@BarcodeNumber nvarchar(50),
@ModifierID uniqueidentifier)
AS 

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE    dbo.ItemMain

SET      [Name] = dbo.CheckString(@Name),
		 [Description] = dbo.CheckString(@Description),
		 BarcodeNumber =dbo.CheckString(@BarcodeNumber), 
         UserModified = @ModifierID

WHERE    (ItemID = @ItemID) --AND (DateModified = @DateModified OR DateModified IS NULL) 



select @UpdateTime as DateModified
GO