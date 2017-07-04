{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class

import   Data.ByteString
import Data.Conduit
import Data.Conduit.List

import Database.Redis

import Database.Redis.RedisT
import Testrs


sinkPrint :: (Show i, MonadIO m) => Sink i m ()
sinkPrint = awaitForever $ \ x -> liftIO $ print x

sinkSet :: (MonadRedis m) => (i -> (ByteString, ByteString)) -> Sink i m ()
sinkSet kv = awaitForever $ \ x -> liftRedis $ do (uncurry set) (kv x); return ()

condSet :: (MonadRedis m) => (i -> (ByteString, ByteString)) -> Conduit i m i 
condSet kv = awaitForever $ \ x -> do
                            liftRedis (do (uncurry set) (kv x); return ())
                            yield x


--kv :: ()

main :: IO ()
main = do
  print "done"
  conn <- checkedConnect defaultConnectInfo
  runRedisT (sourceList [1..10] .| condSet ( \ _ -> ( "test", "testval")) $$ sinkPrint) conn

