create table if not exists comments_users (
  id SERIAL PRIMARY KEY,
  comment_id INTEGER,
  user_id INTEGER,
  FOREIGN KEY (comment_id) REFERENCES comments (id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
)
