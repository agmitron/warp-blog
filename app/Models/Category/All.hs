{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}

module Models.Category.All
(getAll, createCategoryTree)
where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ
import qualified Data.ByteString.UTF8 as B8
import Utils as U
import GHC.Generics
import qualified Models.Category.Common as CC
import Prelude hiding (id)
import Data.Maybe
import Data.Aeson (ToJSON)
import qualified Data.Text as T

getAll :: IO [CC.Category]
getAll = do
  conn <- U.createConnection
  query_
    conn
    [sql| select * from categories; |]


data CategoryTree = CategoryTree {
  id :: Integer,
  parent_id :: Maybe Integer,
  name :: T.Text,
  children :: [CategoryTree]
} deriving (Generic, Show, ToJSON)


createCategoryTree :: [CC.Category]-> [CategoryTree]
createCategoryTree [] = []
createCategoryTree cats =
  let rootElems = filter (\c -> isNothing $ CC.parent_id c) cats
  in foldl
      (\acc cat -> acc ++ [
        CategoryTree
          (CC.id cat)
          (CC.parent_id cat)
          (CC.name cat)
          (findChildren cats $ CC.id cat)
        ]
      )
      []
      rootElems


findChildren :: [CC.Category] -> Integer -> [CategoryTree]
findChildren [] _ = []
findChildren cats categoryId =
  let directChildren = filter (\cat -> CC.parent_id cat == Just categoryId) cats
      childrenOfChildren cats' id' = findChildren cats' id'
  in
    foldl
      (\acc child ->
        acc ++ [(CategoryTree
          (CC.id child)
          (CC.parent_id child)
          (CC.name child)
          (childrenOfChildren cats $ CC.id child )
        )]
      )
      []
      directChildren
