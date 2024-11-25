#!/bin/bash

spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --name "apli1" /opt/hadoop/spark/examples/jars/spark-examples_2.12-3.5.3.jar 5