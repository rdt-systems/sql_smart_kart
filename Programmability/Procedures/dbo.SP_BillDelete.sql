SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_BillDelete]
(@BillID uniqueidentifier,
@ModifierID uniqueidentifier)

AS Update dbo.Bill

   
  SET    status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
   
  WHERE   BillID = @BillID
GO