/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//package org.apache.hadoop.examples;

import java.io.IOException;
import java.io.DataOutput;
import java.util.StringTokenizer;
import java.util.Iterator;
import java.util.Map;
import java.util.ArrayList;
import java.lang.StringBuilder;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.ArrayWritable;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;


/*  Log nacho */
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class Maximo {
public static final Log log = LogFactory.getLog(Maximo.class);

/********************************** MAPEADOR *******************************/
  public static class Mapeador 
       extends Mapper<Object, Text, Text, IntWritable>{
    
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();
      
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {

	log.info("map es llamado por key = " + key.toString() + " value = " + value );

	Text nombreText = new Text();
	IntWritable notaIntWritable = new IntWritable(0);

	/*ejemplo para pasar los datos tal cual sin mapear nada*/
      StringTokenizer itr = new StringTokenizer(value.toString());
	String nombre = itr.nextToken();
	String nota  = itr.nextToken();
	nombreText.set(nombre);
	notaIntWritable.set(Integer.parseInt(nota));

	context.write(nombreText,notaIntWritable);
    }
  }
  



/************************ REDUCTOR  ********************************/

  public static class Reductor
       extends Reducer<Text,IntWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> valores, 
                       Context context
                       ) throws IOException, InterruptedException {
      int max = 0;
	log.info("reduce es llamado por " + key );
      for (IntWritable valor : valores ){
		log.info("  reduce es llamado por  " + valor.get());
		if ( valor.get() > max){
			max = valor.get();
			log.info("Nuevo maximo " + max );
			}
      		}
					
      result.set(max);
      context.write(key, result);
    }
  
}

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    String propiedad = "hadoop.http.authentication.token.validity";
    log.info("Configuracion de " + propiedad + " : " + conf.get(propiedad));
 /*  Iterator<Map.Entry<String,String>> iterator = conf.iterator();
   while (iterator.hasNext() ){
	Map.Entry<String, String> entrada = iterator.next();
	System.out.println("Dato de la configuracion " + entrada.getKey() + " : " +
		entrada.getValue());
	}
*/

 for (String argumento : args)
	log.info("Argumento nativo: " + argumento);
    String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();

  
   for (String argumento : otherArgs)
	log.info("Argumento hadoop: " + argumento);
 
   if (otherArgs.length < 2) {
      System.err.println("Usage: Maximo <in> [<in>...] <out>");
      System.exit(2);
    }
    Job job = Job.getInstance(conf, "Maximo");
    job.setJarByClass(Maximo.class);
    job.setMapperClass(Mapeador.class);
    //job.setCombinerClass(Combinador.class);
    job.setReducerClass(Reductor.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);
    //job.setMapOutputValueClass(IntWritable.class);
    for (int i = 0; i < otherArgs.length - 1; ++i) {
      FileInputFormat.addInputPath(job, new Path(otherArgs[i]));
    }
    FileOutputFormat.setOutputPath(job,
      new Path(otherArgs[otherArgs.length - 1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }

}
