SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		Nathan Ehrenthal
-- ALTER date: 5/27/2013
-- Description:	To Get All SalesIncentiveHeader
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetSalesIncentiveHeaderView]
(@ActiveOnly BIT =1,
 @SalesIncentiveHeaderID uniqueidentifier = NULL)

AS
 IF @SalesIncentiveHeaderID IS NULL BEGIN
  IF (@ActiveOnly= 1)
    SELECT * FROM SalesIncentiveHeaderView WHERE dbo.Getday(ToDate) > dbo.GetDay(dbo.GetLocalDATE())
  ELSE
    SELECT * FROM SalesIncentiveHeaderView  
END
ELSE BEGIN
	SELECT * FROM SalesIncentiveHeaderView  WHERE SalesIncentiveHeaderID = @SalesIncentiveHeaderID 
END
GO