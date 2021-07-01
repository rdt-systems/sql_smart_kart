SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_ComputersInsert]
(@ComputerID uniqueidentifier,
@ComputerName nvarchar(255),
@ComputerNo nvarchar(255),
@StoreID uniqueidentifier,
@LabelPrinter nvarchar(255),
@ShelfPrinter nvarchar(255),
@InvoicePrinter nvarchar(255),
@StatementPrinter nvarchar(255),
@Status smallint,
@ModifierID uniqueidentifier)
as
	Insert Into Computers(ComputerID,ComputerName,ComputerNo,StoreID,LabelPrinter,ShelfPrinter,InvoicePrinter,StatementPrinter,Status,DateCreated,UserCreated,DateModified,UserModified)
	values(@ComputerID,dbo.CheckString(@ComputerName),@ComputerNo,@StoreID,@LabelPrinter,@ShelfPrinter,@InvoicePrinter,@StatementPrinter,isnull(@Status,1),dbo.GetLocalDATE(),@ModifierID,dbo.GetLocalDATE(),@ModifierID)
GO