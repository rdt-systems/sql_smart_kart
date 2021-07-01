CREATE TABLE [dbo].[ItemMain] (
  [ItemID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ItemMain_ItemID] DEFAULT (newid()),
  [Name] [nvarchar](250) NULL,
  [Description] [nvarchar](4000) NULL,
  [ModalNumber] [nvarchar](50) NULL,
  [Quantization] [decimal](28, 3) NULL,
  [Unit] [uniqueidentifier] NULL,
  [ParentID] [uniqueidentifier] NULL,
  [MatrixTableNo] [uniqueidentifier] NULL,
  [LinkNo] [uniqueidentifier] NULL,
  [Matrix1] [nvarchar](50) NULL,
  [Matrix2] [nvarchar](50) NULL,
  [Matrix3] [nvarchar](50) NULL,
  [Matrix4] [nvarchar](50) NULL,
  [Matrix5] [nvarchar](50) NULL,
  [Matrix6] [nvarchar](50) NULL,
  [BarcodeNumber] [nvarchar](50) NULL,
  [CaseBarcodeNumber] [nvarchar](50) NULL,
  [CaseQty] [int] NULL CONSTRAINT [DF_ItemMain_CaseQty] DEFAULT (0),
  [CaseDescription] [nvarchar](50) NULL,
  [BarcodeType] [int] NULL CONSTRAINT [DF_ItemMain_BarcodeType] DEFAULT (0),
  [ItemType] [int] NULL CONSTRAINT [DF_ItemMain_ItemType] DEFAULT (0),
  [ItemPicture] [image] NULL,
  [PicturePath] [nvarchar](4000) NULL,
  [ItemPicture2] [image] NULL,
  [PicturePath2] [nvarchar](4000) NULL,
  [ItemPicture3] [image] NULL,
  [PicturePath3] [nvarchar](4000) NULL,
  [IsTemplate] [bit] NULL,
  [IsSerial] [bit] NULL,
  [ManufacturerID] [uniqueidentifier] NULL,
  [ManufacturerPartNo] [nvarchar](50) NULL,
  [PriceByCase] [bit] NULL CONSTRAINT [DF_ItemMain_PriceByCase] DEFAULT (0),
  [CostByCase] [bit] NULL CONSTRAINT [DF_ItemMain_CostByCase] DEFAULT (0),
  [Size] [nvarchar](120) NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_ItemMain_Status] DEFAULT (1),
  [DateCreated] [datetime] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateModified] [datetime] NULL,
  [UserModified] [uniqueidentifier] NULL,
  [ExtraInfo] [ntext] NULL,
  [Units] [decimal](18, 2) NULL,
  [Meaasure] [int] NULL,
  [CaseBarCode] [nvarchar](25) NULL,
  [ExtraInfo2] [ntext] NULL,
  [CustomerCode] [nvarchar](50) NULL,
  [NoScanMsg] [nvarchar](100) NULL,
  [StyleNo] [nvarchar](50) NULL,
  [CustomInteger1] [int] NULL,
  [ExtName] [uniqueidentifier] NULL,
  [SeasonID] [uniqueidentifier] NULL,
  [CustomField1] [uniqueidentifier] NULL,
  [CustomField10] [uniqueidentifier] NULL,
  [CustomField2] [uniqueidentifier] NULL,
  [CustomField3] [uniqueidentifier] NULL,
  [CustomField4] [uniqueidentifier] NULL,
  [CustomField5] [uniqueidentifier] NULL,
  [CustomField6] [uniqueidentifier] NULL,
  [CustomField7] [uniqueidentifier] NULL,
  [CustomField8] [uniqueidentifier] NULL,
  [CustomField9] [uniqueidentifier] NULL,
  [Note] [nvarchar](2000) NULL,
  [PkgCode] [nvarchar](50) NULL,
  CONSTRAINT [PK_ItemMain] PRIMARY KEY CLUSTERED ([ItemID]) WITH (STATISTICS_NORECOMPUTE = ON)
)
GO

