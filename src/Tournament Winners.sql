-- Question 109
-- Table: Players

-- +-------------+-------+
-- | Column Name | Type  |
-- +-------------+-------+
-- | player_id   | int   |
-- | group_id    | int   |
-- +-------------+-------+
-- player_id is the primary key of this table.
-- Each row of this table indicates the group of each player.
-- Table: Matches

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | first_player  | int     |
-- | second_player | int     | 
-- | first_score   | int     |
-- | second_score  | int     |
-- +---------------+---------+
-- match_id is the primary key of this table.
-- Each row is a record of a match, first_player and second_player contain the player_id of each match.
-- first_score and second_score contain the number of points of the first_player and second_player respectively.
-- You may assume that, in each match, players belongs to the same group.
 

-- The winner in each group is the player who scored the maximum total points within the group.
-- In the case of a tie,
-- the lowest player_id wins.

-- Write an SQL query to find the winner in each group.

-- The query result format is in the following example:

-- Players table:
-- +-----------+------------+
-- | player_id | group_id   |
-- +-----------+------------+
-- | 15        | 1          |
-- | 25        | 1          |
-- | 30        | 1          |
-- | 45        | 1          |
-- | 10        | 2          |
-- | 35        | 2          |
-- | 50        | 2          |
-- | 20        | 3          |
-- | 40        | 3          |
-- +-----------+------------+

-- Matches table:
-- +------------+--------------+---------------+-------------+--------------+
-- | match_id   | first_player | second_player | first_score | second_score |
-- +------------+--------------+---------------+-------------+--------------+
-- | 1          | 15           | 45            | 3           | 0            |
-- | 2          | 30           | 25            | 1           | 2            |
-- | 3          | 30           | 15            | 2           | 0            |
-- | 4          | 40           | 20            | 5           | 2            |
-- | 5          | 35           | 50            | 1           | 1            |
-- +------------+--------------+---------------+-------------+--------------+

-- Result table:
-- +-----------+------------+
-- | group_id  | player_id  |
-- +-----------+------------+ 
-- | 1         | 15         |
-- | 2         | 35         |
-- | 3         | 40         |
-- +-----------+------------+
--
CREATE TEMP TABLE Players (
  player_id INT,
  group_id INT
);

CREATE TEMP TABLE matches (
  match_id INT,
  first_player INT,
  second_player INT,
  first_score INT,
  second_score INT
);

INSERT INTO Players (player_id, group_id) VALUES
  (15, 1),
  (25, 1),
  (30, 1),
  (45, 1),
  (10, 2),
  (35, 2),
  (50, 2),
  (20, 3),
  (40, 3);

INSERT INTO matches (match_id, first_player, second_player, first_score, second_score) VALUES
  (1, 15, 45, 3, 0),
  (2, 30, 25, 1, 2),
  (3, 30, 15, 2, 0),
  (4, 40, 20, 5, 2),
  (5, 35, 50, 1, 1);

with abc as (
select b.group_id,a.player_id,sum(score) as points from (
select first_player as player_id,sum(first_score) score from matches
group by 1
union
select second_player as player_id,sum(second_score) from matches
group by 1) a inner join Players b on a.player_id=b.player_id
group by 1,2)
select * from (
select group_id,player_id,points,rank() over (partition by group_id order by points desc,player_id
    ) as rank
from abc) where rank=1




-- Solution
with abc as (
select first_player as player_id,sum(score) as total_score from (
select first_player,first_score as score from matches
union
select second_player,second_score as score from matches
)
group by 1)
select group_id, min(player_id) as player_id from (
select a.player_id,b.group_id,total_score,
dense_rank() over(partition by b.group_id order by total_score desc) as rank
from abc a inner join Players b
on a.player_id=b.player_id
) where rank=1
group by 1





