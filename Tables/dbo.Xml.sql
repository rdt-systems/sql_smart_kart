CREATE TABLE [dbo].[Xml] (
  [XmlID] [uniqueidentifier] NOT NULL,
  [DateCreated] [datetime] NULL,
  [XmlFile] [text] NULL,
  CONSTRAINT [PK_Xml_XmlID] PRIMARY KEY CLUSTERED ([XmlID])
)
GO