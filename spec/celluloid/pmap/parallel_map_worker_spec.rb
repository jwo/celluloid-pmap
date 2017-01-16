require 'celluloid/pmap/parallel_map_worker'

describe Celluloid::Pmap::ParallelMapWorker do
  it 'should execute the block we send' do
    result = subject.yielder(proc { 6 + 3 })
    result.should eq(9)
  end

  it 'should send in the argument to the block' do
    result = subject.yielder(6, ->(e) { e + 3 })
    result.should eq(9)
  end
end
