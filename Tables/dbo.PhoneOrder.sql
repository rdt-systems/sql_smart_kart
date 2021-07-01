CREATE TABLE [dbo].[PhoneOrder] (
  [PhoneOrderID] [uniqueidentifier] NOT NULL,
  [PhoneOrderNo] [nvarchar](50) NULL,
  [StoreID] [uniqueidentifier] NULL,
  [CustomerID] [uniqueidentifier] NOT NULL,
  [DriversNote] [nvarchar](2000) NULL,
  [CustomerNote] [nvarchar](2000) NULL,
  [PickNote] [nvarchar](2000) NULL,
  [PhoneOrderDate] [datetime] NULL,
  [PhoneOrderTime] [datetime] NULL,
  [DeliveryDate] [datetime] NULL,
  [ShiftID] [nvarchar](50) NULL,
  [ShippingID] [uniqueidentifier] NULL,
  [PhoneOrderStatus] [int] NULL,
  [PickByID] [uniqueidentifier] NULL,
  [TakeByID] [uniqueidentifier] NULL,
  [TransactionID] [uniqueidentifier] NULL,
  [Type] [int] NULL,
  [Total] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [Freezer] [bit] NULL,
  [PaymentNote] [nvarchar](2000) NULL,
  [UserEditing] [uniqueidentifier] NULL,
  [StartEditing] [datetime] NULL,
  [TenderID] [int] NULL,
  CONSTRAINT [PK_PhoneOrder] PRIMARY KEY CLUSTERED ([PhoneOrderID])
)
GO

CREATE INDEX [IX_PhoneOrder_1]
  ON [dbo].[PhoneOrder] ([CustomerID], [DeliveryDate], [Status])
GO

CREATE INDEX [IX_PhoneOrder_2]
  ON [dbo].[PhoneOrder] ([PhoneOrderNo])
GO

CREATE INDEX [IX_PhoneOrder_Type_001]
  ON [dbo].[PhoneOrder] ([TransactionID])
  INCLUDE ([Type])
GO

CREATE INDEX [IX_PhoneOrder_WebExport_005]
  ON [dbo].[PhoneOrder] ([PhoneOrderStatus], [Status])
GO