SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ItemsLastTansactionView]
(
@DateModified datetime=null,
@StoreID uniqueidentifier
)
AS 
 CREATE TABLE #Trans(
    [CustomerID] [uniqueidentifier] NULL,
    [Price] [money] NULL,
	[Qty] [decimal] NULL,
	[StartSaleTime] [datetime] NULL,
	[TransactionNo] [nvarchar](100) NULL,
    [ItemID] [uniqueidentifier] NULL,
	[BarcodeNumber] [nvarchar](100) NULL,
    [TransactionID] [uniqueidentifier] NULL,
	[Name] [nvarchar](150) NULL,
	[ModalNumber] [nvarchar](100) NULL,
	[ID] [nvarchar](100) NULL,
	[DateModified] [datetime] NULL,
    [Status] [int] NULL
)

Select
    ItemMain.ItemID,
    ItemStore.ItemStoreID,
    ItemMain.BarcodeNumber,
    ItemMain.Name,
    ItemMain.ModalNumber,
    ItemStore.DateModified
into #ItmTmp
From
    dbo.ItemMain Inner Join
    dbo.ItemStore On ItemStore.ItemNo = ItemMain.ItemID
Where
    (ItemStore.DateModified >= @DateModified or @DateModified is null)
	and StoreNo =@StoreID

declare @B as int=1
DECLARE @ItemID as uniqueidentifier
DECLARE @ISID as uniqueidentifier
Declare @Name as  [nvarchar](150)
Declare @UPC as  [nvarchar](100)
Declare @MN as  [nvarchar](100)
DECLARE @D as DateTime

SET @B= (SELECT COUNT(*) FROM #ItmTmp)
WHILE @B > 0                    
BEGIN

		Select Top(1) @ItemID=ItemID,@ISID=ItemStoreID,@D=DateModified,@Name=[Name],@UPC=BarcodeNumber,@MN=ModalNumber from #ItmTmp
		print convert(nvarchar(50),@ItemID)
		INSERT INTO #trans
		Select Top (5)
			[Transaction].CustomerID,
			TransactionEntry.UOMPrice As Price,
			TransactionEntry.UOMQty As Qty,
			[Transaction].StartSaleTime,
			[Transaction].TransactionNo,
			@ItemID,
			@UPC,
			[Transaction].TransactionID,
			@Name,
			@MN,
			CONVERT(varchar(100), Cast(ROW_NUMBER() OVER (PARTITION BY ItemStoreID
		  ORDER BY StartSaleTime desc,ItemStoreID  ) as decimal(38, 0)))+@UPC AS ID,
			@D,
			1 As Status
		From
			dbo.TransactionEntry WITH (NOLOCK) Inner Join
			dbo.[Transaction]  WITH (NOLOCK)  On TransactionEntry.TransactionID = [Transaction].TransactionID
		Where
			[Transaction].Status > 0 And
			TransactionEntry.Status > 0 and
			TransactionEntry.ItemStoreID = @ISID
		Order By
			[Transaction].StartSaleTime Desc

	delete from #ItmTmp  where ItemID=@ItemID
    SET @B=@B-1
END

Select * from #Trans
drop table #ItmTmp
drop table #Trans
GO