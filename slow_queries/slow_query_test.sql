SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- Log queries longer than 1 second

SET GLOBAL slow_query_log_file = '/var/log/mysql/slow-queries.log';

SELECT SLEEP(5);


SELECT * FROM tasks WHERE description LIKE '%performance%';


SELECT COUNT(*) FROM tasks AS t1, tasks AS t2;


SHOW GLOBAL STATUS LIKE 'Slow_queries';

