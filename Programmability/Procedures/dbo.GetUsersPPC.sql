﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetUsersPPC]
as
SELECT *
FROM dbo.PPComp
WHERE Status>-1
GO