SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintLabelLayoutUpdate]
(@PrintLabelLayoutID uniqueidentifier,
@LayoutName nvarchar(4000),
@LayoutContent text,
@PrinterType int= 0,
@ModifierID uniqueidentifier = null,
@DateModified datetime = null,
@Status int =1
)
as

	UPDATE dbo.PrintLabelLayout
	SET
	 LayoutName=@LayoutName,
	 LayoutContent=@LayoutContent,
     PrinterType =@PrinterType,
	 Status=@Status
	WHERE PrintLabelLayoutID=@PrintLabelLayoutID
GO