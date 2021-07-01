CREATE TABLE [dbo].[PhoneNote] (
  [PhoneNoteIDVal] [int] IDENTITY,
  [Value] [nvarchar](1000) NULL,
  [Type] [smallint] NULL,
  [Sort] [smallint] NULL,
  [Status] [smallint] NULL CONSTRAINT [DF_PhoneNote_Status] DEFAULT (1),
  CONSTRAINT [PK_PhoneNote] PRIMARY KEY CLUSTERED ([PhoneNoteIDVal])
)
GO