SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_Filter] (@MyFilter nvarchar(4000))
 AS
Declare @MySelect  nvarchar (3888)
Set @MySelect = '
  SELECT    distinct  Name, OnOrder,Cost,Price        

    FROM     SearchView  '
 Execute (@MySelect + @MyFilter )
GO