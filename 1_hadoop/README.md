## Hadoop cluster setup

We installed HDP 2.4 cluster, managed by Ambari 2.2.1 using this [guide](https://docs.hortonworks.com/HDPDocuments/Ambari-2.2.1.0/bk_Installing_HDP_AMB/bk_Installing_HDP_AMB-20160301.pdf). We used 4 m3.xlarge AWS instances (4 VCPU, 15 GB RAM, 2x40GB storage).

The cluster has the below components:

* HDFS with 3 datanodes
* YARN
* Hive
* Sqoop
* Spark
* Kafka
* Zookeeper

## Add data to HDFS and Hive

* Adding data to HDFS: [add-data-to-hdfs.md](add-data-to-hdfs.md)
* Setup Hive tables: [hive-tables-setup.hql](hive-tables-setup.hql)
