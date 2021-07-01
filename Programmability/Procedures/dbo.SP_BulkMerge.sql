SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BulkMerge] (@DoubleName bit = 0,
@DoubleBarcode bit =0)
AS
BEGIN

	Declare @GoodID Uniqueidentifier
	Declare @NoGoodID Uniqueidentifier
	Declare @UPC Nvarchar(50)


	IF @DoubleBarcode = 1
	BEGIN
		select  ItemID,  Name,BarcodeNumber, Cost, Price, OnHand, DupeCount Into #MyMerge FROM
		(SELECT ROW_NUMBER() OVER (PARTITION BY  Name
			  ORDER BY Name, Cost, Price, OnHand Desc) AS DupeCount,Name, BarcodeNumber, ItemID, Cost, Price, OnHand
		  FROM ItemMainAndStoreGrid  Where  Status>-1 and StoreNo= (SELECT TOP(1) StoreID from Store Where status>0)) AS f

		Declare S Cursor For

		SELECT        good.ItemID, doble.ItemID AS NoGood
		FROM            [#MyMerge] AS doble INNER JOIN
									 (SELECT        *
									   FROM            [#MyMerge]
									   WHERE        (DupeCount = 1)) AS good ON doble.NAME = good.Name
		WHERE        (doble.DupeCount > 1)

		Open S

		Fetch Next From S Into @GoodID,@NoGoodID

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			EXEC    [dbo].[SP_MergeItems]
					@FromItemID = NULL,
					@ToItemID = NULL,
					@ModifierID = NULL,
					@FItemMainID = @NoGoodID,
					@ToItemMainID = @GoodID

			Update ItemAlias Set ItemNo = @GoodID, DateModified = dbo.GetLocalDATE() Where ItemNo = @GoodID

			Fetch Next From S Into @GoodID,@NoGoodID
		End

		Close S
		Deallocate S
		DROP TABLE  [#MyMerge]
	End

	ELSE IF @DoubleName = 1
	BEGIN

		select  ItemID,  Name,BarcodeNumber, Cost, Price, OnHand, DupeCount Into #MyMerge1 FROM
		(SELECT ROW_NUMBER() OVER (PARTITION BY  Name
			  ORDER BY Name, Cost, Price, OnHand Desc) AS DupeCount,Name, BarcodeNumber, ItemID, Cost, Price, OnHand
		  FROM ItemMainAndStoreGrid  Where  Status>-1 and StoreNo= (SELECT TOP(1) StoreID from Store Where status>0)) AS f


		Declare B Cursor For
		
		SELECT        good.ItemID, doble.ItemID AS NoGood, doble.BarcodeNumber
		FROM            [#MyMerge1] AS doble INNER JOIN
									 (SELECT        *
									   FROM            [#MyMerge1]
									   WHERE        (DupeCount = 1)) AS good ON doble.NAME = good.Name
		WHERE        (doble.DupeCount > 1) 

		Open B

		Fetch Next From B Into @GoodID,@NoGoodID,@UPC

		WHile @@FETCH_STATUS = 0 
		BEGIN

			EXEC    [dbo].[SP_MergeItems]
					@FromItemID = NULL,
					@ToItemID = NULL,
					@ModifierID = NULL,
					@FItemMainID = @NoGoodID,
					@ToItemMainID = @GoodID

			Update ItemAlias Set ItemNo = @GoodID, DateModified = dbo.GetLocalDATE() Where ItemNo = @GoodID

			Insert Into ItemAlias (AliasId,ItemNo,BarcodeNumber,Status,DateCreated,DateModified)
			Values (NEWID(), @GoodID, @UPC, 1, dbo.GetLocalDATE(), dbo.GetLocalDATE())

			Update ItemMain Set DateModified = dbo.GetLocalDATE() Where ItemID = @GoodID
			Update ItemStore Set DateModified = dbo.GetLocalDATE() Where ItemNo = @GoodID

			Fetch Next From B Into @GoodID,@NoGoodID,@UPC
		End

		Close B
		Deallocate B
		DROP TABLE  [#MyMerge1]
	End


END
GO