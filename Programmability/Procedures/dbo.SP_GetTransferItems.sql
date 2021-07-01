SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetTransferItems]
(@Filter nvarchar(4000))

as

declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.TransferItemsView.* FROM dbo.TransferItemsView  Where  '
print (@MySelect + @Filter)
Execute (@MySelect + @Filter )
GO