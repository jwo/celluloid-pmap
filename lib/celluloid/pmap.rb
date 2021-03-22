require 'celluloid/pmap/parallel_map_worker'
require "celluloid/pmap/version"

module Celluloid
  module Pmap

    def self.find_loaded_gem(name)
      Gem.loaded_specs.values.detect{|repo| repo.name == name }
    end

    def self.ensure_celluloid_running
      celluloid_running = Celluloid.running? rescue false
      Celluloid.boot unless celluloid_running
    end

    def self.pool_class
      celluloid_version = find_loaded_gem("celluloid").version.to_s.split('.')
      if celluloid_version[0].to_i == 0 && celluloid_version[1].to_i <= 16
        require 'celluloid'
        require 'celluloid/autostart'
        ensure_celluloid_running
        Celluloid::PoolManager
      elsif celluloid_version[0].to_i == 0 && celluloid_version[1].to_i < 18
        require 'celluloid/current'
        ensure_celluloid_running
        Celluloid::Supervision::Container::Pool
      else
        require 'celluloid'
        require 'celluloid/pool'
        ensure_celluloid_running
        Celluloid::Supervision::Container::Pool
      end
    end

    def self.included(base)
      base.class_eval do

        def pmap(pool_or_size=Celluloid.cores, &block)
          pool = if pool_or_size.class.ancestors.include?(Celluloid::Pmap.pool_class)
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
