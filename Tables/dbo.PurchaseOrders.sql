CREATE TABLE [dbo].[PurchaseOrders] (
  [PurchaseOrderId] [uniqueidentifier] NOT NULL,
  [SupplierNo] [uniqueidentifier] NULL,
  [StoreNo] [uniqueidentifier] NULL,
  [PoNo] [nvarchar](50) NULL,
  [PersonOrderdId] [uniqueidentifier] NULL,
  [GrandTotal] [money] NULL,
  [ShipVia] [uniqueidentifier] NULL,
  [ShipTo] [uniqueidentifier] NULL,
  [TrackNo] [nvarchar](50) NULL,
  [TermsNo] [uniqueidentifier] NULL,
  [PurchaseOrderDate] [datetime] NULL,
  [ReqDate] [datetime] NULL,
  [ExpirationDate] [datetime] NULL,
  [Shipdrop] [bit] NULL,
  [POStatus] [int] NULL,
  [Note] [nvarchar](4000) NULL,
  [Reorder] [bit] NULL,
  [Status] [smallint] NULL,
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [BillToStoreID] [uniqueidentifier] NULL,
  [BuyerID] [uniqueidentifier] NULL,
  [DepartmentID] [uniqueidentifier] NULL,
  [SeasonID] [uniqueidentifier] NULL,
  [TermsID] [uniqueidentifier] NULL,
  [VendorPONo] [nvarchar](100) NULL,
  [ClassID] [uniqueidentifier] NULL,
  [MinMarkup] [decimal](18, 4) NULL,
  [ListPrice] [decimal](18, 4) NULL,
  [Import] [smallint] NULL,
  [Sent] [bit] NULL,
  [Approved] [bit] NULL,
  CONSTRAINT [PK_PurchaseOrders] PRIMARY KEY CLUSTERED ([PurchaseOrderId])
)
GO

CREATE INDEX [IX_PO_Info]
  ON [dbo].[PurchaseOrders] ([SupplierNo])
  INCLUDE ([DateCreated], [UserCreated], [DateModified], [UserModified])
GO

CREATE INDEX [IX_PO_Info_1]
  ON [dbo].[PurchaseOrders] ([Status])
  INCLUDE ([SupplierNo], [PurchaseOrderDate])
GO

CREATE INDEX [IX_PO_Stuff_Speed_001]
  ON [dbo].[PurchaseOrders] ([Status])
  INCLUDE ([PoNo])
GO

CREATE INDEX [IX_PurchaseOrders_PreSale_View_Speed_001]
  ON [dbo].[PurchaseOrders] ([Status])
  INCLUDE ([StoreNo], [POStatus])
GO

CREATE INDEX [IX_PurchaseOrders_PreSale_View_Speed_002]
  ON [dbo].[PurchaseOrders] ([StoreNo], [Status])
  INCLUDE ([POStatus])
GO

CREATE INDEX [IX_PurchaseOrders_PurchaseOrderDate_Status]
  ON [dbo].[PurchaseOrders] ([PurchaseOrderDate], [Status])
  INCLUDE ([StoreNo], [GrandTotal])
GO

CREATE INDEX [PurchaseOrders_IX1]
  ON [dbo].[PurchaseOrders] ([PurchaseOrderDate], [Status])
  INCLUDE ([PurchaseOrderId], [StoreNo])
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_ChangePurchaseOrders] on [dbo].[PurchaseOrders]
for  update , insert , delete
as

 declare @PurchaseOrderId nvarchar(500) ,@ModifierID uniqueidentifier
 select  @PurchaseOrderId =inserted.PurchaseOrderId,@ModifierID=UserModified
 from inserted 


 
 declare @PurchaseOrderIdDelete nvarchar(500) ,@ModifierIDDelete uniqueidentifier
 select  @PurchaseOrderIdDelete =deleted.PurchaseOrderId,@ModifierIDDelete=deleted.UserModified
 from deleted 

if (select count(0) from inserted ) >0 and   (select count(0) from deleted ) <=0 
begin 
 exec SP_SaveRecentActivity 13,'PurchaseOrders',1,@PurchaseOrderId,1,'PurchaseOrderId',@ModifierID,null
end 


else if Update (Status) AND ((select count(0) from inserted WHERE STATUS <1) > 0)
begin 
exec SP_SaveRecentActivity 15,'PurchaseOrders',1,@PurchaseOrderId,1,'PurchaseOrderId',@ModifierID,null
end 

else if
 (select count(0) from inserted ) >0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 14,'PurchaseOrders',1,@PurchaseOrderId,1,'PurchaseOrderId',@ModifierID,null
end 


else if
 (select count(0) from inserted ) =0 and   (select count(0) from deleted ) >=0

begin 
exec SP_SaveRecentActivity 16,'PurchaseOrders',1,@PurchaseOrderIdDelete,1,'PurchaseOrderId',@ModifierIDDelete,null
end
GO