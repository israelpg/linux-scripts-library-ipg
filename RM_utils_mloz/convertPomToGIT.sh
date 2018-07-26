find . -type f -name "pom.xml" -exec sed -i '/<scm>/,/<\/scm>/d' {}  \;
find . -type f -name "pom.xml" -exec sed -i '/<providerImplementations>/,/<\/providerImplementations>/d' {} \;
