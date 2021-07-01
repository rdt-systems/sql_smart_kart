SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetEntryByReceiveID]
(@Filter nvarchar(4000))

as
declare @MySelect nvarchar(4000)
set @MySelect= 'SELECT     dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.BarcodeNumber, dbo.ItemMainAndStoreView.ModalNumber, 
                      dbo.ReceiveEntryView.Qty as Qty, dbo.ReceiveEntryView.UOMPrice,
                      dbo.ReceiveEntryView.ReceiveEntryID as ID
FROM         dbo.ItemMainAndStoreView INNER JOIN
                      dbo.ReceiveEntryView ON dbo.ItemMainAndStoreView.ItemStoreID = dbo.ReceiveEntryView.ItemStoreNo
where  dbo.ReceiveEntryView.Status>-1'

Execute (@MySelect + @Filter )
GO