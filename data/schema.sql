-- Using Postgres 9.4+

-- schema
CREATE SCHEMA IF NOT EXISTS data;

-- tables
DROP TABLE IF EXISTS data.plays CASCADE;
CREATE TABLE data.plays (
  id INTEGER PRIMARY KEY,
  game_id CHAR(16) NOT NULL,
  rel_play_id INTEGER NOT NULL,
  quarter INTEGER NOT NULL,
  minute INTEGER NOT NULL, -- used in nn
  second INTEGER NOT NULL,
  off_team CHAR(3) NOT NULL,
  def_team CHAR(3) NOT NULL,
  drive_id INTEGER NOT NULL,
  down INTEGER NOT NULL, -- used in nn
  yards_to_first INTEGER NOT NULL, -- used in nn
  yards_to_goal INTEGER NOT NULL, -- used in nn
  description TEXT NOT NULL,
  off_score INTEGER NOT NULL, -- used in nn (score_diff)
  def_score INTEGER NOT NULL, -- used in nn (score_diff)
  season INTEGER NOT NULL,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  day INTEGER NOT NULL,
  home_team CHAR(3) NOT NULL,
  away_team CHAR(3) NOT NULL,
  play_type VARCHAR(512)
);

DROP TABLE IF EXISTS data.types CASCADE;
CREATE TABLE data.types (
  id SERIAL PRIMARY KEY,
  type CHAR(32) NOT NULL
);

DROP TABLE IF EXISTS data.plays_types CASCADE;
CREATE TABLE data.plays_types (
  play_id INTEGER REFERENCES data.plays (id),
  type_id INTEGER REFERENCES data.types (id),
  CONSTRAINT pk_play_type PRIMARY KEY (play_id, type_id)
);

-- data
-- NOTE: path is absolute, will need to be changed for different systems
COPY data.plays FROM '/Users/scott/projects/neuralnfl/data/nflplays.csv' DELIMITER '	';
INSERT INTO data.types (type) VALUES
  ('Run'),
  ('Pass'),
  ('Field goal'),
  ('Fake field goal'),
  ('Punt'),
  ('Fake punt'),
  ('Kneel'),
  ('Spike');

-- indexes
CREATE INDEX i_plays_game_id ON data.plays (game_id);
CREATE UNIQUE INDEX i_plays_rel_play_id ON data.plays (game_id, rel_play_id);
CREATE INDEX i_plays_play_type ON data.plays (play_type varchar_pattern_ops);
CREATE INDEX i_plays_description ON data.plays (description text_pattern_ops);

-- handle some play types missing from the data
UPDATE data.plays SET play_type = 'EXTRA_POINT'
  WHERE description LIKE '%extra point%';
UPDATE data.plays SET play_type = 'KNEEL'
  WHERE description LIKE '%kneels%' or description LIKE '%takes a knee%';
UPDATE data.plays SET play_type = 'SPIKE'
  WHERE description LIKE '%spiked the ball%';
UPDATE data.plays SET play_type = 'QB_SNEAK'
  WHERE description LIKE '%scrambles%';

-- remove garbage data
DELETE FROM data.plays
  WHERE description LIKE 'class="%'
  OR description = '*** play under review ***'
  OR trim(description) = ''
  OR description ~ '^\(\d+:\d+\)$'
  OR description ~ '^-?\d+$';

-- remove unused rows
DELETE FROM data.plays
  WHERE play_type LIKE '%CONVERSION%'
  OR play_type LIKE '%EXTRA_POINT%'
  OR play_type LIKE '%KICKOFF%';

-- associate our play types with plays
INSERT INTO data.plays_types -- Run
  SELECT id as play_id, 1 as type_id FROM data.plays
  WHERE play_type LIKE '%RUN%'
  OR play_type LIKE '%QB_SNEAK%';
INSERT INTO data.plays_types -- Pass
  SELECT id as play_id, 2 as type_id FROM data.plays
  WHERE play_type LIKE '%PASS_COMPLETE%'
  OR play_type LIKE '%PASS_INCOMPLETE%'
  OR play_type LIKE '%INTERCEPTION%';
INSERT INTO data.plays_types -- Field goal
  SELECT id as play_id, 3 as type_id FROM data.plays
  WHERE play_type LIKE '%FIELD_GOAL_GOOD%'
  OR play_type LIKE '%FIELD_GOAL_MISSED%'
  OR play_type LIKE '%FIELD_GOAL_BLOCKED%';
INSERT INTO data.plays_types -- Fake field goal
  SELECT id as play_id, 4 as type_id FROM data.plays
  WHERE play_type LIKE '%FIELD_GOAL_FAKE%';
INSERT INTO data.plays_types -- Punt
  SELECT id as play_id, 5 as type_id FROM data.plays
  WHERE play_type LIKE '%PUNT%'
  OR play_type LIKE '%PUNT_BLOCKED%';
INSERT INTO data.plays_types -- Fake punt
  SELECT id as play_id, 6 as type_id FROM data.plays
  WHERE play_type LIKE '%PUNT_FAKE%';
INSERT INTO data.plays_types -- Kneel
  SELECT id as play_id, 7 as type_id FROM data.plays
  WHERE play_type LIKE '%KNEEL%';
INSERT INTO data.plays_types -- Spike
  SELECT id as play_id, 8 as type_id FROM data.plays
  WHERE play_type LIKE '%SPIKE%';
