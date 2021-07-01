SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_RegisterKeysView]
(
@DateModified datetime=null
)
AS 
SELECT [RegisterKeysView].*  FROM [RegisterKeysView]   WHERE (DateModified >@DateModified) AND Status>0
GO