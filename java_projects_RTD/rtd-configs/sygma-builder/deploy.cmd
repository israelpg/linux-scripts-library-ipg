@echo off

if [%1]==[] goto usage

set TARGET_ENV=%1
for /f "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b

cls
@echo Deploying to %TARGET_ENV%

if not "%TARGET_ENV%"=="local" (
	@echo Stopping and undeploying application
	call mvn -f wl-stop-pom.xml weblogic:wlst -Denv=%TARGET_ENV% %ALL_BUT_FIRST%
	if %errorlevel% neq 0 exit /b %errorlevel%
)

@echo Undeploying application
call mvn -f wl-undeploy-pom.xml weblogic:wlst -Denv=%TARGET_ENV% %ALL_BUT_FIRST%
if %errorlevel% neq 0 exit /b %errorlevel%

@echo Deploying application
call mvn -pl eu.europa.ec.rdg.sygma:sygma-application weblogic:deploy -Denv=%TARGET_ENV% %ALL_BUT_FIRST%
call mvn -pl eu.europa.ec.rdg.sygma:sygma-it-plumber-ear weblogic:deploy -Denv=%TARGET_ENV% %ALL_BUT_FIRST%
if %errorlevel% neq 0 exit /b %errorlevel%

if not "%TARGET_ENV%"=="local" (
	@echo Starting
	call mvn -f wl-start-pom.xml weblogic:wlst -Denv=%TARGET_ENV% %ALL_BUT_FIRST%
)

goto :eof




:usage
@echo Missing parameter (it should match a profile you have in your maven settings.xml)
@echo Usage: %0 ^<environment^> (example: deploy int)
exit /B 1
