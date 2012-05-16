#!/bin/sh
# HadoopIlluminated script
mvn assembly:single

hadoop fs -rmr /hadoopilluminated/test-data/ch01
hadoop fs -mkdir /hadoopilluminated/test-data/ch01
hadoop fs -copyFromLocal  test-data/ch01/moby-dick.txt /hadoopilluminated/test-data/ch01
hadoop fs -rmr /hadoopilluminated/test-output/ch01

hadoop jar \
target/HadoopIlluminated-1.0-SNAPSHOT-jar-with-dependencies.jar \
com.hadoopilluminated.ch01.MRWordCount21 \
/hadoopilluminated/test-data/ch01 \
/hadoopilluminated/test-output/ch01
