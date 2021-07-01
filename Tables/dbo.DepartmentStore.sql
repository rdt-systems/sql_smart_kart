CREATE TABLE [dbo].[DepartmentStore] (
  [DepartmentStoreID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Description] [nvarchar](4000) NULL,
  [ParentDepartmentID] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [KeyNumber] [int] NULL,
  [DefaultMarkup] [decimal](19, 3) NULL,
  [DefaultMarkupA] [decimal](19, 3) NULL,
  [DefaultMarkupB] [decimal](19, 3) NULL,
  [DefaultMarkupC] [decimal](19, 3) NULL,
  [DefaultMarkupD] [decimal](19, 3) NULL,
  [RoundUp] [int] NOT NULL,
  [RoundUpA] [int] NULL,
  [RoundUpB] [int] NULL,
  [RoundUpC] [int] NULL,
  [RoundUpD] [int] NULL,
  [RoundValue] [decimal](18, 3) NULL,
  [RoundValueA] [decimal](18, 3) NULL,
  [RoundValueB] [decimal](18, 3) NULL,
  [RoundValueC] [decimal](18, 3) NULL,
  [RoundValueD] [decimal](18, 3) NULL,
  [DefaultCogsAccount] [int] NULL,
  [DefaultIncomeAccount] [int] NULL,
  [DefaultTaxNo] [uniqueidentifier] NULL,
  [IsDefaultTaxInclude] [bit] NULL,
  [IsDefaultFoodStampable] [bit] NULL CONSTRAINT [DF_DepartmentStore_IsDefaultFoodStampable] DEFAULT (1),
  [DefaultProfitCalculation] [int] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [IsDefaultDiscountable] [bit] NULL CONSTRAINT [DF_DepartmentStore_IsDefaultFoodStampable1] DEFAULT (1),
  [DepartmentNo] [nvarchar](50) NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [UseImageCard] [bit] NULL,
  CONSTRAINT [PK_DepartmentStore] PRIMARY KEY CLUSTERED ([DepartmentStoreID])
)
GO

CREATE INDEX [IX_SubDepartments]
  ON [dbo].[DepartmentStore] ([Status])
  INCLUDE ([Name], [ParentDepartmentID])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDepartment] on [dbo].[DepartmentStore]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT DepartmentStoreID, 'DepartmentStore' , Status, dbo.GetLocalDATE() , 1,'DepartmentStoreID' FROM      inserted
  end
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDepartmentStore] on [dbo].[DepartmentStore]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT DepartmentStoreID, 'DepartmentStore' , Status, dbo.GetLocalDATE() , 1,'DepartmentStoreID' FROM      inserted
  end
GO