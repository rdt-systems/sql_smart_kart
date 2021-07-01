SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SP_GetSalesIncentiveEntryView]
(@SalesIncentiveEntryID uniqueidentifier=null,
 @Filter nvarchar(4000))
AS 



IF @SalesIncentiveEntryID IS NOT NULL 
		BEGIN 
			  SELECT     dbo.SalesIncentiveEntryView.*
			  FROM         dbo.SalesIncentiveEntryView
			  WHERE      SalesIncentiveEntryID=@SalesIncentiveEntryID

		END
		ELSE BEGIN
		  DECLARE @MySelect nvarchar(4000)
		  SET @MySelect ='SELECT * FROM SalesIncentiveEntryView '
		  exec(@MySelect +@Filter)
		  --SELECT * FROM SalesIncentiveEntryView WHERE Status>@Status 
		END
GO