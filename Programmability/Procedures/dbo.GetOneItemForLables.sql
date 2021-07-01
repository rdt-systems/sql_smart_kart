SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[GetOneItemForLables]
(	@StoreID uniqueidentifier = NULL,
    @ItemStoreID uniqueidentifier,
	@qty int =1

)
as
BEGIN

	WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)

 SELECT * 
 FROM  ItemlableView AS IL 
 INNER JOIN  (SELECT     number, @ItemStoreID AS ItemStoreID 
						   FROM          CTE 
                            WHERE     (number > 0) AND (number <= @qty)) AS PrintQty 
							on IL.ItemStoreID = PrintQty.ItemStoreID  OPTION ( MAXRECURSION 0)
END
GO