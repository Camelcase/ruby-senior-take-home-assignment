require 'redis'
require 'json'

module Vandelay
  module Util
    class Cache
      def initialize(redis_host: 'redis', redis_port: 6379)
        @redis = Redis.new(host: redis_host, port: redis_port)
      end

      def fetch_and_cache(key, expiration = 600, &block)
        cached_result = nil

        cache_key = "cache:#{key}"
        # we bypass the caching for test env, it gets in the way (for this scenario)
        cached_result = @redis.get(cache_key) unless ENV['RACK_ENV'] == 'test'

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
