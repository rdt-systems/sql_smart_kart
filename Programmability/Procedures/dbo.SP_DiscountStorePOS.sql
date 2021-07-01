SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_DiscountStorePOS]
(
@DateModified datetime=null
)
AS 
SELECT [DiscountStorePOS].*  FROM [DiscountStorePOS]  WHERE (DateModified >@DateModified) AND Status>0
GO