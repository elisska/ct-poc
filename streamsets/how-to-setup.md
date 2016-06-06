# How to setup StreamSets data collector

1. Download StreamSets:

```
cd /opt
wget https://archives.streamsets.com/datacollector/1.4.0.0/tarball/streamsets-datacollector-all-1.4.0.0.tgz
tar xvzf streamsets-datacollector-all-1.4.0.0.tgz
ln -s streamsets-datacollector-1.4.0.0 sdc
rm -rf streamsets-datacollector-all-1.4.0.0.tgz
```

2. Setup JDBC connector to MemSQL database and add Hadoop configs to StreamSets resources:

```
cd
wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz
tar xvzf mysql-connector-java-5.1.39.tar.gz 
mkdir -p /opt/sdc-extras/streamsets-datacollector-jdbc-lib/lib
cp ~/mysql-connector-java-5.1.39/mysql-connector-java-5.1.39-bin.jar /opt/sdc-extras/streamsets-datacollector-jdbc-lib/lib/
echo 'export STREAMSETS_LIBRARIES_EXTRA_DIR="/opt/sdc-extras/"' >> /opt/sdc/libexec/sdcd-env.sh
cat >> /opt/sdc/etc/sdc-security.policy <<DELIM
// user-defined additional driver directory
grant codebase "file:///opt/sdc-extras/-" {
  permission java.security.AllPermission;
};
DELIM
ln -s /etc/hadoop/conf /opt/sdc/resources/hadoop-conf
```

3. Start Data Collector:

``` 
/opt/sdc/bin/streamsets dc
```

4. Add `root` user (or another user under which you are running dc) to HDFS proxy users
