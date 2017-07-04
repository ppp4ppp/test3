{-# LANGUAGE FlexibleInstances #-}

module Database.Redis.RedisT where


import Control.Monad 
import Control.Monad.Trans

import Data.Conduit

import Database.Redis


data RedisT r m a = RedisT { runRedisT ::  r -> m a } 

instance (Functor m) => Functor (RedisT r m) where  
  fmap f v = RedisT $ \ r -> fmap f (runRedisT v r)

instance (Monad m) => Applicative (RedisT r m) where
  pure a = RedisT $ \ r -> do (pure a)
  (<*>) = ap

instance (Monad m) => Monad (RedisT r m) where
  return a = RedisT $ \ r -> do return a
  v >>= f = RedisT $ \ r -> do 
                      b <- (runRedisT v r)
                      runRedisT (f b) r

instance MonadTrans (RedisT Connection) where
  lift = liftRedisT

instance  MonadRedis (RedisT Connection IO) where
  liftRedis r = RedisT $ \ conn -> runRedis conn r

instance (MonadRedis m) => MonadRedis (ConduitM i o m) where
  liftRedis = lift . liftRedis

instance (MonadIO m) => MonadIO (RedisT Connection m) where
  liftIO = lift . liftIO


liftRedisT :: m a -> RedisT r m a
liftRedisT m = RedisT (const m)