drop table if exists meeting_room;
Create temp table meeting_room(id int, start_time timestamp, end_time timestamp);
insert into meeting_room values (1, '2018-12-10 08:00'::timestamp,'2018-12-10 09:15'::timestamp);
insert into meeting_room values(2, '2018-12-10 13:20'::timestamp,'2018-12-10 15:20'::timestamp);
insert into meeting_room values(3, '2018-12-10 10:00'::timestamp,'2018-12-10 14:15'::timestamp);
insert into meeting_room values(4, '2018-12-10 13:55'::timestamp,'2018-12-10 16:25'::timestamp);
insert into meeting_room values(5, '2018-12-10 14:00'::timestamp,'2018-12-10 17:45'::timestamp);
insert into meeting_room values(6, '2018-12-10 14:05'::timestamp,'2018-12-10 17:45'::timestamp);
select * from meeting_room

--Minimum number of meeting room require to accommodate all meetings

-- basically we know the highest overlapping meetings then that means we should need that many rooms

select a.id,count(1) from meeting_room a left join meeting_room b on
a.start_time between b.start_time and  b.end_time
group by 1



