CREATE TABLE public.fact_videos (
  id TEXT PRIMARY KEY,
  title TEXT,
  description TEXT,
  channel_id TEXT,
  published_at TIMESTAMP,
  duration_raw TEXT,
  duration_sec INT,
  view_count BIGINT,
  like_count BIGINT,
  comment_count BIGINT,
  idioma TEXT,
  origem TEXT
);
