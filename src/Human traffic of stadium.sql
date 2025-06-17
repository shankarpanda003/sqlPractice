-- Question 99
-- X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

-- Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).

-- For example, the table stadium:
-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 1    | 2017-01-01 | 10        |
-- | 2    | 2017-01-02 | 109       |
-- | 3    | 2017-01-03 | 150       |
-- | 4    | 2017-01-04 | 99        |
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- For the sample data above, the output is:

-- +------+------------+-----------+
-- | id   | visit_date | people    |
-- +------+------------+-----------+
-- | 5    | 2017-01-05 | 145       |
-- | 6    | 2017-01-06 | 1455      |
-- | 7    | 2017-01-07 | 199       |
-- | 8    | 2017-01-08 | 188       |
-- +------+------------+-----------+
-- Note:
-- Each day only have one row record, and the dates are increasing with id increasing.

-- Solution
drop table if exists data_table;
create temp table data_table as (select 1 as id, current_date as visit_date, 10 as people
                                 union all
                                 select 2 as id, current_date + 1, 109
                                 union all
                                 select 3 as id, current_date + 2, 150
                                 union all
                                 select 4 as id, current_date + 3, 99
                                 union all
                                 select 5 as id, current_date + 4, 145
                                 union all
                                 select 6 as id, current_date + 5, 1455
                                 union all
                                 select 7 as id, current_date + 6, 199
                                 union all
                                 select 8 as id, current_date + 7, 188
                                 union all
                                 select 9 as id, current_date + 8, 10
                                 union all
                                 select 10 as id, current_date + 9, 10
                                 union all
                                 select 11 as id, current_date + 10, 188
                                 union all
                                 select 12 as id, current_date + 11, 188
                                 union all
                                 select 13 as id, current_date + 12, 188
                                 union all
                                 select 14 as id, current_date + 13, 188
                                 union all
                                 select 15 as id, current_date + 14, 188);


WITH t1 AS (
            SELECT id,
                   visit_date,
                   people,
                   id - ROW_NUMBER() OVER(ORDER BY visit_date) AS dates,
                   ROW_NUMBER() OVER(ORDER BY visit_date) as rows
              FROM data_table
            WHERE people >= 100) 
            
SELECT t1.id, 
       t1.visit_date,
       t1.people
FROM t1
LEFT JOIN (
            SELECT dates, 
                   COUNT(*) as total
              FROM t1
            GROUP BY dates) AS b
USING (dates)
WHERE b.total > 2


WITH t1 AS (
    SELECT id,
           visit_date,
           people,
           id - ROW_NUMBER() OVER(ORDER BY visit_date) AS dates,
           ROW_NUMBER() OVER(ORDER BY visit_date) as rows
    FROM data_table
    WHERE people >= 100),
abc as (SELECT dates,
        as total
FROM t1
GROUP BY dates)
select t1.*,abc.total from t1 left join abc on t1.dates=abc.dates
where abc.total > 2


--alternate.. find the last hole approach
with abc as (
select a.id,a.people,max(b.id) as max_id, a.id-max(b.id) as diff
from data_table a left join  data_table b on a.id >= b.id and b.people <100 and a.id < 100
group by 1,2)
,bac as (select id,diff as diff from abc
    where diff =(select max(diff) from abc)
)
select * from abc where id > (select id-diff from bac) and id <=(select id from bac )



