{-# LANGUAGE OverloadedStrings #-}
module Github where

import Data.Text (Text)
import Data.Aeson ((.:))
import qualified Data.Aeson as Aeson

import Control.Applicative ((<$>), (<*>))
import Control.Monad (mzero)

import qualified Network.OAuth.OAuth2 as OAuth2
import Network.OAuth.OAuth2.HttpClient (doJSONGetRequest)

data GithubUser = GithubUser Integer Text Text deriving Show

instance Aeson.FromJSON GithubUser where
    parseJSON (Aeson.Object o) =
      GithubUser <$> o .: "id" <*> o .: "name" <*> o .: "email"
    parseJSON _ = mzero

userInfo :: OAuth2.OAuth2 -> IO (Maybe GithubUser)
userInfo oauth =
  doJSONGetRequest (OAuth2.appendAccessToken "https://api.github.com/user" oauth)