SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetAdjustInventory]
(@Filter nvarchar(4000))
as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT dbo.AdjustInventory.AdjustInventoryId,
		       dbo.AdjustInventory.DateCreated,
	               dbo.AdjustInventory.Qty,
		       dbo.AdjustInventory.OldQty,
		       dbo.AdjustInventory.AdjustType
                FROM dbo.AdjustInventory
                WHERE '

Execute (@MySelect + @Filter )
GO