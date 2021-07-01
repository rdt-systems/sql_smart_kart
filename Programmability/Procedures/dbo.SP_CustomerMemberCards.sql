SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_CustomerMemberCards]
(
@DateModified datetime=null
)
AS 
SELECT [CustomerMemberCards].*  FROM [CustomerMemberCards]   WHERE (DateModified >@DateModified) AND Status>0
GO