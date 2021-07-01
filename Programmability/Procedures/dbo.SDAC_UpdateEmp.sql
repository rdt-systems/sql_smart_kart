SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SDAC_UpdateEmp]  
	@EMPNO	int,
	@ENAME	nvarchar(20),
	@JOB	nvarchar(10),
        @EMPINFO   nvarchar(30) OUTPUT
AS
	UPDATE EMP
	SET 
		ENAME = @ENAME, JOB = @JOB 
	WHERE
		EMPNO = @EMPNO
      SET @EMPINFO = CAST(@EMPNO AS nvarchar) + ' ' + @JOB
      RETURN @EMPNO;
GO