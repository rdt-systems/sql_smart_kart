CREATE TABLE [dbo].[DiscountBrand] (
  [DiscountBrandID] [uniqueidentifier] NOT NULL,
  [DiscountID] [uniqueidentifier] NULL,
  [BrandID] [uniqueidentifier] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_DiscountBrand] PRIMARY KEY CLUSTERED ([DiscountBrandID])
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteDiscountBrand] on [dbo].[DiscountBrand]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT DiscountBrandID, 'DiscountBrandPOS' , Status, dbo.GetLocalDATE() , 1,'DiscountBrandID' FROM      inserted
  end
GO