{-# LANGUAGE OverloadedStrings #-}

import Blaze.ByteString.Builder (copyByteString)
import qualified Controllers.User
import qualified Controllers.Category
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Database.PostgreSQL.Simple
import qualified Migrations as M
import Network.HTTP.Types (status200, status404)
import Network.HTTP.Types.Method
import Network.Wai
import Network.Wai.Handler.Warp
import System.Environment
import qualified Utils as U


main :: IO ()
main = do
  args <- getArgs
  case args of
    ["migration"] -> M.runMigrations
    _ -> do
      let port = 3000
      putStrLn $ "Listening on port " ++ show port
      run port app
      return ()

app :: Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
app req respond = case pathInfo req of
  ["auth", "register"] -> case requestMethod req of
    "POST" -> Controllers.User.register req respond
    _ -> notFound respond
  ["auth", "login"] -> case requestMethod req of
    "POST" -> Controllers.User.login req respond
    _ -> notFound respond
  ["categories"] -> case requestMethod req of
    "GET" -> Controllers.Category.all req respond
    _ -> notFound respond
  x -> notFound respond


notFound :: (Response -> IO ResponseReceived) -> IO ResponseReceived
notFound respond = do
  respond $
    responseLBS
      status404
      [("Content-Type", "text/plain")]
      "Not found"
