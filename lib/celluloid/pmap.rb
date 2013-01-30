require 'celluloid'
require "celluloid/pmap/version"

module Celluloid
  module Pmap

    def self.included(base)
      base.class_eval do

        def pmap(&block)
          futures = map { |elem| Celluloid::Future.new(elem, &block) }
          futures.map { |future| future.value }
        end

      end
    end
  end
end

module Enumerable
  include Celluloid::Pmap
end
