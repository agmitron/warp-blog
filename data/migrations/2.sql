create table if not exists authors (
  id SERIAL PRIMARY KEY,
  user_id INTEGER,
  description TEXT,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
)
