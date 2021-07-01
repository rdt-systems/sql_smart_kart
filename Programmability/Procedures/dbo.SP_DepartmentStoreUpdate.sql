SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DepartmentStoreUpdate]
(@DepartmentStoreID uniqueidentifier,
@Name nvarchar(50),
@Description nvarchar(4000),
@ParentDepartmentID uniqueidentifier,
@StoreID nvarchar(50),
@KeyNumber int,
@DefaultMarkup nvarchar(50),
@DefaultMarkupA nvarchar(50),
@DefaultMarkupB nvarchar(50),
@DefaultMarkupC nvarchar(50),
@DefaultMarkupD nvarchar(50),
@RoundUp int,
@RoundUpA int,
@RoundUpB int,
@RoundUpC int,
@RoundUpD int,
@RoundValue nvarchar(50),
@RoundValueA nvarchar(50),
@RoundValueB nvarchar(50),
@RoundValueC nvarchar(50),
@RoundValueD nvarchar(50),
@DefaultCogsAccount int,
@DefaultIncomeAccount int,
@DefaultTaxNo nvarchar(50),
@IsDefaultTaxInclude bit,
@IsDefaultFoodStampable bit,
@IsDefaultDiscountable bit,
@DefaultProfitCalculation int,
@departmentno nvarchar(50),
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier,
@DiscountID uniqueidentifier = NULL,
@UseImageCard bit = 0)


AS

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

 UPDATE dbo.DepartmentStore
                
       SET  [Name] =dbo.CheckString(@Name), [Description]=dbo.CheckString(@Description), ParentDepartmentID=@ParentDepartmentID, StoreID=@StoreID,[KeyNumber] = @KeyNumber, DefaultMarkup=@DefaultMarkup,DefaultMarkupA=@DefaultMarkupA,
	DefaultMarkupB=@DefaultMarkupB,DefaultMarkupC=@DefaultMarkupC,DefaultMarkupD=@DefaultMarkupD,
 	 RoundUp=@RoundUp, RoundUpA=@RoundUpA, RoundUpB=@RoundUpB, RoundUpC=@RoundUpC, RoundUpD=@RoundUpD, 
	RoundValue=@RoundValue,RoundValueA=@RoundValueA,RoundValueB=@RoundValueB,RoundValueC=@RoundValueC,RoundValueD=@RoundValueD, 
	DefaultCogsAccount=@DefaultCogsAccount,DefaultIncomeAccount= @DefaultIncomeAccount, 
                DefaultTaxNo=@DefaultTaxNo, IsDefaultTaxInclude=@IsDefaultTaxInclude,IsDefaultFoodStampable=@IsDefaultFoodStampable,
	IsDefaultDiscountable=@IsDefaultDiscountable,
	DefaultProfitCalculation=@DefaultProfitCalculation,departmentno = @departmentno, Status=@Status,DateModified=@UpdateTime, UserModified=@ModifierID, DiscountID = @DiscountID , UseImageCard = @UseImageCard

WHERE (DepartmentStoreID=@DepartmentStoreID) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

---- Update The Parent Department Table
--IF EXISTS(select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ParentDepartmentList')
--drop table ParentDepartmentList
--Begin
--WITH CTE AS
--( SELECT DepartmentStoreID,ParentDepartmentID,Name, 0 [Level]
--FROM DepartmentStore 
--UNION ALL
--SELECT CTE.DepartmentStoreID, DepartmentStore.ParentDepartmentID, CTE.Name, Level+1 
--FROM CTE
--INNER JOIN DepartmentStore
--ON CTE.ParentDepartmentID = DepartmentStore.DepartmentStoreID
--WHERE DepartmentStore.ParentDepartmentID IS NOT NULL AND DepartmentStore.ParentDepartmentID<>'00000000-0000-0000-0000-000000000000' and Status >0 
--) 

--SELECT c.DepartmentStoreID, c.Name, c.ParentDepartmentID,c.Level,c.MaxLevel,DepartmentStore.Name As ParentName into ParentDepartmentList
--FROM ( SELECT *, MAX([Level]) OVER (PARTITION BY DepartmentStoreID) [MaxLevel]
--FROM
--  CTE
--        ) c INNER JOIN DepartmentStore On C.ParentDepartmentID=DepartmentStore.DepartmentStoreID 
--End
GO