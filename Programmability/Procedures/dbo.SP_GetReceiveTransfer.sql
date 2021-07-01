SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveTransfer]
(@Filter nvarchar(4000))

as

declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ReceiveTransferView.* FROM dbo.ReceiveTransferView  Where  '
print (@MySelect + @Filter)
Execute (@MySelect + @Filter )
GO