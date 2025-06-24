CREATE temp TABLE intervals (
    id INT ,
    start_v INT,
    end_v INT
);

INSERT INTO intervals (id, start_v, end_v) VALUES
(1, 1, 3),
(2, 2, 6),
(3, 8, 10),
(4, 15, 18);

with abc as (
select *,nvl(lag(start_v,1) over(order by id),-1) as prev_start,
nvl(lag(end_v,1) over(order by id),-1) as prev_end
 from intervals)
 ,bac as(select id,start_v,end_v, case when start_v between prev_start and prev_end then 0 else 1 end as brk_ind
 from abc)
 ,cumm_grp as (
 select *,sum(brk_ind) over(order by id rows between unbounded preceding and current row) as grp from bac)
 select grp,min(start_v) as start_value,max(end_v) as max_value from cumm_grp
 group by 1
