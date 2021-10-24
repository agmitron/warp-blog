create table if not exists comments (
  id SERIAL PRIMARY KEY,
  author_id INTEGER,
  content TEXT,
  FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE
)
