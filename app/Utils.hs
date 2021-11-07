module Utils
  (
    createConnection,
    safeHead
  )
where

import Database.PostgreSQL.Simple (ConnectInfo (connectDatabase, connectHost, connectPassword, connectPort, connectUser, ConnectInfo), connect, Connection)

createConnection :: IO Connection
createConnection = connect $ ConnectInfo {
    connectHost = "127.0.0.1"
    , connectPort = 5432
    , connectUser = "alek"
    , connectPassword = ""
    , connectDatabase = "warp-blog"
  }

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x
