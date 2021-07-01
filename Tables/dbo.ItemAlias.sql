CREATE TABLE [dbo].[ItemAlias] (
  [AliasId] [uniqueidentifier] NOT NULL,
  [ItemNo] [uniqueidentifier] NULL,
  [BarcodeNumber] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_ItemAlias] PRIMARY KEY CLUSTERED ([AliasId])
)
GO

CREATE INDEX [ix_ItemAlias_1]
  ON [dbo].[ItemAlias] ([ItemNo], [Status])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteItemAlias] on [dbo].[ItemAlias]
for  update,Insert
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT BarcodeNumber, 'ItemsQuery' , Status, dbo.GetLocalDATE() , 0,'AliasBarcode' FROM      inserted
  end

IF update (Status) AND ((select count(0) from inserted WHERE STATUS >0) > 0)
Begin
Delete From DeleteRecordes Where TableID IN (Select CONVERT(nvarchar(50),BarcodeNumber) From inserted)
End
GO