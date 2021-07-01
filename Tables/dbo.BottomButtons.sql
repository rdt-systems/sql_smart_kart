CREATE TABLE [dbo].[BottomButtons] (
  [ButtonID] [uniqueidentifier] NOT NULL,
  [SheetID] [uniqueidentifier] NOT NULL,
  [ItemID] [uniqueidentifier] NOT NULL,
  [Description] [nvarchar](250) NULL,
  [IsCase] [bit] NULL,
  [Sort] [int] NOT NULL,
  [Status] [int] NOT NULL,
  [DateModified] [datetime] NULL,
  [ColorCode] [int] NOT NULL,
  [FontSize] [int] NULL,
  [PromptQty] [bit] NULL,
  CONSTRAINT [PK_BottomButtons] PRIMARY KEY CLUSTERED ([ButtonID])
)
GO

ALTER TABLE [dbo].[BottomButtons]
  ADD CONSTRAINT [FK_BottomButtons_ButtonSheets] FOREIGN KEY ([SheetID]) REFERENCES [dbo].[ButtonSheets] ([SheetID])
GO