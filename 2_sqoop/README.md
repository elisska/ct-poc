# Sqoop metrics

## Append to table

Each measurement was an 3 times.

| Run name | # of rows | Size | Average time | Command to run |
| -------- | --------- | ---------- | --- | -------------------------------- |
| Sqoop export from HDFS (text, CSV files) | 22884377 | 592 MB | 3.1 mins | `sqoop export --connect jdbc:mysql://ip-172-31-44-167.ec2.internal:3306/hadoop_poc?user=myuser --table ratings_text --export-dir /apps/hive/warehouse/poc.db/ratings_text` |
| Sqoop export from Hive ORC files | 22884377 | 145 MB | 3.2 mins | `sqoop export --connect jdbc:mysql://ip-172-31-44-167.ec2.internal:3306/hadoop_poc?user=myuser --table ratings_orc --hcatalog-database poc --hcatalog-table ratings_orc` |
| Sqoop export from Hive ORC files with Snappy | 22884377 | 214 MB | 3 mins | `sqoop export --connect jdbc:mysql://ip-172-31-44-167.ec2.internal:3306/hadoop_poc?user=myuser --table ratings_orc_snappy --hcatalog-database poc --hcatalog-table ratings_orc_snappy` |
| Sqoop export from (text, CSV files, 9 mappers) | 45768754 | 5.57 GB | **6,5 mins** | `sqoop export --connect jdbc:mysql://ip-172-31-44-167.ec2.internal:3306/hadoop_poc?user=myuser --table ratings_large_text --hcatalog-database poc --hcatalog-table ratings_large_text --num-mappers 15` |

## Merge to table 

TBD

## Important notes

* Sqoop execution mode - batch - so scheduling to be done via any scheduling tool (oozie, cron, autosys, control-m, etc)
* Table in MemSQL must exists and be the same name
* Column names in HCatalog and MemSQL should be the same
* Staging table can be used with `--staging-table`
* Incremental inserts/updates are allowed with sqoop. `--update-key` can be specified in command to allow merge into target table

