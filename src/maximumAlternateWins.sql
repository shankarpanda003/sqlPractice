CREATE temp TABLE ipl_winners (
    team VARCHAR(50) NOT NULL,
    winning_year INT NOT NULL,
    PRIMARY KEY (team, winning_year)
);

INSERT INTO ipl_winners (team, winning_year) VALUES
('Rajasthan Royals', 2008),
('Deccan Chargers', 2009),
('Chennai Super Kings', 2010),
('Chennai Super Kings', 2011),
('Kolkata Knight Riders', 2012),
('Mumbai Indians', 2013),
('Kolkata Knight Riders', 2014),
('Mumbai Indians', 2015),
('Sunrisers Hyderabad', 2016),
('Mumbai Indians', 2017),
('Chennai Super Kings', 2018),
('Mumbai Indians', 2019),
('Mumbai Indians', 2020),
('Chennai Super Kings', 2021),
('Gujarat Titans', 2022),
('Chennai Super Kings', 2023),
('Kolkata Knight Riders', 2024),
('Royal Challengers Bengaluru', 2025);

select * from ipl_winners


with team_prev2_winning_year as
(
select
	team,
	winning_year,
	lag(winning_year,1) over(partition by team order by winning_year) as prev_1_winning_year,
	lag(winning_year,2) over(partition by team order by winning_year) as prev_2_winning_year
from ipl_winners
),
team_with_group_switch_signal as
(
select
	team,
	winning_year,
	case
		when winning_year <> prev_1_winning_year + 1 and winning_year = prev_2_winning_year + 2 then 0 else 1
	end as group_switch_signal
from team_prev2_winning_year
)
,team_with_group as
(
select
	team,
	winning_year,
	sum(group_switch_signal) over(partition by team order by winning_year) as group_val
from team_with_group_switch_signal
)
select
	team,
	group_val,
	count(1) as streak_length
from team_with_group
group by 1,2
