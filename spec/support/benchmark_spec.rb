require 'benchmark'

RSpec::Matchers.define :take_approximately do |expected|
  chain :seconds do; end

  match do |block|
    @elapsed = Benchmark.realtime do
      block.call
    end
    @elapsed.should be_within(0.2).of(expected)
  end

  supports_block_expectations if respond_to? :supports_block_expectations

  failure_message_for_should do |actual|
    "expected block to take about #{expected} seconds, but took #{@elapsed}"
  end

  failure_message_for_should_not do |actual|
    "expected block to not take about #{expected} seconds, but took #{@elapsed}"
  end

  description do
    "take approximately #{expected} seconds to execute"
  end

end

