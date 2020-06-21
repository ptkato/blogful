{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Foundation where

import Data.IORef
import Data.Text (Text)

import Yesod.Core

import Settings

data App = App
    { appSettings :: AppSettings
    , blogPosts   :: IORef [Post]
    }

mkYesodData "App" $(parseRoutesFile "config/routes")

instance Yesod App where
    approot = ApprootMaster $ Settings.approot . appSettings
