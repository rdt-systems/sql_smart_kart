SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_MixAndMatch]
(
@DateModified datetime=null
)
AS 
SELECT [MixAndMatch].*  FROM [MixAndMatch]   WHERE (DateModified >@DateModified) AND Status>0
GO