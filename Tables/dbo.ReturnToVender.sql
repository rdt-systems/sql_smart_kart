CREATE TABLE [dbo].[ReturnToVender] (
  [ReturnToVenderID] [uniqueidentifier] NOT NULL,
  [ReturnToVenderNo] [nvarchar](50) NULL,
  [StoreNo] [uniqueidentifier] NULL,
  [SupplierID] [uniqueidentifier] NULL,
  [PersonReturnID] [uniqueidentifier] NULL,
  [Total] [money] NULL,
  [Note] [nvarchar](4000) NULL,
  [ReturnToVenderDate] [datetime] NULL,
  [Taxable] [bit] NULL,
  [TaxRate] [decimal](19, 4) NULL,
  [TaxAmount] [money] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TransferedToBookkeeping] [bit] NULL,
  [Discount] [money] NULL,
  [IsDiscountInAmount] [bit] NULL,
  PRIMARY KEY CLUSTERED ([ReturnToVenderID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO