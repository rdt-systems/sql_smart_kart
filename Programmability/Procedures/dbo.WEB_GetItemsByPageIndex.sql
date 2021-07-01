SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[WEB_GetItemsByPageIndex]
(@PageIndex INT,
 @NumRows INT =-1,
 @Departments nvarchar(4000),
 @DepNot nvarchar(50)=null,
 @ItemCount int output
)

AS
IF NOT EXISTS (Select * from sys.tables where name = 'Temp1')
CREATE TABLE Temp1 (DepartmentID uniqueidentifier NOT NULL
CONSTRAINT [PK_Temp1] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
 
Declare @MySelect nvarchar(4000)
Set @MySelect=' Insert Into Temp1
Select DepartmentStoreID as DepartmentID 
				from departmentstore     
                    where (1<>1)  '


execute (@MySelect + @Departments)

IF EXISTS (Select * from sys.tables where name = 'Temp1')
	BEGIN
		  DECLARE @startRowIndex INT;
		  		  SELECT @ItemCount=(SELECT COUNT(*) FROM ItemMain m
				inner join ItemStore s on m.itemid=s.itemno and s.status>0 and s.onhand>0
								
				 WHERE           m.status>0  and 
								(m.itemtype=0 or m.itemtype=2) and
							    (s.DepartmentID in (Select DepartmentID From Temp1))  
								  );
				if  @NumRows=-1  
					begin
						set @NumRows=@ItemCount
						set @StartRowIndex=0
					end
			else
						SET @startRowIndex = (@PageIndex * @NumRows)+1 ;
					


		 With ItemsPage as (
								SELECT     ROW_NUMBER() OVER (ORDER BY m.BarcodeNumber ASC) AS Row,
								m.[name], s.price, m.[description],s.ItemStoreID,m.ItemID,m.BarcodeNumber,s.DepartmentID
	
								FROM ItemMain m
								inner join ItemStore s on m.itemid=s.itemno and s.status>0 and s.onhand>0



								 WHERE   m.status>0  and 
								(m.itemtype=0 or m.itemtype=2) and
							  (s.DepartmentID in (Select DepartmentID From Temp1)  )  
								 
							)

			 SELECT     [name], price, [description],ItemStoreID,ItemID,BarcodeNumber,DepartmentID
			 FROM       ItemsPage
			 WHERE     Row BETWEEN @startRowIndex AND @StartRowIndex + @NumRows-1  
	END
IF EXISTS (Select * from sys.tables where name = 'Temp1')
drop table Temp1
GO