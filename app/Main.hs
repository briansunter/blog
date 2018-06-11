{-# language OverloadedStrings #-}
{-# language DuplicateRecordFields #-}
module Main where

import SitePipe
import qualified Text.Mustache as MT
import qualified Text.Mustache.Types as MT
import qualified Data.Text as T
import Control.Monad
import qualified Data.ByteString.Lazy.Char8 as BS

import Reader (decodeYaml)

main :: IO ()
main = siteWithGlobals templateFuncs $ do
  -- Load all the posts from site/posts/
  posts <- resourceLoader markdownReader ["posts/*.md"]
  photos <- resourceLoader markdownReader ["posts/photos/*.md"]
  personalInfo <- liftIO $ readFile "site/data/personal-info.yaml" >>= decodeYaml
  liftIO $ print photos

  -- getTags will return a list of all tags from the posts,
  -- each tag has a 'tag' and a 'posts' property
  let tags = getTags makeTagUrl posts
      -- Create an object with the needed context for a table of contents
      indexContext :: Value
      indexContext = object [ "posts" .= posts
                            , "photos" .= photos
                            , "info" .= personalInfo
                            , "tags" .= tags
                            , "url" .= ("/index.html" :: String)
                            ]
      rssContext :: Value
      rssContext = object [ "posts" .= posts
                          , "domain" .= ("http://bsun.io" :: String)
                          , "url" .= ("/rss.xml" :: String)
                          ]

      personalDataContext :: Value
      personalDataContext = object ["personalData" .= personalInfo
                                   , "url" .= ("/data/personal-data.language-json" ::String)]

  -- Render index page, posts and tags respectively
  writeTemplate "templates/index.html" [indexContext]
  writeTemplate "templates/post.html" posts
  writeTemplate "templates/tag.html" tags
  writeTemplate "templates/rss.xml" [rssContext]
  writeWith (\j -> return (BS.unpack (encode j))) [personalDataContext]

  copyFiles ["data/*.pub"]
  files <- staticAssets
  liftIO $ print files

-- We can provide a list of functions to be availabe in our mustache templates
templateFuncs :: MT.Value
templateFuncs = MT.object
  [ "tagUrl" MT.~> MT.overText (T.pack . makeTagUrl . T.unpack)
  ]

makeTagUrl :: String -> String
makeTagUrl tagName = "/tags/" ++ tagName ++ ".html"

-- | All the static assets can just be copied over from our site's source
staticAssets :: SiteM [Value]
staticAssets = copyFiles
    -- We can copy a glob
    [ "css/*.css"
    -- Or just copy the whole folder!
    , "language-js/"
    , "images/"
    ]
