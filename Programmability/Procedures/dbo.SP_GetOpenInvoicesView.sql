SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetOpenInvoicesView] 

@CUID uniqueidentifier=null

as

if @CUID is null

		SELECT * 
		FROM InvoicesView
		WHERE OpenBalance>0 and Type='Sale' and status>0

ELSE

	SELECT * 
	FROM InvoicesView
	WHERE OpenBalance>0 and PID=@CUID and Type='Sale' and status>0
GO