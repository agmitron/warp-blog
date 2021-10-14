{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Migrations
(runMigrations)
where
import Database.PostgreSQL.Simple (Connection, execute, FromRow)
import Database.PostgreSQL.Simple.SqlQQ
import Data.Int (Int64)

createUsersTable :: Connection -> IO Int64
createUsersTable conn = do
  execute conn [sql| create table users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    surname VARCHAR(50),
    avatar_uri TEXT,
    login VARCHAR(50),
    password TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_admin BOOLEAN
  ) |] ()

runMigrations :: Connection -> IO Int64
runMigrations conn = do
  createUsersTable conn
