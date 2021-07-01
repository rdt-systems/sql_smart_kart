CREATE TABLE [dbo].[EncData] (
  [EncData] [ntext] NULL,
  [Type] [nvarchar](20) NULL,
  [DateModified] [datetime] NULL,
  [StoreID] [uniqueidentifier] NULL,
  [ID] [int] IDENTITY,
  [Status] [tinyint] NULL,
  CONSTRAINT [PK__EncData__3214EC27FD3CA4D2] PRIMARY KEY CLUSTERED ([ID])
)
GO