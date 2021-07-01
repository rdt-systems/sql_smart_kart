﻿CREATE TABLE [dbo].[W_Transaction] (
  [TransactionID] [uniqueidentifier] NOT NULL,
  [TransactionNo] [nvarchar](50) NOT NULL,
  [TransactionType] [int] NOT NULL,
  [RegisterTransaction] [bit] NULL,
  [BatchID] [uniqueidentifier] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [CustomerID] [uniqueidentifier] NULL,
  [Debit] [money] NULL,
  [Credit] [money] NULL,
  [StartSaleTime] [datetime] NULL,
  [EndSaleTime] [datetime] NULL,
  [DueDate] [datetime] NULL,
  [CurrBalance] [money] NULL,
  [LeftDebit] [money] NULL,
  [Freight] [money] NULL,
  [Tax] [money] NULL,
  [TaxType] [nvarchar](50) NULL,
  [TaxRate] [decimal](19, 4) NULL,
  [TaxID] [uniqueidentifier] NULL,
  [Rounding] [money] NULL CONSTRAINT [DF_W_Transaction_Rounding] DEFAULT (0),
  [ShipTo] [uniqueidentifier] NULL,
  [ShipVia] [uniqueidentifier] NULL,
  [PONo] [nvarchar](50) NULL,
  [RepID] [uniqueidentifier] NULL,
  [TermsID] [uniqueidentifier] NULL,
  [PhoneOrder] [bit] NULL,
  [ToPrint] [bit] NULL,
  [ToEmail] [bit] NULL,
  [CustomerMessage] [uniqueidentifier] NULL,
  [RegisterID] [uniqueidentifier] NULL,
  [RecieptTxt] [ntext] NULL,
  [Note] [nvarchar](4000) NULL,
  [VoidReason] [nvarchar](4000) NULL,
  [ResellerID] [uniqueidentifier] NULL,
  [DeliveryDate] [datetime] NULL,
  [TrackNo] [nvarchar](50) NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [TransferedToBookkeeping] [bit] NULL CONSTRAINT [DF_W_Transaction_TransferedToBookkeeping] DEFAULT (0),
  CONSTRAINT [PK_W_Transaction] PRIMARY KEY CLUSTERED ([TransactionID])
)
GO