CREATE INDEX [_dta_index_ItemMain_21_201572302__K1_2_4_12]
  ON [dbo].[ItemMain] ([ItemID], [Status])
  INCLUDE ([StyleNo], [BarcodeNumber], [ModalNumber], [Name])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemMain_5_286624064__K1_K20_K21_K6_K8_K30_K4_K16_2_18]
  ON [dbo].[ItemMain] ([ItemID], [BarcodeType], [ItemType], [Unit], [MatrixTableNo], [ManufacturerID], [ModalNumber], [BarcodeNumber])
  INCLUDE ([Name], [CaseQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemMain_5_286624064__K1_K6_K8_K30_K20_18]
  ON [dbo].[ItemMain] ([ItemID], [Unit], [MatrixTableNo], [ManufacturerID], [BarcodeType])
  INCLUDE ([CaseQty])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemMain_5_830626002__K1_K21_K6_K8_K30_2_4_16_18]
  ON [dbo].[ItemMain] ([ItemID], [ItemType], [Unit], [MatrixTableNo], [ManufacturerID])
  INCLUDE ([ModalNumber], [BarcodeNumber], [CaseQty], [Name])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [_dta_index_ItemMain_6_286624064__K1_K6_K8_K30_K21_2_4_16_18]
  ON [dbo].[ItemMain] ([ItemID], [Unit], [MatrixTableNo], [ManufacturerID], [ItemType])
  INCLUDE ([BarcodeNumber], [CaseQty], [ModalNumber], [Name])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE UNIQUE INDEX [IX_ItemMain]
  ON [dbo].[ItemMain] ([BarcodeNumber])
  WHERE ([Status]>(-1))
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_LinkNo]
  ON [dbo].[ItemMain] ([LinkNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_LinkNo_Status]
  ON [dbo].[ItemMain] ([LinkNo], [Status])
  INCLUDE ([Matrix1], [Matrix2])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_OnHandUpdate_Speed_001]
  ON [dbo].[ItemMain] ([ItemType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_Reports_Speed_00002]
  ON [dbo].[ItemMain] ([LinkNo], [ItemType], [Status])
  INCLUDE ([Matrix1], [StyleNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_Reports_Speed_0001]
  ON [dbo].[ItemMain] ([Status])
  INCLUDE ([LinkNo], [Matrix1], [StyleNo])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_Search_Mis]
  ON [dbo].[ItemMain] ([BarcodeNumber], [ItemType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_Speed_001]
  ON [dbo].[ItemMain] ([Status])
  INCLUDE ([ItemID], [ModalNumber])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_Status]
  ON [dbo].[ItemMain] ([Status])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_Status_Speed_005]
  ON [dbo].[ItemMain] ([Status])
  INCLUDE ([Name], [BarcodeNumber], [ItemType], [Size])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [Ix_ItemMain_style_itemType]
  ON [dbo].[ItemMain] ([StyleNo], [ItemType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_TransactionEntryItem_Speed_00001]
  ON [dbo].[ItemMain] ([ItemType])
  INCLUDE ([LinkNo], [CaseQty], [BarcodeType])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [IX_ItemMain_WebExport_0005]
  ON [dbo].[ItemMain] ([Status])
  INCLUDE ([Name], [Description], [ModalNumber], [BarcodeNumber], [Size])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

CREATE INDEX [Ix_Missing_513]
  ON [dbo].[ItemMain] ([ItemType])
  INCLUDE ([Name], [ModalNumber], [MatrixTableNo], [LinkNo], [Matrix1], [Matrix2], [BarcodeNumber], [CaseBarcodeNumber], [CaseQty], [ManufacturerID], [PriceByCase], [CostByCase], [Status], [DateModified], [CustomerCode], [ExtName], [SeasonID], [CustomField1], [CustomField10], [CustomField2], [CustomField3], [CustomField4], [CustomField5], [CustomField6], [CustomField7], [CustomField8], [CustomField9])
  WITH (STATISTICS_NORECOMPUTE = ON)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_SeasonHistoryOnItemMain] on [dbo].[ItemMain]
for  update
as 

if   Update (SeasonID) 
BEGIN

Declare @UpdateTime datetime
SELECT @UpdateTime = dbo.GetLocalDATE()
Declare @ItemStoreID uniqueidentifier
Declare @ItemId uniqueidentifier
Declare @OldSeasonID uniqueidentifier
Declare @SeasonID uniqueidentifier
Declare @ModifierID uniqueidentifier


SELECT   TOP(1) @OldSeasonID = SeasonID
From deleted

select @ItemId=ItemID, @SeasonID=SeasonID, @ModifierID=UserModified
from inserted


IF @OldSeasonID<>@SeasonID 
INSERT INTO
 dbo.SeasonHistory(SeasonHistoryId, StoreId, ItemId, ItemStoreId, OldSeasonId, NewSeasonId, Onhand,Cost, DateCreated, UserCreated)
select  NEWID(),itemStore.StoreNo,@ItemId,itemStore.ItemStoreID,@OldSeasonID,@SeasonID,itemStore.Onhand,itemStore.Cost,@UpdateTime,@ModifierID
from itemStore
where itemStore.itemNo=@ItemId

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_ItemTypeOnItemMain] on [dbo].[ItemMain]
for  update
as 

if   Update (ItemType) 
BEGIN

Declare @UpdateTime datetime
SELECT @UpdateTime = dbo.GetLocalDATE()
Declare @ItemID uniqueidentifier
Declare @OldItemType int
Declare @NewItemType int
Declare @ModifierID uniqueidentifier


SELECT   TOP(1) @OldItemType = ItemType
From deleted

select @ItemID=ItemID, @NewItemType=ItemType, @ModifierID=UserModified
from inserted


IF @OldItemType<>@NewItemType 
INSERT INTO
 dbo.ItemTypeHistory (OldItemType,NewItemType,DateChanged,UserChanged,ItemID)
VALUES(@OldItemType, @NewItemType, @UpdateTime, @ModifierID, @ItemID)

END
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE trigger [Tr_ItemMainCreated] on [dbo].[ItemMain]
for  insert
as


BEGIN

Declare @ModifierID uniqueidentifier
Declare @ToItemId uniqueidentifier

select  @ToItemId = ItemId ,@ModifierID=UserModified
from inserted

Begin
exec SP_SaveRecentActivity 3,'ItemMain',1,@ToItemId,1,'ItemID',@ModifierID,null
End

END
GO







































SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO