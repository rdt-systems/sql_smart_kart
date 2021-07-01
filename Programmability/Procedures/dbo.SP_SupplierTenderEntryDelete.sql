SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierTenderEntryDelete]
@SuppTenderEntryId uniqueidentifier,
@ModifierID uniqueidentifier
AS

UPDATE  dbo.SupplierTenderEntry
SET      status = -1, DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE   SuppTenderEntryId = @SuppTenderEntryId
GO