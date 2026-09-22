-- Check for overlapping downtime events on the same line.
-- Expected result for the current sample: zero rows.

SELECT
    a.line_id,
    a.downtime_id AS first_event,
    b.downtime_id AS second_event
FROM downtime a
JOIN downtime b
    ON a.line_id = b.line_id
   AND a.downtime_id < b.downtime_id
   AND a.start_time < b.end_time
   AND b.start_time < a.end_time;