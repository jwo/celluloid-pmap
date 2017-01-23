require 'benchmark'

RSpec::Matchers.define :take_approximately do |expected|
  chain :seconds do
  end

  match do |block|
    @elapsed = Benchmark.realtime do
      block.call
    end
    expect(@elapsed).to be_within(0.2).of(expected)
  end

  supports_block_expectations if respond_to? :supports_block_expectations

  failure_message do |_actual|
    "expected block to take about #{expected} seconds, but took #{@elapsed}"
  end

  failure_message_when_negated do |_actual|
    "expected block to not take about #{expected} seconds, but took #{@elapsed}"
  end

  description do
    "take approximately #{expected} seconds to execute"
  end
end
