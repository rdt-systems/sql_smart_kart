SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_ComputersUpdate]
(@ComputerID uniqueidentifier,
@ComputerName nvarchar(255),
@ComputerNo nvarchar(255),
@StoreID uniqueidentifier,
@LabelPrinter nvarchar(255),
@ShelfPrinter nvarchar(255),
@InvoicePrinter nvarchar(255),
@StatementPrinter nvarchar(255),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)
as
	update Computers
	Set 	ComputerName=dbo.CheckString(@ComputerName),
		ComputerNo=@ComputerNo,
		StoreID=@StoreID,
		LabelPrinter=@LabelPrinter,
		ShelfPrinter=@ShelfPrinter,
		InvoicePrinter=@InvoicePrinter,
		StatementPrinter=@StatementPrinter,
		Status=@Status,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	where 	(ComputerID=@ComputerID) AND
		(DateModified = @DateModified OR DateModified IS NULL)
GO