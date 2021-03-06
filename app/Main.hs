{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}

module Main where

import Control.Concurrent (forkIO, threadDelay)
import Control.Monad.STM (atomically)
import Control.Concurrent.STM.TBQueue (newTBQueueIO,readTBQueue, writeTBQueue, TBQueue(..))
import Control.Monad
import Control.Monad.IO.Class
import Control.Exception

import           Data.ByteString.Char8 (ByteString(..), pack, unpack)
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

condPublish :: (MonadRedis m) => ByteString -> Conduit ByteString m (Either Reply (Integer, ByteString))
condPublish chanell = do
  awaitForever $ \ x -> do
                      r <- liftRedis $ publish chanell x
                      yield $ fmap ( \ i -> (i, x)) r

prodPubSub :: (MonadIO m) => Connection -> ByteString -> Producer m ByteString
prodPubSub conn chanell = do
  tbqueue <- liftIO $ newTBQueueIO 10000
  liftIO $ forkIO $ runRedis conn $ pubSub (subscribe [chanell]) $ \msg -> do
                            putStrLn $ "Message from pubsub prod 22" ++ show (msgChannel msg)
                            atomically $ do writeTBQueue tbqueue $ msgChannel msg
                            return mempty
  lq tbqueue

lq :: (MonadIO m) => TBQueue ByteString -> Producer m ByteString
lq tbqueue = do
  v <- liftIO $ atomically $ do rs <- readTBQueue tbqueue; return rs
  yield v
  lq tbqueue

kv :: Int -> (ByteString, ByteString)
kv i = ((pack (show i)) , (pack (show (i + 100))))

myhandler :: ByteString -> IO ()
myhandler msg = putStrLn $ "my handler output " ++ unpack msg

onInitialComplete :: IO ()
onInitialComplete = putStrLn "Redis acknowledged that mychannel is now subscribed"

pubit :: Connection -> IO (Either Reply Integer)
pubit conn = do
  runRedis conn $ do publish "ch1" "senging senging"


main :: IO ()
main = do
  print "done"
  conn <- checkedConnect $ defaultConnectInfo { connectHost           = "localhost"}
--  runRedisT (CL.sourceList [1..10] .| condSet kv $$ sinkPrint) conn
--  runRedisT (prodKeys $$ sinkPrint) conn
  --runRedisT (CL.sourceList (replicate 10000000 "t1") .| condPublish "ch1"  $$ sinkPrint) conn
  prodPubSub conn "ch1" $$ sinkPrint 
  --runRedisT (prodPubSub "ch1" $$ sinkPrint) conn
  threadDelay $ 1000000 * 10
  print "done"






















