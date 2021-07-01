CREATE TABLE [dbo].[ReceiveOrder] (
  [ReceiveID] [uniqueidentifier] NOT NULL,
  [PackingSlipNo] [nvarchar](50) NULL,
  [StoreID] [uniqueidentifier] NULL,
  [SupplierNo] [uniqueidentifier] NULL,
  [BillID] [uniqueidentifier] NULL,
  [Freight] [money] NULL,
  [Discount] [decimal](18, 3) NULL,
  [Note] [nvarchar](4000) NULL,
  [Total] [money] NULL,
  [CurrBalance] [money] NULL,
  [IsDiscAmount] [bit] NULL,
  [ReceiveOrderDate] [datetime] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [FilePath] [nvarchar](150) NULL,
  [CustomsDuties] [money] NULL,
  [OtherCharges] [money] NULL,
  [TermsID] [uniqueidentifier] NULL,
  [BuyerID] [uniqueidentifier] NULL,
  [BillToStoreID] [uniqueidentifier] NULL,
  [VendorPONo] [nvarchar](100) NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [SeasonID] [uniqueidentifier] NULL,
  [UserEditing] [uniqueidentifier] NULL,
  [StartEditing] [datetime] NULL,
  CONSTRAINT [PK_ReceiveOrder] PRIMARY KEY CLUSTERED ([ReceiveID])
)
GO

CREATE INDEX [IX_ReceiveInfo]
  ON [dbo].[ReceiveOrder] ([Status])
  INCLUDE ([SupplierNo], [ReceiveOrderDate])
GO

CREATE INDEX [IX_ReceiveInfo_1]
  ON [dbo].[ReceiveOrder] ([SupplierNo])
  INCLUDE ([DateCreated], [UserCreated], [DateModified], [UserModified])
GO

CREATE INDEX [IX_ReceiveOrder_Dashboard01]
  ON [dbo].[ReceiveOrder] ([ReceiveOrderDate], [Status])
  INCLUDE ([StoreID], [Total])
GO

CREATE INDEX [IX_ReceiveOrder_Speed_001]
  ON [dbo].[ReceiveOrder] ([Status])
  INCLUDE ([BillID], [ReceiveOrderDate])
GO

CREATE INDEX [IX_ReciveOrder_Speed_0002]
  ON [dbo].[ReceiveOrder] ([BillID], [Status])
  INCLUDE ([ReceiveOrderDate])
GO

CREATE INDEX [ReceiveOrder_IX1]
  ON [dbo].[ReceiveOrder] ([ReceiveID], [StoreID], [ReceiveOrderDate], [Status])
  INCLUDE ([Total])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_ChangeReceiveOrder] on [dbo].[ReceiveOrder]
for  update , insert , delete
as

 declare @ReceiveID nvarchar(500) ,@ModifierID uniqueidentifier
 select  @ReceiveID =inserted.ReceiveID,@ModifierID=UserModified
 from inserted 
 where inserted.status != -9


 
 declare @ReceiveIDDelete nvarchar(500) ,@ModifierIDDelete uniqueidentifier
 select  @ReceiveIDDelete =deleted.receiveID,@ModifierIDDelete=deleted.UserModified
 from deleted 
 where deleted.status != -9

if (select count(0) from inserted ) >0 and   (select count(0) from deleted ) <=0 
begin 
 exec SP_SaveRecentActivity 17,'ReceiveOrder',1,@ReceiveID,1,'ReceiveID',@ModifierID,null
end 


else if Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
begin 
exec SP_SaveRecentActivity 19,'ReceiveOrder',1,@ReceiveID,1,'ReceiveID',@ModifierID,null
end 

else if
 (select count(0) from inserted ) >0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 18,'ReceiveOrder',1,@ReceiveID,1,'ReceiveID',@ModifierID,null
end 


else if
 (select count(0) from inserted ) =0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 20,'ReceiveOrder',1,@ReceiveIDDelete,1,'ReceiveID',@ModifierIDDelete,null
end
GO