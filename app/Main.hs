{-# LANGUAGE OverloadedStrings #-}

import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Network.HTTP.Types (status200)
import Network.Wai
import Network.Wai.Handler.Warp
import qualified Models.User
import qualified Migrations as M
import qualified Utils as U
import Database.PostgreSQL.Simple

main :: IO ()
main = do
  conn <- U.createConnection
  M.runMigrations conn
  -- (Models.User.create conn Models.User.UserModel {
  --   Models.User.name = "Ivan"
  --   , Models.User.surname = "Ivanov"
  --   , Models.User.avatar_uri = "Url"
  --   , Models.User.login = "login"
  --   , Models.User.password = "password"
  --   , Models.User.is_admin = False
  -- })
  -- return ()

  -- let port = 3000
  -- putStrLn $ "Listening on port " ++ show port
  -- run port app
  -- return ()



app :: Request -> (Response -> t) -> t
app req respond = respond $
  case pathInfo req of
    ["yay"] -> yay
    x -> index x

yay :: Response
yay =
  responseBuilder status200 [("Content-Type", "text/plain")] $
    mconcat $
      map
        copyByteString
        ["yay"]

index :: Show a => a -> Response
index x =
  responseBuilder status200 [("Content-Type", "text/html")] $
    mconcat $
      map
        copyByteString
        [ "<p>Hello from ",
          BU.fromString $ show x,
          "!</p>",
          "<p><a href='/yay'>yay</a></p>\n"
        ]
