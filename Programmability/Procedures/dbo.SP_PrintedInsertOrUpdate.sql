SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PrintedInsertOrUpdate] (
@PrintedName varchar(50),
@PrintedContent text,
@Status int = 1
)	
AS
BEGIN
	if (select count(*) from printed
	where PrintedName=@PrintedName)>0
		begin
			UPDATE dbo.printed
				SET PrintedContent=@PrintedContent,Status=@Status
				WHERE PrintedName=@PrintedName
		end
	else
		begin
			INSERT INTO dbo.printed
				(PrintedContent,PrintedName,Status)
				VALUES(@PrintedContent,@PrintedName,@Status)
		end

END
GO