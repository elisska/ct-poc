## Available files

* How to setup StreamSets: [how-to-setup.md](how-to-setup.md)
* StreamSets pipeline with HDFS origin and JDBC destination: [hdfs_to_memsql_with_lib_definition.json](hdfs_to_memsql_with_lib_definition.json)
* Performance metrics: [performance-metrics.md](performance-metrics.md)

## Performance metrics

| Run name | # of rows | Size in MB | Average time | 
| -------- | --------- | ---------- | --- | 
| HDFS (text,CSV) to MemSQL JDBC | 45768754 | 5.57 GB | 14mins | 

## StreamSets notes

* Data can be read from HDFS with pipeline Cluster Batch mode. So that once all data copied, the pipeline stops. 

