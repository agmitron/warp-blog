{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}

module Models.User where

import Crypto.Error
import Crypto.KDF.Argon2
import Crypto.Random (getRandomBytes)
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString as B
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import GHC.Generics
import qualified Utils as U

data UserModel = UserModel
  { name :: String,
    surname :: String,
    avatar_uri :: String,
    login :: String,
    password :: String,
    is_admin :: Bool
  } deriving (Generic)


create :: Connection -> UserModel -> IO (Either CryptoError [Only Int])
create conn model = do
  salt <- getRandomBytes 16 :: IO B.ByteString
  let pwd = BC.pack $ password model
      out = (hash defaultOptions pwd salt 256)
  case out of
    CryptoPassed hashedPassword -> do
      let hashedPasswordStr = BC.unpack $ hashedPassword
      res <-
        query
          conn
          [sql| insert into users
          (name,surname,avatar_uri,login,password,is_admin)
          values (?,?,?,?,?,?) RETURNING id;|]
          $ (
            name model :: String,
            surname model :: String,
            avatar_uri model :: String,
            login model :: String,
            hashedPasswordStr :: String,
            is_admin model :: Bool
          )
      return $ Right res
    CryptoFailed err -> return $ Left err
