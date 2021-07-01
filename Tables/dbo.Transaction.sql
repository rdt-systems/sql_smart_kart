CREATE TABLE [dbo].[Transaction] (
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
  [Rounding] [money] NULL CONSTRAINT [DF_Transaction_Rounding] DEFAULT (0),
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
  [TransferedToBookkeeping] [bit] NULL CONSTRAINT [DF_Transaction_TransferedToBookkeeping] DEFAULT (0),
  [RegShiftID] [uniqueidentifier] NULL,
  [TransactionInt] [int] IDENTITY,
  PRIMARY KEY CLUSTERED ([TransactionID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_Transaction_10_539669516__K36_K11_K7_K6_K1_K33_2_3_4_5_8_9_10_12_14_15_16_17_18_19_20_21_22_23_24_25_26_27_28_29_31_]
  ON [dbo].[Transaction] ([Status], [EndSaleTime], [CustomerID], [StoreID], [TransactionID], [ResellerID])
  INCLUDE ([PhoneOrder], [TermsID], [ToEmail], [ToPrint], [ShipVia], [UserModified], [RepID], [PONo], [CustomerMessage], [DateCreated], [TrackNo], [DateModified], [UserCreated], [Note], [RegisterID], [DeliveryDate], [VoidReason], [TaxID], [BatchID], [Debit], [Credit], [RegisterTransaction], [ShipTo], [TransactionNo], [TransactionType], [StartSaleTime], [TaxType], [Tax], [Freight], [LeftDebit], [DueDate], [TaxRate])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_11_133575514__K1_K10_K7_K36_3_8_9]
  ON [dbo].[Transaction] ([TransactionID], [StartSaleTime], [CustomerID], [Status])
  INCLUDE ([Credit], [TransactionType], [Debit])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_11_133575514__K3_K36_K7_K10_1_8_9_11]
  ON [dbo].[Transaction] ([TransactionType], [Status], [CustomerID], [StartSaleTime])
  INCLUDE ([Credit], [EndSaleTime], [Tax], [Debit], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_11_133575514__K7_K10_K36_K3_1_8_9_11]
  ON [dbo].[Transaction] ([CustomerID], [StartSaleTime], [Status], [TransactionType])
  INCLUDE ([Debit], [Credit], [EndSaleTime], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_23_133575514__K10_K8_K36_1_7_12_14]
  ON [dbo].[Transaction] ([StartSaleTime], [Debit], [Status])
  INCLUDE ([LeftDebit], [DueDate], [TransactionID], [CustomerID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_1317579732__K1_K10_K37_K6_2_3_7_39]
  ON [dbo].[Transaction] ([TransactionID], [StartSaleTime], [Status], [StoreID])
  INCLUDE ([TransactionType], [CustomerID], [UserCreated], [TransactionNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_1317579732__K1_K37_K43]
  ON [dbo].[Transaction] ([TransactionID], [Status], [RegShiftID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_1317579732__K10_K37_K1_K7_2_3]
  ON [dbo].[Transaction] ([StartSaleTime], [Status], [TransactionID], [CustomerID])
  INCLUDE ([TransactionNo], [TransactionType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_1317579732__K43_K37_K1_8_9_16]
  ON [dbo].[Transaction] ([RegShiftID], [Status], [TransactionID])
  INCLUDE ([Tax], [Debit], [Credit])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_1317579732__K6_K1_K10_K37]
  ON [dbo].[Transaction] ([StoreID], [TransactionID], [StartSaleTime], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_2005582183__K1_10_37]
  ON [dbo].[Transaction] ([TransactionID])
  INCLUDE ([Status], [StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_2005582183__K10_K6_K37_K1]
  ON [dbo].[Transaction] ([StartSaleTime], [StoreID], [Status], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_2005582183__K5]
  ON [dbo].[Transaction] ([BatchID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_37575172__K1_K10_K32_K3_K11_K6_K7_K29_8_9_14]
  ON [dbo].[Transaction] ([TransactionID], [StartSaleTime], [Status], [TransactionType], [EndSaleTime], [StoreID], [CustomerID], [RegisterID])
  INCLUDE ([Debit], [LeftDebit], [Credit])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_629577281__K7_K11_K1]
  ON [dbo].[Transaction] ([CustomerID], [EndSaleTime], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_5_629577281__K7_K11_K1_K13]
  ON [dbo].[Transaction] ([CustomerID], [EndSaleTime], [TransactionID], [CurrBalance])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_6_2005582183__K6_K1_K10_K37_2_3_7_39]
  ON [dbo].[Transaction] ([StoreID], [TransactionID], [StartSaleTime], [Status])
  INCLUDE ([TransactionType], [CustomerID], [UserCreated], [TransactionNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_7_2005582183__K10_K6_K37_K1_K7_2]
  ON [dbo].[Transaction] ([StartSaleTime], [StoreID], [Status], [TransactionID], [CustomerID])
  INCLUDE ([TransactionNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_7_2005582183__K11_K3_K37_K1_K7_K39_K6_K13_2_4_5_8_9_10_12_15_16_17_18_19_20_21_22_23_24_25_26_27_28_29_]
  ON [dbo].[Transaction] ([EndSaleTime], [TransactionType], [Status], [TransactionID], [CustomerID], [UserCreated], [StoreID], [CurrBalance])
  INCLUDE ([ToPrint], [PhoneOrder], [CustomerMessage], [ToEmail], [TermsID], [ShipVia], [RegShiftID], [RepID], [PONo], [DateCreated], [TrackNo], [UserModified], [DateModified], [DeliveryDate], [Note], [RegisterID], [ResellerID], [VoidReason], [Rounding], [Debit], [Credit], [StartSaleTime], [BatchID], [ShipTo], [TransactionNo], [RegisterTransaction], [Freight], [TaxRate], [TaxType], [Tax], [DueDate], [TaxID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_Transaction_7_2005582183__K7_K37_K3_K13_10]
  ON [dbo].[Transaction] ([CustomerID], [Status], [TransactionType], [CurrBalance])
  INCLUDE ([StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IndexForTransactionEntryForTax1]
  ON [dbo].[Transaction] ([Status])
  INCLUDE ([StartSaleTime], [TaxRate], [StoreID], [TransactionID], [TransactionNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_CurrBalance_Trans]
  ON [dbo].[Transaction] ([CustomerID], [CurrBalance], [Status])
  INCLUDE ([StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_LastTransaction_Speed_001]
  ON [dbo].[Transaction] ([Status])
  INCLUDE ([Credit], [CustomerID], [DateCreated], [DateModified], [Debit], [EndSaleTime], [TransactionID], [TransactionInt], [TransactionNo], [TransactionType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction]
  ON [dbo].[Transaction] ([TransactionInt])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_1651656165]
  ON [dbo].[Transaction] ([StoreID], [Status])
  INCLUDE ([TransactionID], [StartSaleTime], [Tax])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_CUstomerDetails]
  ON [dbo].[Transaction] ([StoreID])
  INCLUDE ([CustomerID], [StartSaleTime], [Tax], [UserCreated])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [ix_Transaction_IX3]
  ON [dbo].[Transaction] ([CustomerID], [Status])
  INCLUDE ([EndSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_QBSync_001]
  ON [dbo].[Transaction] ([StoreID], [Status])
  INCLUDE ([Debit], [Credit], [StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_Report_Speed_001]
  ON [dbo].[Transaction] ([StoreID], [StartSaleTime], [Status])
  INCLUDE ([TransactionNo], [EndSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_ResellerID_Status]
  ON [dbo].[Transaction] ([ResellerID], [Status])
  INCLUDE ([Debit])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_Speed_0006]
  ON [dbo].[Transaction] ([UserCreated], [Status])
  INCLUDE ([StartSaleTime], [TransactionID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_Speed_0056]
  ON [dbo].[Transaction] ([StoreID], [Status])
  INCLUDE ([TransactionID], [StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_speed002]
  ON [dbo].[Transaction] ([CustomerID], [CurrBalance], [Status])
  INCLUDE ([EndSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_UserCreated_Status]
  ON [dbo].[Transaction] ([UserCreated], [Status])
  INCLUDE ([StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_Transaction_WebOrder_Speed_001]
  ON [dbo].[Transaction] ([PONo], [Status])
  INCLUDE ([Debit], [EndSaleTime], [TransactionID], [TransactionNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [missing_index_14109_14108_Transaction]
  ON [dbo].[Transaction] ([TransactionNo], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [nci_wi_Transaction_0D3A255EAC2E025EEBC1D1D65FA2A972]
  ON [dbo].[Transaction] ([StoreID], [EndSaleTime])
  INCLUDE ([CustomerID], [Debit], [StartSaleTime], [Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [NonClusteredIndex-20160321-182203]
  ON [dbo].[Transaction] ([Status], [TransactionID], [StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [RM_Transaction_]
  ON [dbo].[Transaction] ([TransactionType], [Status], [TransactionID])
  INCLUDE ([StartSaleTime], [Debit], [StoreID])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [TransactionTypeOnCustomerID]
  ON [dbo].[Transaction] ([TransactionType], [CustomerID], [Status])
  INCLUDE ([StartSaleTime])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_ChangeTransaction] on [dbo].[Transaction]
for  update , insert , delete
as

 declare @TransactionID nvarchar(500) ,@ModifierID uniqueidentifier
 select  @TransactionID =inserted.TransactionID,@ModifierID=ISNULL(UserModified,Inserted.UserCreated)
 from inserted 


 
 declare @TransactionIDDelete nvarchar(500) ,@ModifierIDDelete uniqueidentifier
 select  @TransactionIDDelete =deleted.TransactionID,@ModifierIDDelete=ISNULL(deleted.UserModified,Deleted.UserCreated)
 from deleted 

if (select count(0) from inserted ) >0 and   (select count(0) from deleted ) <=0 
begin 
 exec SP_SaveRecentActivity 21,'Transaction',1,@TransactionID,1,'TransactionID',@ModifierID,null
end 


else if Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
begin 
exec SP_SaveRecentActivity 23,'Transaction',1,@TransactionID,1,'TransactionID',@ModifierID,null
end 

else if
 (select count(0) from inserted ) >0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 22,'Transaction',1,@TransactionID,1,'TransactionID',@ModifierID,null
end 


else if
 (select count(0) from inserted ) =0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 24,'Transaction',1,@TransactionIDDelete,1,'TransactionID',@ModifierIDDelete,null
end
GO

















































































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO