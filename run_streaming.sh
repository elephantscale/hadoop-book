#!/bin/sh
hadoop jar \
/usr/lib/hadoop-0.20/contrib/streaming/hadoop-streaming-0.20.2-cdh3u2.jar \
-libjars target/HadoopInPracticeCode-1.0-SNAPSHOT-jar-with-dependencies.jar \
-input /test-data/ch1/moby-dick.txt \
-output /test-output/ch1 \
-mapper com.hadoopilluminated.ch01.Map \
-reducer com.hadoopilluminated.ch01.Reduce \
-verbose \
