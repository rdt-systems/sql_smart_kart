SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Eziel Fleischman>
-- Create date: <3/20/2013>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetItemsForReorder] 

@StoreID uniqueidentifier

AS
BEGIN

SET NOCOUNT ON;

select * from ItemMainAndStoreView Where (isnull(OnHand,0) + isnull(OnOrder,0)+isnull(OnTransferOrder,0) < isnull(ReorderPoint,0) ) AND  ItemType<>'3' AND ItemType<>'5' AND ItemType<>'2'
And Status >0
And StoreNo = @StoreID
END
GO