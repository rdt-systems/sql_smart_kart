SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TaxDelete]
(@TaxID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 
 Update dbo.Tax
               
SET      Status =-1,   DateModified =dbo.GetLocalDATE(),  UserModified =@ModifierID

Where TaxID = @TaxID
GO