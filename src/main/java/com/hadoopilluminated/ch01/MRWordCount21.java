package com.hadoopilluminated.ch01;

import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

/**
 * This example uses Hadoop 0.21 API
 * @author mark
 */
public class MRWordCount21 extends Configured implements Tool {

    @Override
    public int run(String[] args) throws Exception {
        System.out.println("Running MR: MRWordCount21");
        Job job = new Job(getConf());
        job.setJarByClass(MRWordCount21.class);
        job.setJobName("MRWordCount21");

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        job.setMapperClass(Map21.class);
        job.setCombinerClass(Reduce21.class);
        job.setReducerClass(Reduce21.class);

        job.setInputFormatClass(TextInputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);

        System.out.println("Input path: " + args[0]);
        System.out.println("Output path: " + args[1]);
        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        boolean success = job.waitForCompletion(true);
        return success ? 0 : 1;
    }

    public static void main(String[] args) throws Exception {
        int ret = ToolRunner.run(new MRWordCount21(), args);
        if (ret != 0) {
            System.exit(ret);
        }
    }
}