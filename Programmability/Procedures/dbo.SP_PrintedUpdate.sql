SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintedUpdate]
@PrintedName varchar(50),
@PrintedContent text,
@Status int =1
as

	UPDATE dbo.printed
	SET PrintedContent=@PrintedContent ,Status=@Status
	WHERE PrintedName=@PrintedName
GO