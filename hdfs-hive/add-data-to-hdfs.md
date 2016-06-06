## Adding data to HDFS

We use [MovieLens](http://grouplens.org/datasets/movielens) dataset here.

Run the below commands to add data to the HDFS:

```
cd
wget http://files.grouplens.org/datasets/movielens/ml-latest.zip
unzip ml-latest.zip
rm -rf ml-latest.zip
sed -i -e "1d" links.csv
sed -i -e "1d" movies.csv
sed -i -e "1d" ratings.csv
sed -i -e "1d" tags.csv

hdfs dfs -mkdir /user/root
hdfs dfs -chown root:root /user/root
hdfs dfs -mkdir /user/ec2-user
hdfs dfs -chown ec2-user:ec2-user /user/ec2-user
```
