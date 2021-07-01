CREATE TABLE [dbo].[CustomerMemberCards] (
  [CardID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NOT NULL,
  [CardNumber] [varchar](200) NULL,
  [HolderName] [nvarchar](200) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_CustomerMemberCards] PRIMARY KEY CLUSTERED ([CardID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeleteCustomerMemberCards] on [dbo].[CustomerMemberCards]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT CardID, 'CustomerMemberCards' , Status, dbo.GetLocalDATE() , 1,'CardID' FROM      inserted
  end
GO

ALTER TABLE [dbo].[CustomerMemberCards]
  ADD CONSTRAINT [FK_CustomerMemberCards_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID])
GO