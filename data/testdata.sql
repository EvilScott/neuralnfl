-- create test data
COPY (
SELECT
  (60.0 - p.minute) / 60.0 AS "time",
  p.down / 4.0 AS "down",
  p.yards_to_first / 100.0 AS "to_first",
  p.yards_to_goal / 100.0 AS "to_goal",
  (p.off_score - p.def_score) AS "score_diff",
  CASE WHEN t.type = 'Run' THEN 1 ELSE 0 END AS "is_run",
  CASE WHEN t.type = 'Pass' THEN 1 ELSE 0 END AS "is_pass",
  CASE WHEN t.type = 'Field goal' THEN 1 ELSE 0 END AS "is_field_goal",
  CASE WHEN t.type = 'Fake field goal' THEN 1 ELSE 0 END AS "is_fake_field_goal",
  CASE WHEN t.type = 'Punt' THEN 1 ELSE 0 END AS "is_punt",
  CASE WHEN t.type = 'Fake punt' THEN 1 ELSE 0 END AS "is_fake_punt",
  CASE WHEN t.type = 'Kneel' THEN 1 ELSE 0 END AS "is_kneel",
  CASE WHEN t.type = 'Spike' THEN 1 ELSE 0 END AS "is_spike"
FROM data.plays p
  JOIN data.plays_types pt ON (p.id = pt.play_id)
  JOIN data.types t ON (pt.type_id = t.id)
) TO '/Users/scott/projects/neuralnfl/data/testdata.csv' DELIMITER ',';
