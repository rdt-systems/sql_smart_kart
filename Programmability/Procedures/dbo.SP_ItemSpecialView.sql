SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ItemSpecialView]
(
@DateModified datetime=null,
@storeID uniqueidentifier
)
AS 

SELECT *  FROM [ItemSpecialView] WHERE ([StoreNo]=@storeID) AND (SaleEndDate>dbo.GetLocalDate()-1) AND (DateModified >@DateModified) AND Status>0
GO