{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}

import Blaze.ByteString.Builder (copyByteString)
import qualified Data.ByteString.UTF8 as BU
import Data.Monoid
import Network.HTTP.Types (status200)
import Network.Wai
import Network.Wai.Handler.Warp
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ

qry :: IO [Only Int]
qry = do
  conn <- connectPostgreSQL "host='localhost' port=5432 dbname='warp-blog' user='alek' password='qwerty'"
  (query_ conn [sql| select 2+2 |])

main :: IO ()
main = do
  let port = 3000
  putStrLn $ "Listening on port " ++ show port
  res <- qry
  print res
  run port app
  return ()

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
