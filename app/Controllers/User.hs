{-# LANGUAGE OverloadedStrings #-}

module Controllers.User where

import qualified Data.ByteString as BS
import Data.ByteString.Lazy.UTF8 as BLU
import qualified Models.User.Find
import qualified Models.User.Create
import Network.HTTP.Types (status200, status400, status500)
import Network.Wai.Handler.Warp
import Network.Wai.Parse
import Network.Wai
import qualified Data.Map as M
import qualified Utils as U
import Controllers.Controllers
import qualified Data.List as L

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

  case L.lookup "login" $ fst body of
    Just userLogin -> do
      user <- Models.User.Find.find userLogin
      print user
      respond $ responseLBS
        status200
        [("Content-Type", "text/plain")]
        "kek"
    Nothing -> do
      respond $ responseLBS
        status400
        [("Content-Type", "text/plain")]
        "Invalid data"



