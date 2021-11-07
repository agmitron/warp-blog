{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Models.User.Find
(
  UserModelFindData (UserModelFindData),
  name,
  surname,
  avatar_uri,
  login,
  password,
  is_admin,
  find
)
where

import qualified Data.ByteString.UTF8 as B8
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.Time
import Database.PostgreSQL.Simple.SqlQQ
import GHC.Generics
import qualified Utils as U

data UserModelFindData = UserModelFindData
  {
    id :: Int,
    name :: B8.ByteString,
    surname :: B8.ByteString,
    avatar_uri :: B8.ByteString,
    login :: B8.ByteString,
    password :: B8.ByteString,
    created_at :: UTCTimestamp,
    is_admin :: Bool,
    token :: Maybe B8.ByteString
  }
  deriving (Generic, Show, FromRow)

find :: B8.ByteString -> IO (Maybe UserModelFindData)
find login = do
  conn <- U.createConnection
  res <- query
    conn
    [sql| select * from users where login = ? limit 1; |]
    (Only (login :: B8.ByteString))
  return $ U.safeHead res
