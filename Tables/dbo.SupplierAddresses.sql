CREATE TABLE [dbo].[SupplierAddresses] (
  [AddressID] [uniqueidentifier] NOT NULL,
  [Name] [nvarchar](50) NULL,
  [Line1] [nvarchar](50) NULL,
  [Line2] [nvarchar](50) NULL,
  [Quarter] [nvarchar](20) NULL,
  [City] [nvarchar](20) NULL,
  [State] [nvarchar](50) NULL,
  [Zip] [nvarchar](15) NULL,
  [Country] [nvarchar](15) NULL,
  [AddressType] [int] NOT NULL,
  [CCRT] [nvarchar](20) NULL,
  [PhoneNumber1] [nvarchar](20) NULL,
  [Ext1] [nvarchar](20) NULL,
  [PhoneNumber2] [nvarchar](20) NULL,
  [PhoneNumber3] [nvarchar](20) NULL,
  [Ext2] [nvarchar](20) NULL,
  [SortOrder] [smallint] NULL,
  [Status] [smallint] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [cellphone] [nvarchar](20) NULL,
  [Ext3] [nvarchar](20) NULL,
  CONSTRAINT [PK_SupplierAddresses] PRIMARY KEY CLUSTERED ([AddressID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO