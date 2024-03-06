CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# lib
# grading-area
# grade.sh
# student-submission
# GradeServer.java
# Server.java
# TestLIstExamples.java

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [ -f ./student-submission/ListExamples.java ]
then
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
else
    echo "ListExamples.java is missing"
    echo "Score: 0"
    exit 1
fi

cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ]
then
    echo "Program won't compile"
    echo "Score: 0"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples >junit-output.txt


linecount=$(wc -l < "junit-output.txt")

if [ "$linecount" -gt 6 ]
then
    lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
    tests=$(echo $lastline | awk '{print $3}' | tr -d ',')
    failures=$(echo $lastline | awk '{print $5}')
    successes=$((tests - failures))
    echo "Score: $successes / $tests"
else
    echo "Score: 100%"
fi
