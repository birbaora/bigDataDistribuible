val v1 = sc.textFile("/spark/puertos.csv")
System.out.println(v1.count())

val v2 = v1.filter(line => line.contains("Barcelona"))
System.out.println(v2.count())

System.exit(0)
