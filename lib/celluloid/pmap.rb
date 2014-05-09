require 'celluloid'
require 'celluloid/pmap/parallel_map_worker'
require "celluloid/pmap/version"

module Celluloid
  module Pmap

    def self.included(base)
      base.class_eval do

        def pmap(size=Celluloid.cores, &block)
          pool = Pmap::ParallelMapWorker.pool(size: size)
          futures = map { |elem| pool.future :yielder, elem, &block }
          futures.map { |future| future.value }.tap { pool.terminate }
        end

      end
    end
  end
end

module Enumerable
  include Celluloid::Pmap
end
