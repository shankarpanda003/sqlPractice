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


with RECURSIVE abc(Number,Frequency,Count) as (
    SELECT Number, Frequency, 1 AS Count
    FROM NumberFrequency
    WHERE Frequency > 0
    UNION ALL
    SELECT ng.Number, ng.Frequency, ng.Count + 1
    FROM abc ng
             JOIN NumberFrequency nf ON ng.Number = nf.Number
    WHERE ng.Count < nf.Frequency

)
select median(Number) from abc
