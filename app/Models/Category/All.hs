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

getAll :: IO [CC.Category]
getAll = do
  conn <- U.createConnection
  query_
    conn
    [sql| select * from categories; |]


data CategoryTree = CategoryTree {
  id :: Integer,
  parent_id :: Maybe Integer,
  name :: B8.ByteString,
  children :: [CategoryTree]
} deriving (Show)

sortedCatsExample :: [CC.Category]
sortedCatsExample = [CC.Category {CC.id = 1, CC.parent_id = Nothing, CC.name = "news"},
  CC.Category {CC.id = 2, CC.parent_id = Just 1, CC.name = "news_about_memes"},
  CC.Category {CC.id = 5, CC.parent_id = Just 1, CC.name = "news_about_covid19"},
  CC.Category {CC.id = 3, CC.parent_id = Just 2, CC.name = "memes_about_coding"},
  CC.Category {CC.id = 4, CC.parent_id = Just 2, CC.name = "memes_about_cats"},
  CC.Category {CC.id = 6, CC.parent_id = Just 5, CC.name = "covid19_death_count"}]


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
