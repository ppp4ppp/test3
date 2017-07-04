module Database.Redis.RedisT where

import Database.Redis
import Control.Monad 

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

