SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintedInsert]
@PrintedName varchar(50),
@PrintedContent text,
@Status int =1
as

	INSERT INTO dbo.printed
	(PrintedContent,PrintedName,Status)
	VALUES(@PrintedContent,@PrintedName,@Status)
GO