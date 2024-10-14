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




public class Medias {

/* Log nacho */
  public  static final  Log log = LogFactory.getLog(Medias.class);

static class IntArrayWritable extends ArrayWritable { 
	public IntArrayWritable() { super(IntWritable.class); } 

	public IntArrayWritable(IntWritable[] values) {
        	super(IntWritable.class, values);
    	}
	@Override
    	public IntWritable[] get() {
		Writable[] writables = super.get();
		IntWritable[] intWritables = new IntWritable[writables.length];
		for (int i = 0; i < writables.length ; i++)
			intWritables[i] = (IntWritable) writables[i];
        	return intWritables;
    	}

	@Override
	public void set ( Writable[] values) {
		super.set(values);
	}

/*	@Override
    	public void write(DataOutput arg0) throws IOException {
        	for(IntWritable data : get()){
            	data.write(arg0);
        	}
    }
*/
	@Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (String s : super.toStrings())
        {
            sb.append(s).append(" ");
        }
        return sb.toString();
    }

}

/********************************** MAPEADOR *******************************/
  public static class Mapeador 
       extends Mapper<Object, Text, Text, IntArrayWritable>{
    
    private final static IntWritable one = new IntWritable(1);
    private static IntArrayWritable salida;
    private Text word = new Text();
      
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
	log.info("map es llamado por key = " + key + " value = " + value );

	Text nombreText = new Text();
	IntWritable notaIntWritable = new IntWritable(0);

	/*ejemplo para pasar los datos tal cual sin mapear nada*/
      StringTokenizer itr = new StringTokenizer(value.toString());
	String nombre = itr.nextToken();
	String nota  = itr.nextToken();
	nombreText.set(nombre);
	notaIntWritable.set(Integer.parseInt(nota));
	IntWritable[] listaIntWritable =  new IntWritable[1];
	listaIntWritable[0] = notaIntWritable;
	salida = new IntArrayWritable(listaIntWritable);
//	context.write(nombreText,notaIntWritable);
	context.write(nombreText,salida);
/*
      StringTokenizer itr = new StringTokenizer(value.toString());
      while (itr.hasMoreTokens()) {
        word.set(itr.nextToken());
        context.write(word, one);
	log.info("map() escribiendo " + word + " " + one );
      }*/
    }
  }
  


  public static class Combinador_Aprobado_Suspendido
       extends Reducer<Text,IntWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntWritable> values, 
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
	log.info("Combinador es llamado  " + key );
      for (IntWritable val : values) {
	Text claveNueva = new Text();
	log.info("   value= " + val );
        if (val.get() >= 50 )
		claveNueva.set(key.toString() +"_Aprobado");
	else 
		claveNueva.set(key.toString() + "_Suspendido");
	context.write(claveNueva,val);
      }
    }
  }

/************************ COMBINADOR ********************************/

  public static class Combinador
       extends Reducer<Text,IntArrayWritable,Text,IntArrayWritable> {
    private IntWritable result = new IntWritable();
    private IntArrayWritable listaSalida = new IntArrayWritable();

    public void reduce(Text key, Iterable<IntArrayWritable> valores, 
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
      log.info("Combinador es llamado  " + key );
      ArrayList<IntWritable> listaValoresSalida = new ArrayList<IntWritable>();
	//log.info("tamanyo de la lista " + valores.size());
      for (IntArrayWritable val : valores){
		IntWritable[] listaIntWritables = val.get();
			log.info("combinador recibe lista de " + 
				+listaIntWritables.length + " elemetos");
			for (int i=0; i<listaIntWritables.length;i++) { 
				listaValoresSalida.add(listaIntWritables[i]);
				log.info("   value= " + val );
	}
      	}
	IntWritable[] listaIntWritables = new IntWritable[listaValoresSalida.size()];
	listaValoresSalida.toArray(listaIntWritables);
	listaSalida.set(listaIntWritables);
	IntArrayWritable listaSal = new IntArrayWritable(listaIntWritables);
	context.write(key,listaSal);
    }
  }

/************************ REDUCTOR  ********************************/

  public static class Reductor
       extends Reducer<Text,IntArrayWritable,Text,IntWritable> {
    private IntWritable result = new IntWritable();

    public void reduce(Text key, Iterable<IntArrayWritable> valores, 
                       Context context
                       ) throws IOException, InterruptedException {
      int sum = 0;
      int cuenta = 0;
	log.info("reduce es llamado por " + key );
      for (IntArrayWritable lista : valores ){
		log.info("  reduce es llamado por lista de " + lista.get().length + "elementos");
	     IntWritable[] listaIntWritables = lista.get();
	      for (IntWritable val : listaIntWritables) {
		log.info("     value= " + val );
       	 	sum += val.get();
		cuenta++;
      	}
}
      result.set(sum/cuenta);
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
      System.err.println("Usage: Medias <in> [<in>...] <out>");
      System.exit(2);
    }
    Job job = Job.getInstance(conf, "Medias");
    job.setJarByClass(Medias.class);
    job.setMapperClass(Mapeador.class);
    //job.setCombinerClass(Combinador.class);
    job.setReducerClass(Reductor.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntArrayWritable.class);
    //job.setMapOutputValueClass(IntWritable.class);
    for (int i = 0; i < otherArgs.length - 1; ++i) {
      FileInputFormat.addInputPath(job, new Path(otherArgs[i]));
    }
    FileOutputFormat.setOutputPath(job,
      new Path(otherArgs[otherArgs.length - 1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
