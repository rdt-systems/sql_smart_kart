SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WEB_GetItemsChildWithBind]
(@PageIndex INT,
 @NumRows INT =-1,
  @Departments nvarchar(4000))

AS
  
IF NOT EXISTS (Select * from sys.tables where name = 'Temp5')
CREATE TABLE Temp5 (DepartmentID uniqueidentifier NOT NULL
CONSTRAINT [PK_Temp5] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
 
Declare @MySelect nvarchar(4000)
Set @MySelect=' Insert Into Temp5
Select DepartmentStoreID as DepartmentID 
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
										inner join dbo.itemmainandstoreview SL on SL.barcodenumber collate HEBREW_CI_AS=m.barcodenumber collate HEBREW_CI_AS
										and SL.onhand>0 and SL.status>0 
										where   m.status>0  and (m.itemtype=0 or m.itemtype=2)
								      ) as ISell_Items
								inner join itemmainandstoreview as matrix on 
						         ISell_Items.itemid=matrix.linkno and matrix.linkno is not null and matrix.status>0 and matrix.itemtype=1
								inner join dbo.itemmainandstoreview SL on SL.barcodenumber collate HEBREW_CI_AS=matrix.barcodenumber collate HEBREW_CI_AS
										and SL.onhand>0 and SL.status>0 

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

IF EXISTS (Select * from sys.tables where name = 'Temp5')
drop table Temp5
drop table #ItemsPage
GO