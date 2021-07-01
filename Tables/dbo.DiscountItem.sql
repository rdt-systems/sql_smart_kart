CREATE TABLE [dbo].[DiscountItem] (
  [ItemDiscountID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [ItemID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DiscountItem] PRIMARY KEY CLUSTERED ([ItemDiscountID])
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDiscountItem] on [dbo].[DiscountItem]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT ItemDiscountID, 'DiscountItemPOS' , Status, dbo.GetLocalDATE() , 1,'ItemDiscountID' FROM      inserted
  end
GO