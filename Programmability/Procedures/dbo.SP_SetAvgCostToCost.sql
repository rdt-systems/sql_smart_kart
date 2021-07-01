SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Moshe Freund>
-- ALTER date: <C12/28/2015>
-- Description:	<Change all Avg Cost to Cost>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SetAvgCostToCost]
AS
BEGIN
Print 'Set All TransactionEntry Avg Cost = Cost'
Update TransactionEntry SET AVGCost = ISNULL(Cost,0) Where ISNULL(AVGCost,0) <> ISNULL(Cost,0)
Print 'Finished Set All TransactionEntry Avg Cost = Cost'

Print 'Set All ItemStore Avg Cost = Cost'
Update ItemStore SET AVGCost = ISNULL(Cost,0), DateModified = dbo.GetLocalDATE() Where ISNULL(AVGCost,0) <> ISNULL(Cost,0)
Print 'Finished Set All ItemStore Avg Cost = Cost'

Print 'Make sure all TransactionEntrys have ItemStoreID'
Update TransactionEntry Set ItemStoreID = '00000000-0000-0000-0000-000000000000' where ItemStoreID IS NULL
Print 'Finished Make sure all TransactionEntrys have ItemStoreID'

Print 'Make Sure all TransactionEntrys Have Cost'
Update TransactionEntry SET Cost = ItemStore.Cost, AVGCost = ItemStore.Cost
FROM            TransactionEntry INNER JOIN
                         ItemStore ON TransactionEntry.ItemStoreID = ItemStore.ItemStoreID
Where ISNULL(TransactionEntry.Cost,0) = 0 And ISNULL(ItemStore.Cost,0) <> 0
Print 'Finished Make Sure all TransactionEntrys Have Cost'
 
Print 'All Done'

END
GO