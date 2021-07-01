CREATE TABLE [dbo].[CustomerAddresses] (
  [CustomerAddressID] [uniqueidentifier] NOT NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [Name] [nvarchar](50) NULL,
  [Street1] [nvarchar](200) NULL,
  [Street2] [nvarchar](50) NULL,
  [City] [nvarchar](100) NULL,
  [State] [nvarchar](100) NULL,
  [Zip] [nvarchar](15) NULL,
  [Country] [nvarchar](50) NULL,
  [AddressType] [int] NOT NULL,
  [CCRT] [nvarchar](20) NULL,
  [PhoneNumber1] [nvarchar](100) NULL,
  [Ext1] [nvarchar](20) NULL,
  [PhoneNumber2] [nvarchar](100) NULL,
  [Ext2] [nvarchar](20) NULL,
  [SortOrder] [smallint] NULL,
  [IsTextable] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [UseSMS] [bit] NULL,
  CONSTRAINT [PK_CustomerAddresses] PRIMARY KEY CLUSTERED ([CustomerAddressID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_CustomerAddresses_7_146099561__K1_K2_K10_K17_K4_K12_K6_K7_K8_5]
  ON [dbo].[CustomerAddresses] ([CustomerAddressID], [CustomerID], [AddressType], [Status], [Street1], [PhoneNumber1], [City], [State], [Zip])
  INCLUDE ([Street2])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustAddressStatus]
  ON [dbo].[CustomerAddresses] ([AddressType], [Status])
  INCLUDE ([Zip], [State], [PhoneNumber1], [Country], [City], [CustomerID], [CustomerAddressID], [Street2], [Street1])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustomerAddress_Speed_001]
  ON [dbo].[CustomerAddresses] ([AddressType], [Status])
  INCLUDE ([City], [CustomerAddressID], [CustomerID], [PhoneNumber1], [PhoneNumber2], [State], [Street1], [Street2], [Zip])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustomerAddresses_AddressType_CustomerID_PhoneNumber1_Status]
  ON [dbo].[CustomerAddresses] ([AddressType], [CustomerID], [PhoneNumber1], [Status])
  INCLUDE ([Street1], [Street2], [City], [State], [Zip], [PhoneNumber2])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustomerAddresses_AddressType_PhoneNumber1_Status]
  ON [dbo].[CustomerAddresses] ([AddressType], [PhoneNumber1], [Status])
  INCLUDE ([CustomerID], [Street1], [Street2], [City], [State], [Zip], [PhoneNumber2])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustomerAddresses_CustomerID_Status]
  ON [dbo].[CustomerAddresses] ([CustomerID], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CustomerAddresses_CustomerID_Status_DateModified]
  ON [dbo].[CustomerAddresses] ([CustomerID], [Status], [DateModified])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_DeletetCustomerAddresses] on [dbo].[CustomerAddresses]
for  update
as
if   Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
  begin
    INSERT INTO DeleteRecordes (TableID, TableName, Status, DateModified, IsGuid,FieldName)
	SELECT CustomerID, 'CustomerAddresses' , Status, dbo.GetLocalDATE() , 1,'CustomerAddressID' FROM      inserted
  end
GO















SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO