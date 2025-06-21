-- Question 107
-- The Numbers table keeps the value of number and its frequency.

-- +----------+-------------+
-- |  Number  |  Frequency  |
-- +----------+-------------|
-- |  0       |  7          |
-- |  1       |  1          |
-- |  2       |  3          |
-- |  3       |  1          |
-- +----------+-------------+
-- In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.


CREATE temp TABLE NumberFrequency (
                                 Number INT,
                                 Frequency INT
);

INSERT INTO NumberFrequency (Number, Frequency) VALUES (0, 7);
INSERT INTO NumberFrequency (Number, Frequency) VALUES (1, 1);
INSERT INTO NumberFrequency (Number, Frequency) VALUES (2, 3);
INSERT INTO NumberFrequency (Number, Frequency) VALUES (3, 1);

-- +--------+
-- | median |
-- +--------|
-- | 0.0000 |
-- +--------+
-- Write a query to find the median of all numbers and name the result as median.

-- Solution
with t1 as(
select *,
sum(frequency) over(order by number) as cum_sum, (sum(frequency) over())/2 as middle
from numbers)

select avg(number) as median
from t1
where middle between (cum_sum - frequency) and cum_sum



select * from NumberFrequency


with recursive abc(number,frequency,count) as (
select number,frequency,1 as count from NumberFrequency
union all
select a.number,a.frequency,a.count+1 from abc a inner join NumberFrequency b
on a.number=b.number and a.count < b.frequency
)
select percentile_cont(0.5) WITHIN GROUP (ORDER BY Number)::numeric(10,4)
AS median from abc


-- generate sequence of numbers from 1 to 10
with recursive random_number(id) as(
select 1 as id
union all
select a.id+1 from random_number a where a.id < 10
)
select * from random_number