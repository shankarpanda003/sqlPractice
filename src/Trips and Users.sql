-- Question 98
-- The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

-- +----+-----------+-----------+---------+--------------------+----------+
-- | Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
-- +----+-----------+-----------+---------+--------------------+----------+
-- | 1  |     1     |    10     |    1    |     completed      |2013-10-01|
-- | 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
-- | 3  |     3     |    12     |    6    |     completed      |2013-10-01|
-- | 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
-- | 5  |     1     |    10     |    1    |     completed      |2013-10-02|
-- | 6  |     2     |    11     |    6    |     completed      |2013-10-02|
-- | 7  |     3     |    12     |    6    |     completed      |2013-10-02|
-- | 8  |     2     |    12     |    12   |     completed      |2013-10-03|
-- | 9  |     3     |    10     |    12   |     completed      |2013-10-03| 
-- | 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
-- +----+-----------+-----------+---------+--------------------+----------+



write a create table and insert statement for below -- +----+-----------+-----------+---------+--------------------+----------+
-- | Id | Client_Id | Driver_Id | City_Id |        Status      |Request_at|
-- +----+-----------+-----------+---------+--------------------+----------+
-- | 1  |     1     |    10     |    1    |     completed      |2013-10-01|
-- | 2  |     2     |    11     |    1    | cancelled_by_driver|2013-10-01|
-- | 3  |     3     |    12     |    6    |     completed      |2013-10-01|
-- | 4  |     4     |    13     |    6    | cancelled_by_client|2013-10-01|
-- | 5  |     1     |    10     |    1    |     completed      |2013-10-02|
-- | 6  |     2     |    11     |    6    |     completed      |2013-10-02|
-- | 7  |     3     |    12     |    6    |     completed      |2013-10-02|
-- | 8  |     2     |    12     |    12   |     completed      |2013-10-03|
-- | 9  |     3     |    10     |    12   |     completed      |2013-10-03|
-- | 10 |     4     |    13     |    12   | cancelled_by_driver|2013-10-03|
-- +----+-----------+-----------+---------+--------------------+----------+

-- Create table statement
CREATE TEMP TABLE RideRequests (
                              Id INT,
                              Client_Id INT,
                              Driver_Id INT,
                              City_Id INT,
                              Status VARCHAR(20),
                              Request_at DATE
);

-- Insert statements
INSERT INTO RideRequests (Id, Client_Id, Driver_Id, City_Id, Status, Request_at) VALUES
                                                                                     (1, 1, 10, 1, 'completed', '2013-10-01'),
                                                                                     (2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
                                                                                     (3, 3, 12, 6, 'completed', '2013-10-01'),
                                                                                     (4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
                                                                                     (5, 1, 10, 1, 'completed', '2013-10-02'),
                                                                                     (6, 2, 11, 6, 'completed', '2013-10-02'),
                                                                                     (7, 3, 12, 6, 'completed', '2013-10-02'),
                                                                                     (8, 2, 12, 12, 'completed', '2013-10-03'),
                                                                                     (9, 3, 10, 12, 'completed', '2013-10-03'),
                                                                                     (10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');
-- The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

-- +----------+--------+--------+
-- | Users_Id | Banned |  Role  |
-- +----------+--------+--------+
-- |    1     |   No   | client |
-- |    2     |   Yes  | client |
-- |    3     |   No   | client |
-- |    4     |   No   | client |
-- |    10    |   No   | driver |
-- |    11    |   No   | driver |
-- |    12    |   No   | driver |
-- |    13    |   No   | driver |
-- +----------+--------+--------+

CREATE temp TABLE Users (
                       Users_Id INT PRIMARY KEY,
                       Banned VARCHAR(3),
                       Role VARCHAR(10)
);

-- Insert statements
INSERT INTO Users (Users_Id, Banned, Role) VALUES
                                               (1, 'No', 'client'),
                                               (2, 'Yes', 'client'),
                                               (3, 'No', 'client'),
                                               (4, 'No', 'client'),
                                               (10, 'No', 'driver'),
                                               (11, 'No', 'driver'),
                                               (12, 'No', 'driver'),
                                               (13, 'No', 'driver');
-- Write a SQL query to find the cancellation rate of requests made by unbanned users (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The cancellation rate is computed by dividing the number of canceled (by client or driver) requests made by unbanned users by the total number of requests made by unbanned users.

-- For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

-- +------------+-------------------+
-- |     Day    | Cancellation Rate |
-- +------------+-------------------+
-- | 2013-10-01 |       0.33        |
-- | 2013-10-02 |       0.00        |
-- | 2013-10-03 |       0.50        |
-- +------------+-------------------+
-- Credits:
-- Special thanks to @cak1erlizhou for contributing this question, writing the problem description and adding part of the test cases.

-- Solution
with t1 as(
select request_at, count(status) as total
from trips 
where client_id = any(select users_id
from users
where banned != 'Yes') 
and driver_id = any(select users_id
from users
where banned != 'Yes')
and request_at between '2013-10-01' and '2013-10-03'
group by request_at),

t2 as
( select request_at, count(status) as cancel
from trips 
where client_id = any(select users_id
from users
where banned != 'Yes') 
and driver_id = any(select users_id
from users
where banned != 'Yes')
and request_at between '2013-10-01' and '2013-10-03'
and status != 'completed'
group by request_at
)

select request_at as Day, coalesce(round((cancel+0.00)/(total+0.00),2),0) as "Cancellation Rate"
from t1 left join t2
using(request_at)

with abc as (
select a.Request_at,count(1) as total_request from RideRequests a inner join Users b on
    a.Client_Id=b.Users_Id and b.Banned='No'
        inner join users c on a.driver_id=c.Users_Id and c.banned='No'
         where a.Request_at between '2013-10-01' and '2023-10-03'
group by 1)
, bac as (
select a.Request_at,count(1) as cancel_request from RideRequests a inner join Users b on
    a.Client_Id=b.Users_Id and b.Banned='No'
        inner join users c on a.driver_id=c.Users_Id and c.banned='No'
         where a.Request_at between '2013-10-01' and '2023-10-03'
         and a.Status <> 'completed'
         group by 1)
select a.Request_at,coalesce(round((b.cancel_request+0.00)/(a.total_request+0.00),2),0)
from abc a inner join bac b on a.Request_at=b.Request_at;
