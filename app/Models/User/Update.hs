{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Models.User.Update
(updateToken)
where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import qualified Data.ByteString.UTF8 as B8
import System.Random
import qualified Utils as U
import Data.Maybe

updateToken :: B8.ByteString -> IO [Only B8.ByteString]
updateToken login = do
  conn <- U.createConnection
  genSalt <- randomRIO (0, 100) :: IO Int
  let pureGen = mkStdGen genSalt
      tokenHash = B8.fromString $ take 20 (randomRs ('a','z') pureGen)

  query
    conn
    [sql| update users set token = ? where login = ? returning token; |]
    (tokenHash, login)
