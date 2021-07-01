SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerNotesPOS]
(
@DateModified datetime=null
)
AS 
SELECT [CustomerNotesPOS].*  FROM [CustomerNotesPOS]  WHERE (DateModified >@DateModified) AND Status>0
GO