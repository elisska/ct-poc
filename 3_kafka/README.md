## Notes

We used custom Kafka producer to read data from HDFS and send the data to Kafka topic. 

Then, MemSQL was able to connect to Kafka topic and send data directly to MemSQL table using Streamliner. 

The huge bottleneck in this solution is that custom Kafka producer - to make a **stream**, it should read HDFS directory in several threads and then synchronize between them. This is extreamly hard-to-maintain solution. 
