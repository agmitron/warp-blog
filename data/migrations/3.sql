create table if not exists categories (
  id SERIAL PRIMARY KEY,
  parent_id INTEGER,
  name VARCHAR(50)
)
