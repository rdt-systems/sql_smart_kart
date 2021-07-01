SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintLabelLayoutInsert]
(@PrintLabelLayoutID uniqueidentifier,
@LayoutName nvarchar(4000),
@LayoutContent text,
@PrinterType Int=0,
@Status int =1)
AS INSERT INTO dbo.PrintLabelLayout
                 (PrintLabelLayoutID
                  ,LayoutName
                  ,LayoutContent
                  ,PrinterType,
				  Status)
VALUES          
(@PrintLabelLayoutID,
 @LayoutName,
 @LayoutContent,
 @PrinterType,
 @Status)
GO