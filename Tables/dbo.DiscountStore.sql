CREATE TABLE [dbo].[DiscountStore] (
  [DiscountStoreID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DiscountStore] PRIMARY KEY CLUSTERED ([DiscountStoreID])
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDiscountStore] on [dbo].[DiscountStore]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT DiscountStoreID, 'DiscountStorePOS' , Status, dbo.GetLocalDATE() , 1,'DiscountStoreID' FROM      inserted
  end
GO