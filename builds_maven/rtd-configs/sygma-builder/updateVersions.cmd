@echo on
if "%1"=="" goto usage
set version=%1
set basedir=%CD%\..
cd..
echo using basedir %basedir%
pause
echo Updating full project to version %version%

cd %basedir%\sygma-runtime-engine
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-mod-utils
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-gap
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-h2020-gap
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-pc-cd
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-amendments
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-h2020-amendments
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-payment
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-onl-batch
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-collection-form-a
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-h2020-collection-form-a
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-reporting
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-deliverables
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-ethics-appraisal
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-exercise-risk
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-gui
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-webservices
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-mod-admin
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-config
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-db
call mvn versions:set -DnewVersion=%version%
call mvn clean install -Dmaven.test.skip=true

cd %basedir%\sygma-it
call mvn versions:set -DnewVersion=%version%
REM do not build!!!

cd %basedir%\sygma\sygma-builder
call mvn versions:set -DnewVersion=%version%
REM do not build!!!


:relations
cd %basedir%\sygma-builder
echo Updating relative relationships

call mvn -pl eu.europa.ec.rdg.sygma:sygma-runtime-engine versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-runtime-engine versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-mod-utils versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-mod-utils versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-gap versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-gap versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-h2020-gap versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-h2020-gap versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-pc-cd versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-pc-cd versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-amendments versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-amendments versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-h2020-amendments versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-h2020-amendments versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-payment versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-payment versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-onl-batch versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-onl-batch versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-collection-form-a versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-collection-form-a versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-h2020-collection-form-a versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-h2020-collection-form-a versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-reporting versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-reporting versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-deliverables versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-deliverables versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-ethics-appraisal versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-ethics-appraisal versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-risk versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-exercise-risk versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-gui versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-gui versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-webservices versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-webservices versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-mod-admin versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-mod-admin versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-config versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-config versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-db versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-db versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-it versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-it versions:use-latest-snapshots -DallowSnapshots=true

call mvn -pl eu.europa.ec.rdg.sygma:sygma-builder versions:update-properties -DallowSnapshots=true
call mvn -pl eu.europa.ec.rdg.sygma:sygma-builder versions:use-latest-snapshots -DallowSnapshots=true

goto end

:usage
echo Usage: updateVersions ^<desired version^>

:end
