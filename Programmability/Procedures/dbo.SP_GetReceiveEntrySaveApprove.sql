SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetReceiveEntrySaveApprove]
(@Filter NVARCHAR(4000))

as
Declare @MySelect as NVARCHAR(4000)

Set @MySelect='Update ReceiveEntry
              Set ForApprove=0 
              where ' 
Exec (@MySelect + @Filter)
GO