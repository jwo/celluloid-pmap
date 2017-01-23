require 'celluloid/pmap/parallel_map_worker'
require 'celluloid/pmap/version'

module Celluloid
  module Pmap
    celluloid_version = Gem.loaded_specs
                        .values
                        .detect { |repo| repo.name == 'celluloid' }
                        .version.to_s.split('.')

    if celluloid_version[0].to_i == 0 && celluloid_version[1].to_i <= 16
      require 'celluloid'
      POOL_CLASS = Celluloid::PoolManager
    else
      require 'celluloid/current'
      POOL_CLASS = Celluloid::Supervision::Container::Pool
    end

    def self.included(base)
      base.class_eval do
        def pmap(pool_or_size = Celluloid.cores, &block)
          pool = begin
             if pool_or_size.class.ancestors.include?(POOL_CLASS)
               pool_or_size
             else
               default_pool = true
               Pmap::ParallelMapWorker.pool(size: pool_or_size)
             end
           end
          futures = map { |elem| pool.future(:yielder, elem, block) }
          futures.map(&:value)
        ensure
          # We are responsible for terminating the actors that we spawned
          # see https://github.com/celluloid/celluloid/wiki/Actor-lifecycle
          pool.terminate if default_pool && pool.alive?
        end
      end
    end
  end
end

module Enumerable
  include Celluloid::Pmap
end
