SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_StoreInventory]
(
@DateModified datetime=null
)
AS 
SELECT *
  FROM [dbo].[StoreInventory]

  Where Status > 0 AND DateModified > @DateModified
GO