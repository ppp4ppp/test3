module Database.Redis.RedisT where

import Database.Redis

data RedisT r m a = RedisT { runRedisT ::  r -> m a } 


