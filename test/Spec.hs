{-# LANGUAGE OverloadedStrings #-}


import Control.Concurrent (forkIO, threadDelay)
import Control.Monad
import Control.Monad.IO.Class
import Control.Exception

import           Data.ByteString.Char8 (ByteString(..), pack, unpack)
import           Data.Conduit
import qualified Data.Conduit.List as CL

import Database.Redis
import Database.Redis.RedisT

condPublish :: (MonadRedis m) => ByteString -> Conduit ByteString m (Either Reply (Integer, ByteString))
condPublish chanell = do
  awaitForever $ \ x -> do
                      r <- liftRedis $ publish chanell x
                      yield $ fmap ( \ i -> (i, x)) r

sinkPrint :: (Show i, MonadIO m) => Sink i m ()
sinkPrint = awaitForever $ \ x -> liftIO $ print x



myhandler :: ByteString -> IO ()
myhandler msg = putStrLn $ "my handler output " ++ unpack msg

onInitialComplete :: IO ()
onInitialComplete = putStrLn "Redis acknowledged that mychannel is now subscribed"

main :: IO ()
main = do
  print "done"
  conn <- checkedConnect defaultConnectInfo
  pubSubCtrl <- newPubSubController [("ch1", myhandler)] []
  forkIO $ forever $
      pubSubForever conn pubSubCtrl onInitialComplete
        `catch` (\e-> do
          putStrLn $ "Got error: " ++ show (e::NonTermination)
          threadDelay $ 50*1000) -- TODO: use exponential backoff
  threadDelay $ 1000000 * 1
  runRedisT (CL.sourceList (replicate 10000000 "t1") .| condPublish "ch1"  $$ sinkPrint) conn
  threadDelay $ 1000000 * 20
  print "done test"

