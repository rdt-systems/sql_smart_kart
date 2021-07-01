SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_SerialUpdate](@SerializationID nvarchar(50),
@ItemNo nvarchar(50),
@Barcode nvarchar(50),
@Status nvarchar(50))
AS UPDATE    dbo.Serialization
SET              SerializationID = @SerializationID, ItemNo = @ItemNo, Barcode = @Barcode, Status = @Status
GO