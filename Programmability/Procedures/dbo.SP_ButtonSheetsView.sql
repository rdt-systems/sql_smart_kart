SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ButtonSheetsView]
(
@DateModified datetime=null
)
AS 
SELECT [ButtonSheetsView].*  FROM [ButtonSheetsView]  WHERE (DateModified >@DateModified) AND Status>0
GO