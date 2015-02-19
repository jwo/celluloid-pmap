require 'celluloid'
require 'celluloid/pmap/parallel_map_worker'
require "celluloid/pmap/version"

module Celluloid
  module Pmap

    def self.included(base)
      base.class_eval do

        def pmap(pool_or_size=Celluloid.cores, &block)
          pool = if pool_or_size.class.ancestors.include?(Celluloid::PoolManager)
                   pool_or_size
                 else
                   Pmap::ParallelMapWorker.pool(size: pool_or_size)
                 end
          futures = map { |elem| pool.future(:yielder, elem, block) }
          futures.map { |future| future.value }
        end

      end
    end
  end
end

module Enumerable
  include Celluloid::Pmap
end
