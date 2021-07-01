CREATE TABLE [dbo].[DiscountDepartment] (
  [DiscountDepartmentID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DiscountDepartment] PRIMARY KEY CLUSTERED ([DiscountDepartmentID])
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDiscountDepartment] on [dbo].[DiscountDepartment]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT DiscountDepartmentID, 'DiscountDepartmentPOS' , Status, dbo.GetLocalDATE() , 1,'DiscountDepartmentID' FROM      inserted
  end
GO