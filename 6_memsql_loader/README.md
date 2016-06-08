# Load data using MemSQL Loader

1. Login to any host.  Install wget, if needed:

   ```
sudo yum -y install wget
```

2. Download and unpack memsql-loader:

   ```
wget https://github.com/memsql/memsql-loader/releases/download/2.0.4/memsql-loader.tar.gz
tar -xvf memsql-loader.tar.gz
cd memsql-loader
ls -als
```

3. Open another terminal window to the host and open memsql-loader log:

   ```
cd memsql-loader
./memsql-loader log
```

4. Run load in the first window:

   ```
./memsql-loader load -D <database name> -t <table name> -u root -h <IP or hostname of MemSQL Master Aggregator> -P 3306 --hdfs-host <IP or hostname of HDFS name node> --hdfs-user hdfs --debug --fields-terminated "," --fields-enclosed '"' --fields-escaped '\\' --columns <comma-separated list of column names> <HDFS path>
```

   For example:

   ```
./memsql-loader load -D hadoop_poc -t ratings_large_text -u root -h 172.31.44.167 -P 3306 --hdfs-host 172.31.34.179 --hdfs-user hdfs --debug --fields-terminated "," --fields-enclosed '"' --fields-escaped '\\' --columns user_id,movie_id,rating,tms,user_id1,movie_id1,rating1,tms1,user_id2,movie_id2,rating2,tms2,user_id3,movie_id3,rating3,tms3,user_id4,movie_id4,rating4,tms4 hdfs:///apps/hive/warehouse/poc.db/ratings_large_text/*
```

   Instead of specifying a bunch of CLI parameters, you can pass a single JSON file
with all the data using "--spec <path to JSON file>".  Format of the JSON may be
revealed by appending "--print-spec" flag.

   Please note that if you need to run the test several times, you should additionally
add "--force" flag to say memsql-loader to reprocess the files, which have been
processed earlier.  memsql-loader is smart enough to process only new files by default,
so you can easily run incremental updates.  memsql-loader can also track changes in
the existing files, but to do that your table must have a file_id column
(append " --file-id-column <column name>").

5. What if our input files are not in CSV format?  memsql-loader allows you to
easily inject a script that will transform your data into CSV format and apply
any additional filtering or transformation (if needed).  For example, if your files
on HDFS are compressed, you can just append "--script 'lzma -d'".  The data is
being passed to your script using pipe.

   Let's assume that your files instead of CSV contain a JSON object for each record like:

   ```
{"user_id": 1, "movie_id": 2, "rating": 0.5, "tms": "1287412650"}
{"user_id": 2, "movie_id": 3, "rating": 0.6, "tms": "1287412651"}
```

   To insert that data, you may create a simple Python script like the following:

   ```
$ cat /tmp/transform.py
import json
import sys

def main():
    for input_line in sys.stdin:
        value = json.loads(input_line)
        output_line = '%s,%s,%s,%s\n' % (value['user_id'],
                                         value['movie_id'],
                                         value['rating'],
                                         value['tms'])
        sys.stdout.write(output_line)

if __name__ == '__main__':
    main()
```

   Then append to your load command the following: "--script 'python /tmp/transform.py'".

## Performance:

This approach is the fastest one.  It takes slightly more than 2 minutes to import
about 5,696 MB of original HDFS data (45,768,754 of "ratings_large_text" records):

Running memsql-loader on MemSQL Master Aggegator:

* 2:16
* 2:13
* 2:13
* Average: 2:14

Running memsql-loader on a host outside of the MemSQL cluster:

* 2:04
* 2:03
* 2:06
* Average: 2:04

When we pass the data through a custom script, performance is slightly worse.
Let's inject the following script (just redirects each line from input to output):

   ```
import sys

def main():
    for input_line in sys.stdin:
        sys.stdout.write(input_line)

if __name__ == '__main__':
    main()
```

Running on MemSQL Master Aggegator:

* 2:22
* 2:22
* 2:23
* Average: 2:22

## Limitations:

There are no significant limitations.  The approach is fast and flexible enough
and may be used for both one-time load and incremental updates.
