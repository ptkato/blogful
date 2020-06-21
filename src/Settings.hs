module Settings where

import Data.Aeson         (FromJSON, withObject, (.:), parseJSON)
import Data.Text          (Text)
import Data.Time.Calendar (Day)

data AppSettings = AppSettings
    { repositoryUrl    :: String
    , workingDirectory :: FilePath
    , approot          :: Text
    , port             :: Int
    }

instance FromJSON AppSettings where
    parseJSON = withObject "AppSettings" $ \o -> do
        repositoryUrl    <- o .: "repository-url"
        workingDirectory <- o .: "working-directory"
        approot          <- o .: "approot"
        port             <- o .: "port"
        return AppSettings {..}

data Post = Post
    { slug     :: Text
    , title    :: Text
    , author   :: Text
    , filepath :: FilePath
    , date     :: Day
    }

instance FromJSON Post where
    parseJSON = withObject "Post" $ \o -> do
        slug     <- o .: "slug"
        title    <- o .: "title"
        author   <- o .: "author"
        filepath <- o .: "filepath"
        date     <- o .: "date"
        return Post {..}

type Year = Int
type Month = Int
