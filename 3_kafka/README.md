# Load data from Kafka

1. Setup a new Kafka topic.  Login to the host where Kafka is installed,
go to Kafka bin folder and run:

```
./kafka-topics.sh --create --zookeeper <Zookeeper Quorum (comma-separated list of host:port)> --replication-factor 1 --partitions 3 --topic <topic name>
```

2. Go to MemSQL Ops UI, click Data Sources, click Streamliner and then click Add Pipeline button.

3. Specify Name, Description and Batch Interval (default and minimum interval is 1 second).

4. Set Extract Source to Kafka (Zookeeper).

5. Specify Zookeeper Quorum (linebreak-separated list of host:port) and Kafka Topic.

6. Set Transformation to CSV to SQL (default values should be fine).

7. Specify Column Spec JSON in the following format:

```
[
    {
        "column_type": "<integer|double|string>",
        "name": "<field name>"
    },
    ...
]
```

8. Specify Database Name and Table Name and click Save & Run.

9. Now you need to put records into Kafka.  Find some application that can read from HDFS and post
into a Kafka topic in CSV format.  We have used
[https://github.com/CiscoCloud/mantl-apps/blob/master/demo-apps/hadoop-demo-apps/fs-kafka-producer/]
(https://github.com/CiscoCloud/mantl-apps/blob/master/demo-apps/hadoop-demo-apps/fs-kafka-producer/).
Build JAR and run Hadoop job using instructions from DEMO-INSTRUCTIONS-CDH.md (on some HDFS cluster host).

10. Return to MemSQL Ops UI and monitor the progress.

## Performance:

In our case the speed of this approach was mostly affected by the Kafka producer application
that reads HDFS and posts to Kafka topics.  In fact, it was a huge bottleneck:
Each Kafka import on MemSQL side took less than 0.1 s for 1 s batch (in other words,
90% of time we were just waiting for new records from the Kafka producer).
It would probably take more than an hour to read the whole 5,696 MB of original HDFS data,
but we stopped it.

## Limitations:

1. Good for streaming data, but requires a custom Kafka Producer application outside of the
MemSQL cluster that must be really fast, otherwise it will quickly become a bottleneck.

