{-# LANGUAGE OverloadedStrings #-}

module Controllers.User where

import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as B8
import qualified Models.User.Find
import qualified Models.User.Create
import qualified Models.User.Update
import Database.PostgreSQL.Simple
import Network.HTTP.Types (status200, status400, status500, status404)
import Network.Wai.Handler.Warp
import Network.Wai.Parse
import Network.Wai
import qualified Data.Map as M
import qualified Utils as U
import Controllers.Controllers
import qualified Data.List as L
import Crypto.Hash
import Data.Maybe

formToUserModel :: M.Map BS.ByteString BS.ByteString -> Maybe Models.User.Create.UserModelCreateData
formToUserModel params = do
  name <- M.lookup "name" params
  surname <- M.lookup "surname" params
  password <- M.lookup "password" params
  login <- M.lookup "login" params
  avatar_uri <- M.lookup "avatar_uri" params

  return $ Models.User.Create.UserModelCreateData name surname avatar_uri login password False

register :: Controller
register req respond = do
  body <- parseRequestBody lbsBackEnd req
  let params    = M.fromList $ fst body
      file      = snd body
      userModel = formToUserModel params

  case userModel of
    Just uM -> do
      createdUser <- Models.User.Create.create uM
      print ("success: " ++ show createdUser)
      respond $ responseLBS
        status200
        [("Content-Type", "text/plain")]
        "Created"
    Nothing -> do
      print "Invalid data"
      respond $ responseLBS
        status400
          [("Content-Type", "text/plain")]
          "Invalid data"

login :: Controller
login req respond = do
  body <- parseRequestBody lbsBackEnd req
  let login = L.lookup "login" $ fst body
      password = L.lookup "password" $ fst body

  if (isJust login) && (isJust password)
    then
        do
          foundUser <- Models.User.Find.find $ fromJust login
          case foundUser of
            Just user -> do
              let storedHashedPassword = Models.User.Find.password user
                  receivedPassword = show ((hash $ fromJust password) :: Digest Blake2b_256)
              print storedHashedPassword
              print receivedPassword
              if show storedHashedPassword == ("\"" ++ receivedPassword ++ "\"")
                then
                  do
                    [Only newToken] <- Models.User.Update.updateToken $ fromJust login
                    respond $ responseLBS
                      status200
                      [("Content-Type", "application/json")]
                      $ ("{\"token\": \"" <> (B8.fromStrict newToken) <> "\"}")
                else
                  do
                    respond $ responseLBS
                      status400
                      [("Content-Type", "text/plain")]
                      "Incorrect password."
            Nothing -> do
              respond $ responseLBS
                status404
                [("Content-Type", "text/plain")]
                "User doesn't exist."
    else
        respond $ responseLBS
            status400
            [("Content-Type", "text/plain")]
            "Invalid data"





