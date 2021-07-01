CREATE TABLE [dbo].[PPComp] (
  [PPCompID] [uniqueidentifier] NOT NULL,
  [PPCName] [nvarchar](50) NULL,
  [InvoiceNum] [nvarchar](50) NULL,
  [ReturnNum] [nvarchar](50) NULL,
  [PaymentNum] [nvarchar](50) NULL,
  [SaleOrderNum] [nvarchar](50) NULL,
  [ReceiveNum] [nvarchar](50) NULL,
  [ReturnSupplierNum] [nvarchar](50) NULL,
  [PaymentSupplierNum] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  CONSTRAINT [PK_PPComp] PRIMARY KEY CLUSTERED ([PPCompID])
)
GO