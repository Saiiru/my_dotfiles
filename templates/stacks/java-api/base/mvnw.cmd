@IF EXIST "%~dp0\mvnw.cmd" (
  "%~dp0\mvnw.cmd" %*
) ELSE (
  @ECHO Maven wrapper not found.
  EXIT /B 1
)
