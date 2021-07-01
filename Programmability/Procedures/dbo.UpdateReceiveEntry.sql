SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateReceiveEntry]
(@ReceiveNo uniqueidentifier,
 @InsertOrDel int = 1,
 @ModifierID uniqueidentifier)
as
GO