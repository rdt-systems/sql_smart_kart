SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetItemIDByBarcode]
(@TypeID int,
@Barcode nvarchar(50),
@LastDateSync datetime)
As 

--SELECT Top 1 GuidNum
--FROM DBO.SyncChanges
--WHERE OldID=@Barcode And TypeID=@TypeID And DateCreated>@LastDateSync
GO