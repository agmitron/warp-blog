{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Models.User () where

import Crypto.Error
import Crypto.Hash
import Crypto.Random (getRandomBytes)
import qualified Data.ByteString.UTF8 as B8
import Data.Int
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import GHC.Generics
import qualified Utils as U

