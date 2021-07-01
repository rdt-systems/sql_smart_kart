CREATE TABLE [dbo].[GridsLayoutsUser] (
  [LayoutName] [nvarchar](50) NULL,
  [LayoutFileName] [nvarchar](50) NULL,
  [LayoutXMLContent] [ntext] NULL,
  [UserCreated] [uniqueidentifier] NULL,
  [DateCreated] [datetime] NULL CONSTRAINT [DateCreated_Def] DEFAULT (getdate()),
  [ComputerName] [nvarchar](150) NULL
)
GO