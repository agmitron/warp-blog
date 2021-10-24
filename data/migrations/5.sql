create table if not exists news (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  author_id INTEGER,
  category_id INTEGER,
  content TEXT,
  thumbnail_photo_id INTEGER,
  is_draft BOOLEAN DEFAULT false,
  FOREIGN KEY (author_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL,
  FOREIGN KEY (thumbnail_photo_id) REFERENCES photos (id) ON DELETE SET NULL
)
