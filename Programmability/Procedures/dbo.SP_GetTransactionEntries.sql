SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[SP_GetTransactionEntries]
(@TransactionID uniqueidentifier,
@Voided bit = 0,
@SortBy Nvarchar(50) = NULL)
as


If ISNULL(@SortBy,'SortID') = 'SortID' 
	Set @SortBy = 'Sort'
If @SortBy = 'ModalNo'
	Set @SortBy = 'ModalNumber'
If @SortBy = 'UPC'
	Set @SortBy = 'ItemCode'

DECLARE @MySelect Nvarchar(4000)
IF @Voided = 1
SET @MySelect = '	SELECT     dbo.TransactionEntryView.*
	FROM       dbo.TransactionEntryView
	WHERE     (TransactionID=''' + CONVERT(nvarchar(100),@TransactionID) + ''') ORDER BY '
ELSE
SET @MySelect = '	SELECT     dbo.TransactionEntryView.*
	FROM       dbo.TransactionEntryView
	WHERE     (Status > 0) and (TransactionID=''' + CONVERT(nvarchar(100),@TransactionID) + ''') ORDER BY '

PRINT (@MySelect + @SortBy)
EXEC (@MySelect + @SortBy)
GO