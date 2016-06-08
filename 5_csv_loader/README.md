# Load data from CSV files on HDFS

1. Go to MemSQL Ops UI, click Data Sources and Import.

2. Click HDFS CSV.

3. Specify HDFS Server (either hostname or IP address), HDFS Port (8020)
and File or Folder to Import and click Continue.  For example:
/apps/hive/warehouse/poc.db/ratings_large_text/*.  Please note that a folder name
must be followed by a wildcard.

4. Configure CSV data formatting (default values should be fine, unless your
files have headers) and click Test & Continue.

5. Verify the data and click Continue.

6. Specify Database Name and Table Name and click Continue.

7. Verify field mapping and click Start Import.

## Performance:

This approach is reasonably fast.  Using configuration described above, it takes
about 4 minutes to import about 5,696 MB of original HDFS data
(45,768,754 of "ratings_large_text" records):

* 3:37
* 4:09
* 3:36
* Average: 3:47

## Limitations:

1. Assumes CSV files on HDFS.  It's not possible to use other input formats.
2. Good for one-time load, but hard to use for streaming data.
It's not possible to run incremental updates.

