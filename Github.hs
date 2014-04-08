{-# LANGUAGE OverloadedStrings #-}
module Github where

import Data.Text ( Text )
import Data.Aeson ( (.:) )
import qualified Data.Aeson as Aeson
    ( Value(Object), FromJSON(..) )
import Control.Applicative ( (<$>), (<*>) )
import Control.Monad ( mzero )
import qualified Network.OAuth.OAuth2 as OAuth2 ( AccessToken )
import Network.OAuth.OAuth2.HttpClient ( authGetJSON )

data GithubUser = GithubUser {
  githubID :: Integer,
  githubLogin :: Text
} deriving Show

instance Aeson.FromJSON GithubUser where
  parseJSON (Aeson.Object o) =
    GithubUser <$> o .: "id" <*> o .: "login"
  parseJSON _ = mzero

-- TODO: Replace Maybe with Either String
userInfo :: OAuth2.AccessToken -> IO (Maybe GithubUser)
userInfo token =
  fmap (either (const Nothing) Just) (authGetJSON token "https://api.github.com/user")
