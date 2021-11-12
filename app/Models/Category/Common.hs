{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Models.Category.Common
(Category(Category), id, parent_id, name)
where

import qualified Data.ByteString.UTF8 as B8
import GHC.Generics
import Database.PostgreSQL.Simple
import Prelude hiding (id)

data Category = Category {
  id :: Integer,
  parent_id :: Maybe Integer,
  name :: B8.ByteString
} deriving (Generic, Show, FromRow)

