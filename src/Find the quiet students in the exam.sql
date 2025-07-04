-- Question 106
-- Table: Student

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | student_id          | int     |
-- | student_name        | varchar |
-- +---------------------+---------+
-- student_id is the primary key for this table.
-- student_name is the name of the student.
 

-- Table: Exam

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | exam_id       | int     |
-- | student_id    | int     |
-- | score         | int     |
-- +---------------+---------+
-- (exam_id, student_id) is the primary key for this table.
-- Student with student_id got score points in exam with id exam_id.
 

-- A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score.

-- Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.

-- Don't return the student who has never taken any exam. Return the result table ordered by student_id.

-- The query result format is in the following example.

 

-- Student table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Jade          |
-- | 3           | Stella        |
-- | 4           | Jonathan      |
-- | 5           | Will          |
-- +-------------+---------------+

-- Exam table:
-- +------------+--------------+-----------+
-- | exam_id    | student_id   | score     |
-- +------------+--------------+-----------+
-- | 10         |     1        |    70     |
-- | 10         |     2        |    80     |
-- | 10         |     3        |    90     |
-- | 20         |     1        |    80     |
-- | 30         |     1        |    70     |
-- | 30         |     3        |    80     |
-- | 30         |     4        |    90     |
-- | 40         |     1        |    60     |
-- | 40         |     2        |    70     |
-- | 40         |     4        |    80     |
-- +------------+--------------+-----------+


CREATE temp TABLE Student (
                         student_id INT,
                         student_name VARCHAR(255)
);

CREATE temp TABLE Exam (
                      exam_id INT,
                      student_id INT,
                      score INT
);

-- Insert data into Student table
INSERT INTO Student (student_id, student_name) VALUES (1, 'Daniel');
INSERT INTO Student (student_id, student_name) VALUES (2, 'Jade');
INSERT INTO Student (student_id, student_name) VALUES (3, 'Stella');
INSERT INTO Student (student_id, student_name) VALUES (4, 'Jonathan');
INSERT INTO Student (student_id, student_name) VALUES (5, 'Will');

-- Insert data into Exam table
INSERT INTO Exam (exam_id, student_id, score) VALUES (10, 1, 70);
INSERT INTO Exam (exam_id, student_id, score) VALUES (10, 2, 80);
INSERT INTO Exam (exam_id, student_id, score) VALUES (10, 3, 90);
INSERT INTO Exam (exam_id, student_id, score) VALUES (20, 1, 80);
INSERT INTO Exam (exam_id, student_id, score) VALUES (30, 1, 70);
INSERT INTO Exam (exam_id, student_id, score) VALUES (30, 3, 80);
INSERT INTO Exam (exam_id, student_id, score) VALUES (30, 4, 90);
INSERT INTO Exam (exam_id, student_id, score) VALUES (40, 1, 60);
INSERT INTO Exam (exam_id, student_id, score) VALUES (40, 2, 70);
INSERT INTO Exam (exam_id, student_id, score) VALUES (40, 4, 80);


-- Result table:
-- +-------------+---------------+
-- | student_id  | student_name  |
-- +-------------+---------------+
-- | 2           | Jade          |
-- +-------------+---------------+

-- For exam 1: Student 1 and 3 hold the lowest and high score respectively.
-- For exam 2: Student 1 hold both highest and lowest score.
-- For exam 3 and 4: Studnet 1 and 4 hold the lowest and high score respectively.
-- Student 2 and 5 have never got the highest or lowest in any of the exam.
-- Since student 5 is not taking any exam, he is excluded from the result.
-- So, we only return the information of Student 2.

-- Solution
with examwise_score as (
select exam_id,max(score) as high_score,min(score) as low_score
from Exam
group by 1)
select * from (
select c.student_name,
sum(case when a.score > b.low_score and a.score < b.high_score then  0 else 1 end) as performance_idx
from Exam a inner join examwise_score b on a.exam_id=b.exam_id
inner join Student c on a.student_id=c.student_id
group by 1
) where performance_idx=0;

--get the student_id who scored high and low and then check which student is basically not in this list
select distinct a.student_id from Exam a inner join (
select exam_id,max(score) as max_mark,min(score) as min_mark from exam group by 1) b
    on a.exam_id=b.exam_id and (a.score = b.min_mark or a.score = b.max_mark)