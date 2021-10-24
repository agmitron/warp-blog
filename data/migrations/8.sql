create table if not exists photos_news (
  id SERIAL PRIMARY KEY,
  photo_id INTEGER,
  news_id INTEGER,
  FOREIGN KEY (photo_id) REFERENCES photos (id) ON DELETE CASCADE,
  FOREIGN KEY (news_id) REFERENCES news (id) ON DELETE CASCADE
)
