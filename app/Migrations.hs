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
import Database.PostgreSQL.Simple.Migration hiding (runMigrations)
import qualified Data.ByteString as BS
import qualified Data.ByteString.UTF8 as B8
import Data.Int (Int64)
import qualified Data.List as L
import Data.Function
import Control.Monad
import System.Directory (listDirectory, getCurrentDirectory)
import System.IO
import Data.String (fromString)
import qualified Utils as U
import System.Exit
import Data.FileEmbed

migrationsDir = "data/migrations/"

errorHandler :: String -> SqlError -> IO Int64
errorHandler fileName err = do
  print (fileName ++ ": " ++ show err)
  return 0

sortedMigrations :: [(FilePath, BS.ByteString)]
sortedMigrations =
  let unsorted = $(embedDir "data/migrations/")
  in L.sortBy (compare `on` fst) unsorted

runMigrations :: IO ()
runMigrations = do
  conn <- U.createConnection
  let defaultContext =
          MigrationContext
          { migrationContextCommand = MigrationInitialization
          , migrationContextVerbose = False
          , migrationContextConnection = conn
          }
      migrations = ("(init)", defaultContext) :
                     [
                        (k, defaultContext
                            { migrationContextCommand =
                                MigrationScript k v
                            })
                        | (k, v) <- sortedMigrations
                     ]
  forM_ migrations $ \(migrDescr, migr) -> do
    BS.putStrLn $ "Running migration: " <> B8.fromString migrDescr
    res <- runMigration migr
    case res of
      MigrationSuccess -> return ()
      MigrationError reason -> do
        BS.putStrLn $ "Migration failed: " <> B8.fromString reason
        exitFailure
