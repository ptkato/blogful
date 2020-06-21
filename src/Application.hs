{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE ViewPatterns         #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application where

import Control.Concurrent
import Control.Monad
import Data.IORef
import Data.Yaml             (decodeFileEither)
import System.Directory
import System.Process

import Yesod.Core
import Yesod.Default.Config2 (loadYamlSettings, useEnv)

import Foundation
import Settings

import Blogful

mkYesodDispatch "App" resourcesApp

appMain :: IO ()
appMain = do
    appS@(AppSettings repo dir _ port) <- loadYamlSettings ["config/settings.yaml"] [] useEnv

    posts  <- newIORef []

    exists <- doesDirectoryExist dir
    unless exists $ do
        void $ rawSystem "git" ["clone", repo, dir]
        writeIORef posts =<< grabPosts dir

    void . forkIO . forever $ do
        threadDelay 1800000000 -- half an hour
        void $ runProcess "git" ["pull"] (Just dir) Nothing Nothing Nothing Nothing
        writeIORef posts =<< grabPosts dir

    warp port $ App appS posts

grabPosts :: FilePath -> IO [Post]
grabPosts dir = fmap (either (const []) id) $ decodeFileEither dir
