SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_CustomerAddressesDelete]
(@CustomerAddressID uniqueidentifier,
@ModifierID uniqueidentifier)
AS  UPDATE dbo.CustomerAddresses
                     
SET    status=-1, DateModified = dbo.GetLocalDATE()

WHERE CustomerAddressID=@CustomerAddressID
GO