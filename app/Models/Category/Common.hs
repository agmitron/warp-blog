{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}

module Models.Category.Common
(Category(Category), id, parent_id, name)
where

import qualified Data.ByteString.UTF8 as B8
import GHC.Generics
import Database.PostgreSQL.Simple
import Prelude hiding (id)
import qualified Data.Text as T

data Category = Category {
  id :: Integer,
  parent_id :: Maybe Integer,
  name :: T.Text
} deriving (Generic, Show, FromRow)

