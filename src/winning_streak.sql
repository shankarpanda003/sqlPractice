--To find the maximum winning streak for each team, you need a table (e.g., matches) with at least team and winning_year columns, where each row represents a win by a team in a given year.
CREATE TABLE matches (
  team VARCHAR(50),
  winning_year INT
);

INSERT INTO matches (team, winning_year) VALUES
  ('A', 2017),
  ('A', 2018),
  ('A', 2019),
  ('B', 2017),
  ('B', 2019),
  ('B', 2020),
  ('B', 2021),
  ('C', 2018),
  ('C', 2019);


  --sol1 myapproach
  --prepare all combination of team and year. which means each year should have all team
  with recursive date_dim(winning_year) as(
  select min(winning_year) as winning_year from matches
  union all
  select winning_year+1 from date_dim where winning_year < (select max(winning_year) from matches)
  ),unique_combination as (
  select a.winning_year as year_p,b.team from date_dim a
  inner join (select team from matches)b on 1=1
  group by 1,2 order by 2,1)
  ,abc as (
  select row_number() over(partition by a.team order by a.year_p) as id,a.year_p as winning_year,a.team,
  case when b.team is null then 'lost' else 'won' end as winning_status
  from unique_combination a left join matches b on a.year_p=b.winning_year
  and a.team=b.team
  order by a.year_p)
  ,final as(
  select id,winning_year,team,winning_status,
  id-row_number() over (partition by team order by winning_year) as grp
  from abc
  where winning_status='won')
  ,team_grp_cnt as(
  select team,grp,count(1) cnt
  from final
  group by 1,2)
  select a.winning_year,a.team from final a inner join
  (select team,grp from team_grp_cnt where cnt=(select max(cnt) from team_grp_cnt)) b
  on a.team=b.team
  and a.grp=b.grp;

  -- optimised solution

  WITH streaks AS (
    SELECT
      team,
      winning_year,
      winning_year - ROW_NUMBER() OVER (PARTITION BY team ORDER BY winning_year) AS grp
    FROM matches
  ),
  grouped AS (
    SELECT
      team,
      MIN(winning_year) AS start_year,
      MAX(winning_year) AS end_year,
      COUNT(*) AS streak_length
    FROM streaks
    GROUP BY team, grp
  )
  SELECT
    team,
    start_year,
    end_year,
    streak_length
  FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY team ORDER BY streak_length DESC) AS rn
    FROM grouped
  ) t
  WHERE rn = 1;
