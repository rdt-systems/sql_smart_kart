SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[AttachmentsView]
AS
SELECT     dbo.Attachments.*,StoreNo as StoreID
FROM         dbo.Attachments INNER JOIN ItemStore On ItemStore.ItemStoreID=Attachments.ItemStoreID
GO