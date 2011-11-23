package com.hadoopilluminated.ch01;

import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reporter;

public class Map
        extends MapReduceBase
        implements Mapper<LongWritable, Text, Text, IntWritable> {

    // design pattern - avoid creating extra objects. If you can create it once
    // and use it - go for it
    private static IntWritable ONE = new IntWritable(1);
    private Text word = new Text();

    @Override
    public void map(LongWritable key, Text value,
            OutputCollector<Text, IntWritable> output, Reporter reporter)
            throws IOException {
        String line = value.toString();
        // a quick way to split a line of text into words
        String[] tokens = line.split("\\W");
        for (String token : tokens) {
            if (token.trim().length() > 0) {
                word.set(token);
                output.collect(word, ONE);
            }
        }
    }
}