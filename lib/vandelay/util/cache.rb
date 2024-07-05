require 'redis'
require 'json'

module Vandelay
  module Util
    class Cache
      def initialize(redis_host: 'redis', redis_port: 6379)
        @redis = Redis.new(host: redis_host, port: redis_port)
      end

      def fetch_and_cache(key, expiration = 600, &block)
        cache_key = "cache:#{key}"
        cached_result = @redis.get(cache_key)

        if cached_result
          JSON.parse(cached_result)
        else
          result = yield
          @redis.set(cache_key, result.to_json, ex: expiration)
          result
        end
      end
    end
  end
end
