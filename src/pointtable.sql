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