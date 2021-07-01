CREATE TABLE [dbo].[Delivery] (
  [DeliveryID] [int] IDENTITY,
  [Road] [char](25) NULL,
  [DeliveryDate] [datetime] NULL,
  [Assigned] [char](30) NULL,
  [Status] [int] NULL,
  [Note] [char](1000) NULL,
  CONSTRAINT [PK_Delivery] PRIMARY KEY CLUSTERED ([DeliveryID])
)
GO