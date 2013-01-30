require 'celluloid'
module Celluloid::Pmap

  class ParallelMapWorker
    include Celluloid

    def yielder(element=nil, &block)
      yield element
    end
  end

end
