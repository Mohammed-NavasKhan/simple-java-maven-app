#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
echo "Project Name: ${NAME}"
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
echo "Project Version: ${VERSION}"
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
echo "Checking for JAR file at target/${NAME}-${VERSION}.jar"
if [ -f "target/${NAME}-${VERSION}.jar" ]; then
  echo "JAR file exists, running it."
  java -jar target/${NAME}-${VERSION}.jar
else
  echo "JAR file not found. Please check the file name and build process."
  exit 1
fi
