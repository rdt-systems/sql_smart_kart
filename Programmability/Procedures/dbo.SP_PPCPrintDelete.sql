SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PPCPrintDelete]
(@PrintType int,	
@IsSystem bit)
AS
UPDATE  dbo.PPCPrint
SET status=-1,
DateModified = dbo.GetLocalDATE()
WHERE 
(PrintType=@PrintType
and IsSystem=@IsSystem)
GO