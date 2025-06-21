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
create temp table Players(player_id int,group_id int) ;
create temp table matches(match_id int,first_player int,second_player int,first_score int,second_score int) ;

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
with t1 as(
select first_player, sum(first_score) as total
from
(select first_player, first_score
from matches
union all
select second_player, second_score
from matches) a
group by 1),

t2 as(
select *, coalesce(total,0) as score
from players p left join t1
on p.player_id = t1.first_player)

select group_id, player_id
from 
(select *, row_number() over(partition by group_id order by group_id, score desc) as rn
from t2) b
where b.rn = 1


--cricket match point table
create temp table match_t(team1 varchar(20),team2 varchar(20),Winner varchar(20));
insert into match_t values('India','Pakistan','India');
insert into match_t values('India','Srilanka','India');
insert into match_t values('Srilanka','Pakistan','Pakistan');
insert into match_t values('Srilanka','India','Srilanka');
insert into match_t values('Pakistan','Srilanka','Srilanka');

insert into match_t values('Pakistan','India','India');
insert into match_t values('India','Srilanka','India');
insert into match_t values('Pakistan','India',null);
insert into match_t values('Srilanka','Pakistan',null);


select * from match_t

--winner 2 point, tie 1 point, looser = 0 points

select team,
       sum(matches_played) as matches_played,
       sum(number_of_win) as number_of_win,
       sum(number_of_tie) as number_of_ties,
       sum(matches_played-(number_of_win+number_of_tie)) as number_of_lose
from (
select team1 as team,count(1) as matches_played,
       count(case when Winner=team1 then 1 else null end) as number_of_win,
       count(case when winner is null then 1  else null end) as number_of_tie
       from match_t
group by 1
union
select team2 as team,count(1) as matches_played,
       count(case when Winner=team2 then 1 else null end) as number_of_win,
       count(case when winner is null then 1  else null end) as number_of_tie
from match_t
group by 1)
group by 1



