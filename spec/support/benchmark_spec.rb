require 'benchmark'

RSpec::Matchers.define :take_approximately do |n|
  chain :seconds do; end

  match do |block|
    elapsed = Benchmark.realtime do
      block.call
    end
    elapsed.should be_within(0.2).of(n)
  end

end

