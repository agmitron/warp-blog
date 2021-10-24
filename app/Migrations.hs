{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module Migrations
(runMigrations)
where
import Prelude hiding (catch)
import Control.Exception
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import qualified Data.ByteString as BS
import Data.Int (Int64)
import qualified Data.List as L
import Data.Function
import Control.Monad
import System.Directory (listDirectory, getCurrentDirectory)
import System.IO
import Data.String (fromString)

migrationsDir = "data/migrations/"

errorHandler :: String -> SqlError -> IO Int64
errorHandler fileName err = do
  print (fileName ++ ": " ++ show err)
  return 0

runMigrations :: Connection -> IO ()
runMigrations conn = do
  currentDir <- getCurrentDirectory
  print currentDir
  unsorted <- listDirectory migrationsDir
  let sorted = L.sort unsorted
  print sorted
  forM_ sorted (\f -> do
    let fileName = migrationsDir ++ f
    withFile fileName ReadMode (\handle -> do
      contents <- hGetContents handle
      (execute_ conn $ fromString contents) `catch` errorHandler fileName))
