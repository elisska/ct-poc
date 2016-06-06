## Setup MemSQL cluster in AWS

1. Provision 3 machines.  We have used CentOS 7.1 x86_64 with cloud-init (HVM) (ami-91e416fa),
m4.xlarge (4 vCPUs and 16 GiB) and default 8 GB of General Purpose SSD (GP2).

The following inbound rules have been created:

```
All traffic | All | All | <IP range of the subnetwork>
SSH | TCP | 22 | 0.0.0.0/0
Custom TCP Rule | TCP | 9000 | 0.0.0.0/0 (MemSQL Ops Web UI)
Custom TCP Rule | TCP | 10010 | 0.0.0.0/0 (Spark Web UI)
```

2. Deploy MemSQL.  The following instruction has been precisely followed:
[http://docs.memsql.com/docs/quick-start-on-premises](http://docs.memsql.com/docs/quick-start-on-premises).
It is pretty straightforward, just follow each step and carefully read the messages
on MemSQL UI.  Also the following document may used as a reference:
[http://docs.memsql.com/docs/quick-start-with-amazon-webservices#section-setting-up-on-aws-manually]
(http://docs.memsql.com/docs/quick-start-with-amazon-webservices#section-setting-up-on-aws-manually).

3. If you have 3 machines, by default the first of them will act as a Master Aggregator
node and others two as Leaf nodes.  To use our resources more effectively,
we have added an additional Leaf node on the first machine (a few clicks on MemSQL Ops UI).
Default port 3306 is already occupied by Master Aggregator, so we have chosen 3307.

4. Create a database and two tables for our test data:

```
CREATE DATABASE hadoop_poc;

USE hadoop_poc;

CREATE TABLE `ratings_text` (
  `user_id` int(11),
  `movie_id` int(11),
  `rating` double,
  `tms` varchar(20)
);

CREATE TABLE `ratings_large_text` (
  `user_id` int(11),
  `movie_id` int(11),
  `rating` double,
  `tms` varchar(20),
  `user_id1` int(11),
  `movie_id1` int(11),
  `rating1` double,
  `tms1` varchar(20),
  `user_id2` int(11),
  `movie_id2` int(11),
  `rating2` double,
  `tms2` varchar(20),
  `user_id3` int(11),
  `movie_id3` int(11),
  `rating3` double,
  `tms3` varchar(20),
  `user_id4` int(11),
  `movie_id4` int(11),
  `rating4` double,
  `tms4` varchar(20));
```

For each new test you need to drop the whole database (truncating the tables will
leave all physical files) and when create it again:

```
DROP DATABASE hadoop_poc;
```

