drop database IF EXISTS poc;
create database IF NOT EXISTS poc;
use poc;

drop table IF EXISTS ratings_text;
create table IF NOT EXISTS ratings_text (
  user_id            int,
  movie_id           int,
  rating            double,
  tms              string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

load data LOCAL inpath '/home/ec2-user/ml-latest/ratings.csv' OVERWRITE into table ratings_text;

------------------------------------------
--              ORC FILES		--
------------------------------------------
use poc;

drop table IF EXISTS ratings_orc;
create table IF NOT EXISTS ratings_orc (
  user_id            int,
  movie_id           int,
  rating            double,
  tms              string
)
STORED AS ORCFILE;

INSERT OVERWRITE TABLE  ratings_orc SELECT *  FROM  ratings_text;

------------------------------------------
--     ORC with SNAPPY compression	--
------------------------------------------
use poc;

drop table IF EXISTS ratings_orc_snappy;
create table IF NOT EXISTS ratings_orc_snappy (
  user_id            int,
  movie_id           int,
  rating            double,
  tms              string
)
STORED AS ORCFILE
tblproperties ("orc.compress"="SNAPPY", "orc.stripe.size"="67108864","orc.row.index.stride"="50000") ;

INSERT OVERWRITE TABLE  ratings_orc_snappy SELECT *  FROM  ratings_text;

------------------------------------------
--              Adding more rows	--
------------------------------------------
use poc;
DROP TABLE IF EXISTS ratings_large_text;
CREATE TABLE IF NOT EXISTS ratings_large_text
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
AS
SELECT  user_id, movie_id, rating, tms, 
	user_id as user_id1, movie_id as movie_id1, rating as rating1, tms as tms1, 
	user_id as user_id2, movie_id as movie_id2, rating as rating2, tms as tms2, 
	user_id as user_id3, movie_id as movie_id3, rating as rating3, tms as tms3,
	user_id as user_id4, movie_id as movie_id4, rating as rating4, tms as tms4  
FROM ratings_text
UNION ALL
SELECT  user_id, movie_id, rating, tms, 
	user_id as user_id1, movie_id as movie_id1, rating as rating1, tms as tms1, 
	user_id as user_id2, movie_id as movie_id2, rating as rating2, tms as tms2, 
	user_id as user_id3, movie_id as movie_id3, rating as rating3, tms as tms3,
	user_id as user_id4, movie_id as movie_id4, rating as rating4, tms as tms4  
FROM ratings_text;

drop table IF EXISTS ratings_large_orc;
create table IF NOT EXISTS ratings_large_orc 
STORED AS ORCFILE
AS
select * from ratings_large_text;

select 'ratings_text' as table_name, count(*) as row_cnt from ratings_text
union all
select 'ratings_orc' as table_name, count(*) as row_cnt from ratings_orc
union all
select 'ratings_orc_snappy' as table_name, count(*) as row_cnt from ratings_orc_snappy
union all
select 'ratings_large_text' as table_name, count(*) as row_cnt from ratings_large_text
union all 
select 'ratings_large_orc' as table_name, count(*) as row_cnt from ratings_large_orc;
exit;
