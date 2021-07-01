SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetItemsChild]
(@PageIndex INT,
 @NumRows INT =-1,
  @Departments nvarchar(4000))

AS
  
Declare @MySelect nvarchar(4000)
Set @MySelect=' Select DepartmentStoreID as DepartmentID 
				into Temp5
				from departmentstore     
                    where (1<>1)  '
execute (@MySelect + @Departments)

					    DECLARE @startRowIndex INT;
		 
						SET @startRowIndex = (@PageIndex * @NumRows)+1 ;
					
						SELECT   Row ,matrix1, linkno,ItemStoreID,price
						Into #ItemsPage
						FROM (
								SELECT   Row ,matrix.matrix1, matrix.linkno,matrix.ItemStoreID,matrix.price
								FROM (
										select ROW_NUMBER() OVER (ORDER BY m.BarcodeNumber ASC) AS Row, m.Matrix1,m.LinkNo,s.ItemStoreID,m.itemid,s.price 
										from ItemMain m
										inner join ItemStore s on m.itemid=s.itemno and s.status>0
										and s.DepartmentID in (Select DepartmentID From Temp5)
										where   m.status>0  and (m.itemtype=0 or m.itemtype=2)
								      ) as ISell_Items
								inner join itemmainandstoreview as matrix on 
						         ISell_Items.itemid=matrix.linkno and matrix.linkno is not null and matrix.status>0 and matrix.itemtype=1
							) as a



if @NumRows<> -1
			 SELECT     Matrix1,LinkNo,ItemStoreID,price
			 FROM         #ItemsPage
			 WHERE     Row BETWEEN @startRowIndex AND @StartRowIndex + @NumRows-1 
			 order by matrix1
else
             SELECT     Matrix1,LinkNo,ItemStoreID,price
			 FROM         #ItemsPage
order by matrix1

drop table Temp5
drop table #ItemsPage
GO