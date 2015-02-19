require 'celluloid'
module Celluloid::Pmap

  class ParallelMapWorker
    include Celluloid

    def yielder(element=nil, block)
      block.call(element)
    end
  end

end
