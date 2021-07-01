SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetRequestTransfer]
(@Filter nvarchar(4000))

as

declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.RequestTransferView.* FROM dbo.RequestTransferView  Where  '
print (@MySelect + @Filter)
Execute (@MySelect + @Filter )
GO