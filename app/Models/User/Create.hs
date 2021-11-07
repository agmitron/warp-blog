{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Models.User.Create
(
  UserModelCreateData (UserModelCreateData),
  name,
  surname,
  avatar_uri,
  login,
  password,
  is_admin,
  create
)
where

import Crypto.Hash
import qualified Data.ByteString.UTF8 as B8
import Data.Int
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import GHC.Generics
import qualified Utils as U

data UserModelCreateData = UserModelCreateData
  { name :: B8.ByteString,
    surname :: B8.ByteString,
    avatar_uri :: B8.ByteString,
    login :: B8.ByteString,
    password :: B8.ByteString,
    is_admin :: Bool
  }
  deriving (Generic, Show, FromRow)

create :: UserModelCreateData -> IO [Only Int64]
create model = do
  conn <- U.createConnection
  let hashedPasswordStr = (hash $ password model) :: Digest Blake2b_256
  print hashedPasswordStr
  query
    conn
    [sql| insert into users
    (name,surname,avatar_uri,login,password,is_admin)
    values (?,?,?,?,?,?) RETURNING id;|]
    $ ( name model :: B8.ByteString,
        surname model :: B8.ByteString,
        avatar_uri model :: B8.ByteString,
        login model :: B8.ByteString,
        show hashedPasswordStr :: String,
        is_admin model :: Bool
      )
