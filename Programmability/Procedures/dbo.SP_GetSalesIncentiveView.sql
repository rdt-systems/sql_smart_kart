SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSalesIncentiveView]
(@SalesIncentiveHeaderID uniqueidentifier=null,
 --@Status int=0,
 @Filter nvarchar(4000))
AS 


DECLARE @MySelect nvarchar(4000)
IF @SalesIncentiveHeaderID IS NOT NULL 
		BEGIN 
			  SET @MySelect ='SELECT * FROM SalesIncentiveView WHERE SalesIncentiveHeaderID='''+ CONVERT(VARCHAR(50), @SalesIncentiveHeaderID)+'''AND ' 
			   exec(@MySelect+@Filter )
			  --WHERE  SalesIncentiveHeaderID=@SalesIncentiveHeaderID

		END
		ELSE BEGIN
		  SET @MySelect ='SELECT * FROM SalesIncentiveView WHERE '
		exec(@MySelect+@Filter )
		END
GO