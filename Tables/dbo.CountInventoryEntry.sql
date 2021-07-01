CREATE TABLE [dbo].[CountInventoryEntry] (
  [CountInventoryEntryID] [int] IDENTITY,
  [CountInventoryID] [int] NULL,
  [ItemStoreID] [uniqueidentifier] NULL,
  [Status] [int] NULL,
  [Total] [int] NULL,
  [DateCreated] [datetime] NULL,
  [DateModified] [datetime] NULL,
  [OnHand] [decimal] NULL,
  [CountEntryID] [uniqueidentifier] NULL,
  CONSTRAINT [PK__CountInv__66A2AF8E45B43A08] PRIMARY KEY CLUSTERED ([CountInventoryEntryID])
)
GO

CREATE UNIQUE INDEX [IX_CountInventoryEntry]
  ON [dbo].[CountInventoryEntry] ([CountEntryID])
  WHERE ([Status]>(-1) AND [CountEntryID] IS NOT NULL)
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [trg_UpdateItemCount]
   ON  [dbo].[CountInventoryEntry]  
  AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

     IF Update(Total) 
	BEGIN
	Update ItemStore Set CountOnHand = i.OnHand,  
	LastCount = (select sum(Total) from CountInventoryEntry cie where cie.Status > 0 and cie.ITemstoreid = i.itemstoreid)
	, CountDate = i.DateCreated From inserted i inner join Itemstore its on its.itemstoreid = i.itemstoreid 
	END

END
GO