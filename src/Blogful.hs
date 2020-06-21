module Blogful where

import Control.Concurrent
import Data.IORef
import Data.List              (find)
import Data.Text              (Text)
import Data.Time.Calendar     (toGregorian)
import Data.Time.Clock        (getCurrentTime, utctDay)
import System.Directory
import System.Exit
import System.FilePath.Posix
import System.Process

import Yesod.Core
import Yesod.Markdown
import Text.Pandoc.Extensions (githubMarkdownExtensions)

import Foundation
import Settings

getLatestR :: Handler Html
getLatestR = do
    (App settings refPosts) <- getYesod
    post <- liftIO . fmap head . readIORef $ refPosts
    redirect . PostR $ slug post

getPostR :: Text -> Handler Html
getPostR s = do
    (App settings refPosts) <- getYesod
    posts <- liftIO $ readIORef refPosts
    post  <- return . find (\x -> s == slug x) $ posts
    case post of
        Just (Post _ t a f d) -> do
            md <- liftIO
                $ fmap (either (const (toHtml ("" :: Text))) id . markdownToHtmlWithExtensions githubMarkdownExtensions)
                $ markdownFromFile f
            defaultLayout [whamlet|
                <div>
                    #{t} by #{a}
                <div>
                    #{md}
            |]
        _ -> notFound
