create table if not exists news_tags (
  id SERIAL PRIMARY KEY,
  news_id INTEGER,
  tag_id INTEGER,
  FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE,
  FOREIGN KEY (news_id) REFERENCES news (id) ON DELETE CASCADE
)
