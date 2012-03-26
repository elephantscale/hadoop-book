package com.hadoopilluminated.ch01;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.StringTokenizer;
import org.apache.hadoop.filecache.DistributedCache;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;
import org.apache.hadoop.util.StringUtils;

public class MapFeatures
        extends MapReduceBase
        implements Mapper<LongWritable, Text, Text, IntWritable> {

    static enum Counters {

        INPUT_WORDS
    }
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();
    private boolean caseSensitive = true;
    private Set<String> patternsToSkip = new HashSet<String>();
    private long numRecords = 0;
    private String inputFile;

    @Override
    public void configure(JobConf job) {
        caseSensitive = job.getBoolean("wordcount.case.sensitive", true);
        inputFile = job.get("map.input.file");

        if (job.getBoolean("wordcount.skip.patterns", false)) {
            Path[] patternsFiles = new Path[0];
            try {
                patternsFiles = DistributedCache.getLocalCacheFiles(job);
            } catch (IOException ioe) {
                System.err.println("Caught exception getting cached files: "
                        + StringUtils.stringifyException(ioe));
            }
            for (Path patternsFile : patternsFiles) {
                parseSkipFile(patternsFile);
            }
        }
    }

    private void parseSkipFile(Path patternsFile) {
        try {
            BufferedReader fis = new BufferedReader(
                    new FileReader(patternsFile.toString()));
            String pattern = null;
            while ((pattern = fis.readLine()) != null) {
                patternsToSkip.add(pattern);
            }
        } catch (IOException ioe) {
            System.err.println("Caught exception parsing the cached file '"
                    + patternsFile + "' : "
                    + StringUtils.stringifyException(ioe));
        }
    }

    public void map(LongWritable key, Text value,
            OutputCollector<Text, IntWritable> output, Reporter reporter)
            throws IOException {
        String line = (caseSensitive) ? value.toString()
                : value.toString().toLowerCase();

        for (String pattern : patternsToSkip) {
            line = line.replaceAll(pattern, "");
        }

        StringTokenizer tokenizer = new StringTokenizer(line);
        while (tokenizer.hasMoreTokens()) {
            word.set(tokenizer.nextToken());
            output.collect(word, one);
            reporter.incrCounter(Counters.INPUT_WORDS, 1);
        }

        if ((++numRecords % 100) == 0) {
            reporter.setStatus("Finished processing " + numRecords
                    + " records " + "from the input file: " + inputFile);
        }
    }
}