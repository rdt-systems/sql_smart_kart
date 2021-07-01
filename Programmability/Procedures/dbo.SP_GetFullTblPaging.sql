SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetFullTblPaging]
(@TblName nvarchar(50),
@Filter nvarchar(4000),
@PageIndex INT,
@NumRows INT )
as 

DECLARE @startRowIndex INT
SET @startRowIndex = (@PageIndex * @NumRows)+1; 

declare @Str nvarchar(4000)
set @str='

		 With Page as (	SELECT     ROW_NUMBER() OVER (Order By DateCreated Asc) AS Row,*
						FROM       ' + @TblName + '
						WHERE	   1=1 ' + @Filter + '	
					  )
			
		 SELECT    *
		 FROM      Page
		 WHERE     Row BETWEEN ' + convert(nvarchar,@startRowIndex) + ' AND ' +convert(nvarchar, @StartRowIndex + @NumRows-1 ) 


exec (@str)
GO