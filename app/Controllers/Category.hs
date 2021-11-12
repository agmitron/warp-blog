{-# LANGUAGE OverloadedStrings #-}

module Controllers.Category where
import qualified Models.Category.All as AC
import Controllers.Controllers
import Network.HTTP.Types
import Network.Wai.Handler.Warp
import Network.Wai
import Models.Category.Common (Category(Category))
import Data.List (sortBy)
import Data.Aeson

all :: Controller
all req respond = do
  res <- AC.getAll
  let sorted = sortCategoriesByParentId res
      categoryTree = AC.createCategoryTree sorted
  print categoryTree
  respond $ responseLBS
    status200
    [("Content-Type", "application/json")]
    (encode categoryTree)

sortCategoriesByParentId :: [Category] -> [Category]
sortCategoriesByParentId cats = sortBy compareParentIds cats
  where compareParentIds = (\(Category _ a _) (Category _ b _) -> compare a b)
