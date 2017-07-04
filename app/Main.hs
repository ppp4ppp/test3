{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class

import           Data.ByteString.Char8
import           Data.Conduit
import qualified Data.Conduit.List as CL

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

prodKeys :: (MonadRedis m) => Producer m ByteString
prodKeys = do 
  v <- liftRedis $ do keys "*"
  either ( \ l -> return ()) ( \ r -> CL.sourceList r) v


kv :: Int -> (ByteString, ByteString)
kv i = ((pack (show i)) , (pack (show (i + 100))))

main :: IO ()
main = do
  print "done"
  conn <- checkedConnect defaultConnectInfo
  runRedisT (CL.sourceList [1..10] .| condSet kv $$ sinkPrint) conn
  runRedisT (prodKeys $$ sinkPrint) conn

